@isTest
private class GoodsReceiptHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup();
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch, supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item, sku, purchaseOrder, taxGroup, purchaseRequisition);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplierAccount, branch, purchaseOrder);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment, sku, purchaseOrderLine);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount, branch, purchaseOrder, supplierAccount);
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        dmpl__InspectionLine__c inspectionLine = GoodRecieptsTestDataHelpers.createInspectionLine(item, sku, goodsReceipt);
    }
    
    @isTest
    static void createGoodsReceiptTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(null, receipt, 'Goods Receipt should have been created');
        System.assertEquals(Date.today(), receipt.dmpl__DocumentDate__c);
        System.assertEquals(true, receipt.dmpl__PerformReceive__c);
        System.assertEquals(true, receipt.dmpl__PerformInspection__c);
        System.assertEquals(true, receipt.dmpl__PerformInspectionComplete__c);
        System.assertEquals(true, receipt.dmpl__IsInspectionCompleted__c);
    }

    @isTest
    static void createGoodsReceiptLineTest() {
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grn, 'GRN Line should have been created');
        System.assertEquals(1, grn.dmpl__ReceivedQuantity__c);
        System.assertEquals(1, grn.dmpl__OrderedQuantity__c);
        System.assertEquals(1, grn.dmpl__SupplierQuantity__c);
    }
     
    @isTest
    static void updateGoodsReceiptTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(null, receipt, 'Goods Receipt should exist before update.');

        receipt.dmpl__PerformReceive__c = false;
        receipt.dmpl__PerformInspection__c = false;
        receipt.dmpl__PerformInspectionComplete__c = false;
        receipt.dmpl__IsInspectionCompleted__c = false;
        update receipt;

        dmpl__GoodsReceipt__c updated = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertEquals(false, updated.dmpl__PerformReceive__c);
        System.assertEquals(false, updated.dmpl__PerformInspection__c);
        System.assertEquals(false, updated.dmpl__PerformInspectionComplete__c);
        System.assertEquals(false, updated.dmpl__IsInspectionCompleted__c);
    }

    @isTest
    static void updateGoodsReceiptLineTest() {
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grn, 'GRN Line should exist before update.');

        grn.dmpl__ReceivedQuantity__c = 5;
        grn.dmpl__OrderedQuantity__c = 5;
        grn.dmpl__SupplierQuantity__c = 5;
        update grn;

        dmpl__GoodsReceiptLine__c updated = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertEquals(5, updated.dmpl__ReceivedQuantity__c);
        System.assertEquals(5, updated.dmpl__OrderedQuantity__c);
        System.assertEquals(5, updated.dmpl__SupplierQuantity__c);
    }

    @isTest
    static void deleteGoodsReceiptTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(null, receipt, 'Goods Receipt should exist before delete.');

        Test.startTest();
        delete receipt;
        Test.stopTest();
		dmpl__GoodsReceipt__c deletedReceipt=null;
        
        try {
            deletedReceipt=GoodRecieptsTestDataHelpers.getGoodsReceipt();
        } catch (Exception e) {
			deletedReceipt=null;
        }
        System.assertEquals(null, deletedReceipt, 'Goods receipt should be deleted.');
    }

    @isTest
    static void deleteGoodsReceiptLineTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grn, 'GRN Line should exist before delete.');

        Test.startTest();
        delete receipt;
        Test.stopTest();
		dmpl__GoodsReceiptLine__c deletedGrn=null;
        
        try {
           	deletedGrn=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedGrn);
        } catch (Exception e) {
            deletedGrn=null;
        }
        System.assertEquals(null, deletedGrn, 'Goods receipt lines should be deleted.');
    }
}