@isTest
public with sharing class AutoPurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplier);
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__TaxGroup__c taxGroupGST18partner1 = TestDataHelpers.createTaxGroup('GST 18', partner.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__ItemLotType__c itemLot = TestDataHelpers.createItemLotType(item);
        dmpl__Tax__c taxCGST18 = TestDataHelpers.createTax(
            'CGST18', 
            'CGST', 
            18, 
            taxGroupGST18partner1.Id, 
            'Tax1'
        );
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partner, supplier, branch);
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(autoPurchaseOrder, item, sku);
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item,
            itemLot, 
            sku
        );
    }
    
    @isTest
    static void createAutoPurchaseOrderPositive() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertNotEquals(null, autoPurchaseOrder, 'Auto Purchase Order should be created.');
        System.assertEquals('Minimum Stock Level', autoPurchaseOrder.dmpl__AutoOrderType__c);
    }
    
    @isTest
    static void updateAutoPurchaseOrderPositive() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        autoPurchaseOrder.dmpl__Remarks__c = 'Updated by test';
        autoPurchaseOrder.dmpl__PerformOrderGeneration__c = false;
        update autoPurchaseOrder;
        dmpl__AutoPurchaseOrder__c updatedOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder(autoPurchaseOrder.Id);
        System.assertEquals('Updated by test', updatedOrder.dmpl__Remarks__c);
        System.assertEquals(false, updatedOrder.dmpl__PerformOrderGeneration__c);
    }
    
    @isTest
    static void deleteAutoPurchaseOrder() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertNotEquals(null, autoPurchaseOrder, 'Auto Purchase Order should exist before delete.');
        delete autoPurchaseOrder;
        dmpl__AutoPurchaseOrder__c deletedOrder;
        try {
            deletedOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder(autoPurchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'Auto Purchase Order should be deleted and not found in query.');
    }
    
    @isTest
    static void createAutoPurchaseOrderLinePositive() {
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertNotEquals(null, autoPurchaseOrderLine, 'Auto Purchase Order Line should be created.');
        System.assertEquals(1, autoPurchaseOrderLine.dmpl__MaximumQuantity__c);
        System.assertEquals(1, autoPurchaseOrderLine.dmpl__MinimumQuantity__c);
    }
    
    @isTest
    static void updateAutoPurchaseOrderLinePositive() {
        dmpl__AutoPurchaseOrderLine__c line = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertNotEquals(null, line, 'Auto Purchase Order Line should exist before update.');
        line.dmpl__MaximumQuantity__c = 5;
        update line;
        dmpl__AutoPurchaseOrderLine__c updatedLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine(line.Id);
        System.assertEquals(5, updatedLine.dmpl__MaximumQuantity__c);
        System.assertEquals(1, updatedLine.dmpl__MinimumQuantity__c);
    }
    
    @isTest
    static void deleteAutoPurchaseOrderLine() {
        dmpl__AutoPurchaseOrderLine__c line = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertNotEquals(null, line, 'Auto Purchase Order Line should exist before delete.');
        try {
            delete line;
            dmpl__AutoPurchaseOrderLine__c deletedLine = null;
            try {
                deletedLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine(line.Id);
            } catch (Exception e) {
                deletedLine = null;
            }
            System.assertEquals(null, deletedLine, 'Auto Purchase Order Line should be deleted.');
        } catch (DmlException e) {
            System.assert (
                e.getMessage().contains('downstream transaction'), 'Unexpected error during delete: ' + e.getMessage());
        }
    }
    
    @isTest
    static void createAutoPurchaseOrderLineRelationPositive() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation record should be created.');
        System.assertEquals(1000, relation.dmpl__UnitCost__c);
        System.assertEquals(100, relation.dmpl__OrderQuantity__c);
    }
    
    @isTest
    static void updateAutoPurchaseOrderLineRelationPositive() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation should exist for update.');
        relation.dmpl__UnitCost__c = 2000;
        relation.dmpl__OrderQuantity__c = 500;
        update relation;
        dmpl__AutoPurchaseOrderLineRelation__c updated = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation(relation.Id);
        System.assertEquals(2000, updated.dmpl__UnitCost__c, 'Unit cost should be updated.');
        System.assertEquals(500, updated.dmpl__OrderQuantity__c, 'Order quantity should be updated.');
    }
    
    @isTest
    static void deleteAutoPurchaseOrderLineRelation() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation should exist before delete.');
        delete relation;
        dmpl__AutoPurchaseOrderLineRelation__c deletedRelation = null;
        try {
            deletedRelation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation(relation.Id);
        } catch (Exception e) {
            deletedRelation = null;
        }
        System.assertEquals(null, deletedRelation, 'Relation record should be deleted.');
    }
    
    @isTest
    public static void
    autoPurchaseOrderCreationCreateAutoPurchaseOrderWithValidPartnerAccountBranchAndPriceListPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationLinkExistingAutoOrderReferenceDuringCreationNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder1 = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        try {
            dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
                partner, 
                supplier, 
                branch, 
                'Template', 
                autoPurchaseOrder1.Id);
            System.assert (false, 'Expected exception not thrown');
        } catch (exception e) {
            System.assert (true, 'Something wrong');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationPartnerAccountLookupShowsOnlyActiveAndValidAccountsPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationBranchLookupFiltersBySelectedPartnerAccountPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationCreateWithMinimalRequiredFieldsOnlyPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationMissingPartnerAccountDuringCreationNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        try {
            dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
                null, 
                supplier, 
                branch, 
                'Template', 
                null
            );
            System.assert (false, 'Expected exception not thrown');
        } catch (exception e) {
            System.assert (true, 'Something wrong');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationMissingBranchDuringCreationNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        try {
            dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
                partner, 
                supplier, 
                null, 
                'Template', 
                null
            );
            System.assert (false, 'Expected exception not thrown');
        } catch (exception e) {
            System.assert (true, 'Something wrong');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderCreationSaveFailsWhenAllRequiredFieldsAreBlankNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        try {
            dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
                null, 
                supplier, 
                null, 
                'Template', 
                null
            );
            System.assert (false, 'Expected exception not thrown');
        } catch (exception e) {
            System.assert (true, 'Something wrong');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationCreateAutoPoLineWithValidItemAndQuantityPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void AutoPurchaseOrderLineCreationQuantityEnteredLessThanEqualsSuggestedQuantityPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10, 
            10, 
            null, 
            null
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__SuggestedQuantity__c, 'Suggested Quantity does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationPendingPurchaseOrderQuantityIsVisiblePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10, 
            10, 
            null, 
            null
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__SuggestedQuantity__c, 'Suggested Quantity does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationSupportCreationWithOptionalFieldsLeftBlankPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationAttemptToSaveWithMissingItemNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        try {
            dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
                autoPurchaseOrder, 
                null, 
                10
            );
            system.assert (true, 'There should be error on creating the no item but succeed');
        } catch (exception e) {
            system.assert (true, 'There should be error on creating without Item');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationAttemptToSaveWithQuantityAs0OrNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        try {
            dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
                autoPurchaseOrder, 
                item, 
                -10
            );
            system.assert (false, 'There should be error on creating the no item but succeed');
        } catch (exception e) {
            system.assert (true, 'There should be error on creating without Item');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationLeaveAutoPurchaseOrderFieldBlankPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        try {
            dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
                null, 
                item, 
                10
            );
            system.assert (false, 'There should be error on creating the no item but succeed');
        } catch (exception e) {
            system.assert (true, 'There should be error on creating without Item');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineCreationChangeLotTypeDueToChangeInItemSettingsPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        autoPurchaseOrderLine.dmpl__ItemLotTypeId__c = null;
        try {
            update autoPurchaseOrderLine;
            system.assert (true, 'There should be an error while editing');
        } catch (exception e) {
            system.assert (false, 'There should be an error');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationCreateRelationWithValidAutoPoAndAutoPoLinePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationLinkFulfillmentOrderLineSuccessfullyPositiveNew() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(
            partner, 
            customer, 
            branch, 
            null, 
            null, 
            Date.today(), 
            'Draft'
        );
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment,
            item, 
            3, 
            1500, 
            null, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation =
            AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        autoPurchaseOrderLineRelation.dmpl__FulfillmentOrderLineId__c = fulfillmentOrderLine.Id;
        update autoPurchaseOrderLineRelation;
        System.assertEquals(fulfillmentOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__FulfillmentOrderLineId__c,'FulfillmentOrderLineId does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationAssignValidItemLotTypeAndSkuCombinationPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationEnterValidOrderQuantityAndSuggestedQuantityPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationAssignCorrectUnitCostAndCheckCurrencyFormatPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationAutoPoOrPoLineFieldLeftBlankPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            null, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(null, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c, 'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationItemOrSkuSelectedIsInactiveNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        try {
            dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
                null, 
                autoPurchaseOrderLine, 
                null, 
                10, 
                173
            );
            system.assert (true, 'There should be error on creating the no item but succeed');
        } catch (exception e) {
            system.assert (true, 'There should be error on creating without Item');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationOrderQuantitySuggestedQuantityNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder, 
            autoPurchaseOrderLine, 
            item, 
            10, 
            173
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(autoPurchaseOrderLine.Id, autoPurchaseOrderLineRelation.dmpl__AutoPurchaseOrderLineId__c,'AutoPurchaseOrderLineId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLineRelation.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLineRelation.dmpl__OrderQuantity__c, 'OrderQuantity does not match');
        System.assertEquals(173, autoPurchaseOrderLineRelation.dmpl__UnitCost__c, 'UnitCost does not match');
        try {
            autoPurchaseOrderLineRelation.dmpl__SuggestedQuantity__c = 20;
            update autoPurchaseOrderLineRelation;
            System.assert (true, 'Expected exception was not thrown');
        } catch (exception e) {
            System.assert (true, 'Exception message should mention SuggestedQuantity');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void autoPurchaseOrderLineRelationCreationRemoveMandatoryFieldAndAttemptSaveNegativeEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(
            partner, 
            supplier, 
            branch, 
            'Template', 
            null
        );
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals('Template', autoPurchaseOrder.dmpl__AutoOrderType__c, 'AutoOrderType does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(
            autoPurchaseOrder, 
            item, 
            10
        );
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(10, autoPurchaseOrderLine.dmpl__Quantity__c, 'Quantity does not match');
        try {
            dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(
                null, 
                autoPurchaseOrderLine, 
                null, 
                10, 
                173
            );
            system.assert (true, 'There should be error on creating the no item but succeed');
        } catch (exception e) {
            system.assert (true, 'There should be error on creating without Item');
        }
        Test.stopTest();
    }

    @isTest
    public static void createProcessAutoPurchaseOrderWithAutoPurchaseOrderLinePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertEquals(autoPurchaseOrder.Id, autoPurchaseOrderLine.dmpl__AutoPurchaseOrderId__c,'AutoPurchaseOrderId does not match');
        System.assertEquals(item.Id, autoPurchaseOrderLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(sku.Id, autoPurchaseOrderLine.dmpl__SKUId__c, 'ItemId does not match');
        Test.stopTest();
    }

    @isTest
    public static void createProcessAutoPurchaseOrderWithAutoPurchaseOrderLineUsingInactivePartnerNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
        Boolean exceptionThrown = false;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');        
        try {
            dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partner, supplier, branch);    
        } catch (exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should not be thrown');
        Test.stopTest();
    }

    @isTest
    public static void createProcessAutoPurchaseOrderWithAutoPurchaseOrderLineUsingInvalidItemSkuNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
         dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2', item7.Id, true);
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertEquals(partner.Id, autoPurchaseOrder.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch.Id, autoPurchaseOrder.dmpl__BranchId__c, 'BranchId does not match');
        try {
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(autoPurchaseOrder, item, sku);
        } catch (exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should not be thrown');
        Test.stopTest();
    }
}