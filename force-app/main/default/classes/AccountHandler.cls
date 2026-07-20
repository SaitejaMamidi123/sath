/**
 * @description Trigger handler for the Account SObject.
 *              All methods are bulkified, governor-limit-safe, and operate
 *              in-memory (no DML) unless explicitly documented otherwise.
 *
 *              Design decisions:
 *              - `with sharing`  : enforces record-level security (OWD / sharing rules).
 *              - Constants       : eliminates magic strings and hardcoded Ids.
 *              - Database.*      : partial-save DML prevents one bad record rolling
 *                                  back an entire batch; errors are logged with context.
 *              - Null guards     : every public entry-point validates its arguments.
 */
public with sharing class AccountHandler {

    // ─── Constants ────────────────────────────────────────────────────────────

    @TestVisible private static final String ACTIVE_STATUS      = 'Yes';
    @TestVisible private static final String DEFAULT_COUNTRY    = 'India';
    @TestVisible private static final String OPP_STAGE          = 'Prospecting';
    @TestVisible private static final Integer OPP_CLOSE_DAYS    = 30;
    @TestVisible private static final String DESC_PHONE_UPDATED = 'Phone number updated';

    @TestVisible private static final String RATING_HOT         = 'Hot';
    @TestVisible private static final String RATING_WARM        = 'Warm';
    @TestVisible private static final String RATING_COLD        = 'Cold';

    @TestVisible private static final String INDUSTRY_ENERGY    = 'Energy';
    @TestVisible private static final String INDUSTRY_AGRI      = 'Agriculture';

    // ─── Public Methods ───────────────────────────────────────────────────────

    /**
     * @description Returns the first Account that has an Industry value set.
     *              ⚠️  Do NOT call from a trigger context — each invocation
     *              consumes one of the 100 synchronous SOQL governor-limit slots.
     * @return Account The first matching record, or null when none exists.
     */
    public static Account getAccountRecord() {
        List<Account> records = [
            SELECT Id, Name, Industry
            FROM   Account
            WHERE  Industry != null
            LIMIT  1
        ];
        return records.isEmpty() ? null : records[0];
    }

    /**
     * @description Marks newly inserted Accounts as active and sets a default
     *              billing country. Operates in-memory — no DML performed.
     * @param newList Trigger.new list of Account records.
     */
    public static void activateNewAccounts(List<Account> newList) {
        if (newList == null || newList.isEmpty()) {
            return;
        }
        for (Account acc : newList) {
            acc.Active__c      = ACTIVE_STATUS;
            acc.BillingCountry = DEFAULT_COUNTRY;
        }
    }

    /**
     * @description Assigns a Rating value derived from Industry when Rating is
     *              currently blank. Operates in-memory — no DML performed.
     * @param accList List of Account records to evaluate.
     */
    public static void updateAccRating(List<Account> accList) {
        if (accList == null || accList.isEmpty()) {
            return;
        }
        for (Account acc : accList) {
            if (acc.Industry != null && String.isBlank(acc.Rating)) {
                acc.Rating = resolveRating(acc.Industry);
            }
        }
    }

    /**
     * @description Creates one child Opportunity per Account and persists them
     *              using partial-save DML (allOrNone = false) so a single invalid
     *              record does not roll back the entire batch.
     * @param accList List of parent Account records.
     */
    public static void createRelatedOpportunities(List<Account> accList) {
        if (accList == null || accList.isEmpty()) {
            return;
        }
        List<Opportunity> oppList = new List<Opportunity>();
        for (Account acc : accList) {
            oppList.add(buildOpportunity(acc));
        }
        if (!oppList.isEmpty()) {
            List<Database.SaveResult> results = Database.insert(oppList, false);
            logSaveErrors(results, 'createRelatedOpportunities');
        }
    }

    /**
     * @description Stamps a description note on an Account when its Phone field
     *              changes. Operates in-memory — no DML performed.
     * @param accList List of updated Account records (Trigger.new).
     * @param oldMap  Map of previous Account values (Trigger.oldMap).
     */
    public static void updateDesc(List<Account> accList, Map<Id, Account> oldMap) {
        if (accList == null || accList.isEmpty() || oldMap == null) {
            return;
        }
        for (Account acc : accList) {
            Account oldAcc = oldMap.get(acc.Id);
            if (oldAcc != null && acc.Phone != oldAcc.Phone) {
                acc.Description = DESC_PHONE_UPDATED;
            }
        }
    }

    /**
     * @description Propagates each Account's Phone value to all its child
     *              Opportunities via a single bulkified SOQL + DML cycle.
     *              Uses partial-save DML (allOrNone = false).
     * @param accList List of Account records whose Phone may have changed.
     */
    public static void syncPhoneToOpportunities(List<Account> accList) {
        if (accList == null || accList.isEmpty()) {
            return;
        }

        // Collect Ids for a single SOQL with a child sub-query
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accList) {
            accIds.add(acc.Id);
        }

        List<Account> accountsWithOpps = [
            SELECT Id, Phone,
                   (SELECT Id, Phone__c FROM Opportunities)
            FROM   Account
            WHERE  Id IN :accIds
        ];

        List<Opportunity> oppList = new List<Opportunity>();
        for (Account acc : accountsWithOpps) {
            if (acc.Opportunities == null || acc.Opportunities.isEmpty()) {
                continue;
            }
            for (Opportunity opp : acc.Opportunities) {
                // Update the existing SObject in-place — avoids unnecessary object allocation
                opp.Phone__c = acc.Phone;
                oppList.add(opp);
            }
        }

        if (!oppList.isEmpty()) {
            List<Database.SaveResult> results = Database.update(oppList, false);
            logSaveErrors(results, 'syncPhoneToOpportunities');
        }
    }

    // ─── Private Helpers ──────────────────────────────────────────────────────

    /**
     * @description Maps an Industry picklist value to its target Rating.
     * @param industry The Account Industry value.
     * @return String  The resolved Rating string.
     */
    private static String resolveRating(String industry) {
        if (industry == INDUSTRY_ENERGY) {
            return RATING_HOT;
        }
        if (industry == INDUSTRY_AGRI) {
            return RATING_WARM;
        }
        return RATING_COLD;
    }

    /**
     * @description Builds an unsaved Opportunity shell linked to the given Account.
     * @param acc  The parent Account record.
     * @return Opportunity A new, not-yet-inserted Opportunity.
     */
    private static Opportunity buildOpportunity(Account acc) {
        return new Opportunity(
            Name      = acc.Name,
            AccountId = acc.Id,
            StageName = OPP_STAGE,
            CloseDate = System.today().addDays(OPP_CLOSE_DAYS)
        );
    }

    /**
     * @description Iterates Database.SaveResult objects and emits structured
     *              ERROR-level debug messages for any failed records.
     * @param results List of SaveResult objects returned by a Database DML call.
     * @param context Calling method name — used as a log prefix for traceability.
     */
    private static void logSaveErrors(List<Database.SaveResult> results, String context) {
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug(
                        LoggingLevel.ERROR,
                        '[AccountHandler.' + context + '] DML Error'
                        + ' | StatusCode: ' + err.getStatusCode()
                        + ' | Message: '    + err.getMessage()
                        + ' | Fields: '     + err.getFields()
                    );
                }
            }
        }
    }
}