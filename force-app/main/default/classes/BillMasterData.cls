@isTest
public with sharing class BillMasterData {
    public static void createBillLineWithNoRequiredSKUData(Id partnerAccountId, Id branchId, Id priceListId) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 1500);
    }

    public static void createGoodsReceiptAndGoodsReceiptLines(
        Account partner,
        Account supplier,
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ){
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner, 
            branch, 
            null, 
            supplier
        );
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        goodsReceiptLine.dmpl__ReceivedQuantity__c = 20;
        goodsReceiptLine.dmpl__InvoiceQuantity__c = 10;
        update goodsReceiptLine;
    }
}