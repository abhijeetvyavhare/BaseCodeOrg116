@isTest
public with sharing class CycleCountHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 1', 'Product');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup('Item Group 1', 'Tax');
        dmpl__Resource__c resource = TestDataHelpers.createResource(
			'Resource 1', 
			partner.Id, 
			branch.Id,
			true
		);
		dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup.Id, item.Id);
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch.Id);
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(
			partner.Id, 
			branch.Id, 
			itemGroup.Id, 
			storageLocation.Id, 
			'Quantity Available'
		);
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
    }
    
    @isTest
    static void createCycleCountTestPositive() {
        Test.startTest();
        dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        System.assertNotEquals(cycleCount.Id, null, 'Expected to see that the Cycle Count Created Wiht Custom Name.');
        Test.stopTest();
    }

	@isTest 
	static void createCycleCountwithStorageLocationPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(storageLocation.Id, cycleCount.dmpl__StorageLocationId__c, 'Storage Location 1 Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithItemGroupPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(itemGroup.Id, cycleCount.dmpl__ItemGroupId__c, 'Item Group 1 Should Match');
		Test.stopTest();
	}
	
	@isTest 
	static void createCycleCountwithCountQuantityTypeAsQuantityAvailablePositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				null, 
				'Quantity Available'
			);
		} catch(Exception e) {
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity Available', cycleCount.dmpl__CountQuantityType__c, 'Quantity Available CountQuantityType Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithCountQuantityTypeAsQuantityInHandPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				null, 
				'Quantity In Hand'
			);
		} catch(Exception e) {
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity In Hand', cycleCount.dmpl__CountQuantityType__c, 'Quantity In Hand CountQuantityType Should Match');
		Test.stopTest();
	}
	
	@isTest 
	static void createCycleCountwithCountQuantityTypeAsActualQuantityPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				null, 
				'Actual Quantity'
			);
		} catch(Exception e) {
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Actual Quantity', cycleCount.dmpl__CountQuantityType__c, 'Actual Quantity Hand CountQuantityType Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithoutPartnerAccountNegative() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				null, 
				branch.Id, 
				null, 
				storageLocation.Id, 
				null
			);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As partner Account not tagged');
		} catch(Exception e) {
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As partner Account not tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithoutBranchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				null, 
				null, 
				storageLocation.Id, 
				null
			);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Branch not tagged');
		} catch (Exception e) {
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Branch not tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongStorageLocationNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        branch3.dmpl__AllowPurchase__c = true;
        branch3.dmpl__AllowInventory__c = false;
        update branch3;
        dmpl__StorageLocation__c storageLocation3 = TestDataHelpers.createStorageLocation('Storage Location 3', branch3.Id);
		storageLocation3.dmpl__LocationType__c = null;
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				storageLocation3.Id, 
				null
			);
		} catch (Exception e) {
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Storage Location tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongPartnerAccountNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.createPartnerAccount('Partner 2'); 
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				storageLocation.Id, 
				null
			);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Partner Account tagged');
		} catch (Exception e) {
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Partner Account tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongBranchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch.dmpl__IsActive__c = false;
        branch.dmpl__AllowPurchase__c = true;
        branch.dmpl__AllowInventory__c = false;
        update branch;
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(
				partner.Id, 
				branch.Id, 
				null, 
				storageLocation.Id, 
				null
			);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Branch tagged');
		} catch (Exception e) {
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Branch tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithItemLotPositive() {
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLotType__c itemLotType = TestDataHelpers.CreateItemLotType(item);
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(
				cycleCount.Id, 
				item.Id, 
				itemLotType.Id, 
				1, 
				0, 
				1
			);
		} catch (Exception e) {
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(itemLotType.Id, cycleCountLine.dmpl__ItemLotTypeId__c, 'Lot ID should match');
		System.assertEquals(0, cycleCountLine.dmpl__OnHandQuantity__c, 'Quantity In Hand should be 0');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithDiscrepancyQuantityPositive() {
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(
				cycleCount.Id, 
				item.Id, 
				null, 
				5, 
				0, 
				1
			);
		} catch (Exception e) {
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(0, cycleCountLine.dmpl__OnHandQuantity__c, 'Quantity In Hand should be 0');
		System.assertEquals(5, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be 5');	
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithOnHandQuantityPositive() {
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(
				cycleCount.Id, 
				item.Id, 
				null, 
				1, 
				10, 
				1
			);
		} catch (Exception e) {
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(10, cycleCountLine.dmpl__ExpectedQuantity__c, 'Expected Quantity should be 10');
		System.assertEquals(10, cycleCountLine.dmpl__OnHandQuantity__c, 'On Hand Quantity should be 10');
		System.assertEquals(-9, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be -9');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithUnitCostPositive() {
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(
				cycleCount.Id, 
				item.Id, 
				null, 
				1, 
				0, 
				500
			);
		} catch (Exception e) {
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count line to be created successfully');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(500, cycleCountLine.dmpl__DiscrepancyCostValue__c, 'Discrepancy Cost Value should be 500');
		System.assertEquals(1, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be 1');
		System.assertEquals(0, cycleCountLine.dmpl__ExpectedQuantity__c, 'Expected Quantity should be 0');
		System.assertEquals(500, cycleCountLine.dmpl__UnitCost__c, 'Unit Cost should be 500');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithoutItemPositive() {
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__ItemId__c = null;
		update cycleCount;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(null, cycleCount.dmpl__ItemId__c, 'Item should match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithInacitveItemNegative(){
		Test.startTest();
		CycleCountMasterData.createCycleCountwithInactiveItemPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
		cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		} catch(Exception e) {
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountLinewithInacitveItemNegative(){
		Test.startTest();
		CycleCountMasterData.createCycleCountwithInactiveItemPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try {
		cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		} catch(Exception e) {
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		}
		Test.stopTest();
	}

	@isTest
	static void createCycleCountLinewithSkuPositive(){
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		Test.stopTest();
	}

	//Cycle Count Created with Valid Item(Edit)
	@isTest 
	static void updateCycleCountwithItemPositive(){
		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Product');
		cycleCount.dmpl__ItemId__c = item.Id;
		update cycleCount;
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCount.dmpl__ItemId__c, 'Item  should match');
		System.assertNotEquals(null, cycleCount.dmpl__BranchId__c, 'Branch should be tagged');
		System.assertNotEquals(null, cycleCount.dmpl__PartnerAccountId__c, 'Partner should be tagged');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithItemGroupPositive(){
		Test.startTest();
		CycleCountMasterData.updateCycleCountwithItemGrouppositiveData();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
		dmpl__InventoryCycleCount__c oldCycleCount = CycleCountTestDataHelpers.getCycleCount();
		oldCycleCount.dmpl__ItemGroupId__c = itemGroup.Id;
		update oldCycleCount;
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.assertEquals(itemGroup.Id, cycleCount.dmpl__ItemGroupId__c, 'Item Group should match');
		System.assertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch should be tagged');
		System.assertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner should be tagged');
		Test.stopTest();
	}

	//Cycle Count Created with Valid Resource(New)
	@isTest 
	static void createCycleCountwithValidResourcePositive(){
		Test.startTest();
		dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c oldCycleCount = CycleCountTestDataHelpers.getCycleCount();
		oldCycleCount.dmpl__ResourceId__c = resource.Id;
		update oldCycleCount;
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.assertEquals(resource.Id, cycleCount.dmpl__ResourceId__c, 'Resource should match');
		System.assertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch should be tagged');
		System.assertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner should be tagged');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithValidResourcePositive(){
		Test.startTest();
		dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partner.Id, branch.Id, false); 
		dmpl__InventoryCycleCount__c oldCycleCount = CycleCountTestDataHelpers.getCycleCount();
		oldCycleCount.dmpl__ResourceId__c = resource.Id;
		update oldCycleCount;
		oldCycleCount.dmpl__ResourceId__c = resource2.Id;
		update oldCycleCount;
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.assertEquals(resource2.Id, cycleCount.dmpl__ResourceId__c, 'Resource should match');
		System.assertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch should be tagged');
		System.assertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner should be tagged');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithStorageLocationPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 2', branch.Id);
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		cycleCount.dmpl__StorageLocationId__c = storageLocation.Id;
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(storageLocation.Id, cycleCount.dmpl__StorageLocationId__c, 'Storage Location 1 Should Match');
		Test.stopTest();
	}

	
	@isTest 
	static void updateCycleCountwithCountQuantityTypeAsQuantityAvailablePositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(
			partner.Id, 
			branch.Id, 
			null, 
			null, 
			'Actual Quantity'
		);	
		cycleCount.dmpl__CountQuantityType__c = 'Quantity Available';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount(cycleCount.Id);
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity Available', cycleCount.dmpl__CountQuantityType__c, 'Quantity type Should Match');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithCountQuantityTypeAsQuantityInHandPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(
			partner.Id, 
			branch.Id, 
			null, 
			null, 
			'Actual Quantity'
		);	
		cycleCount.dmpl__CountQuantityType__c = 'Quantity In Hand';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount(cycleCount.Id);
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity In Hand', cycleCount.dmpl__CountQuantityType__c, 'Quantity type Should Match');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithCountQuantityTypeAsActualQuantityPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(
			partner.Id, 
			branch.Id, 
			null, 
			null, 
			'Quantity In Hand'
		);	
		cycleCount.dmpl__CountQuantityType__c = 'Actual Quantity';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount(cycleCount.Id);
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count ID should match');
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Actual Quantity', cycleCount.dmpl__CountQuantityType__c, 'Quantity type Should Match');
		Test.stopTest();
	}

	//Cycle Count Created with Valid Item(New)
	@isTest 
	static void createCycleCountwithItemPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item =  TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(branch, item);	
		cycleCount = CycleCountTestDataHelpers.getCycleCount(cycleCount.Id);
		System.assertNotEquals(null, cycleCount.Id, 'Cycle Count should create');
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.AssertEquals(item.Id, cycleCount.dmpl__ItemId__c, 'item Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithInactiveItemPositive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountwithInactiveItemPositiveData();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item =  TestDataHelpers.getItem('Item 2');
		Boolean exceptionThrown = false;
		dmpl__InventoryCycleCount__c cycleCount;
		try {
			cycleCount = CycleCountTestDataHelpers.createCycleCount(branch, item);	
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected an exception to be thrown as item is inactive');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountwithInactiveItemPositive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountwithInactiveItemPositiveData();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item =  TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item2 =  TestDataHelpers.getItem('Item 2');
		Boolean exceptionThrown = false;
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(branch, item);	
		try {
			cycleCount.dmpl__ItemId__c = item2.Id;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}	
		System.AssertEquals(true, exceptionThrown, 'Expected an exception to be thrown as item is inactive');
		Test.stopTest();
	}

	//Cycle Count Created with Valid Required fields, then consider Valid Item Lot(Edit)
	@isTest 
	static void updateCycleCountLinewithItemLotPositive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ItemLot__c itemLot = TestDataHelpers.CreateItemLot(branch, item, sku);
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		cycleCountLine.dmpl__ItemLotId__c = itemLot.Id;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(itemLot.Id, cycleCountLine.dmpl__ItemLotId__c, 'Lot ID should match');
		Test.stopTest();
	}

	@isTest
	static void updateCycleCountLinewithSkuPositive(){
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
		cycleCountLine.dmpl__ItemId__c = item7.Id;
		cycleCountLine.dmpl__SKUId__c = sku.Id;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item7.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(sku.Id, cycleCountLine.dmpl__SKUId__c, 'SKU should match');
		Test.stopTest();
	}

	@isTest
	static void updateCycleCountLinewithOnHandQuantityPositive(){
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
		cycleCountLine.dmpl__OnHandQuantity__c = 20;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(20, cycleCountLine.dmpl__OnHandQuantity__c, 'on hand quantity should match');
		Test.stopTest();
	}

	@isTest
	static void createCycleCountLinewithRecordQuantityPositive(){
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
		cycleCountLine.dmpl__RecordedQuantity__c = 18;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(18, cycleCountLine.dmpl__RecordedQuantity__c, 'Record quantity should match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountLinewithStorageLocationPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
		cycleCountLine.dmpl__StorageLocationId__c = storageLocation.Id;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(storageLocation.Id, cycleCountLine.dmpl__StorageLocationId__c, 'Storage Location 1 Should Match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		Test.stopTest();
	}

	@isTest 
	static void updateCycleCountLinewithStorageLocationPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation2 = TestDataHelpers.createStorageLocation('Storage Location 2', branch.Id);
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null);
		cycleCountLine.dmpl__StorageLocationId__c = storageLocation.Id;
		update cycleCountLine;
		cycleCountLine.dmpl__StorageLocationId__c = storageLocation2.Id;
		update cycleCountLine;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(storageLocation2.Id, cycleCountLine.dmpl__StorageLocationId__c, 'Storage Location 1 Should Match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item should match');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcesstoStartCountingPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.assertEquals('Counting in Progress', cycleCount.dmpl__Status__c, 'status should match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(12, cycleCountLine.dmpl__RecordedQuantity__c, 'recorded quantity should match');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcesstoFinishCountingPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.assertEquals('FinishCounting', cycleCount.dmpl__Status__c, 'status should match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(12, cycleCountLine.dmpl__RecordedQuantity__c, 'recorded quantity should match');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchNegative() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
		Boolean exceptionThrown = false;
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		try {
			cycleCount.dmpl__Status__c = 'FinishCounting';
			cycleCount.dmpl__BranchId__c = branch2.Id;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected an exception to be thrown as invalid branch');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcesstoReleaseForAdjustmentPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount.dmpl__PerformReleaseAdjustment__c = True;
		cycleCount.dmpl__Status__c = 'Released for Adjustment';
		update cycleCount;
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, adjustment.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcesstoReleaseForAdjustmentWithInvalidBranchNegative() {
		Test.startTest();
		Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		try {
			cycleCount.dmpl__PerformReleaseAdjustment__c = True;
			cycleCount.dmpl__Status__c = 'Released for Adjustment';
			cycleCount.dmpl__BranchId__c = branch2.Id;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected an exception to be thrown as invalid branch');
		Test.stopTest();
	}

	@isTest
	static void createAdjustmentFromCyclecountProcessPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount.dmpl__PerformReleaseAdjustment__c = True;
		cycleCount.dmpl__Status__c = 'Released for Adjustment';
		update cycleCount;
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, adjustment.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
		System.AssertEquals(adjustment.Id, adjustmentLine.dmpl__InventoryAdjustmentId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createCyclecountwithOnlyOnHandQuantityPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount.dmpl__PerformReleaseAdjustment__c = True;
		cycleCount.dmpl__Status__c = 'Released for Adjustment';
		update cycleCount;
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, adjustment.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
		System.AssertEquals(adjustment.Id, adjustmentLine.dmpl__InventoryAdjustmentId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createCyclecountwithvalidPartnerAccountAndBranchPositive() {
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createCyclecountwithInvalidBranchNegative() {
		Test.startTest();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		Boolean exceptionThrown = false;
		try {
			cycleCount.dmpl__BranchId__c = branch2.Id;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(true, exceptionThrown, 'Expected exception to be thrown');
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createCyclecountwithInvalidPartnerNegative() {
		Test.startTest();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partner2= TestDataHelpers.getPartnerAccount('Partner 2');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		Boolean exceptionThrown = false;
		try {
			cycleCount.dmpl__PartnerAccountId__c = partner2.Id;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(true, exceptionThrown, 'Expected exception to be thrown');
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void updateCyclecountwithoutPartnerAndBranchNegative() {
		Test.startTest();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		Boolean exceptionThrown = false;
		try {
			cycleCount.dmpl__PartnerAccountId__c = null;
			cycleCount.dmpl__BranchId__c = null;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected exception to be thrown');
		Test.stopTest();
	}

	@isTest
	static void updateCyclecountwithPartnerAndBranchNegative() {
		Test.startTest();
		CycleCountMasterData.createAdjustmentFromCyclecountProcesstoFinishCountingWithInvalidBranchPositiveData();
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		Boolean exceptionThrown = false;
		try {
			cycleCount.dmpl__BranchId__c = branch.Id;
			cycleCount.dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c;
			update cycleCount;
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected exception to be thrown');
		Test.stopTest();
	}

	@isTest
	static void createProcessMRP001Positive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__OnHandQuantity__c = 40;
		update cycleCountLine;
		dmpl__InventoryCycleCountLine__c cycleCountLine2 = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		cycleCountLine2.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine2;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount.dmpl__PerformReleaseAdjustment__c = True;
		cycleCount.dmpl__Status__c = 'Released for Adjustment';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, adjustment.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
		System.AssertEquals(adjustment.Id, adjustmentLine.dmpl__InventoryAdjustmentId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createProcessMRP002Positive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__OnHandQuantity__c = -40;
		update cycleCountLine;
		dmpl__InventoryCycleCountLine__c cycleCountLine2 = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		cycleCountLine2.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine2;
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		cycleCountLine2 = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine2.Id);
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		System.AssertEquals(-40, cycleCountLine.dmpl__OnHandQuantity__c, 'On hand quantity Should Match');
		System.AssertEquals(10, cycleCountLine2.dmpl__OnHandQuantity__c, 'On hand quantity Should Match');
		System.AssertEquals(12, cycleCountLine2.dmpl__RecordedQuantity__c, 'Record quantity Should Match');
		System.AssertEquals(2, cycleCountLine2.dmpl__DiscrepencyQuantity__c, 'Discrepency quantity Should Match');
		System.AssertEquals(item.Id, cycleCountLine2.dmpl__ItemId__c, 'Item Should Match');
		Test.stopTest();
	}

	@isTest
	static void createProcessAdjustmentAndAdjustmentLineFromCycleCountWithCycleCountLinePositive() {
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');		
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
		cycleCountLine.dmpl__OnHandQuantity__c = 40;
		update cycleCountLine;
		dmpl__InventoryCycleCountLine__c cycleCountLine2 = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		cycleCountLine2.dmpl__RecordedQuantity__c = 12;
		update cycleCountLine2;
		cycleCount.dmpl__Status__c = 'Counting in Progress';
		update cycleCount;
		cycleCount.dmpl__Status__c = 'FinishCounting';
		update cycleCount;
		cycleCount.dmpl__PerformReleaseAdjustment__c = True;
		cycleCount.dmpl__Status__c = 'Released for Adjustment';
		update cycleCount;
		cycleCount = CycleCountTestDataHelpers.getCycleCount();
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);
		cycleCountLine2 = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine2.Id);
		System.AssertEquals(40, cycleCountLine.dmpl__OnHandQuantity__c, 'On hand quantity Should Match');
		System.AssertEquals(-40, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepency quantity Should Match');
		System.AssertEquals(10, cycleCountLine2.dmpl__OnHandQuantity__c, 'On hand quantity Should Match');
		System.AssertEquals(12, cycleCountLine2.dmpl__RecordedQuantity__c, 'Record quantity Should Match');
		System.AssertEquals(2, cycleCountLine2.dmpl__DiscrepencyQuantity__c, 'Discrepency quantity Should Match');
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, cycleCount.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
		System.AssertEquals(branch.dmpl__PartnerAccountId__c, adjustment.dmpl__PartnerAccountId__c, 'Partner Should Match');
		System.AssertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch Should Match');
		dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
		System.AssertEquals(adjustment.Id, adjustmentLine.dmpl__InventoryAdjustmentId__c, 'Branch Should Match');
		Test.stopTest();
	}

	@isTest
	static void createProcessCycleCountWithCycleCountLineNegative() {
		Test.startTest();
		CycleCountMasterData.createCycleCountLinewithSkuPositiveData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item1.Id, true);			
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		Boolean exceptionThrown = false;
		try {
			dmpl__InventoryCycleCountLine__c cycleCountLine2 = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, sku.Id);
		} catch(Exception e) {
			exceptionThrown = true;
		}
		System.AssertEquals(true, exceptionThrown, 'Expected exception to be thrown');
		Test.stopTest();
	}
}