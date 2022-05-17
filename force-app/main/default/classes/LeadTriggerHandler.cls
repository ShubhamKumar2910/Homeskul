public class LeadTriggerHandler {
  static LeadTriggerHandler handlerInstance;
    public static LeadTriggerHandler getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new LeadTriggerHandler();
        return handlerInstance;
    }
    public void assignLeadToQueue(List<Lead> newLeadsList){
        String queueId  = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Homeskul Lead Queue' limit 1].Id;
        for(Lead ld : newLeadsList) {
            ld.ownerId = queueId;
        }
    }
    
    public static void executeLeadAssignmentLogic(list<lead> leadList){
        if(!leadList.isEmpty()){
            for(lead ld : leadList){
                if(ld.leadSource != null){
                    System.debug(ld.LeadSource);
                    RoundRobinLeadAssignment.assignLeadsToBDS(ld.leadSource);
                }
            }
        }
    }
}