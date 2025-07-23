@isTest
public with sharing class ShipmentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 1500);
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch, supplier);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST12_6 = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST12_6 = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            10
        );
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, supplier.Id, branch.Id);
        dmpl__ShipmentLine__c shipmentLine2 = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            null, 
            purchaseOrderLine
        );
    }
    
    @isTest
    static void createShipmentPositive() {
        Test.startTest();
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assert(shipment!=null, 'Successfully created!');
        Test.stopTest();
    }
    
    @isTest
    static void createShipmentLinePositive() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine);
        System.assertEquals(1, shipmentLine.dmpl__Quantity__c);
    }
    
    @isTest
    static void updateShipmentPositive() {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertNotEquals(null, shipment, 'Shipment should exist before update.');
        Boolean newPerformReleaseReceipt = !shipment.dmpl__PerformReleaseReceipt__c;
        shipment.dmpl__PerformReleaseReceipt__c = newPerformReleaseReceipt;
        update shipment;
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment();
        System.assertEquals(false, updatedShipment.dmpl__PerformReleaseReceipt__c, 'Shipment PerformReleaseReceipt should be updated.');
    }
    
    @isTest
    static void updateShipmentLinePositive() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine);
        shipmentLine.dmpl__Quantity__c = 5;
        update shipmentLine;
        dmpl__ShipmentLine__c updatedShipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertEquals(5, updatedShipmentLine.dmpl__Quantity__c);
    }
    
    @isTest
    static void deleteShipment() {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertNotEquals(null, shipment, 'Shipment should exist before delete.');
        delete shipment;
        dmpl__Shipment__c deletedShipment;
        try {
            deletedShipment = ShipmentTestDataHelper.getShipment();
        } catch (Exception e) {
            deletedShipment = null;
        }
        System.assertEquals(null, deletedShipment, 'Shipment should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteShipmentLine() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine, 'ShipmentLine should exist before delete.');
        delete shipmentLine;
        dmpl__ShipmentLine__c deletedShipmentLine;
        try {
            deletedShipmentLine = ShipmentTestDataHelper.getShipmentLine();
        } catch (Exception e) {
            deletedShipmentLine = null;
        }
        System.assertEquals(null, deletedShipmentLine, 'ShipmentLine should be deleted and not found in query.');
    }
    
    @isTest 
    static void createWithValidItemAssetSerialNumberPositiveNew() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(asset.Id, item.Id);
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertEquals(shippingAssetLine.dmpl__AssetId__c, asset.Id, 'Expected shipping asset line to be linked to the correct asset.');
        System.assertEquals(shippingAssetLine.dmpl__ItemId__c, item.Id, 'Expected shipping asset line to be linked to the correct item.');
        System.assertEquals(shippingAssetLine.dmpl__SerialNumber__c, '1234567890', 'Expected shipping asset line to have the correct serial number.');
        System.assertEquals(shippingAssetLine.dmpl__EngineNumber__c, 'Engine Number', 'Expected shipping asset line to have the correct engine number.');
        System.assertEquals(shippingAssetLine.dmpl__AssetNumber__c, 'Asset Number', 'Expected shipping asset line to have the correct asset number.');
        System.assertEquals(shippingAssetLine.dmpl__DeliveryDate__c, Date.today(), 'Expected shipping asset line to have the correct delivery date.');
        Test.stopTest();
    }
    
    @isTest
    static void saveWithoutSelectingAnyFieldItemPositiveNew() {
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(null, null);
        shippingAssetLine.dmpl__SerialNumber__c = null;
        update shippingAssetLine;
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        System.assertEquals(shippingAssetLine.dmpl__AssetId__c, null, 'Expected shipping asset line to have the correct asset.');
        System.assertEquals(shippingAssetLine.dmpl__ItemId__c, null, 'Expected shipping asset line to have the correct item.');
        Test.stopTest();
    }
    
    @isTest
    static void autoPopulateItemNameBasedOnLookup() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(asset.Id, item.Id);
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertEquals(item.Id, shippingAssetLine.dmpl__ItemId__c, 'Expected shipping asset line to have the correct item.');
        Test.stopTest();
    }
    
    @isTest
    static void saveWhenDeliveryDateIsBlankPositiveNew() {
       Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(asset.Id, item.Id);
        shippingAssetLine.dmpl__DeliveryDate__c = null;
        update shippingAssetLine;
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertEquals(shippingAssetLine.dmpl__DeliveryDate__c, null, 'Expected shipping asset line to have the correct delivery date.');
        Test.stopTest();
    }
    
    @isTest
    static void addEngineNumberAndSaveSuccessfully() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(asset.Id, item.Id);
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertEquals(shippingAssetLine.dmpl__EngineNumber__c, 'Engine Number', 'Expected shipping asset line to have the correct engine number.');
        Test.stopTest();
    }
    
    @isTest
    static void leaveAssetNumberBlankPositiveNew() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__ShippingAssetLine__c shippingAssetLine = ShipmentTestDataHelper.createShippingAssetLine(asset.Id, item.Id);
        System.assertNotEquals(shippingAssetLine, null, 'Expected shipping asset line to be created.');
        shippingAssetLine = ShipmentTestDataHelper.getShipmentAssetLine(shippingAssetLine.Id);
        System.assertEquals('Asset Number', shippingAssetLine.dmpl__AssetNumber__c, 'Expected shipping asset line to have the correct asset number.');
        Test.stopTest();
    }
    
    @isTest
    static void updateShipmentCreationWithWrongBranchNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            shipment.dmpl__BranchId__c = branch3.Id;
            update shipment;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception when using a wrong branch');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    static void updateShipmentCreationWithInactiveBranchNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            shipment.dmpl__PartnerAccountId__c = partner3.Id;
            shipment.dmpl__BranchId__c = branch3.Id;
            update shipment;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception when using a wrong branch');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    static void updateShipmentCreationWithNoSupplierAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        shipment.dmpl__SupplierAccountId__c = null;
        update shipment;
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    @isTest
    static void createShipmentcreationWithBackwardShipmentDatePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.today().addDays(-1), 
            partner.Id, 
            branch.Id, 
            supplier.id, 
            null
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(Date.today().addDays(-1), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today().addDays(-1), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    @isTest
    static void updateShipmentcreationWithBackwardShipmentDateNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            shipment.dmpl__ShipmentDate__c = Date.today().addMonths(-3);
            update shipment;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Shipment date should not update');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    @isTest
    static void createShipmentCreationWithPurchaseOrderReference() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        update shipmentLine;
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item ID should match the expected Item');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be 15000 (Quantity * Unit Price)');
    }
    
    @isTest
    static void createShipmentWithoutPurchaseOrderReference() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.Today(), 
            partner.Id, 
            branch.Id, 
            supplier.id, 
            null
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    @isTest
    static void updateShipmentCreationWithPurchaseOrderReference() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            null, 
            purchaseOrderLine
        );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        update shipmentLine;
        dmpl__ShipmentLine__c shipmentLine2 = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            null, 
            purchaseOrderLine
        );
        shipmentLine2.dmpl__Quantity__c = 15;
        shipmentLine2.dmpl__UnitPrice__c = 1500;
        update shipmentLine2;
        Test.stopTest();
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine2 = ShipmentTestDataHelper.getShipmentLine(shipmentLine2.Id);
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'fetchedShipmentLine: Item ID should match the expected Item');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'fetchedShipmentLine: Unit Price should be 1500');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'fetchedShipmentLine: Quantity should be 10');
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c, 'fetchedShipmentLine: Amount should be 15000 (Quantity * Unit Price)');
        System.assertEquals(item.Id, fetchedShipmentLine2.dmpl__ItemId__c, 'fetchedShipmentLine2: Item ID should match the expected Item');
        System.assertEquals(1500, fetchedShipmentLine2.dmpl__UnitPrice__c, 'fetchedShipmentLine2: Unit Price should be 1500');
        System.assertEquals(15, fetchedShipmentLine2.dmpl__Quantity__c, 'fetchedShipmentLine2: Quantity should be 15');
        System.assertEquals(22500, fetchedShipmentLine2.dmpl__Amount__c, 'fetchedShipmentLine2: Amount should be 22500 (Quantity * Unit Price)');
    }
    
    @isTest
    static void createShipmentCreationWithoutPurchaseOrderReference() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        shipment.dmpl__PurchaseOrderId__c = null;
        update shipment;
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment);
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        update shipmentLine;
        Test.stopTest();
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(null, fetchedShipment.dmpl__PurchaseOrderId__c, 'Shipment should not be linked to any Purchase Order');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Shipment Line: Item ID should match the expected Item');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Shipment Line: Unit Price should be 1500');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line: Quantity should be 10');
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c, 'Shipment Line: Amount should be 15000 (Quantity * Unit Price)');
    }
    
    @isTest
    static void createShipmentWithCorrectPartnerAndBranchPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        Test.stopTest();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    static void createShipmentWithSupplierAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.Today(), 
            partner.Id, 
            branch.Id, 
            supplier.id, 
            purchaseOrder.Id
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }
    
    @isTest
    static void createShipmentLineWithActiveItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment,
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void createShipmentLineWithRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            sku, 
            null, 
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(sku.Id, fetchedShipmentLine.dmpl__SKUId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void createShipmentLineWithNoRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void createShipmentLineWithInactiveItemNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine;
        shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
    }
    
    @isTest
    static void createShipmentLineWithDiscountinuedItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void updateShipmentLineWithInactiveItemNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        try {
            shipmentLine.dmpl__ItemId__c = item2.Id;
            update shipmentLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item2.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item Id should match');
    }
    
    @isTest
    static void createShipmentWithWrongPartnerAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(), 
                partner.Id, 
                branch.Id, 
                supplier.Id, 
                purchaseOrder.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched Partner Account');
    }
    
    @isTest
    static void createShipmentWithInactivePartnerAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner.Id);
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(), 
                partner.Id, 
                branch2.Id, 
                supplier.Id, 
                purchaseOrder.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched Partner Account');
        Test.stopTest();
    }
    
    @isTest
    static void createShipmentWithWrongBranchAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(), 
                Partner.Id, 
                branch4.Id, 
                supplier.Id, 
                purchaseOrder.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for wrong branch');
    }
    
    @isTest
    static void createShipmentWithInactiveBranchAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(), 
                Partner.Id, 
                branch3.Id, 
                supplier.Id, 
                purchaseOrder.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive branch');
    }
    
    @isTest
    static void createShipmentWithNoSupplierAccountPositive() {
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        shipment.dmpl__SupplierAccountId__c = null;
        update shipment;
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c);
    }
    
    @isTest
    static void updateShipmentCreationWithoutSupplierAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        shipment.dmpl__SupplierAccountId__c = null;
        update shipment;
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    @isTest
    static void updateShipmentCreationWithWrongPartnerNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            shipment.dmpl__PartnerAccountId__c = partner3.Id;
            update shipment;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception when using a wrong branch');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    static void updateShipmentCreationWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id);
        partner2.dmpl__IsActive__c = false;
        update partner2;
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            shipment.dmpl__PartnerAccountId__c = partner2.Id;
            shipment.dmpl__BranchId__c = branch2.Id;
            update shipment;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception when using a wrong branch');
    }
    
    @isTest
    static void updateShipmentLineWithDiscountinuedItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        item4.dmpl__IsDiscontinued__c = true;
        update item4;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        shipmentLine.dmpl__ItemId__c = item4.Id;
        update shipmentLine;
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item4.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void updateShipmentLineWithRequiredSKUNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            sku, 
            null, 
            1500, 
            1
        );
        try {
            shipmentLine.dmpl__SKUId__c = null;
            update shipmentLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(null, fetchedShipmentLine.dmpl__SKUId__c, 'Shipment reference should match to be null');
    }
    
    @isTest
    static void updateShipmentLineWithNoRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment( );
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            1
        );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity to be 1500');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match to be 1');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match to be 1500');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Shipment reference should match');
    }
    
    @isTest
    static void createShipmentLineWithZeroQuantityNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                item, 
                shipment, 
                1500, 
                0
            );
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
    }
    
    @isTest
    static void updateShipmentLineWithZeroQuantityNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            null, 
            partner.Id, 
            branch.Id, 
            null, 
            null
        );
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            2
        );
        try {
            shipmentLine.dmpl__Quantity__c = 0;
            update shipmentLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(2, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
    }
    
    @isTest
    static void createShipmentLineWithoutUnitCostPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(shipment.dmpl__PurchaseOrderId__c, fetchedShipment.dmpl__PurchaseOrderId__c, 'Purchase Order ID should match');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(shipmentLine.dmpl__Quantity__c, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match');
    }
    
    @isTest
    static void updateShipmentLineWithoutUnitCostPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            null, 
            partner.Id, 
            branch.Id, 
            null, 
            null
        );
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment);
        shipmentLine.dmpl__UnitPrice__c = null;
        update shipmentLine;
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(shipment.dmpl__PurchaseOrderId__c, fetchedShipment.dmpl__PurchaseOrderId__c, 'Purchase Order ID should match');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(shipmentLine.dmpl__Quantity__c, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match');
    }
    
    @isTest
    static void createShipmentLineWithNegativeQuantityNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        try {
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                item, 
                shipment, 
                1500, 
                -1
            );
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
    }
    
    @isTest
    static void updateShipmentLineWithNegativeQuantityNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            1500, 
            10
        );
        try {
            shipmentLine.dmpl__Quantity__c = -10;
            update shipmentLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match to be 10');
    }
    
    @isTest
    static void createShipmentLineWithPurchaseOrderLineReferencePositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item, 
            null, 
            purchaseOrder, 
            taxGroup
        );
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2000;
		purchaseOrderLine.dmpl__SchemeDiscount__c = null;
		purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
		purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.Today(), 
			partner.Id, 
			branch.Id, 
			null, 
			purchaseOrder.Id
        );
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
			shipment, 
			null, 
			purchaseOrderLine
        );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 2000;
        update shipmentLine;
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(purchaseOrderLine.Id, fetchedShipmentLine.dmpl__PurchaseOrderLineId__c, 'Purchase Order Line ID should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match the expected Shipment');
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item ID should match the expected Item');
        System.assertEquals(10, fetchedShipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 10');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(2000, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20000, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be 20000 (Quantity * Unit Price)');
    }
    
    @isTest
	static void updateShipmentLineWithPurchaseOrderLineReferencePositive() {
		Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item, 
            null, 
            purchaseOrder, 
            taxGroup
        );
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2000;
		purchaseOrderLine.dmpl__SchemeDiscount__c = null;
		purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
		purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.Today(), 
			partner.Id, 
			branch.Id, 
			null, 
			purchaseOrder.Id
        );
		dmpl__ShipmentLine__c shipmentLine;
        try {
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(
				item, 
				shipment, 
				null, 
				purchaseOrderLine
			);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		} catch(Exception e) {
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);      
        System.assertEquals(purchaseOrderLine.Id, shipmentLine.dmpl__PurchaseOrderLineId__c, 'Purchase Order Line ID should match the expected value');
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match the expected Shipment');
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c, 'Item ID should match the expected Item');
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 10');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c, 'Amount should be 20000 (Quantity * Unit Price)');
		try {
			shipmentLine.dmpl__Quantity__c = 20;
			update shipmentLine;
		} catch(Exception e) {
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(20, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 20');
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(40000, shipmentLine.dmpl__Amount__c, 'Amount should be 40000 (Quantity * Unit Price)');
		Test.stopTest();
	}
    
    @isTest
	static void createShipmentLineWithoutPurchaseOrderLineReferenceNegative() {
		Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
		dmpl__ShipmentLine__c shipmentLine;
        try {
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		} catch(Exception e) {
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c, 'Item Id Should Match');
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 10');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c, 'Amount should be 20000 (Quantity * Unit Price)');
		Test.stopTest();
	}
    
    @isTest
	static void updateShipmentLineWithoutPurchaseOrderLineReferenceNegative() {
		Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
		dmpl__ShipmentLine__c shipmentLine;
        try {
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		} catch(Exception e) {
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);  
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match the expected Shipment');
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c, 'Item ID should match the expected Item');
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 10');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c, 'Amount should be 20000 (Quantity * Unit Price)');
		try {
			shipmentLine.dmpl__Quantity__c = 20;
			update shipmentLine;
		} catch(Exception e) {
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(20, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 20');
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(40000, shipmentLine.dmpl__Amount__c, 'Amount should be 40000 (Quantity * Unit Price)');
		Test.stopTest();
	}
    
    @isTest
    static void createShipmentShipmentLinesGoodsReceiptGoodsReceiptLinesBillReturnBillReturnLine() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        shipmentLine.dmpl__Quantity__c = 20;
        update shipmentLine;
        updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(20, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(20, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner.Id,
            supplier.Id,
            branch.Id,
            purchaseOrder.Id,
            shipment.Id
        );
        dmpl__GoodsReceipt__c updatedGoodReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        System.assertEquals(partner.Id, updatedGoodReceipt.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedGoodReceipt.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(purchaseOrder.Id, updatedGoodReceipt.dmpl__PurchaseOrderId__c, 'Purchase Order Id should match.');
        System.assertEquals(shipment.Id, updatedGoodReceipt.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(supplier.Id, updatedGoodReceipt.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        dmpl__GoodsReceiptLine__c goodReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodReceipt.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__GoodsReceiptLine__c updatedGoodReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodReceiptLine.Id);
        System.assertEquals(item.Id, updatedGoodReceiptLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedGoodReceiptLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(null, updatedGoodReceiptLine.dmpl__SupplierQuantity__c, 'Supplier Quantity should match');
        System.assertEquals(goodReceipt.Id, updatedGoodReceiptLine.dmpl__GoodsReceiptId__c, 'Good Receipt ID should match');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should match.');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__ShortageQuantity__c, 'Shortage quantity should match');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__DamagedQuantity__c, 'Damage quantity should be 0.');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier.Id,
            partner.Id,
            branch.Id,
            goodReceipt.Id,
            purchaseOrder.Id
        );
        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
        System.assertEquals(partner.Id, updatedBillReturn.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedBillReturn.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(purchaseOrder.Id, updatedBillReturn.dmpl__PurchaseOrderId__c, 'Purchase Order Id should match.');
        System.assertEquals(goodReceipt.Id, updatedBillReturn.dmpl__GoodsReceiptId__c, 'Good Receipt ID should match');
        System.assertEquals(supplier.Id, updatedBillReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
        dmpl__BillReturnLine__c updatedBillReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, updatedBillReturnLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedBillReturnLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(0, updatedBillReturnLine.dmpl__Amount__c, 'Amount should match.');
        System.assertEquals(billReturn.Id, updatedBillReturnLine.dmpl__BillReturnId__c, 'Good Receipt ID should match');
        System.assertEquals(0, updatedBillReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 10.');
        System.assertEquals(0, updatedBillReturnLine.dmpl__BaseAmount__c, 'Base Amount should match to be 0.');
        System.assertEquals(null, updatedBillReturnLine.dmpl__UnitCost__c, 'Unit Cost should be 2000.');
        Test.stopTest();
    }

    @isTest
    static void shipmentCreatedWithInvalidPartnerAccountAndBranchNegative() {
        Boolean exceptionThrown = false;
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        try {
            Test.startTest();
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The specified Branch is not active!'), 'Unexpected exception message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for invalid partner account and branch.');
    }

    @isTest
    static void shipmentCreatedWithValidPartnerAccountAndBranch() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        Test.stopTest();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    static void shipmentLinesWithInvalidOrInactiveItem () {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                shipment.Id,
                item2.Id,
                sku.Id,
                20
            );
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('SKU you selected is not valid for the selected Item!'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive item or other validation.');
    }

    @isTest
    static void shipmentShipmentLinesGoodsReceiptGoodsReceiptLinesBillReturnWithNoBillReturnLine() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        Test.stopTest();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), shipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(Date.today(), shipment.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner.Id,
            supplier.Id,
            branch.Id,
            purchaseOrder.Id,
            shipment.Id
        );
        dmpl__GoodsReceipt__c updatedGoodReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        System.assertEquals(partner.Id, updatedGoodReceipt.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedGoodReceipt.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(purchaseOrder.Id, updatedGoodReceipt.dmpl__PurchaseOrderId__c, 'Purchase Order Id should match.');
        System.assertEquals(shipment.Id, updatedGoodReceipt.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(supplier.Id, updatedGoodReceipt.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        dmpl__GoodsReceiptLine__c goodReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodReceipt.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__GoodsReceiptLine__c updatedGoodReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodReceiptLine.Id);
        System.assertEquals(item.Id, updatedGoodReceiptLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedGoodReceiptLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(null, updatedGoodReceiptLine.dmpl__SupplierQuantity__c, 'Supplier Quantity should match');
        System.assertEquals(goodReceipt.Id, updatedGoodReceiptLine.dmpl__GoodsReceiptId__c, 'Good Receipt ID should match');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should match.');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__ShortageQuantity__c, 'Shortage quantity should match');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__DamagedQuantity__c, 'Damage quantity should be 0.');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier.Id,
            partner.Id,
            branch.Id,
            goodReceipt.Id,
            purchaseOrder.Id
        );
        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
        System.assertEquals(partner.Id, updatedBillReturn.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedBillReturn.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(purchaseOrder.Id, updatedBillReturn.dmpl__PurchaseOrderId__c, 'Purchase Order Id should match.');
        System.assertEquals(goodReceipt.Id, updatedBillReturn.dmpl__GoodsReceiptId__c, 'Good Receipt ID should match');
        System.assertEquals(supplier.Id, updatedBillReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        Boolean exceptionThrown = false;
        try {
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(null, item.Id, sku.Id);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Required fields are missing'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown while creating Bill Return Line.');
    }

    @isTest
    static void shipmentShipmentLineGoodsReceiptGoodsReceiptLineWithValidDetails() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        System.assertEquals(partner.Id, updatedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), updatedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(Date.today(), updatedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            null,
            1
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(null, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(1, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(1, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        shipmentLine.dmpl__Quantity__c = 2;
        update shipmentLine;
        updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);        
        System.assertEquals(2, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(2, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner.Id,
            supplier.Id,
            branch.Id,
            purchaseOrder.Id,
            shipment.Id
        );
        dmpl__GoodsReceipt__c updatedGoodReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        System.assertEquals(partner.Id, updatedGoodReceipt.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedGoodReceipt.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(purchaseOrder.Id, updatedGoodReceipt.dmpl__PurchaseOrderId__c, 'Purchase Order Id should match.');
        System.assertEquals(shipment.Id, updatedGoodReceipt.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(supplier.Id, updatedGoodReceipt.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        dmpl__GoodsReceiptLine__c goodReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodReceipt.Id,
            item.Id,
            null,
            2
        );
        goodReceiptLine.dmpl__DamagedQuantity__c = 0;
        update goodReceiptLine;
        dmpl__GoodsReceiptLine__c updatedGoodReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodReceiptLine.Id);
        System.assertEquals(item.Id, updatedGoodReceiptLine.dmpl__ItemId__c, 'Item ID should match');
        //System.assertEquals(sku.Id, updatedGoodReceiptLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(goodReceipt.Id, updatedGoodReceiptLine.dmpl__GoodsReceiptId__c, 'Good Receipt ID should match');
        System.assertEquals(0, updatedGoodReceiptLine.dmpl__DamagedQuantity__c, 'Damage quantity should be 0.');
        goodReceiptLine.dmpl__DamagedQuantity__c = 2;
        update goodReceiptLine;
        updatedGoodReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodReceiptLine.Id);
        System.assertEquals(2, updatedGoodReceiptLine.dmpl__DamagedQuantity__c, 'Damage quantity should be 2.');
        System.assertEquals(4, updatedGoodReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable quantity should be 2.');
        goodReceipt.dmpl__PerformReceive__c = true;
        goodReceipt.dmpl__Status__c = 'Receive';
        update goodReceipt;
        dmpl__InventoryStock__c stock = [SELECT Id, dmpl__QuantityAvailable__c, dmpl__QuantityOnAllocation__c, dmpl__ItemId__c FROM dmpl__InventoryStock__c LIMIT 1];
        System.debug('ggg' + stock);
        System.debug(item);
        Test.stopTest();
    }

    @isTest
    static void shipmentNotCreatedWithInvalidPartnerAccountAndBranchNegative() {
        Boolean exceptionThrown = false;
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        try {
            Test.startTest();
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The specified Branch is not valid!'), 'Unexpected exception message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for invalid partner account and branch.');
    }

    @isTest
    static void shipmentNotCreatedWithInactivePartnerAccountAndBranchNegative() {
        Boolean exceptionThrown = false;
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        try {
            Test.startTest();
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The specified Branch is not active!'), 'Unexpected exception message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for invalid partner account and branch.');
    }

    @isTest
    static void shipmentShipmentLinesCreatedWithGoodsReceiptHavingInvalidPartnerAndBranch() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), shipment.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        Account supplier2 = TestDataHelpers.createSupplierAccount('Supplier 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id);
        partner2.dmpl__IsActive__c= false;
        update partner2;
        Boolean exceptionThrown = false;
        try {
            dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner2.Id,
                supplier2.Id,
                branch2.Id,
                purchaseOrder.Id,
                shipment.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The partner account is not active!'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown while creating Goods Receipt.');
        Test.stopTest();
    }

    @isTest
    static void shipmentShipmentLineGoodsReceiptWithInvalidGoodsReceiptLine() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        Test.stopTest();
        System.assertEquals(partner.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), shipment.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            sku.Id,
            10
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(10, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner.Id,
            supplier.Id,
            branch.Id,
            null,
            null
        );
        dmpl__GoodsReceipt__c updatedGoodReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        System.assertEquals(partner.Id, updatedGoodReceipt.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, updatedGoodReceipt.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(supplier.Id, updatedGoodReceipt.dmpl__SupplierAccountId__c, 'Supplier Account Id should match');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        Boolean exceptionThrown = false;
        try {
            dmpl__GoodsReceiptLine__c goodReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
                goodReceipt.Id,
                item2.Id,
                sku.Id,
                null
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The SKU you selected is not valid for the selected Item!'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown while creating Goods Receipt Line.');
    }

    @isTest
    static void shipmentShipmentLinesGoodsReceiptWithInvalidPartnerAndBranch() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        System.assertEquals(partner.Id, updatedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), updatedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            sku.Id,
            1
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertNotEquals(null, updatedShipMentLine, 'Shipment Line should be created successfully');
        System.assertEquals(item.Id, updatedShipMentLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku.Id, updatedShipMentLine.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(1, updatedShipMentLine.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(1, updatedShipMentLine.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 8', 'Product');
        item2.dmpl__IsSKURequired__c = true;
        update item2;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item2.Id, true);
        dmpl__ShipmentLine__c shipmentLine2 = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item2.Id,
            sku2.Id,
            1
        );
        dmpl__ShipmentLine__c updatedShipMentLine2 = ShipmentTestDataHelper.getShipmentLine(shipmentLine2.Id);
        System.assertNotEquals(null, updatedShipMentLine2, 'Shipment Line should be created successfully');
        System.assertEquals(item2.Id, updatedShipMentLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku2.Id, updatedShipMentLine2.dmpl__SKUId__c, 'SKU ID should match');
        System.assertEquals(1, updatedShipMentLine2.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine2.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(1, updatedShipMentLine2.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine2.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        shipmentLine2.dmpl__Quantity__c = 2;
        update shipmentLine2;
        updatedShipMentLine2 = ShipmentTestDataHelper.getShipmentLine(shipmentLine2.Id);
        System.assertEquals(2, updatedShipMentLine2.dmpl__Quantity__c, 'Quantity should match to be 10');
        System.assertEquals(shipment.Id, updatedShipMentLine2.dmpl__ShipmentId__c, 'Shipment ID should match');
        System.assertEquals(2, updatedShipMentLine2.dmpl__PendingQuantity__c, 'Pending Quantity should be 0 after creation');
        System.assertEquals(0, updatedShipMentLine2.dmpl__Amount__c, 'Amount should be 0 as it is not set during creation');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 3', partner2.Id);
        Boolean exceptionThrown = false;
        try {
            dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner.Id,
                supplier.Id,
                branch2.Id,
                purchaseOrder.Id,
                shipment.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('The specified Branch is not valid!'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown while creating Goods Receipt.');
        Test.stopTest();
    }

    @isTest
    static void shipmentShipmentLinesWithInactiveItemGoodReceiptWithInvalidPartnerAccount () {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 8', 'Product');
        item2.dmpl__IsSKURequired__c = true;
        update item2;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2', item2.Id, true);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        System.assertEquals(partner.Id, updatedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), updatedShipment.dmpl__DocumentDate__c, 'Document Date should match');       
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                shipment.Id,
                item.Id,
                sku.Id,
                1
            );
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('SKU you selected is not valid for the selected Item!'), 'Unexpected error message: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive item or other validation.');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 3', partner2.Id);
        try {
            dmpl__GoodsReceipt__c goodReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner.Id,
                supplier.Id,
                branch2.Id,
                purchaseOrder.Id,
                shipment.Id
            );
        } catch (Exception e) {
            System.assert(e.getMessage().contains('The specified Branch is not valid!'), 'Unexpected error message: ' + e.getMessage());
        }
    }
}