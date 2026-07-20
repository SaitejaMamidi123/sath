trigger AccountTrigger on Account (after update, before insert, after insert, before update) {
    
    if(Trigger.isAfter){
        
        if(Trigger.isUpdate){
            
    	TaskCreation.taskForAccount(Trigger.new);
       // AccountHandler.updateSameOnOpp(Trigger.new);
            
        }else if(Trigger.isInsert){
          
           // AccountHandler.creatRelOpp(Trigger.new);
        }
        
    }else if(Trigger.isBefore){
        
            if(Trigger.isInsert){
                
            AccountHandler.activateNewAccounts(Trigger.new);
            AccountHandler.updateAccRating(Trigger.new);
                
            } else if(Trigger.isUpdate){
               AccountHandler.updateDesc(Trigger.new, Trigger.oldmap);
            }
        
    }
}