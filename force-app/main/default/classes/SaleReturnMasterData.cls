public with sharing class SaleReturnMasterData {
    public static void createSaleInvoiceMasterData(){
        Account partner6 = TestDataHelpers.createPartnerAccount('Partner 6');
        TestDataHelpers.createCustomerAccount('Customer 3');
        TestDataHelpers.createBranch('Branch 6', partner6.Id);
    }

    public static void createItemLotMasterData(){
        Account partner6 = TestDataHelpers.createPartnerAccount('Partner 6');
        TestDataHelpers.createBranch('Branch 6', partner6.Id);
        dmpl__item__c item8 = TestDataHelpers.createItem('Item 8', 'Product');
        TestDataHelpers.createSKU('SKU 8', item8.Id, true);
    }
}