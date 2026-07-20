trigger LeadTrigger on Lead (before insert, before update) {
    
    for(Lead leadRec:Trigger.new)
    {
        
        if(leadRec.LeadSource == null)
        {
            leadRec.addError('Pls populate the Lead Source Field');
        }
    }

}