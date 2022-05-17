@RESTResource(urlMapping='/razorpayWebhook/*')
global without sharing class RazorpayWebhookHandler {
    //{"reminder_enable":true,"notify":{"sms":true,"email":true},"notes":{"policy_name":"0060p00000B5SzKAAV"},"first_min_partial_amount":1000.00,"expire_by":1691097057,"description":"Payment for policy no #23456","customer":{"name":"Candidate Onboarding","email":"aakash.jain@utilitarianlab.com","contact":"+917042458620"},"currency":"INR","callback_url":"https://cms-assets.tutsplus.com/cdn-cgi/image/width=850/uploads/users/523/posts/32694/final_image/tutorial-preview-large.png","callback_method":"get","amount":1000.00,"accept_partial":true}    
    @HttpPost
    global static String webhookListener(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String body = req.requestBody.toString();
        
        System.debug('REQUEST----'+body);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String,Object> m2 =  (Map<String, Object>) m.get('payload');
        Map<String,Object> m3 =  (Map<String, Object>) m2.get('payment');
        Map<String,Object> m4 =  (Map<String, Object>) m3.get('entity');
        
        System.debug('PAYMENTID-----'+m4.get('id'));
        
        if(m4.containsKey('captured')){
            Map<String,Object> m5 =  (Map<String, Object>) m4.get('notes');
            String recId = m5.get('policy_name').toString();
            Opportunity opp = new Opportunity(Id=recId, Payment_Captured__c= m4.get('captured')==true?'Success':'Failed',StageName=m4.get('captured')==true?'Closed Won':'Needs Analysis');//, m4.get('captured')==true?StageName='Closed Won':StageName='Closed Lost'
            update opp;
            
            Invoice__c invoiceRec = [Select Id,Status__c From Invoice__c Where Opportunity__c =: recId ORDER BY CreatedDate DESC limit 1];
            if(m4.get('captured')==true){
                invoiceRec.Status__c = 'Realized';
            }
            if(m4.get('captured')==false){
                invoiceRec.Status__c = 'Not realized';
            }
            update invoiceRec;
            return 'Success';
        }
        else{
            return 'Error';
        }
    }
}