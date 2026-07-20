trigger VaccineEligibilityTrigger on CovidVaccineEligibility__c (before insert,before update) {
    switch On Trigger.operationType
    {
        when before_insert {
            
            VaccineEligibilityTriggerHandler.insertVaccineEligibilityStatus(trigger.new);
        }
        
        when before_update {
            VaccineEligibilityTriggerHandler.updateVaccineEligibilityStatus(trigger.new,trigger.oldmap);
        }
    }
    
    
}