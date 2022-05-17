@isTest
public class RazorpayPaymentHandlerTest  {
    
    @isTest
    public Static void TestData(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Account_Email_c__c = 'dineshbaddawar@gmail.com';
        acc.Phone = '122234567890';
        insert acc;
        
        Lead le = new Lead();
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.CloseDate = system.today();
        opp.StageName = 'Prospecting';
        opp.Amount = 5000;
        opp.AccountId = acc.Id;
        insert opp;
        
        test.startTest();
        // RazorpayPaymentHandler var = new RazorpayPaymentHandler();
        // RazorpayPaymentHandler.displayOppRecord();
        Test.setMock(HttpCalloutMock.class, new MockTest());
        RazorpayPaymentHandler.sendPaymentLink(opp.Id);
        test.stopTest();
        
    }
}