public without sharing class InvoiceTriggerHelper {
    static InvoiceTriggerHelper handlerInstance;
    public static InvoiceTriggerHelper getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new InvoiceTriggerHelper();
        return handlerInstance;
    }
    public void paymentStatusUpdated(Map<Id, Invoice__c> oldMap, Map<Id, Invoice__c> newMap){
        set<Id> invoiceIds = new Set<Id>();
        set<Id> failedinvoiceIds = new Set<Id>();
        
        for(Invoice__c invoiceRec : newMap.values()){
            if(invoiceRec.Status__c != oldMap.get(invoiceRec.Id).Status__c && invoiceRec.Status__c == 'Realized'){
                system.debug('Status accepted');
                invoiceIds.add(invoiceRec.Id);
            }
            if(invoiceRec.Status__c != oldMap.get(invoiceRec.Id).Status__c && invoiceRec.Status__c == 'Not realized'){
                system.debug('Status Rejected');
                failedinvoiceIds.add(invoiceRec.Id);
            }
        }
        if(!invoiceIds.isEmpty()){
            EmailIUtility.sendEmailForPaymentSuccess(invoiceIds, 'Razor Pay Success Status');
        }
         if(!failedinvoiceIds.isEmpty()){
            EmailIUtility.sendEmailForPaymentSuccess(failedinvoiceIds, 'Razor Pay Failure Status');
        }
    }
}