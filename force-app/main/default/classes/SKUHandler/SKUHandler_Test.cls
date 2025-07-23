@isTest
public with sharing class SKUHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product');
        item9.dmpl__IsSKURequired__c = true;
        update item9;
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1', 'Product');
    }
    
    @isTest
    static void createSKURecordCreationWithActiveItemPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = TestDataHelpers.createSku(
            'sku3', 
            item9.Id, 
            null, 
            false, 
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, sku, 'SKU record should be created');
        System.assertEquals('sku3', sku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createSKUWithDefinedProductColorPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = TestDataHelpers.createSku(
            'sku3', 
            item9.Id, 
            'Sample', 
            false, 
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, sku, 'SKU record should be created');
        System.assertEquals('sku3', sku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('Sample', sku.dmpl__ProductColor__c, 'Product Color should match');
    }
    
    @isTest
    static void createSKUMarkedAsDefaultPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = TestDataHelpers.createSku(
            'sku3', 
            item9.Id, 
            null, 
            true, 
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, sku, 'SKU record should be created');
        System.assertEquals('sku3', sku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, sku.dmpl__IsDefault__c, 'IsDefault should be true');
    }
    
    @isTest
    static void createSKUWithUnitOfMeasureOfConversionProvidedPositive(){
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = TestDataHelpers.createSku(
            'sku3', 
            item9.Id, 
            null, 
            false, 
            'Sample'
        );
        Test.stopTest();
        System.assertNotEquals(null, sku, 'SKU record should be created');
        System.assertEquals('sku3', sku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('Sample', sku.dmpl__QuantityUnitOfMeasure__c, 'Unit of Measure should be Box');
    }
    
    @isTest
    static void createSKUWithoutItemIdNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__SKU__c sku = TestDataHelpers.createSku(
                'sku3', 
                null,   
                null, 
                false, 
                null
            );
            System.assertEquals(null, sku.Id, 'SKU creation must fail when ItemId is missing.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception due to missing ItemId was not thrown.');
    }
    
    @isTest
    static void createSKUWithoutSKUNamePositive() {
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        Boolean exceptionThrown = false;
        try {
            dmpl__SKU__c sku = TestDataHelpers.createSku(
                null,     
                item9.Id,     
                null, 
                false, 
                null
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'Exception caught while creating sku without name');
        Test.stopTest();
    }
    
    @isTest
    static void updateMultipleSKUCreatedForTheSameItemWithDifferentColorsPositive() {
        Test.startTest();
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku = TestDataHelpers.createSku(
            'SKU 3', 
            item9.Id, 
            null, 
            false, 
            null
        );
        System.assertNotEquals(null, sku, 'SKU record should be created');
        System.assertEquals('SKU 3', sku.Name, 'SKU Name should match');
        System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');
        sku.dmpl__ProductColor__c = 'Sample';
        update sku;
        System.assertEquals('Sample', sku.dmpl__ProductColor__c, 'Product Color should be updated to Sample');
        Test.stopTest();
    }
}