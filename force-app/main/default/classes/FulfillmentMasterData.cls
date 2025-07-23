@isTest
public class FulfillmentMasterData {
    public static void FulfillmentOrderGeneralize(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
    }
}