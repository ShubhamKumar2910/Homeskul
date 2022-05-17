global class PaymentInvoiceHelper {
 public  String InvoiceId {get; set;}
    public  Opportunity oppDetails {get; set;} 
    public  Invoice__c invoiceRecord {get; set;} 
    //public  Company_Specifications__c companyDetails {get; set;} 
    
    global PaymentInvoiceHelper(){
        InvoiceId =  ApexPages.CurrentPage().getparameters().get('id');
        system.debug('InvoiceId-->'+InvoiceId);
       // companyDetails = [Select Name__c,Address__c,SAC__c,CIN__c,Email__c,GSTIN__c,PAN__c,Phone__c From Company_Specifications__c ];
        //system.debug('companyDetails-->'+companyDetails);
        invoiceRecord = [Select Opportunity__c,Invoice_Number__c,Initiated_Date__c,Invoice_Due_Date__c,PRODUCT_CODE__c,Amount__c,Opportunity__r.Description,Opportunity__r.Amount From Invoice__c where Id =: InvoiceId ];
        system.debug('invoiceRecord-->'+invoiceRecord);
        oppDetails = [Select Id,Name,Account.Name, Account.Phone,Account.Account_Email_c__c,Account.BillingStreet,Description,Amount, 
                      Account.BillingCity, Account.BillingState,Account.ShippingStreet,Account.ShippingCity, Account.ShippingState,Account.ShippingPostalCode,Account.BillingPostalCode
                      ,Account.BillingCountry From Opportunity where id =: invoiceRecord.Opportunity__c];
        system.debug('oppDetails-->'+oppDetails);
    }
    @future(callout=true)
    global static void attachPdf(string recordId){
        string reciepientEmail ;
        PageReference pdfPage = new PageReference('https://partial-razorpaywebhookapi.cs75.force.com/apex/TaxInvoice?id=');
        //PageReference pdfPage = Page.TaxInvoice;
        pdfPage.getParameters().put('id',recordId);
        system.debug('recordId-->'+recordId);
        Blob pdfBlob; 
        pdfBlob = pdfPage.getContent(); 
        
        Attachment attach = new Attachment(parentId = recordId, Name = 'TaxInvoice.pdf', body = pdfBlob); 
        insert attach;
        reciepientEmail = [Select Opportunity__r.Account.Account_Email_c__c From Invoice__c where Id =: recordId].Opportunity__r.Account.Account_Email_c__c;
        
        //EmailIUtility.sendEmailForPaymentSuccess(reciepientEmail, Constants.RAZOR_PAY_SUCCESS_EMAIL_OPPORTUNITY, Constants.OPPORTUNITY, recordId);
    }    
}