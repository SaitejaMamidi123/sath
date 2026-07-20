public class TaskCreation {
   
    public static void taskForAccount(List<Account> newList){
        
        List<task> taskToBeInserted=new List<Task>();
        
        for (account accrec:newList)
        {
            if(accrec.Active__c=='No')
            {
                 Task newTask=new Task();
                newTask.subject='Task created for inactive account'+accrec.name;
                newTask.Whatid=accrec.id;
                newTask.Ownerid=accrec.OwnerId;
                taskToBeInserted.add(newTask);
           }
            
           
        }
         if(!taskToBeInserted.isEmpty())
            {
                insert taskToBeInserted;
            }
    }

}