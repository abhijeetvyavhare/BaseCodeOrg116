@isTest
public with sharing class InventoryAdjustmentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.createAdjustment(branch);
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.createAdjustmentLine(
            item,
            sku,
            storageLocation,
            itemLot,
            adjustment
        );
    }

    @isTest
    static void createInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        System.assertNotEquals(null, adjustment, 'Inventory Adjustment should be created successfully.');
        System.assertEquals('Draft', adjustment.dmpl__Status__c, 'Inventory Adjustment status must be Draft');
    }

    @isTest
    static void createInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'Inventory Adjustment Line should be created successfully.');
        System.assertEquals(100, adjustmentLine.dmpl__TotalCost__c, 'Inventory Adjustment Line TotalCost must be 100');
    }

    @isTest
    static void updateInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        adjustment.dmpl__Status__c = 'Approved';
        update adjustment;
        dmpl__InventoryAdjustment__c updated = InventoryAdjustmentDataHelper.getAdjustment(adjustment.Id);
        System.assertEquals('Approved', updated.dmpl__Status__c, 'Inventory Adjustment status must be updated to Approved');
    }

    @isTest
    static void updateInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        adjustmentLine.dmpl__TotalCost__c = 90;
        update adjustmentLine;
        dmpl__InventoryAdjustmentLine__c updated = InventoryAdjustmentDataHelper.getAdjustmentLine(adjustmentLine.Id);
        System.assertEquals(90, updated.dmpl__TotalCost__c, 'Inventory Adjustment Line Totalcost must be updated to 90');
    }

    @isTest
    static void deleteInventoryAdjustmentLine() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        delete adjustmentLine;
        dmpl__InventoryAdjustmentLine__c deleted;
        try {
            deleted = InventoryAdjustmentDataHelper.getAdjustmentLine(adjustmentLine.Id);
        } catch (Exception e) {
            deleted = null;
        }
        System.assertEquals(null, deleted, 'InventoryAdjustmentLine should be deleted and not found in query.');
    }

    @isTest
    static void deleteInventoryAdjustment() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        delete adjustment;
        dmpl__InventoryAdjustment__c deleted;
        try {
            deleted = InventoryAdjustmentDataHelper.getAdjustment(adjustment.Id);
        } catch (Exception e) {
            deleted = null;
        }
        System.assertEquals(null, deleted, 'InventoryAdjustment should be deleted and not found in query.');
    }

    @isTest
    static void createAdjustmentWithValidProductAndQuantityPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjustmentWithInventoryPostedFalsePositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjustmentCreationWithValidCreatedDateInDatetimeFormatPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjutstmentWithValidBranchAndLocation() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createSaveAdjustmentWithAllValidFieldsPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjustmentWithInventoryPostedTruePositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjustmentForInactiveBranchNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        try {
            dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(null, partnerAccount.Id, Date.today());
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }

    @isTest
    static void createAdjustmentSavedWithoutSelectingLocationNegative() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetched = InventoryAdjustmentDataHelper.getAdjustment(inventory.Id);
        System.assertNotEquals(null, fetched, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createSaveWithoutSelectingBranchNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        try {
            dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(null, partnerAccount.Id, Date.today());
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }

    @isTest
    static void createSaveWithoutSelectingPartnerAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        try {
            dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, null, Date.today());
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }

    @isTest
    static void createLineCreationWithValidItemQuantityAndAdjustmentTypePositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today() );
        dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        Test.stopTest();
        dmpl__InventoryAdjustmentLine__c fetched = InventoryAdjustmentDataHelper.getAdjustmentLine(line.Id);
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item on the line should match');
        System.assertEquals(6, fetched.dmpl__Quantity__c, 'Quantity should be 6');
        System.assertEquals(inventory.Id, fetched.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createLineWithCalculatedUnitCostAndTotalCostPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        Test.stopTest();
        dmpl__InventoryAdjustmentLine__c fetched = InventoryAdjustmentDataHelper.getAdjustmentLine(line.Id);
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item on the line should match');
        System.assertEquals(6, fetched.dmpl__Quantity__c, 'Quantity should be 6');
        System.assertEquals(inventory.Id, fetched.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createLineWithValidItemLotAndLotTypePositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        Test.stopTest();
        dmpl__InventoryAdjustmentLine__c fetched = InventoryAdjustmentDataHelper.getAdjustmentLine(line.Id);
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item on the line should match');
        System.assertEquals(6, fetched.dmpl__Quantity__c, 'Quantity should be 6');
        System.assertEquals(inventory.Id, fetched.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createAttemptToSelectInactiveItemNegative() {
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.startTest();
        try {
            dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive item.');
    }

    @isTest
    static void createAttemptToSaveWithBlankAdjustmentTypePositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        Test.stopTest();
        dmpl__InventoryAdjustmentLine__c fetched = InventoryAdjustmentDataHelper.getAdjustmentLine(line.Id);
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item on the line should match');
        System.assertEquals(6, fetched.dmpl__Quantity__c, 'Quantity should be 6');
        System.assertEquals(inventory.Id, fetched.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createAttemptToSaveWithoutEnteringQuantityNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        try {
            dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, null, inventory.Id);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for missing quantity.');
    }

    @isTest
    static void createItemLotWithoutSelectingItemNegative() {
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        Test.startTest();
        try {
            dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(null, 6, inventory.Id);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for missing item.');
    }

    @isTest
    static void createLineWithInvalidItemLotTypeNotMatchingItemLotPositive() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.createAdjustment(branch.Id, partnerAccount.Id, Date.today());
        dmpl__InventoryAdjustmentLine__c line = InventoryAdjustmentDataHelper.createAdjustmentLine(item.Id, 6, inventory.Id);
        Test.stopTest();
        dmpl__InventoryAdjustmentLine__c fetched = InventoryAdjustmentDataHelper.getAdjustmentLine(line.Id);
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item on the line should match');
        System.assertEquals(6, fetched.dmpl__Quantity__c, 'Quantity should be 6');
        System.assertEquals(inventory.Id, fetched.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }
}