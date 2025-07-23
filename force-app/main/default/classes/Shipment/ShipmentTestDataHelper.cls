public with sharing class ShipmentTestDataHelper {
    public static dmpl__Shipment__c createShipment(
        Account supplierAccount, 
        dmpl__Branch__c branch, 
        dmpl__PurchaseOrder__c purchaseOrder
    ) {
        return (dmpl__Shipment__c) TestFactory.createSObject(
            new dmpl__Shipment__c(
                dmpl__BranchId__c = branch.Id, 
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c, 
                dmpl__SupplierAccountId__c = supplierAccount.Id, 
                dmpl__PurchaseOrderId__c = purchaseOrder.Id
            ), 
            'ShipmentDefaults', 
            true
        );
    }

    public static dmpl__Shipment__c createShipment(
        Id partnerAccountId,
        Id supplierAccountId, 
        Id branchId
    ) {
        return (dmpl__Shipment__c) TestFactory.createSObject(
            new dmpl__Shipment__c(
                dmpl__BranchId__c = branchId, 
                dmpl__PartnerAccountId__c = partnerAccountId, 
                dmpl__SupplierAccountId__c = supplierAccountId
            ), 
            'ShipmentDefaults', 
            true
        );
    }

    public static dmpl__Shipment__c createShipment(
        Date shipmentDate, 
        Id PartnerAccountId, 
        Id BranchId, 
        Id SuppilerId, 
        Id purchaseOrderId
    ) {
        return (dmpl__Shipment__c) TestFactory.createSObject(
            new dmpl__Shipment__c(
                dmpl__BranchId__c = BranchId, 
                dmpl__PartnerAccountId__c = PartnerAccountId, 
                dmpl__SupplierAccountId__c = SuppilerId, 
                dmpl__PurchaseOrderId__c = purchaseOrderId,
                dmpl__ShipmentDate__c = shipmentDate
            ), 
            'ShipmentDefaults', 
            true
        );
    }

    public static dmpl__Shipment__c getShipment() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PerformReleaseReceipt__c, 
                dmpl__DocumentDate__c, 
                dmpl__ShipmentDate__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PurchaseOrderId__c, 
                dmpl__SupplierAccountId__c, 
                dmpl__Status__c
            FROM dmpl__Shipment__c
            LIMIT 1
        ];
    }

    public static dmpl__Shipment__c getShipment(
        Id ShipmentId
    ) {
        return [
            SELECT
                Id, 
                Name, 
                dmpl__PerformReleaseReceipt__c, 
                dmpl__DocumentDate__c, 
                dmpl__ShipmentDate__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PurchaseOrderId__c, 
                dmpl__SupplierAccountId__c, 
                dmpl__Status__c
            FROM dmpl__Shipment__c
            WHERE Id = :ShipmentId
            LIMIT 1
        ];
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item, 
        dmpl__Shipment__c shipment, 
        dmpl__SKU__c sku, 
        dmpl__PurchaseOrderLine__c purchaseOrderLine
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id, 
                dmpl__ShipmentId__c = shipment?.Id, 
                dmpl__SKUId__c = sku?.Id, 
                dmpl__PurchaseOrderLineId__c = purchaseOrderLine?.Id
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item, 
        dmpl__Shipment__c shipment, 
        dmpl__SKU__c sku, 
        dmpl__PurchaseOrderLine__c purchaseOrderLine, 
        Integer unitprice, 
        Integer quantity
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id, 
                dmpl__ShipmentId__c = shipment?.Id, 
                dmpl__Quantity__c = quantity, 
                dmpl__SKUId__c = sku?.Id, 
                dmpl__UnitPrice__c = unitprice, 
                dmpl__PurchaseOrderLineId__c = purchaseOrderLine?.Id
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item, 
        dmpl__Shipment__c shipment, 
        Integer unitprice, 
        Integer quantity
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id, 
                dmpl__ShipmentId__c = shipment?.Id, 
                dmpl__Quantity__c = quantity, 
                dmpl__UnitPrice__c = unitprice
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        Id shipmentId, 
        Id itemId,
        Id skuId,
        Integer quantity
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = itemId, 
                dmpl__ShipmentId__c = shipmentId, 
                dmpl__Quantity__c = quantity, 
                dmpl__SKUId__c = skuId
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item,
        dmpl__Shipment__c shipment,
        dmpl__PurchaseOrderLine__c purchaseOrderLine,
        Integer quantity
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id,
                dmpl__ShipmentId__c = shipment?.Id,
                dmpl__PurchaseOrderLineId__c = purchaseOrderLine?.Id,
                dmpl__Quantity__c = quantity
            ),
            'ShipmentLineDefaults',
            true
        );
    }

    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item, 
        dmpl__Shipment__c shipment
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id, 
                dmpl__ShipmentId__c = shipment?.Id
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }
    
    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item, 
        dmpl__Shipment__c shipment, 
        Integer quantity
    ) {
        return (dmpl__ShipmentLine__c) TestFactory.createSObject(
            new dmpl__ShipmentLine__c(
                dmpl__ItemId__c = item?.Id, 
                dmpl__ShipmentId__c = shipment?.Id, 
                dmpl__Quantity__c = quantity 
            ), 
            'ShipmentLineDefaults', 
            true
        );
    }

    public static dmpl__ShipmentLine__c getShipmentLine() {
        return [
            SELECT
                Id, 
                name, 
                dmpl__ShipmentId__c, 
                dmpl__Quantity__c, 
                dmpl__UnitPrice__c, 
                dmpl__ItemId__c, 
                dmpl__Amount__c, 
                dmpl__SKUId__c, 
                dmpl__PendingQuantity__c, 
                dmpl__PurchaseOrderLineId__c
            FROM dmpl__ShipmentLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ShipmentLine__c getShipmentLine(
        Id lineId
    ) {
        return [
            SELECT
                Id, 
                name, 
                dmpl__ShipmentId__c, 
                dmpl__Quantity__c, 
                dmpl__UnitPrice__c, 
                dmpl__ItemId__c, 
                dmpl__Amount__c, 
                dmpl__SKUId__c, 
                dmpl__PendingQuantity__c, 
                dmpl__PurchaseOrderLineId__c
            FROM dmpl__ShipmentLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }

    public static dmpl__ShippingAssetLine__c createShippingAssetLine(
        Id assetId, 
        Id itemId
    ) {
        return (dmpl__ShippingAssetLine__c) TestFactory.createSObject(
            new dmpl__ShippingAssetLine__c(
                dmpl__AssetId__c = assetId, 
                dmpl__ItemId__c = itemId
            ), 
            'ShippingAssetLineDefaults',
            true
        );
    }

    public static dmpl__ShippingAssetLine__c getShipmentAssetLine(
        Id Id
    ) {
        return [
            SELECT
                Id, 
                name, 
                dmpl__AssetId__c, 
                dmpl__ItemId__c, 
                dmpl__SerialNumber__c, 
                dmpl__EngineNumber__c, 
                dmpl__AssetNumber__c, 
                dmpl__DeliveryDate__c
            FROM dmpl__ShippingAssetLine__c
            WHERE Id = :Id
            LIMIT 1
        ];
    }
}