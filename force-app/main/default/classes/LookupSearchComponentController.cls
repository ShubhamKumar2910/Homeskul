public class LookupSearchComponentController {
    
    @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
        
        return sObjectResultList;
    }
    
    @AuraEnabled
    public static String genrateScore(String LeadId) {
        
        Decimal totalScore = 0;
        decimal MaximumScore = 0;
        List<Scorecard__c> ScoreList = [SELECT Enabled__c,Total_Weight__c,(SELECT Field_Name__c,Field_Type__c,Matching_Type__c,Matching_Value__c,Related_Object__c,Scorecard_Execution_Criteria_Name__c,Scorecard__c,Sequence__c FROM Execution_Criteria_Entry__R) FROM Scorecard__c where enabled__c = true];
        map<string,String> expectedValuebyCriteria = new Map<String,String>();
        map<string,Decimal> allotedMarksbyCriteria = new Map<String,Decimal>();
        map<string,String> leadValueForFields = new Map<String,String>();
        for(Scorecard__c scr:ScoreList){
            for(Execution_Criteria_Entry__c exe:scr.Execution_Criteria_Entry__R){
                expectedValuebyCriteria.put(exe.Field_Name__c,exe.Matching_Value__c);
                allotedMarksbyCriteria.put(exe.Field_Name__c,exe.Sequence__c);
            }
        }
        system.debug('expectedValuebyCriteria'+expectedValuebyCriteria);    
        system.debug('allotedMarksbyCriteria'+allotedMarksbyCriteria);    
        
		List<Lead> LeadsToBeScored = [SELECT Address,Agent__c,Answered_Remarks__c,Answered_Status__c,Call_Status__c,Campaign__c,City,Class__c,Company,ConvertedAccountId,ConvertedContactId,ConvertedDate,ConvertedOpportunityId,Country,CreatedById,CreatedDate,Demo_Opted__c,District__c,Email,EmailBouncedDate,EmailBouncedReason,Exam_Type__c,Father_Occupation__c,FirstName,Follow_up_Comments__c,Follow_Up_Date_and_Time__c,Gender__c,GeocodeAccuracy,Id,Industry,IsConverted,IsDeleted,IsUnreadByOwner,Jigsaw,JigsawContactId,Language_Issue__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,Latitude,LeadSource,Lead_Age__c,Lead_Assigned_Date__c,Lead_Score__c,Lead_Stage__c,Learner_Uid__c,Location__c,Longitude,MasterRecordId,Maximum_Score__c,MiddleName,MobilePhone,Mother_Occupation__c,Name,Not_Answered__c,NumberOfEmployees,OwnerId,Parent_Contact_No__c,Parent_Name__c,Phone,PhotoUrl,Pincode__c,PostalCode,Rating,Registration_Demo__c,Registration_Mock__c,Registration__c,Registtration_Join_Us__c,Salutation,Schedule_Demo_Date__c,School_Name__c,State,State__c,Status,Street,Student_Performance__c,Student_type__c,Suffix,Syllabus__c,SystemModstamp,Title,Website FROM Lead where id = :LeadId];        
        for(String fieldval : expectedValuebyCriteria.keyset()){
            for(Lead ld:LeadsToBeScored)  {
                MaximumScore = MaximumScore+allotedMarksbyCriteria.get(fieldval);
                if(expectedValuebyCriteria.get(fieldval) == String.valueOf(ld.get(fieldval))){
                    totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                }
            }
        }
        Lead LeadTobeUpdated = new Lead(id=LeadId,Lead_Score__c=totalScore,Maximum_Score__c = MaximumScore);
        update LeadTobeUpdated;
        system.debug('totalScore'+totalScore);         
        return 'Success';
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
    
    public static String getMyAPIName(String objectName, String fieldLabel ) {
        
        SObjectType type = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = type.getDescribe().fields.getMap();
        string value= '';
        for(String strField : mfields.keySet())
        {
            SObjectField fl = mfields.get(strField);
            if(fieldLabel == fl.getDescribe().getlabel())
            {
                value =  strField;
            }else{
                
            }
        }
        return value;
    }
}