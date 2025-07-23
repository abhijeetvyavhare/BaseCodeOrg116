@isTest
public class GoodRecieptsTestDataHelpers {
    public static dmpl__GoodsReceipt__c createGoodsReceipt(
        Account partnerAccount, 
        dmpl__Branch__c branch, 
        dmpl__PurchaseOrder__c purchaseOrder, 
        Account supplierAccount
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__PartnerAccountId__c = partnerAccount?.Id, 
                dmpl__BranchId__c = branch?.Id, 
                dmpl__PurchaseOrderId__c = purchaseOrder?.Id, 
                dmpl__SupplierAccountId__c = supplierAccount?.Id
            ), 
            'GoodsReceiptDefaults', 
            true
        );
    }

    public static dmpl__GoodsReceipt__c createGoodsReceipt(
        Id partnerAccountId, 
        Id supplierAccountId, 
        Id branchId, 
        Id purchaseOrderId, 
        Id shipmentId
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__PartnerAccountId__c = partnerAccountId, 
                dmpl__BranchId__c = branchId, 
                dmpl__PurchaseOrderId__c = purchaseOrderId, 
                dmpl__SupplierAccountId__c = supplierAccountId,
                dmpl__ShipmentId__c = shipmentId
            ), 
            'GoodsReceiptDefaults', 
            true
        );
    }

    public static dmpl__GoodsReceipt__c getGoodsReceipt() {
        return [
            SELECT
                Id, 
                name, 
                dmpl__DocumentDate__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__IsClaimed__c, 
                dmpl__Status__c, 
                dmpl__IsBillGenerated__c, 
                dmpl__PurchaseOrderId__c, 
                dmpl__PerformReceive__c, 
                dmpl__IsInspectionCompleted__c, 
                dmpl__PerformReceiveAsync__c, 
                dmpl__PerformInspection__c, 
                dmpl__PerformInspectionComplete__c, 
                dmpl__PerformPopulateChecklist__c, 
                dmpl__PerformAllocation__c
            FROM dmpl__GoodsReceipt__c
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceipt__c getGoodsReceipt(
        Id id
    ) {
        return [
            SELECT
                Id, 
                name, 
                dmpl__DocumentDate__c, 
                dmpl__ShipmentId__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__IsClaimed__c, 
                dmpl__Status__c, 
                dmpl__IsBillGenerated__c, 
                dmpl__PerformReceive__c, 
                dmpl__IsInspectionCompleted__c, 
                dmpl__PerformReceiveAsync__c, 
                dmpl__PerformInspection__c, 
                dmpl__PurchaseOrderId__c, 
                dmpl__PerformInspectionComplete__c, 
                dmpl__PerformPopulateChecklist__c, 
                dmpl__PerformAllocation__c, 
                dmpl__SupplierAccountId__c
            FROM dmpl__GoodsReceipt__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceiptLine__c createGoodReceiptLine(
        dmpl__GoodsReceipt__c GRNDoc, 
        dmpl__Item__c item, 
        dmpl__SKU__c sku
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = GRNDoc?.Id, 
                dmpl__ItemId__c = item?.Id, 
                dmpl__SKUId__c = sku?.Id
            ), 
            true
        );
    }
        public static dmpl__GoodsReceiptLine__c createGoodReceiptLine(
        Id GRNId, 
        Id itemId, 
        Id skuId
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = GRNId,
                dmpl__ItemId__c = itemId ,
                dmpl__SKUId__c = skuId
            ), 
            true
        );
    }

    public static dmpl__GoodsReceiptLine__c createGoodsReceiptLine(
        Id goodReceiptId, 
        Id itemId, 
        Id skuId, 
        Id purchaseorderLineId, 
        Integer orderedQuantity, 
        Integer recievedQuantity, 
        Integer DamagedQuantity, 
        Integer supplierQuantity, 
        Integer unitCost
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = goodReceiptId, 
                dmpl__ItemId__c = itemId, 
                dmpl__SKUId__c = skuId, 
                dmpl__PurchaseOrderLineId__c = purchaseorderLineId, 
                dmpl__OrderedQuantity__c = orderedQuantity, 
                dmpl__DamagedQuantity__c = DamagedQuantity, 
                dmpl__ReceivedQuantity__c = recievedQuantity, 
                dmpl__SupplierQuantity__c = supplierQuantity, 
                dmpl__UnitCost__c = unitCost
            ), 
            true
        );
    }

    public static dmpl__GoodsReceiptLine__c createGoodsReceiptLine(
        Id goodReceiptId, 
        Id itemId, 
        Id skuId, 
        Integer orderedQuantity
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = goodReceiptId, 
                dmpl__ItemId__c = itemId, 
                dmpl__SKUId__c = skuId, 
                dmpl__OrderedQuantity__c = orderedQuantity ?? 0,
                dmpl__ReceivedQuantity__c =  orderedQuantity ?? 0
            ), 
            'GoodReceiptLineDefaults',
            true
        );
    }


    public static dmpl__GoodsReceiptLine__c getGoodReceiptLine() {
        return [
            SELECT
                Id, 
                name, 
                dmpl__GoodsReceiptId__c, 
                dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c, 
                dmpl__ItemLotId__c, 
                dmpl__ReceivedQuantity__c, 
                dmpl__InventoryLedgerId__c, 
                dmpl__StorageLocationId__c, 
                dmpl__UnitCost__c, 
                dmpl__ItemLotTypeId__c, 
                dmpl__PurchaseOrderLineId__c, 
                dmpl__OrderedQuantity__c, 
                dmpl__SupplierQuantity__c, 
                dmpl__InvoiceQuantity__c, 
                dmpl__ItemId__c, 
                dmpl__DamagedQuantity__c, 
                dmpl__ClaimableQuantity__c, 
                dmpl__ShipmentLineId__c, 
                dmpl__ShortageQuantity__c, 
                dmpl__ExcessQuantity__c,
                dmpl__SKUId__c
            FROM dmpl__GoodsReceiptLine__c
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceiptLine__c getGoodsReceiptLine(
        Id id
    ) {
        return [
            SELECT
                Id, 
                name, 
                dmpl__GoodsReceiptId__c, 
                dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c, 
                dmpl__ItemLotId__c, 
                dmpl__ReceivedQuantity__c, 
                dmpl__InventoryLedgerId__c, 
                dmpl__StorageLocationId__c, 
                dmpl__UnitCost__c, 
                dmpl__ItemLotTypeId__c, 
                dmpl__PurchaseOrderLineId__c, 
                dmpl__OrderedQuantity__c, 
                dmpl__SupplierQuantity__c, 
                dmpl__InvoiceQuantity__c, 
                dmpl__ItemId__c, 
                dmpl__DamagedQuantity__c, 
                dmpl__ClaimableQuantity__c, 
                dmpl__ShipmentLineId__c, 
                dmpl__ShortageQuantity__c, 
                dmpl__ExcessQuantity__c,
                dmpl__SKUId__c
            FROM dmpl__GoodsReceiptLine__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

    public static dmpl__InspectionLine__c createInspectionLine(
        dmpl__Item__c item, 
        dmpl__SKU__c sku, 
        dmpl__GoodsReceipt__c grn
    ) {
        return (dmpl__InspectionLine__c) TestFactory.createSObject(
            new dmpl__InspectionLine__c(
                dmpl__ItemId__c = item.id, 
                dmpl__SKUId__c = sku.id, 
                dmpl__ReceiptId__c = grn.id
            ), 
            'InspectionLineDefaults', 
            true
        );
    }

    public static dmpl__InspectionLine__c getInspectionLine() {
        return [
            SELECT
                Id, 
                name, 
                dmpl__ItemId__c, 
                dmpl__SKUId__c, 
                dmpl__Quantity__c, 
                dmpl__ReceivedQuantity__c, 
                dmpl__ReceiptId__c, 
                dmpl__InspectionDone__c
            FROM dmpl__InspectionLine__c
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceipt__c CreateGoodReceiptFromShipment(
        dmpl__Shipment__c shipment
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__BranchId__c = shipment.dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c = shipment.dmpl__PartnerAccountId__c, 
                dmpl__SupplierAccountId__c = shipment.dmpl__SupplierAccountId__c, 
                dmpl__PurchaseOrderId__c = shipment.dmpl__PurchaseOrderId__c, 
                dmpl__ShipmentId__c = shipment.Id
            ), 
            'GoodsReceiptDefaults', 
            true
        );
    }

    public static dmpl__GoodsReceipt__c getGoodReceiptFromShipment() {
        return [
            SELECT 
                Id, 
                Name
            FROM dmpl__GoodsReceipt__c
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceiptLine__c CreateGoodReceiptLineFromShipmentLine(
        dmpl__ShipmentLine__c shipmentLine, 
        dmpl__GoodsReceipt__c goodReceipt
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__ItemId__c = shipmentLine.dmpl__ItemId__c, 
                dmpl__SKUId__c = shipmentLine.dmpl__SKUId__c, 
                dmpl__GoodsReceiptId__c = goodReceipt.Id, 
                dmpl__OrderedQuantity__c = shipmentLine.dmpl__Quantity__c, 
                dmpl__InvoiceQuantity__c = shipmentLine.dmpl__Quantity__c
            ), 
            'GoodReceiptLineDefaults', 
            true
        );
    }

    public static dmpl__GoodsReceipt__c createGoodsReceipt(
        Account partnerAccount, 
        dmpl__Branch__c branch, 
        dmpl__PurchaseOrder__c purchaseOrder, 
        Account supplierAccount, 
        Date Docdate
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__PartnerAccountId__c = partnerAccount?.Id, 
                dmpl__BranchId__c = branch?.Id, 
                dmpl__PurchaseOrderId__c = purchaseOrder?.Id, 
                dmpl__DocumentDate__c = Docdate, 
                dmpl__SupplierAccountId__c = supplierAccount?.Id
            ), 
            'GoodsReceiptDefaults', 
            true
        );
    }
}