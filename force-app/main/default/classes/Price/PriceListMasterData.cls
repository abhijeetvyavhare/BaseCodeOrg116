public with sharing class PriceListMasterData {
    Public Static void updatePriceListWithPriceListPartnerAccountPositiveData(){
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id);
    }
}