public class EmailIUtility {
    public static void sendEmailForPaymentSuccess(set<Id> invoiceIds, String templateName) {
        try{
            List<Invoice__c> invoiceDetails = new List<Invoice__c>();
            system.debug('invoiceIds-----'+invoiceIds);
            system.debug('templateName-----'+templateName);
            EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name =: templateName ];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            invoiceDetails = [Select Id, Opportunity__r.Account.Name,Opportunity__r.Account.Account_Email_c__c	,Amount__c,Opportunity__r.Amount FROM Invoice__c Where Id In : invoiceIds];
            if(!invoiceDetails.isEmpty()){
                for(Invoice__c invoiceRec: invoiceDetails){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> recipients = new List<String>();
                    recipients.add(invoiceRec.Opportunity__r.Account.Account_Email_c__c);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Homeskul');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    htmlBody = htmlBody.replace('{!User.Name}', userinfo.getName());
                    
                    if(htmlBody.contains('{!Account.Name}')){
                        htmlBody = htmlBody.replace('{!Account.Name}', invoiceRec.Opportunity__r.Account.Name);
                    }
                    
                    if(htmlBody.contains('{!Opportunity.Amount}')){
                        htmlBody = htmlBody.replace('{!Opportunity.Amount}', String.ValueOf(invoiceRec.Opportunity__r.Amount) != null ? String.ValueOf(invoiceRec.Opportunity__r.Amount) : '');
                    }
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
            }
            Messaging.sendEmail(mails);
        }catch(Exception e){
            System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
        }
        
    }
    public static void sendEmail(set<Id> recordIds, String templateName,String triggerPoint){
        try{
            List<Opportunity> opportunityList = new List<Opportunity>();
            List<Account> accList = new List<Account>();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate emailTempRec = new EmailTemplate();
            
            if(!String.isBlank(TemplateName) && TemplateName != null){
                emailTempRec = [SELECT Id,Subject,HtmlValue,Body FROM EmailTemplate WHERE Name =: TemplateName];    
            }
            
            if(!recordIds.isEmpty()){
                
                if(triggerPoint == 'RENEWAL'){
                    opportunityList = [Select Id, Account.Name,Account.Account_Email_c__c,Renewal_Date__c FROM Opportunity Where Id In : recordIds];
                }else if(triggerPoint == 'INACTIVE' || triggerPoint == 'DEAD'){
            		accList = [SELECT Id,Name,Account_Email_c__c FROM Account WHERE Id IN :recordIds];
                }
                
                if(!opportunityList.isEmpty()){
                    for(Opportunity oppRec : opportunityList){
                        
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        
                        String[] toAddresses = new String[] {oppRec.Account.Account_Email_c__c}; 
                        email.setToAddresses(toAddresses);
                        
                        String htmlBody = emailTempRec.HtmlValue;
                        
                        htmlBody = htmlBody.replace('{!User.Name}', userinfo.getName());
                        
                        if(htmlBody.contains('{!Account.Name}')){
                            htmlBody = htmlBody.replace('{!Account.Name}', oppRec.Account.Name);
                        }
                            
                        if(htmlBody.contains('{!Opportunity.Renewable_Date__c}')){
                            htmlBody = htmlBody.replace('{!Opportunity.Renewable_Date__c}', String.ValueOf(oppRec.Renewal_Date__c));
                        }
                        
                        email.setHtmlBody(htmlBody);
                        email.setSubject(emailTempRec.Subject);
                        emails.add(email);
                    }
                    if(!emails.isEmpty()){
                        Messaging.sendEmail(emails);
                    }
                }
            }
        }
        catch(Exception ex){
            system.debug('Error-->'+ex.getMessage());
            system.debug('Errror!!-->'+ex.getLineNumber());
        }
    }
}