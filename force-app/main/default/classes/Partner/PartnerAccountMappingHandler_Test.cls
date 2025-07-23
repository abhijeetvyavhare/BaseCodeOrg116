@isTest
public with sharing class PartnerAccountMappingHandler_Test {
    @TestSetup
    static void createRequiredDate() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping('Testing');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);       
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 6','Product');
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
    }
    
    @isTest
    static void createPartnerAccountMapping() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertEquals(Date.newInstance(2024, 8, 21), partnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.newInstance(2025, 5, 21), partnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void updatePartnerAccountMapping() {
        Test.startTest();
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        partnerAccountMapping.dmpl__ToDate__c = Date.today().addDays(2);
        update partnerAccountMapping;
        Test.stopTest();
        dmpl__PartnerAccountMapping__c updatedPartnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertEquals(Date.newInstance(2024, 8, 21), updatedPartnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.today().addDays(2), updatedPartnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void deletePartnerAccountMapping() {
        Test.startTest();
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertNotEquals(null, partnerAccountMapping, 'Partner Account Mapping should exist before deletion.');
        Id mappingId = partnerAccountMapping.Id;
        delete partnerAccountMapping;
        Test.stopTest();
        dmpl__PartnerAccountMapping__c deletedMapping;
        try {
            deletedMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping(mappingId);
        } catch (Exception e) {
            deletedMapping = null;
        }
        System.assertEquals(null, deletedMapping, 'Partner Account Mapping should be marked as deleted.');
    }    
    
    @isTest
    static void editPartnerAccountMappingToExtendToDatePositiveEdit() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');     
        Date toDateExtended = Date.newInstance(2025, 6, 21);        
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping('Mapping 1',partnerAccount.id);
        mapping.dmpl__ToDate__c = toDateExtended;
        update mapping;        
        dmpl__PartnerAccountMapping__c updated = PartnerAccountMappingTestDataHelpers.getPartnerAccountMappingById(mapping.Id);
        System.assertEquals(partnerAccount.Id, updated.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(toDateExtended, updated.dmpl__ToDate__c, 'To Date should be updated/extended');
        Test.stopTest();
    }
    
    @isTest
    static void createMappingBetweenValidPartnerAccountAndCustomerWithCorrectBranchSelectedPositiveNew(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6'); 
        Date toDate = Date.newInstance(2025, 6, 30);
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
            'Mapping 1',
            customerAccount,
            branch,
            itemGroup,
            item,
            partnerAccount,
            toDate
        );        
        System.assertNotEquals(null, mapping, 'Mapping should be created successfully');
        System.assertEquals(partnerAccount.Id, mapping.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, mapping.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(branch.Id, mapping.dmpl__BranchId__c, 'Branch should match');
        Test.stopTest();
    }

    @isTest
    static void excludeAnItemGroupFromPartnerAccountMappingToRestrictPurchaseVisibilityPositiveEdit() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        Date toDate = Date.newInstance(2025, 6, 30);
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
            'Mapping 1',
            customerAccount,
            branch,
            null, 
            item,
            partnerAccount,
            toDate
        );
        System.assertNotEquals(null, mapping, 'Mapping should be created successfully');
        System.assertEquals('Mapping 1', mapping.Name, 'Name should match');
        System.assertEquals(customerAccount.Id, mapping.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(branch.Id, mapping.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, mapping.dmpl__ItemGroupId__c, 'Item Group should be excluded (null)');
        System.assertEquals(item.Id, mapping.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(partnerAccount.Id, mapping.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(toDate, mapping.dmpl__ToDate__c, 'To Date should match');
        Test.stopTest();    
    }
}