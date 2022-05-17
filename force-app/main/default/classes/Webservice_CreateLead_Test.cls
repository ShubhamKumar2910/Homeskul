@isTest 
public class Webservice_CreateLead_Test {
    
    @isTest public static void testingWebService(){
        RestRequest request             = new RestRequest();
        request.requestUri              = 'https://homeskulinnolearnprivatelimited--homeskuldv.my.salesforce.com/services/apexrest/lead_creation/';
        request.httpMethod              = 'POST';
        request.requestBody             = Blob.valueOf('{"FirstName": "Test","LastName": "User","EmailAddress": "test@test.com","Phone": "1234657890","mx_Class_Course": "10","mx_School_Name": "School1","mx_Syllabus": "CBSE","mx_RegistrationGKGM": "true","SourceCampaign": "Website"}');
        RestContext.request             = request;
        // Call the method to test
        Webservice_CreateLead.createLeadFromMobile();
        
    }   
}