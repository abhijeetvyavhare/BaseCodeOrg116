@isTest
public with sharing class DeliveryOrderMasterData {
    public static void createDeliveryOrderLineWithWrongStorageLocationNegativeTestData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3' ,partnerAccount.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 3', branch.Id);
        dmpl__Item__c discontinuedItem = TestDataHelpers.createItem('Item 8','Product');
    }

    public static void createDeliveryOrderLineWithInactiveItemData() {
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
        item2.dmpl__IsActive__c=false;
        update item2;
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3',partnerAccount.Id,branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item1.Id,1500);
    } 

    public static void createDeliveryOrderLineWithoutRepairOrderLineData(
        Id customerAccountId,
        Id partenerAccountId,
        Id branchId,
        Id PriceListId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5','Product');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partenerAccountId,branchId);
        dmpl__Tax__c taxIGST = TestDataHelpers.createIGSTTax('IGST',taxGroup.Id,18);
        dmpl__TaxGroupRule__c taxGroupRule= TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PriceListRules__c  priceListRule = TestDataHelpers.createPriceListRules(PriceListId, item.Id, 1000);
    }

    public static void createDeliveryOrderLineWithoutSaleOrderLineData(
        Id customerAccountId,
        Id partenerAccountId,
        Id branchId,
        Id PriceListId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item.id, false);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partenerAccountId,branchId);
        dmpl__Tax__c taxIGST = TestDataHelpers.createIGSTTax('IGST',taxGroup.Id,18);
        dmpl__TaxGroupRule__c taxGroupRule= TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PriceListRules__c  priceListRule = TestDataHelpers.createPriceListRules(PriceListId, item.Id, 1200);
    }

    public static void createDeliveryOrderLineWithRequiredSKUPositiveData(
        Id partenerAccountId,
        Id branchId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item.id, false);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partenerAccountId,branchId);
        dmpl__Tax__c taxIGST = TestDataHelpers.createIGSTTax('IGST',taxGroup.Id,18);
        dmpl__TaxGroupRule__c taxGroupRule= TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }
 
    public static void createDeliveryOrderLineWithRepairOrderLineReferenceData(
        Account partner, 
        Account customer, 
        dmpl__Branch__c branch, 
        dmpl__Item__c item
    ) {
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
		dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(partner, customer, branch, asset, 100);
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLine(repairOrder.Id, item.Id, 10.00, 1000.00);
    }

    public static void createDeliveryOrderLineWithNoRequiredSKUPositiveData(
        Id partenerAccountId,
        Id branchId,
        Id ItemId
    ) {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partenerAccountId,branchId);
        dmpl__Tax__c taxIGST = TestDataHelpers.createIGSTTax('IGST',taxGroup.Id,18);
        dmpl__TaxGroupRule__c taxGroupRule= TestDataHelpers.createTaxGroupRule(itemId, taxGroup.Id);
    }

    public static void createDeliveryOrderLineWithDiscountinuedItemPositiveData(
        Id partnerId,
        Id branchId
    ){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partnerId, branchId);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroupGST = TestDataHelpers.createTaxGroup('IGST 18', partnerId, branchId);
        dmpl__Tax__c taxIGST = TestDataHelpers.createTax('IGST', taxGroupGST.Id, 18);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST.Id);
    }
}