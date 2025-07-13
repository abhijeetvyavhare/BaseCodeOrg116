@isTest
public with sharing class SKUHandler_Test {
    @TestSetup
    static void createRequiredData() {
        
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product');
        item9.dmpl__IsSKURequired__c = true;
        update item9;
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        
    }
    
    @isTest
    static void createSKURecordCreationWithActiveItemPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            False,
            item9
        );
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    }
    
    
    @isTest
    static void createSKUWithDefinedProductColorPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');        
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            False,
            item9
        );
        sku.dmpl__ProductColor__c = 'Sample';
        Update sku;
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('Sample', fetchSku.dmpl__ProductColor__c, 'Product Color should match');
    }
    
    
    @isTest
    static void createSKUMarkedAsDefaultPositive(){
        Test.startTest();
        
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            True,
            item9 
        );
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        Test.stopTest();
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, fetchSku.dmpl__IsDefault__c, 'IsDefault should be true');
    }
    
    
    @isTest
    static void createSKUWithUnitOfMeasureOfConversionProvidedPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            False,
            item9
        );
        sku.dmpl__QuantityUnitOfMeasure__c = 'Sample';
        Update sku;
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('Sample', fetchSku.dmpl__QuantityUnitOfMeasure__c, 'Unit of Measure should be Box');
    }
    
    
    @isTest
    static void createSKUWithoutItemIdNegative() {
        Test.startTest();
        
        dmpl__SKU__c sku;
        Boolean exceptionThrown = false;
        try {
            sku = ItemDataHelper.createSKU(
                False,
                null
            );
        System.assert.isTrue(sku == null, 'SKU creation must fail when ItemId is missing.');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(sku == null, 'SKU creation must fail when ItemId is missing.');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception due to missing ItemId was not thrown.');
    }
    
    
    @isTest
    static void createSKUWithoutSKUNamePositive() {
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku;
        Boolean exceptionThrown = false;
        try {
            sku = ItemDataHelper.createSKU(
                False,
                item9
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(sku != null, 'SKU creation must fail when SKU Name is missing.');
        }
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
        Test.stopTest();
    }
    
    
    @isTest
    static void updateSKURecordCreationWithActiveItemPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            False,
            item9
        );
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        Test.stopTest();
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    }
    
    
    @isTest
    static void updateMultipleSKUCreatedForTheSameItemWithDifferentColorsPositive() {
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = ItemDataHelper.createSKU(
            False,
            item9
        );
        sku.dmpl__ProductColor__c = 'Sample';
        Update sku;
        dmpl__SKU__c fetchSku = ItemDataHelper.getSKU(sku);
        System.assertNotEquals(null, fetchSku, 'SKU record should be created');
        System.assertEquals('Test SKU', fetchSku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('Sample', fetchSku.dmpl__ProductColor__c, 'Initial Product Color should be Red');
        Test.stopTest();
    }
 
}