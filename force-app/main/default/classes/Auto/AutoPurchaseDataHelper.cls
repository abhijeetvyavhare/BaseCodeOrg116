@isTest
public with sharing class AutoPurchaseDataHelper {
    public static dmpl__AutoPurchaseOrder__c createAutoPurchaseOrder(
        Account partnerAccount,
        Account supplierAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__AutoPurchaseOrder__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrder__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__AutoOrderType__c = 'Minimum Stock Level',
                dmpl__BudgetAmount__c = 5000,
                dmpl__IsTemplateCreated__c = false,
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Auto created from helper',
                dmpl__PerformOrderGeneration__c = true,
                dmpl__IsOrderGenerated__c = false,
                dmpl__DocumentDate__c = System.today()
            ),
            'AutoPurchaseOrderDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrder__c createAutoPurchaseOrder(
        Account partnerAccount,
        Account supplierAccount,
        dmpl__Branch__c branch,
        String autoOrderType,
        Id AutoPurchaseOrderId
    ) {
        return (dmpl__AutoPurchaseOrder__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrder__c(
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__SupplierAccountId__c = supplierAccount != null ? supplierAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__AutoOrderType__c = autoOrderType,
                dmpl__AutoPurchaseOrderId__c = AutoPurchaseOrderId,
                dmpl__BudgetAmount__c = 5000,
                dmpl__IsTemplateCreated__c = false,
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Auto created from helper',
                dmpl__PerformOrderGeneration__c = true,
                dmpl__IsOrderGenerated__c = false,
                dmpl__DocumentDate__c = System.today()
            ),
            'AutoPurchaseOrderDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrder__c updateAutoPurchaseOrder(
        dmpl__AutoPurchaseOrder__c existingOrder,
        String newRemark
    ) {
        return (dmpl__AutoPurchaseOrder__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrder__c(
                Id = existingOrder.Id,
                dmpl__Remarks__c = newRemark,
                dmpl__PerformOrderGeneration__c = false,
                dmpl__IsOrderGenerated__c = true
            ),
            'AutoPurchaseOrderDefaults',
            false
        );
    }

    public static dmpl__AutoPurchaseOrder__c getAutoPurchaseOrder() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Remarks__c,
                dmpl__AutoOrderType__c,
                dmpl__Status__c,
                dmpl__PerformOrderGeneration__c,
                dmpl__IsOrderGenerated__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c
            FROM dmpl__AutoPurchaseOrder__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrder__c getAutoPurchaseOrder(
        Id autoOrderId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Remarks__c,
                dmpl__AutoOrderType__c,
                dmpl__Status__c,
                dmpl__PerformOrderGeneration__c,
                dmpl__IsOrderGenerated__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c
            FROM dmpl__AutoPurchaseOrder__c
            WHERE Id = :autoOrderId
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLine__c createAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id
            ),
            'AutoPurchaseOrderLineDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLine__c createAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__Item__c item,
        Integer quantity,
        Integer suggestedQuantity,
        Integer pendingPurchaseQuantity,
        Id itemLotTypeId
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder != null ? autoPurchaseOrder.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Quantity__c = quantity,
                dmpl__SuggestedQuantity__c = suggestedQuantity,
                dmpl__PendingPurchaseOrderQuantity__c = pendingPurchaseQuantity,
                dmpl__ItemLotTypeId__c = itemLotTypeId
            ),
            'AutoPurchaseOrderLineDefaults',
            true
        );
    }
    
    public static dmpl__AutoPurchaseOrderLine__c createAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__Item__c item,
        Integer quantity
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder != null ? autoPurchaseOrder.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Quantity__c = quantity
            ),
            'AutoPurchaseOrderLineDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLine__c updateAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrderLine__c existingLine,
        Integer newOrderQuantity,
        Decimal newUnitCost
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                Id = existingLine.Id,
                dmpl__UnitCost__c = newUnitCost
            ),
            'AutoPurchaseOrderLineDefaults',
            false
        );
    }

    public static dmpl__AutoPurchaseOrderLine__c getAutoPurchaseOrderLine() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__MaximumQuantity__c,
                dmpl__MinimumQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLine__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLine__c getAutoPurchaseOrderLine(
        Id lineId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__MaximumQuantity__c,
                dmpl__MinimumQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c createAutoPurchaseOrderLineRelation(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine,
        dmpl__Item__c item,
        dmpl__ItemLotType__c itemLot,
        dmpl__SKU__c sku
    ) {
        return (dmpl__AutoPurchaseOrderLineRelation__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLineRelation__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.Id,
                dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotTypeId__c = itemLot.Id,
                dmpl__SKUId__c = sku.Id
            ),
            'AutoPurchaseOrderLineRelationDefault', 
            true
        );
    }
    
    public static dmpl__AutoPurchaseOrderLineRelation__c createAutoPurchaseOrderLineRelation(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine
    ) {
        return (dmpl__AutoPurchaseOrderLineRelation__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLineRelation__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.Id,
                dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine.Id
            ),
            'AutoPurchaseOrderLineRelationDefault', 
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c createAutoPurchaseOrderLineRelation(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine,
        dmpl__Item__c item,
        dmpl__ItemLotType__c itemLot,
        dmpl__SKU__c sku,
        Integer quantity,
        Decimal unitCost
    ) {
        return (dmpl__AutoPurchaseOrderLineRelation__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLineRelation__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder != null ? autoPurchaseOrder.Id : null,
                dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine != null ? autoPurchaseOrderLine.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ItemLotTypeId__c = itemLot != null ? itemLot.Id : null,
                dmpl__SKUId__c = sku != null ? sku.Id : null,
                dmpl__OrderQuantity__c = quantity,
                dmpl__UnitCost__c = unitCost
            ),
            'AutoPurchaseOrderLineRelationDefault', 
            true
        );
    }
    
    public static dmpl__AutoPurchaseOrderLineRelation__c createAutoPurchaseOrderLineRelation(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine,
        dmpl__Item__c item,
        Integer quantity,
        Decimal unitCost
    ) {
        return (dmpl__AutoPurchaseOrderLineRelation__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLineRelation__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder != null ? autoPurchaseOrder.Id : null,
                dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine != null ? autoPurchaseOrderLine.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__OrderQuantity__c = quantity,
                dmpl__UnitCost__c = unitCost
            ),
            'AutoPurchaseOrderLineRelationDefault', 
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c getAutoPurchaseOrderLineRelation() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__AutoPurchaseOrderLineId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__OrderQuantity__c,
                dmpl__PurchaseOrderQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLineRelation__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c getAutoPurchaseOrderLineRelation(
        Id recordId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__AutoPurchaseOrderLineId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__OrderQuantity__c,
                dmpl__PurchaseOrderQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLineRelation__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}