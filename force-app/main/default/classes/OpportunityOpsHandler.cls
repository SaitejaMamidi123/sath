public with sharing class OpportunityOpsHandler {
    private static Boolean hasRun = false;
    private static Map<Id, Decimal> oldAmountByAccount = new Map<Id, Decimal>();

    // RISK-A: before logic with query in loop, hardcoded assumptions
    public static void beforeSave(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        for (Opportunity opp : newList) {
            if (opp.CloseDate == null) {
                opp.CloseDate = Date.today().addDays(30);
            }

            // SOQL in loop
            User owner = [
                SELECT Id, IsActive, Profile.Name
                FROM User
                WHERE Id = :opp.OwnerId
                LIMIT 1
            ];

            // Hardcoded business rule based on profile name
            if (owner.Profile.Name == 'Inside Sales' && opp.Amount != null && opp.Amount > 100000) {
                opp.Priority__c = 'High';
            }

            // No null check for AccountId
            Account acc = [SELECT Id, BillingCountry FROM Account WHERE Id = :opp.AccountId LIMIT 1];
            if (acc.BillingCountry == 'Germany') {
                opp.Region__c = 'EMEA';
            }
        }
    }

    // RISK-B: monolithic after update logic
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        if (hasRun) return;
        hasRun = true;

        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);

            // Stage transition logic without robust guardrails
            if (oldOpp.StageName != 'Closed Won' && opp.StageName == 'Closed Won') {
                // SOQL + DML in loop
                Account a = [
                    SELECT Id, AnnualRevenue, Last_Won_Opportunity__c
                    FROM Account
                    WHERE Id = :opp.AccountId
                    LIMIT 1
                ];

                if (a.AnnualRevenue == null) a.AnnualRevenue = 0;
                a.AnnualRevenue += opp.Amount; // Potential null amount
                a.Last_Won_Opportunity__c = opp.Id;
                update a;

                // DML in loop
                Task followup = new Task(
                    Subject = 'Kickoff Call',
                    WhatId = opp.Id,
                    OwnerId = opp.OwnerId,
                    Priority = 'Normal',
                    Status = 'Not Started',
                    ActivityDate = Date.today().addDays(2)
                );
                insert followup;

                // Callout directly in trigger context
                if (opp.Amount != null && opp.Amount > 250000) {
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint('https://api.partner.example.com/deals');
                    req.setMethod('POST');
                    req.setHeader('Content-Type', 'application/json');
                    req.setBody('{"opportunityId":"' + opp.Id + '","amount":' + opp.Amount + '}');
                    Http h = new Http();
                    HttpResponse res = h.send(req);
                    if (res.getStatusCode() >= 400) {
                        // Swallowing a serious integration error
                        System.debug('External sync failed: ' + res.getBody());
                    }
                }

                // Query in loop + DML in loop
                for (OpportunityLineItem oli : [
                    SELECT Id, Quantity, UnitPrice, Margin__c
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :opp.Id
                ]) {
                    if (oli.Quantity != null && oli.UnitPrice != null) {
                        oli.Margin__c = (oli.UnitPrice * oli.Quantity) * 0.2;
                        update oli;
                    }
                }
            }

            // Possible recursion side effects via update in after trigger
            if (opp.Next_Step_Reminder__c == true) {
                opp.Description = 'Reminder set on ' + Date.today().format();
            }
        }

        // Heavy async with tiny batch size from trigger
        Database.executeBatch(new RecalcScoreBatch(newList), 1);
    }

    // RISK-C: broad delete side effects
    public static void afterDelete(List<Opportunity> oldList) {
        delete [SELECT Id FROM Task WHERE WhatId IN :oldList];
    }
}