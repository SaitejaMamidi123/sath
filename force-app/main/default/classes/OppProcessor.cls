public class OppProcessor implements Database.Batchable<sObject>, Database.Stateful {
    
    Integer totalCount = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select id, Name from Opportunity]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> opps){
        
        for(Opportunity op : opps){
            op.Leadsource = 'Web';
            totalCount +=1;
        }
        
        update opps;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Execution finished for '+totalCount);
    }

}