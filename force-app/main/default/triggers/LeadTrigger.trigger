trigger LeadTrigger on Lead (before insert,After Insert) {
SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Lead');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        LeadTriggerHandler handlerInstance = LeadTriggerHandler.getInstance();
        if(Trigger.isBefore && Trigger.isInsert) {
            system.debug('Before insert invoice');
            handlerInstance.assignLeadToQueue(trigger.new);
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
       // LeadTriggerHandler.executeLeadAssignmentLogic(Trigger.new);
    }
}