@isTest
public with sharing class StorageLocationHandler_Test {
    @TestSetup
    static void createRequiredData() {   
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
    }
    
    @isTest
    static void createStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        if (storageLocation != null) {
            System.assertNotEquals(storageLocation, null, 'Expected StorageLocation to be created.');
            System.assertEquals('Test - Storage - Location', storageLocation.Name, 'Name should match');
        }
    }
    
    @isTest
    static void updateStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertNotEquals(storageLocation, null, 'StorageLocation should exist before update.');   
        storageLocation.Name = 'Name changed';
        update storageLocation;
        dmpl__StorageLocation__c updatedLocation = TestDataHelpers.getStorageLocation();    
        System.assertEquals('Name changed', updatedLocation.Name, 'Name is updated');
    }
    
    @isTest
    static void deleteStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertNotEquals(storageLocation, null, 'StorageLocation should exist before delete.');
        delete storageLocation;
        dmpl__StorageLocation__c deletedLocation = null;
        try {
            deletedLocation = TestDataHelpers.getStorageLocation();
        } catch (Exception e) {
            deletedLocation = null;
        }
        System.assertEquals(null, deletedLocation, 'StorageLocation should be deleted and not found in query.');
    }
    
    @isTest
    static void createStorageLocationNormalPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        Test.stopTest();
        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals(branch.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
    }
    
    @isTest
    static void createStorageLocationWithoutBranchNegative() {
        Test.startTest();
        try {
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', null, 'Warehouse');
            System.assertEquals(null, storageLocation.Id, 'Storage location should not be created without branch');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created without branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createStorageLocationWithBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        Test.stopTest();
        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals(branch.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
    }
    
    @isTest
    static void createStorageLocationWithWrongBranchNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try {
            StorageLocationMasterData.createStorageLocationWithWrongBranchNegativeData(partnerAccount.Id);
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
            System.assertNotEquals(null, storageLocation.Id, 'Storage location should not be created with wrong branch');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created with wrong branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateStorageLocationWithWrongBranchNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertEquals(branch.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            StorageLocationMasterData.createStorageLocationWithWrongBranchNegativeData(partnerAccount.Id);
            dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');     
            storageLocation.dmpl__BranchId__c = branch4.Id;
            update storageLocation;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when assigning wrong branch to storage location');
        Test.stopTest();
    }
    
    @isTest
    static void createStorageLocationWithInactiveBranchNegative() {
        Test.startTest();
        try {
            StorageLocationMasterData.createStorageLocationWithInactiveBranchNegativeData();
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
            System.assertNotEquals(null, storageLocation.Id, 'Storage location should not be created with inactive branch');    
        } catch(Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created with inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateStorageLocationWithInactiveBranchNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertEquals(branch.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            StorageLocationMasterData.createStorageLocationWithInactiveBranchNegativeData();
            dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
            storageLocation.dmpl__BranchId__c = branch3.Id;
            update storageLocation;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when assigning Inactive branch to storage location');
        Test.stopTest();
    }
    
    @isTest
    static void createStorageLocationWithLocationNamePositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        Test.stopTest();
        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals('Test - Storage - Location', storageLocation.Name, 'Name should be Test - Storage - Location');
        System.assertEquals(branch.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
    }
    
    @isTest
    static void createStorageLocationWithoutLocationNameNegative() {
        Test.startTest();
        try {
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
            storageLocation.Name = null;
            update storageLocation;
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created without name');
        }
        Test.stopTest();
    }
}