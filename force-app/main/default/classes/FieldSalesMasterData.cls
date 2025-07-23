public with sharing class FieldSalesMasterData {
    public static void createPartner4Data() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
    }
}