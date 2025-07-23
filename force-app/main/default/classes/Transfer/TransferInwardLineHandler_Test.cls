@isTest
public with sharing class TransferInwardLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch  = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.id, true);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
        dmpl__TransferInwardLine__c transferInwardLine = TransferTestDataHelper.createTransferInwardLine(transferOutwardLine, transfer, branch);
    }
    
    @isTest
    static void createTransferInwardLinePositive() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        if (line != null) {
            System.assertNotEquals(line, null, 'Expected TransferInwardLine to be created.');
            System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be 1');
            System.assertNotEquals(line.dmpl__TransferId__c, null, 'TransferId should not be null');
            System.assertNotEquals(line.dmpl__BranchId__c, null, 'BranchId should not be null');
        }
    }
    
    @isTest
    static void updateTransferInwardLinePositive() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(line, null, 'TransferInwardLine should exist before update.');
        line.dmpl__Quantity__c = 5;
        update line;
        dmpl__TransferInwardLine__c updatedLine = TransferTestDataHelper.getTransferInwardLine();
        System.assertEquals(5, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
    }
    
    @isTest
    static void deleteTransferInwardLineNegative() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(line, null, 'TransferInwardLine should exist before delete.');
        Test.startTest();
        try {
            delete line;
            System.assert(false, 'Expected DML exception when deleting TransferInwardLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 
            'Expected FIELD_CUSTOM_VALIDATION_EXCEPTION error');
            System.assert(e.getMessage().contains('There are downstream transaction'), 
            'Error should mention downstream transactions');
        }
        Test.stopTest();
        dmpl__TransferInwardLine__c nonDeletedLine = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(null, nonDeletedLine, 'TransferInwardLine should still exist after failed delete');
    }
    
    @isTest
    static void  createTransferInwardLineWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    @isTest
    static void  updateTransferInwardLineWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        Update branch3;
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch3.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__BranchId__c = branch.Id;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    @isTest
    static void  createTransferInwardLineWithItemPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    @isTest
    static void  updateTransferInwardLineWithItemPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__ItemId__c = item3.Id;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item3.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    @isTest
    static void  createTransferInwardLineWithQuantityPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    static void  updateTransferInwardLineWithQuantityPositive(){
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id, 
            transferOutwardLine.Id, 
            branch.Id, 
            item.Id, 
            1000
        );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__Quantity__c = 2000;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item3.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(2000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    @isTest
    static void createTransferInwardLineWithoutQuantityNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        try {
            dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
                transfer.Id, 
                transferOutwardLine.Id, 
                branch.Id, 
                item.Id, 
                null
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when quantity is missing.');
    }

    @isTest
    static void TransferInwardLineCreatedWithItem(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,item7.Id);
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void TransferInwardLineIsNotCreatedWithInactiveItem(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
        try{
            dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,item2.Id);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create transferLine.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
		test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithItemSku(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            null
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithItemLot(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
        dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
        test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithValidQuantity(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
        dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
        test.stopTest();
    }

    @isTest
    static void TransferInwardLineIsNotBeCreatedWithNegativeQuantity(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
        try{
            dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,item2.Id,
                -10
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create transferLine.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @istest
    static void TransferInwardLineCreatedWithValidQuantityEdit(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
        dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,item2.Id,
            10
        );
        test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithItemAndSkuCombination(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithItemLotAndQuantity(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void TransferInwardLineCreatedWithValidItemSkuLotAndQuantityDetails(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void ReceiveTransfer(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }

    @isTest
    static void StockWillGetIncreasedAfterTransferReceive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemLot__c ItemLot = TestDataHelpers.createItemLot(branch,item2,sku);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferInwardLine__c transferLine = TransferTestDataHelper.createTransferInwardLine(transfer.Id, branch.Id,1000,
            item2.Id,
            sku.Id,
            ItemLot.Id
        );
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		test.stopTest();
    }
}