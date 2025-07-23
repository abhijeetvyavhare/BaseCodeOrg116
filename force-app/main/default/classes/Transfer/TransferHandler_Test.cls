@isTest
public with sharing class TransferHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partner1.Id);
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id);
        partner2.dmpl__IsActive__c = false;
        update partner2;
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch2);
    } 
 
    @isTest
    static void createTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        if (transfer != null) {
            System.assertNotEquals(transfer, null, 'Expected Transfer to be created.');
            System.assertEquals(false, transfer.dmpl__PerformInwardPosting__c, 'PerformInwardPosting should be false');
            System.assertEquals(false, transfer.dmpl__PerformInwardReceive__c, 'PerformInwardReceive should be false');
            System.assertEquals(Date.today(), transfer.dmpl__TransferTime__c, 'TransferTime should be today');
            System.assertNotEquals(transfer.dmpl__BranchId__c, null, 'BranchId should not be null');
            System.assertNotEquals(transfer.dmpl__ToBranchId__c, null, 'ToBranchId should not be null');
            System.assertNotEquals(transfer.dmpl__PartnerAccountId__c, null, 'PartnerAccountId should not be null');
        }
    }
 
    @isTest
    static void updateTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(transfer, null, 'Transfer should exist before update.');
        transfer.dmpl__PerformInwardPosting__c = true;
        transfer.dmpl__PerformInwardReceive__c = true;
        update transfer;
        dmpl__Transfer__c updatedTransfer = TransferTestDataHelper.getTransfer();
        System.assertEquals(true, updatedTransfer.dmpl__PerformInwardPosting__c, 'PerformInwardPosting should be updated to true');
        System.assertEquals(true, updatedTransfer.dmpl__PerformInwardReceive__c, 'PerformInwardReceive should be updated to true');
    }
 
    @isTest
    static void deleteTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(transfer, null, 'Transfer should exist before delete.');
        delete transfer;
        dmpl__Transfer__c deletedTransfer = null;
        try {
            deletedTransfer = TransferTestDataHelper.getTransfer();
        } catch (Exception e) {
            deletedTransfer = null;
        }
        System.assertEquals(null, deletedTransfer, 'Transfer should be deleted and not found in query.');
    }
    
    @isTest
    static void createATransferRecordWithAllMandatoryFields() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch);
        System.assertNotEquals(null, transfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'Branch should match');
    }
   
    @isTest
    static void createTransferWithValidPartnerAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch);
        System.assertNotEquals(null, transfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    static void createTransferWithDifferentValidFromAndToBranchesPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner4.Id);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch4);
        dmpl__Transfer__c fetchedtransfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, fetchedTransfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partner1.Id, fetchedTransfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedTransfer.dmpl__BranchId__c, 'Branch should match');
        Test.stopTest();
    }
    
    @isTest
    Static void createTransferWithInactiveFromBranchNegative(){
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        try {
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner3, branch3, branch1);
        } catch (Exception e) {
            exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using inactive branch');
    }

    @isTest
    static void createTransferWithEmptyToBranchNegative() {
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        try {
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, null);
        } catch (Exception e) {
            exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using to branch as null');
    }

    @isTest 
    static void updateTransferRemovePartnerAccountNegative(){
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch);
        try {
            transfer.dmpl__PartnerAccountId__c = null;
            update transfer;
            dmpl__Transfer__c fetchedTransfer = TransferTestDataHelper.getTransfer(transfer);
        } catch (Exception e) {
            exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when removinf partner partner');
    }

    @isTest
    static void updateTransferAddDateTimePositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, null);
        transfer.dmpl__TransferTime__c = Date.Today();
        update transfer;
        dmpl__Transfer__c fetchedtransfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, fetchedTransfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partner.Id, fetchedTransfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedTransfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.Today(), fetchedTransfer.dmpl__TransferTime__c, 'Error');
    }

    @isTest
    static void createTransferWithOnlyNameNegative(){
        Boolean exceptionThrown = false;
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        try {
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, null);
        } catch (Exception e) {
            exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when only using partner partner');
    }

    @isTest
    static void createTransferWithInvalidBranchAndValidPartnerAccountNegative(){
        Boolean exceptionThrown = false;
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        try {
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner2, branch3);
        } catch (Exception e) {
            exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using invactive branch and inactive partner account');
    }

    @isTest
    static void createTransferWithActivePartnerPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithInActivePartnerNegative(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.createTransfer(partner2, branch1, branch2);
            System.Assert(transfer == null, 'Transfer should not get created with InActive Partner');
        } catch (Exception e) {
            System.Assert(transfer == null, 'Transfer should not get created with InActive Partner' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createTransferWithInActiveToBranchNegative(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch3);
            System.Assert(transfer != null, 'Transfer should not get created with InActive To Branch');
        } catch (Exception e) {
            System.Assert(transfer != null, 'Transfer should not get created with InActive To Branch' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createTransferWithTypeAsOutwardPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals('Outward', transfer.dmpl__Type__c, 'Type should Outward');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithTypeAsInwardPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch2, 'Inward');
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals('Inward', transfer.dmpl__Type__c, 'Type should Inward');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithNoTypeSelectedNegative(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch2, 'None');
            System.Assert(transfer == null, 'Transfer should not get created with Type as None');
        } catch (Exception e) {
            System.Assert(transfer == null, 'Transfer should not get created with Type as None' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createTransferWithSameFromBranchAsDealerPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.getTransfer();
        } catch (Exception e) {
            System.Assert(transfer == null, 'Transfer should create with Same From Branch As Dealer' + e.getMessage());
        }
        transfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithSameToBranchAsDealerPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch1);
        } catch (Exception e) {
            System.Assert(transfer == null, 'Transfer should create with Same To Branch As Dealer' + e.getMessage());
        }
        transfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch1.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithDifferentFromBranchNegative(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer;
        try {
            transfer = TransferTestDataHelper.createTransfer(partner1, branch2, branch1);
            System.Assert(transfer == null, 'Transfer should not get created with different From Branch');
        } catch(Exception e) {
            System.Assert(transfer == null, 'Transfer should not get created with different From Branch' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createTransferWithDifferentToBranchPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithValidTransferTimePositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        transfer.dmpl__TransferTime__c = Date.today();
        update transfer;
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals(Date.today(), transfer.dmpl__TransferTime__c, 'Transfer Time should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithValidTransferDatePositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        transfer.dmpl__TransferTime__c = Date.today().addDays(1);
        update transfer;
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals(Date.today().addDays(1), transfer.dmpl__TransferTime__c, 'Transfer Time should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithTransferByPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Resource__c resource = TestDataHelpers.createResource('Resource 1', partner1.Id, branch1.Id, true); 
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        transfer.dmpl__TransferredById__c = resource.Id;
        update transfer;
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created with Active Resource!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals(resource.Id, transfer.dmpl__TransferredById__c, 'Resource should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithInactiveTransferByPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Resource__c resource = TestDataHelpers.createResource('Resource 2', partner2.Id, branch2.Id, false); 
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        try{
            transfer.dmpl__TransferredById__c = resource.Id;
            update transfer;
            System.Assert(false, 'Transfer should cannot be created! with Inactive Resource');
        } catch (Exception e) {
            System.Assert(true, 'Transfer should cannot be created! with Inactive Resource' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createTransferWithInwardDocumentPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c inwardTransfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch2, 'Inward');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        transfer.dmpl__InwardDocumentId__c = inwardTransfer.Id;
        update transfer;
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created with Active Resource!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals(inwardTransfer.Id, transfer.dmpl__InwardDocumentId__c, 'Inward Document should match');
        Test.stopTest();
    }

    @isTest
    static void createTransferWithOutwardDocumentPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Transfer__c outwardTransfer = TransferTestDataHelper.createTransfer(partner1, branch1, branch2, 'Outward');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        transfer.dmpl__OutwardDocumentId__c = outwardTransfer.Id;
        update transfer;
        System.assertNotEquals(null, transfer.Id, 'Transfer should get Created with Active Resource!');
        System.assertEquals(partner1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(branch2.Id, transfer.dmpl__ToBranchId__c, 'To Branch should match');
        System.assertEquals(outwardTransfer.Id, transfer.dmpl__OutwardDocumentId__c, 'Outward Document should match');
        Test.stopTest();
    }
}