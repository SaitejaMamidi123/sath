trigger ContactTrigger on Contact (before Delete, before update, after delete, after undelete){
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            ContactHandler.activeContactError(Trigger.old);
        }
    } else if(Trigger.isAfter)
            {
               if(Trigger.isDelete){
            	ContactHandler.populateConCountOnAcc(Trigger.old);
               } else if(Trigger.isUndelete){
                 ContactHandler.acvtConAndPopuCnt(Trigger.new);
               }
            }

}