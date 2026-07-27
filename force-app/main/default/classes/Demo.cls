public class Demo {
    
    public static void oppCreateForAcc(){

        List<opportunity> oppList = new List<opportunity>();
    	List<Account> accList = [Select id, name from account where name = 'Saiteja12345'];
        
        if(!accList.isEmpty()){
            for(Account acc : accList){
                Opportunity opp = new Opportunity();
                opp.name = acc.name;
                opp.AccountId = acc.id;
                opp.StageName = 'prospecting';
                opp.CloseDate = System.Today();
                oppList.add(opp);
                
            }
		 if(!oppList.isEmpty()){
                insert oppList;
            }
            
        }
    }

}
