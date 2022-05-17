public without sharing class RazorpayPaymentHandler {
    public RazorpayPaymentHandler() {
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> displayOppRecord(){
        return [Select Id,Name from Opportunity];
    }
    
    @AuraEnabled(cacheable = true)
    public static Map<String,Object> sendPaymentLink(String recordId){
        // String username = 'rzp_test_UJ6CeLOw4o6n89';
        // String password = 'S6PdyPzfyds12aPkkH0CKrQP';
        
        if(!String.isBlank(recordId)){
            Opportunity opp = [SELECT Id, Name, Amount ,AccountId,Account.Phone,Account.Account_Email_c__c From Opportunity Where Id =: recordId];
            System.debug('Opportunity'+opp);
            
            if(opp.Amount!=null && opp.Account.Account_Email_c__c!=null && opp.Account.Phone!=null){
                
                String email = opp.Account.Account_Email_c__c;
                String contact = opp.Account.Phone;
                String name = opp.Name;
                Decimal amount = opp.Amount *100;
                
                try {
                    RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();
                    
                    razorpayRequestJSON.amount = amount;
                    razorpayRequestJSON.first_min_partial_amount = amount;
                    razorpayRequestJSON.setCustomer(name,contact,email);
                    razorpayRequestJSON.setNotes(opp.Id);
                    
                    String body = JSON.serialize(razorpayRequestJSON);
                    body = body.replace('currencyType','currency');
                    
                    System.debug('Body---'+body);
                    
                    HTTP http = new HTTP();
                    HttpRequest req = new HttpRequest();
                    
                    req.setHeader('Content-Type', 'application/json');
                    req.setEndpoint('callout:RazorPay');
                    req.setMethod('POST');
                    req.setBody(body);
                    
                    HTTPResponse res = http.send(req);
                    Map<String,Object> jsonBody = (Map<String,Object>) Json.deserializeUntyped(res.getBody());
                    
                    System.debug('RESPPPP'+jsonBody);
                    return jsonBody;       
                }
                catch (Exception e) {
                    system.debug('Error>>'+e.getMessage());
                    system.debug('Error@>>'+e.getLineNumber());
                    throw new AuraHandledException(e.getMessage());
                }
            }
            return null;
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static void createInvoiceRec(String recordId){
        try {
            system.debug('recordId-->'+recordId);
            if(!String.isBlank(recordId)){
                Id recId = (Id) recordId;
                
                Opportunity opp;
                
                opp = [SELECT Id, Name, Amount ,AccountId,Account.Phone,Account.Account_Email_c__c From Opportunity Where Id =: recordId];
                Invoice__c invoiceRec = new Invoice__c();
                invoiceRec.Opportunity__c = opp.Id;
                invoiceRec.Amount__c = opp.Amount;
                insert invoiceRec;
                
                
            }    
        } catch (Exception e) {
            system.debug('e-->'+e.getMessage());
            system.debug('e-->'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
}