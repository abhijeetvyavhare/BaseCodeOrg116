public with sharing class ContactMasterData {
    public static void createInvalidAccount(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Invalid Customer Account');
        customerAccount.dmpl__IsActive__c = false;
        update customerAccount;
    }
}