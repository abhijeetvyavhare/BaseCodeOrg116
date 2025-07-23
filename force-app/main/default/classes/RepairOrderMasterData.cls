public with sharing class RepairOrderMasterData {
    public static void createRepairOrderWithInactiveBranchNegativeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
    }

    public static void createRepairOrderWithInactiveCustomerAccountNegativeData() {
        Account customer7 = TestDataHelpers.createCustomerAccount('Customer 7');
        customer7.dmpl__IsActive__c=false;
        update customer7;
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
    }

    public static void createRepairOrderWithPriceListforPartneraccountAndBranchData() {
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    }
}