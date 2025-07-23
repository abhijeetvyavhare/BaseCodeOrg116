public with sharing class ServiceLeadMasterData {
    public static void CreateServiceLeadWithinactivePartnerCustomerBranchNegativeData(){
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c=false;
        update partner;
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner.Id);
    }
}