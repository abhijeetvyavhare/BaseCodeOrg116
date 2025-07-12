@isTest
public with sharing class AutoPurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLotType__c itemLot = TestDataHelpers.createItemLotType(item);

        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partnerAccount, supplierAccount, branch);
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(autoPurchaseOrder, item, sku);
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseDataHelper.createAutoPurchaseOrderLineRelation(autoPurchaseOrder, autoPurchaseOrderLine, item, itemLot, sku);
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
            System.assert(
                e.getMessage().contains('downstream transaction'),
                'Unexpected error during delete: ' + e.getMessage()
            );
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
}