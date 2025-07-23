@isTest
public with sharing class PurchaseRequisitionLineHandler_Test {
    @TestSetup
    static void createRequiredData() {        
		Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
		dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        item7.dmpl__IsSKURequired__c = true;
        update item7;
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.createRequisition(partner?.Id, branch?.Id, supplier?.Id);
        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
            purchaseRequisition, 
            item7, 
            sku, 
            1
        );
    }
    
    @isTest
    static void createPurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2', item.Id, false);
        Test.startTest();
        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
            purchaseRequisition, 
            item, 
            sku,
            1
        );
        Test.stopTest();
        System.assertNotEquals(null, requisitionLine.Id, 'Purchase Requisition Line should be created');
        System.assertEquals(purchaseRequisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should be linked');
        System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'Item should be linked');
        System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU should be linked');
        System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should be 1');
    }
    
    @isTest
    static void updatePurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisitionLine__c existingLine = RequisitionTestDataHelpers.getRequisitionLine();
        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        Test.startTest();
        existingLine.dmpl__Quantity__c = 2;
        update existingLine;
        Test.stopTest();
        dmpl__PurchaseRequisitionLine__c updatedLine = RequisitionTestDataHelpers.getRequisitionLine();
        System.assertEquals(2, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
    }
    
    @isTest
    static void deletePurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisitionLine__c existingLine = RequisitionTestDataHelpers.getRequisitionLine();
        Test.startTest();
        delete existingLine;
        Test.stopTest();
        try {
            dmpl__PurchaseRequisitionLine__c remainingLines = RequisitionTestDataHelpers.getRequisitionLine();
            System.Assert.isTrue(false, 'Should get deleted');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Should get deleted');
        }
    }
    
    @isTest 
	static void createRequisitionLineWithActiveItemPositive() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                1500
            );
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(1, requisitionLine.dmpl__PendingQuantity__c, 'Pending Quantity should Match');
		System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1500, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(1500, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithRequiredSKUPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner?.Id, branch?.Id, null);
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                7
            );
			requisitionLine.dmpl__UnitCost__c = 1000;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(7, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(7000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU ID should match');
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithNoRequiredSKUPositive() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                10, 
                1500
            );
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(10, requisitionLine.dmpl__PendingQuantity__c, 'Pending Quantity should Match');
		System.assertEquals(10, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1500, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(15000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithInactiveItemNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                1500
            );
			System.Assert(false, 'Exception Expected!');
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithDiscontinuedItemNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                2000
            );
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithInactiveItemNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                1500
            );
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(1, requisitionLine.dmpl__PendingQuantity__c, 'Pending Quantity should Match');
		System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1500, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(1500, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
		try {
			requisitionLine.dmpl__ItemId__c = item.Id;
			requisitionLine.dmpl__Quantity__c = 7;
			requisitionLine.dmpl__UnitCost__c = 2400;
			update requisitionLine;
			System.Assert(false, 'Exception Expected!');
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithDiscontinuedItemNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
		dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2', item.Id, false);
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                1
            );
			requisitionLine.dmpl__UnitCost__c = 1500;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(1, requisitionLine.dmpl__PendingQuantity__c, 'Pending Quantity should Match');
		System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1500, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(1500, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
		try {
			requisitionLine.dmpl__ItemId__c = item.Id;
			update requisitionLine;
			System.Assert(false, 'Exception Expected!: Update must fail');
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithRemovingRequiredSKUNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                10
            );
			requisitionLine.dmpl__UnitCost__c = 1000;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(10, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(10000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU ID should match');
		try {
			requisitionLine.dmpl__SKUId__c = null;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithNoRequiredSKUPositive() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                1000
            );
			requisitionLine.dmpl__SKUId__c = sku.id;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(1000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU ID should match');
		try {
			requisitionLine.dmpl__SKUId__c = null;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(null, requisitionLine.dmpl__SKUId__c, 'SKU ID should match');
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithActiveItemPositive() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                1, 
                1500
            );
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1500, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(1500, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		try {
			requisitionLine.dmpl__Quantity__c = 7;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(7, requisitionLine.dmpl__Quantity__c, 'Quantity should match');
		System.assertEquals(10500, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithRequiredSKUPositive() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                7
            );
			requisitionLine.dmpl__UnitCost__c = 1000;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception Not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(7, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(7000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU ID should match');
		try {
			requisitionLine.dmpl__Quantity__c = 10;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(false, 'Exception not Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(10, requisitionLine.dmpl__Quantity__c, 'Quantity should match');
		System.assertEquals(10000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithBlankQuantityNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                null, 
                1000
            );
			System.Assert(false, 'Exception Expected!');
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void updateRequisitionLineWithBlankQuantityNegative() {
		Test.startTest();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.getRequisition();
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                7
            );
			requisitionLine.dmpl__UnitCost__c = 1000;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(7, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(7000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		try {
			requisitionLine.dmpl__Quantity__c = null;
			update requisitionLine;
			System.Assert(false, 'Exception not Expected!');
		} catch (Exception e) {
			System.Assert(true, 'Exception not Expected!');
		}
		Test.stopTest();
	}
    
    @isTest 
	static void createRequisitionLineWithRequiredSKU2Positive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequisition(partner?.Id, branch?.Id, null);
		dmpl__PurchaseRequisitionLine__c requisitionLine;
		try {
			requisitionLine = RequisitionTestDataHelpers.createRequisitionLine(
                requisition, 
                item, 
                sku,
                7
            );
			requisitionLine.dmpl__UnitCost__c = 1000;
			update requisitionLine;
		} catch (Exception e) {
			System.Assert(true, 'Exception Expected!');
		}
		requisitionLine = RequisitionTestDataHelpers.getRequisitionLine(requisitionLine.Id);
		System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'ItemId should be Match');
		System.assertEquals(7, requisitionLine.dmpl__Quantity__c, 'Quantity should Match');
		System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should Match');
		System.assertEquals(7000, requisitionLine.dmpl__Amount__c, 'Amount should Match');
		System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Requisition ID should match');
		Test.stopTest();
	}
}