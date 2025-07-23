@isTest
public with sharing class BillMasterData {
    public static void createBillLineWithNoRequiredSKUData(Id partnerAccountId, Id branchId, Id priceListId) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 1500);
    }
}