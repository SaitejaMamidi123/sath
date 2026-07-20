public class AccProcessor implements Database.Batchable <sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select id from Account]);
    }
    public void execute(Database.BatchableContext bc, List<Account> accRec){
        //
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}