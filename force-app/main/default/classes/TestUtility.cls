public class TestUtility {
    public static Account createAccount(String Name, string email,string phone){
        Account acc = new Account();
        acc.Name = Name;
        acc.Phone = phone;
        acc.Account_Email_c__c = email;
        return acc;
    }
}