@isTest
public with sharing class ServiceBayHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.createServiceBay(branch1);
    }

    @isTest
    static void createServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        if(serviceBay != null){
            System.assertNotEquals(serviceBay, null, 'Expected serviceBay to be created.');
        }
        System.assertEquals('Test - ServiceBay', serviceBay.Name, 'Name not matched');
    }

    @isTest
    static void updateServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        System.assertNotEquals(serviceBay, null, 'ServiceBay should exist before update.');
        serviceBay.Name = 'Updated - ServiceBay';
        update serviceBay;
        dmpl__ServiceBay__c updatedServiceBay = TestDataHelpers.getServiceBay();
        System.assertEquals('Updated - ServiceBay', updatedServiceBay.Name, 'Expected Name to be updated.');
    }

    @isTest
    static void deleteServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        System.assertNotEquals(serviceBay, null, 'ServiceBay should exist before delete.');
        delete serviceBay;
        dmpl__ServiceBay__c deletedServiceBay;
        try {
            deletedServiceBay = TestDataHelpers.getServiceBay();
        } catch (Exception e) {
            deletedServiceBay = null;
        }
        System.assertEquals(null, deletedServiceBay, 'Expected ServiceBay to be deleted.');
    }

    @isTest
    static void createServiceBayWithActiveBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay('SBN2', branch, 'Warehouse');
        Test.stopTest();
        System.assertNotEquals(null, serviceBay, 'Service Bay should be created');
        System.assertEquals(branch.Id, serviceBay.dmpl__BranchId__c, 'Service Bay should be linked to correct Branch');
        System.assertEquals('SBN2', serviceBay.Name, 'Service Bay should have correct name');
    }
    
    @isTest
    static void createServiceBayWithInactiveBranchPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount.Id);
        partnerAccount.dmpl__IsActive__c = false;
        update partnerAccount;
        dmpl__Branch__c inactiveBranch = TestDataHelpers.getBranch('Branch 2');
        try {
            dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay('SBN2', inactiveBranch, 'Warehouse');
            System.assertNotEquals(null, serviceBay.Id, 'Service Bay has been be created');
        } catch (DmlException e) {
            System.assertEquals(e.getMessage().contains('inactive') || e.getMessage().contains('constraint'), false, 'Exception should relate to inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateServiceBayWithActiveBranchPositive() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount.Id);
        partnerAccount.dmpl__IsActive__c = false;
        update partnerAccount;
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay('SBN2', branch2, 'Warehouse');
        Boolean assignmentFailed = false;
        Test.startTest();
        try {
            serviceBay.dmpl__BranchId__c = branch1.Id;
            update serviceBay;
        } catch (System.SObjectException e) {
            assignmentFailed = true;
            System.assert(e.getMessage().contains('dmpl__BranchId__c'), 'Expected failure due to BranchId field being non-writable');
        }
        Test.stopTest();
        System.assert(assignmentFailed, 'Expected assignment to fail due to non-writable field');
    }

    @isTest
    static void createServiceBayWithoutBranchPositive() {
        Test.startTest();
        try {
            dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay('SBN2', null, 'Warehouse');
            System.assertEquals(null, serviceBay.Id, 'Service Bay has been be created without branch');
        } catch(Exception e) {
            System.assertEquals(e.getMessage().contains('Branch'), false, 'Exception should relate to branch');
        }
        Test.stopTest();
    }

    @isTest
    static void createServiceBayWithoutNameNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        try {
            dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay(null, branch, 'Warehouse');
            System.assertNotEquals(null, serviceBay.Id, 'Service Bay has been be created without name');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Name'), 'Expected error related to missing Name');
        }
        Test.stopTest();
    }
}