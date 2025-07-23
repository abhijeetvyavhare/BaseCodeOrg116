public with sharing class PurchaseRequisitionMasterData {
    public static void createBranch3(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch(
            'Branch 3', 
            partnerAccount1.Id
        );
    }
}