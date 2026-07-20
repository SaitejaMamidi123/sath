public class ContactHandler {
    
    public static void activeContactError(List<Contact> deleteConList){
        List<task> taskToBeInserted=new List<Task>();
        if(!deleteConList.isEmpty()){
            for(Contact con : deleteConList){
                Task newTask=new Task();
                newTask.subject='Task created for newly deleted Contact' +con.name;
                newTask.Ownerid=con.OwnerId;
                taskToBeInserted.add(newTask);
                } 
                if(!taskToBeInserted.isEmpty()){
                   insert taskToBeInserted;
                }
         }
      }  
    public static void populateConCountOnAcc(List<Contact> deletedConList){
        List<Account> AccToBeUpdated = new List<Account>();
        Set<Id> AccountIds = new Set<Id>();
        for(Contact con : deletedConList){
            if(con.AccountId != null){
                AccountIds.add(con.AccountId);
        	}
        }
        List<Account> AccList = [Select id,Contact_Count__c, (Select id from Contacts) from Account where id IN :AccountIds];

        if(!AccList.isEmpty()){
            for(Account acc : AccList){
                acc.Contact_Count__c =acc.Contacts.size();
                AccToBeUpdated.add(acc);
            }
                if(!AccToBeUpdated.isEmpty()){
                    update AccToBeUpdated;
                }
            
        }
    }
    public static void acvtConAndPopuCnt(List<Contact> undeletedList){
        List<Account> accListToBeInserted = new List<Account>();
        List<Contact> conListToBeInserted = new List<Contact>();
        Set<Id> accIds = new Set<Id>();
        if(!undeletedList.isEmpty()){
            for(Contact con : undeletedList){
                if(con.Accountid != null){
                    accIds.add(con.Accountid);
                }
                Contact con1 = new Contact();
                con1.id = con.Id;
                con1.Is_Active__c = true;
                conListToBeInserted.add(con1);
            }
        List<Account> newAccList = [Select id,Contact_Count__c,(Select id from Contacts) from Account where ID in :accIds];
            if(!newAccList.isEmpty()){
                for(Account acc : newAccList){
                    acc.Contact_Count__c = acc.Contacts.size();
                    accListToBeInserted.add(acc);
                }
            }
        }
         if(!accListToBeInserted.isEmpty()){
                    update accListToBeInserted;
          }
          if(!conListToBeInserted.isEmpty()){
                    update conListToBeInserted;
          } 
    }
}