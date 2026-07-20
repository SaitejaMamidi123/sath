public class UpdateAccountBatch implements Database.Batchable<SObject> {
    
 
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Active__c ="No"');
    }
    
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
    
        for (Account acc : scope) {
            acc.Active__c ='Yes'; 
        }
        update scope;
    }
        
     public void finish(Database.BatchableContext BC){
        System.debug('Batch job completed.');
    }
}