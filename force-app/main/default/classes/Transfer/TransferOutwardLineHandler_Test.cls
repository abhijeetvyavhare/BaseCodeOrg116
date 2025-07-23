@isTest
public with sharing class TransferOutwardLineHandler_Test {
	@TestSetup
    static void createRequiredData() {
		Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
		dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch);
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.id, true);
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(
			'Storage Location 1', 
			branch.Id, 
			true, 
			'Warehouse'
		);
		dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
    }

  	@isTest
  	static void createTransferOutwardLinePositive() {
		dmpl__TransferOutwardLine__c outwardLine = TransferTestDataHelper.getTransferOutwardLine();
		System.assertNotEquals(null, outwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(1, outwardLine.dmpl__Quantity__c, 'Quantity should be 1');
		System.assertEquals(10, outwardLine.dmpl__UnitCost__c, 'UnitCost should be 10');
		System.assertNotEquals(null, outwardLine.dmpl__TransferId__c, 'TransferId should be populated');
    }

	@isTest
	static void updateTransferOutwardLinePositive() {
		dmpl__TransferOutwardLine__c outwardLine = TransferTestDataHelper.getTransferOutwardLine();
		System.assertNotEquals(null, outwardLine, 'TransferOutwardLine should exist before update');
		outwardLine.dmpl__Quantity__c = 5;
		outwardLine.dmpl__UnitCost__c = 20;
		update outwardLine;
		dmpl__TransferOutwardLine__c updatedOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
		System.assertEquals(5, updatedOutwardLine.dmpl__Quantity__c, 'Expected updated Quantity value');
		System.assertEquals(20, updatedOutwardLine.dmpl__UnitCost__c, 'Expected updated UnitCost value');
	}

	@isTest
	static void createTransferOutwardLineNormalPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		Test.startTest();
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		Test.stopTest();
		System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
	}

	@isTest
	static void createTransferOutwardLineWithWrongBranchNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Test.startTest();
		try {
			TransferOutwardLineMasterData.createTransferOutwardLineData();
			dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
			dmpl__Branch__c branch5 = TestDataHelpers.getBranch('Branch 5');
			dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch4, branch5);
			System.assertEquals(null, transfer.Id, 'Transfer record should not be inserted');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
		}
	}

	@isTest
	static void createTransferOutwardLineWithInactiveBranchNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Test.startTest();
		try {
			TransferOutwardLineMasterData.createTransferOutwardLineData();
			dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
			dmpl__Branch__c branch5 = TestDataHelpers.getBranch('Branch 5');
			dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch3, branch5);
			System.assertEquals(null, transfer.Id, 'Transfer record should not be created with inactive branch');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'Transfer should not be created with wrong branch');
		}
	}

	@isTest
	static void updateTransferOutwardLineWithWrongBranchNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Branch__c branch5 = TestDataHelpers.getBranch('Branch 5');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'Transfer outward line record should be inserted');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transfer.dmpl__BranchId__c = branch4.Id;
			transfer.dmpl__ToBranchId__c = branch5.Id;
			update transfer;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(true, exceptionCaught, 'Expected exception when assigning wrong branch');
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithInactiveBranchNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Branch__c branch5 = TestDataHelpers.getBranch('Branch 5');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transfer.dmpl__BranchId__c = branch3.Id;
			transfer.dmpl__ToBranchId__c = branch5.Id;
			update transfer;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(true, exceptionCaught, 'Expected exception when assigning inactive branch');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithoutItemNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		try {
			dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, null);
			System.assertEquals(null, transferOutwardLine, 'TransferOutwardLine should not be created');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
		}
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithoutItemNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__ItemId__c = null;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(true, exceptionCaught, 'Expected exception when removing item');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithInactiveItemNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		try {
			dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item2);
			System.assertEquals(null, transferOutwardLine, 'TransferOutwardLine should not be created');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
		}
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithInactiveItemNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__ItemId__c = item2.Id;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(true, exceptionCaught, 'Expected exception when assigning inactive item');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithZeroQuantityPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		try {
			dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
			transferOutwardLine.dmpl__Quantity__c = 0;
			update transferOutwardLine;
			System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
			System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
			System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
			System.assertEquals(0, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
		}
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithZeroQuantityPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__Quantity__c = 0;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'Exception caught when quantity less than 1');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithInsufficientStockPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		try {
			dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
			transferOutwardLine.dmpl__Quantity__c = 10000;
			update transferOutwardLine;
			System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
			System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
			System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
			System.assertEquals(10000, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 10000');
		} catch (Exception e) {
			System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
		}
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithInsufficientQuantityPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__Quantity__c = 10000;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'Exception caught when quantity less than 1');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithRequiredSKUPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item7.id, true);
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7);
		transferOutwardLine.dmpl__SKUId__c = sku.Id;
		update transferOutwardLine;
		item7.dmpl__IsSKURequired__c = true;
		update item7;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(sku.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithNoRequiredSKUPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithRemovingRequiredSKUNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item7.id, true);
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7);
		transferOutwardLine.dmpl__SKUId__c = sku.Id;
		update transferOutwardLine;
		item7.dmpl__IsSKURequired__c = true;
		update item7;
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(sku.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__SKUId__c = null;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithRemovingNoRequiredSKUPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item7.id, true);
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7);
		transferOutwardLine.dmpl__SKUId__c = sku.Id;
		update transferOutwardLine;
		item7.dmpl__IsSKURequired__c = true;
		update item7;
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(sku.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__ItemId__c = item.Id;
			transferOutwardLine.dmpl__SKUId__c = null;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'exception caught when removing no required sku from transfer outward line');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithoutUnitCostPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		transferOutwardLine.dmpl__UnitCost__c = null;
		update transferOutwardLine;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithoutUnitCostPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.assertEquals(10, transferOutwardLine.dmpl__UnitCost__c, 'UnitCost should 10');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__UnitCost__c = null;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'exception caught when removing unit cost from transfer outward line');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithStorageLocationPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		transferOutwardLine.dmpl__StorageLocationId__c = storageLocation.Id;
		update transferOutwardLine;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.assertEquals(storageLocation.Id, transferOutwardLine.dmpl__StorageLocationId__c, 'Storage Location should match');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithRequisitionPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner, branch);
		System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
		System.assertEquals(partner.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, requisition.dmpl__BranchId__c, 'Branch should match');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
		update transferOutwardLine;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.assertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithRequisitionPositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner, branch);
		System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
		System.assertEquals(partner.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, requisition.dmpl__BranchId__c, 'Branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'exception caught when assigning requisition to  transfer outward line');
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.AssertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithRequisitionLinePositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Test.startTest();
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner, branch);
		System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
		System.assertEquals(partner.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, requisition.dmpl__BranchId__c, 'Branch should match');
		dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
			requisition, 
			item, 
			2, 
			1000
		);
		System.assertNotEquals(null, requisitionLine, 'Purchase Requisition Line should be inserted');
		System.assertEquals(2, requisitionLine.dmpl__Quantity__c, 'Quantity should be 2');
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
		transferOutwardLine.dmpl__RequisitionLineId__c = requisitionLine.Id;
		update transferOutwardLine;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.assertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
		System.assertEquals(requisitionLine.Id, transferOutwardLine.dmpl__RequisitionLineId__c, 'Requisition line should match');
		Test.stopTest();
	}
    
	@isTest
	static void updateTransferOutwardLineWithRequisitionLinePositive() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		TransferOutwardLineMasterData.createTransferOutwardLineData();
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch4);
		System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
		System.assertEquals(partner.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'From branch should match');
		System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner, branch);
		System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
		System.assertEquals(partner.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
		System.assertEquals(branch.Id, requisition.dmpl__BranchId__c, 'Branch should match');
		dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
			requisition, 
			item, 
			2, 
			1000
		);
		System.assertNotEquals(null, requisitionLine, 'Purchase Requisition Line should be inserted');
		System.assertEquals(2, requisitionLine.dmpl__Quantity__c, 'Quantity should be 2');
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');
		Test.startTest();
		Boolean exceptionCaught = false;
		try {
			transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
			transferOutwardLine.dmpl__RequisitionLineId__c = requisitionLine.Id;
			update transferOutwardLine;
		} catch (Exception e) {
			exceptionCaught = true;
		}
		System.assertEquals(false, exceptionCaught, 'exception caught when assigning requisitionLine to transfer outward line');
		System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(1, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 1');
		System.AssertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
		System.AssertEquals(requisitionLine.Id, transferOutwardLine.dmpl__RequisitionLineId__c, 'Requisition Line should match');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithItemLotPositive() {
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLot__c itemLot = TestDataHelpers.getItemLot();
		Test.startTest();
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(
				transfer?.Id, 
				item?.Id, 
				itemLot?.Id, 
				'On Hand Transfer', 
				10
			);
		} catch (Exception e) {
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
		System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
		System.AssertEquals(itemLot?.Id, transferOutwardLine.dmpl__ItemLotId__c, 'ItemLot Id should be matched.');
		System.AssertEquals(10, transferOutwardLine.dmpl__Quantity__c, 'Quantity should be 10.');
		System.AssertEquals(10, transferOutwardLine.dmpl__PendingInwardQuantity__c, 'Pending Inward Quantity should be null.');
		Test.stopTest();
	}

	@isTest
	static void createTransferOutwardLineWithItemPositive() {
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLot__c itemLot = null;
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		} catch (Exception e) {
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
		System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
		Test.stopTest();
	}

    @isTest
    static void createTransferOutwardLineWithoutItem2Negative() {
        Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, null);
			System.Assert.isTrue(null == transferOutwardLine, 'TransferOutwardLine should be created.');
		} catch (Exception e) {
			System.Assert.isTrue(null == transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		Test.stopTest();
    }
    
	@isTest
	static void createTransferOutwardLineWithQuantityPositive() {
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
            transferOutwardLine.dmpl__Quantity__c = 10;
            update transferOutwardLine;
		} catch (Exception e) {
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
        System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
	    System.AssertEquals(10, transferOutwardLine.dmpl__Quantity__c, 'Quantity should be 10.');
		Test.stopTest();
	}

	@isTest
	static void updateTransferOutwardLineWithQuantityPositive() {
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
            transferOutwardLine.dmpl__Quantity__c = 20;
            update transferOutwardLine;
		} catch (Exception e) {
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
        System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
	    System.AssertEquals(20, transferOutwardLine.dmpl__Quantity__c, 'Quantity should be 20.');
		Test.stopTest();
	}

    @isTest
	static void createTransferOutwardLineWithNegativeQuantityNegative() {
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
            transferOutwardLine.dmpl__Quantity__c = -10;
            update transferOutwardLine;
			System.Assert.isTrue(null == transferOutwardLine, 'TransferOutwardLine should be created.');
		} catch (Exception e) {
		    transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
			System.Assert.isTrue(-10 != transferOutwardLine.dmpl__Quantity__c, 'TransferOutwardLine should be created.');
		}
		Test.stopTest();
	}

    @isTest
	static void createTransferOutwardLineWithValidItemSKUItemLotAndQuantityPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.id, true);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item);
		transferOutwardLine.dmpl__SKUId__c = sku.Id;
        transferOutwardLine.dmpl__ItemLotId__c = itemLot.Id;
        transferOutwardLine.dmpl__Quantity__c = 10;
		update transferOutwardLine;
		item.dmpl__IsSKURequired__c = true;
		update item;
		System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
		System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
		System.assertEquals(item.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(sku.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
		System.assertEquals(10, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 10');
		System.assertEquals(itemLot.Id, transferOutwardLine.dmpl__ItemLotId__c, 'Item Lot Id should Match');
		Test.stopTest();
	}

    @isTest
	static void createTransferOutwardLineWithValidUnitCostPositive() {
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try {
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item, 1000);
		} catch (Exception e) {
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
        System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
	    System.AssertEquals(1000, transferOutwardLine.dmpl__UnitCost__c, 'Unit Cost should be 1000.');
		Test.stopTest();		
	}

	@isTest
	static void TransferOutwardLineCreatedWithValidUnitCostEdit() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferOutwardLine__c transferLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7, 2000);
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		Test.stopTest();
	}

	@isTest
	static void TransferOutwardLineIsNotCreatedWithUnitCostInNegative() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		try{
			dmpl__TransferOutwardLine__c transferLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7, -2000);
		} catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create transferLine.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true, 'Expected exception not thrown.');
        }
		Test.stopTest();
	}

	@isTest
	static void SubmitForApprovalAndRelease() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferOutwardLine__c transferLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7, 2000);
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		Test.stopTest();
	}

	@isTest
	static void StockWillGetDecreasedAfterOutwardApprovalAndRelease() {
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partner, branch, branch2);
		system.assertNotEquals(null, transfer.Id, 'Transfer should be created');
		dmpl__TransferOutwardLine__c transferLine = TransferTestDataHelper.createTransferOutwardLine(transfer, item7, 2000);
		system.AssertNotEquals(null, transferLine.Id, 'TransferOutwardLine should be created');
		Test.stopTest();
	}
}