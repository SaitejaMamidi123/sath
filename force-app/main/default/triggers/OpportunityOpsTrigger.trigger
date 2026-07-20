trigger OpportunityOpsTrigger on Opportunity (
    before insert, before update, after update, after delete
) {
    if (Trigger.isBefore) {
        OpportunityOpsHandler.beforeSave(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityOpsHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        OpportunityOpsHandler.afterDelete(Trigger.old);
    }
}