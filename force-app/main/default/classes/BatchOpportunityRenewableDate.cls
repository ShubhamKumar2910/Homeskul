public with sharing class BatchOpportunityRenewableDate implements Database.Batchable <Sobject> {
    
   
    public Database.QueryLocator Start(Database.BatchableContext bc){
        Date nowDate = System.today();
        nowDate = nowDate.addDays(Integer.valueOf(Org_Config__c.getValues('Base Values').Renewal_After_Days__c));
        String Query = 'SELECT OwnerId,Name,CreatedDate,CloseDate, Renewal_Date__c FROM Opportunity WHERE Renewable_Date__c =: nowDate';
        return Database.getQueryLocator(Query);
    }
    
    public void Execute(Database.BatchableContext bc, List<Opportunity> oppList){
        if(!oppList.isEmpty()){
            Set<Id> opportutnityIds = new Set<Id>();
            List<Task> taskListToBeInserted = new List<task>();
            
            Date todayDate = System.today();
            todayDate = todayDate.addDays(Integer.valueOf(Org_Config__c.getValues('Base Values').Renewal_After_Days__c));
            
            for(Opportunity opp : oppList){
                System.debug('The OppList--->'+opp);
                if(opp.Renewal_Date__c !=null && opp.Renewal_Date__c == todayDate){    
                    opportutnityIds.add(opp.Id);
                    
                    Task taskrec = new Task();
                    taskrec.Subject = 'Opportunity To Be Renewed';
                    taskRec.Priority = 'Normal';
                    taskrec.Status = 'Open';
                    taskrec.OwnerId = opp.OwnerId;
                    taskrec.WhatId = opp.Id;
                    taskrec.ActivityDate = opp.Renewal_Date__c;
                    taskListToBeInserted.add(taskrec);
                }
            }
            //send Email
            if(!opportutnityIds.isEmpty()){
                EmailIUtility.sendEmail(opportutnityIds,'Renewal Email','RENEWAL');
            }
            //create Task for owner
            if(!taskListToBeInserted.isEmpty()){
                insert taskListToBeInserted;
            }
        }
        
    }
    public void Finish(Database.BatchableContext bc){
    }
}