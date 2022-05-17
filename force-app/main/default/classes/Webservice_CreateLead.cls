@RestResource(urlMapping='/lead_creation/*')
/*"FirstName": "Test",
"LastName": "User",
"EmailAddress": "test@test.com",
"Phone": "1234657890",
"mx_Class_Course": "10",
"mx_School_Name": "School1",
"mx_Syllabus": "CBSE",
"mx_RegistrationGKGM": "true",
"SourceCampaign": "Website"
*/
global class Webservice_CreateLead {
    @HttpPost
    global static JsonParseForLead.ReponseWrapper createLeadFromMobile(){
        JsonParseForLead.ReponseWrapper response = new JsonParseForLead.ReponseWrapper();
        try{
            List<String>apiNames =  new list<String>();
            String JSONInput = RestContext.request.requestBody.tostring();
            
            if(!string.isBlank(JSONInput)){
                system.debug('JSONInput>>'+JSONInput);
                JsonParseForLead parsed = JsonParseForLead.parse(JSONInput);
                if(parsed != null){
                    system.debug('parsed>>'+parsed);
                    system.debug('parsed.Phone-->'+parsed.Phone.length());
                    if(!String.isBlank(parsed.Phone) || parsed.Phone == null || parsed.Phone.length() <= 0){
                        response.error_code = '400';
                        response.error_message = 'Provide Phone Number';
                        return response;
                    }
                    Lead leadRec = new Lead(
                        LastName = parsed.Phone,
                        Phone = parsed.Phone,
                        company = '-'
                    );
                   /* Lead leadRec = new Lead(
                        FirstName = parsed.FirstName,
                        LastName = parsed.LastName,
                        Email = parsed.EmailAddress,
                        Phone = parsed.Phone,
                        Class__c = parsed.mx_Class_Course,
                        School_Name__c = parsed.mx_School_Name,
                        Syllabus__c = parsed.mx_Syllabus,
                        Registration__c = Boolean.valueOf(parsed.mx_RegistrationGKGM),
                        LeadSource = parsed.SourceCampaign,
                        //				Parent Name - Company	
                        company = '-',
                        state__c = parsed.mx_State,
                        Student_type__c = parsed.mx_Student_Type,
                        Exam_Type__c = parsed.mx_Exam_Type,
                        Registtration_Join_Us__c = parsed.mx_RegistrationJoinUs,
                        Registration_Demo__c = parsed.mx_RegistrationDemo,
                        Registration_Mock__c = parsed.mx_RegistrationMock
                    );*/
                    insert leadRec;
                    Schema.DescribeSObjectResult leadObj = Lead.sObjectType.getDescribe();
                    for(string apiName : leadObj.fields.getMap().keySet()){
                        apiNames.add(apiName);
                    }
                    response.leadFieldAPIName = apiNames;
                    response.success_code = '200';
                    response.success_message = 'Lead Created -> '+leadRec.Id;
                }
            }
        }catch(exception ex){
            response.error_code = '400';
            response.error_message = ex.getStackTraceString();
        }
        return response;
    }
}