trigger OpportunityTrigger on Opportunity (after update, after insert, after delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OpportunityHandler.taskForClosedOpp(Trigger.new, Trigger.oldmap);
            OpportunityHandler.popAccountRevenue(Trigger.new, Trigger.oldmap);
        }else if(Trigger.isinsert){
            OpportunityHandler.popAccountRevenue(Trigger.new, null);
        }else if(Trigger.isdelete){
            OpportunityHandler.popAccountRevenue(Trigger.old, null);
        }
      }
}