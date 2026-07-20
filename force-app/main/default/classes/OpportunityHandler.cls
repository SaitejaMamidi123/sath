public class OpportunityHandler {
    public object getClosedWonOpportunityAmountTotal(){
List<AggregateResult> AggregateResultList = new List<AggregateResult>();
AggregateResultList = [Select SUM(Amount) total From Opportunity];
return AggregateResultList[0].get('total');
    }
    public static void taskForClosedOpp(List<Opportunity> oppList, Map<Id, Opportunity> oldmap){
        List<task> taskToBeInserted= new List<Task>();
    for(Opportunity opprec:oppList){
        if(opprec.StageName=='Closed Won' && oldMap.get(opprec.Id).StageName != 'Closed Won'){
        Task newTask=new Task();
        newTask.subject='Task Created for Opportunity'+opprec.name;
        newTask.whatid=opprec.id;
        newTask.Ownerid=opprec.OwnerId;
        newTask.Status = 'Not Started';   
         taskToBeInserted.add(newTask);
             }
    	}
         if(!taskToBeInserted.isEmpty())
        {
            insert taskToBeInserted;
        }
    }
    public static void popAccountRevenue(List<Opportunity> oppList, Map<Id, Opportunity> oldmap){
        Set<id> accIds = new Set<Id>();
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if((oldmap == null && opp.AccountId != null) ||(oldmap != null && opp.AccountId != null && opp.Amount != oldmap.get(opp.id).Amount)) {
                    accIds.add(opp.AccountId);
                }
            }
            List<Account> accList = [Select id, AnnualRevenue, (select id, amount from Opportunities) from Account where id IN :accIds];
            
            if(!accList.isEmpty()){
                for(Account acc : accList){
                    Decimal total = 0;
                    for(Opportunity opp : acc.Opportunities){
                        if(opp.Amount!=null){
                        total = total + opp.Amount;
                        }
                    }
                    acc.AnnualRevenue = total;
                }
             	update accList;
            }
        }
    }
}