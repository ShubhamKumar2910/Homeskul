@isTest 
public class RaxzorPayTest {
    @isTest public static void RazorpayWebhookHandlerTest(){
        RazorpayRequestJSON requestJsonInstance = new RazorpayRequestJSON();
        requestJsonInstance.setCustomer('name', 'contact', 'email');
    }
    @isTest public static void RazorpayPaymentHandlerTest(){
        Account accRec = TestUtility.createAccount('Account', 'aakash.jain@utilitarianlab.com', '+917042458620');
    }
}