public with sharing class CycleCountMasterData {
    public static void updateCycleCountwithItemGrouppositiveData(){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup('Item Group 2', 'Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup.Id, item.Id);
    }

    public static void createCycleCountwithInactiveItemPositiveData(){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
    }

    public static void createCycleCountLinewithSkuPositiveData(){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1',item.Id, true);		
    }

    public static void createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData(){
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
    }
}