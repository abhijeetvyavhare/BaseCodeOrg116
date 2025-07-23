@isTest
public with sharing class PurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        priceList.dmpl__PriceListType__c = 'Purchase Price';
        update priceList;
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 28', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 14);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            20
        );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner, 
            branch, 
            purchaseOrder, 
            supplier
        );
    }

    @isTest
    static void createPurchaseOrderPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'Expected purchaseOrder to be created.');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should be null.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should be null.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should be null.');
    }

    @isTest
    static void updatePurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        purchaseOrder.dmpl__Status__c = 'Pending Approval';
        update purchaseOrder;
        dmpl__PurchaseOrder__c updatePurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals('Pending Approval', updatePurchaseOrder.dmpl__Status__c, 'Status should be Pending Approval.');
    }

    @isTest
    static void deletePurchaseOrder() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before delete.');
        delete purchaseOrder;
        dmpl__PurchaseOrder__c deletedOrder = null;
        try {
            deletedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'PurchaseOrder should be deleted and not found in query.');
    }

    @isTest
    static void createPurchaseOrderLinePositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(item.Id, updatedPurchaseOrderLine.dmpl__ItemId__c, 'ItemId should match.');
        System.assertEquals(taxGroupGST28.Id, updatedPurchaseOrderLine.dmpl__TaxGroupId__c, 'TaxGroupId should match.');
        System.assertEquals(20, updatedPurchaseOrderLine.dmpl__Quantity__c, 'Quantity should be 20.');
        System.assertEquals(1500, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit cost should be 1500.');
        System.assertEquals(4200, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(4200, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(30000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'BaseAmount should be 30000');
        System.assertEquals(8400, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'TaxAmount should be 8400');
        System.assertEquals(38400, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'GrossAmount should be 38400');
    }

    @isTest
    static void updatePurchaseOrderLinePositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);        
        purchaseOrderLine.dmpl__Quantity__c = 30;
        update purchaseOrderLine;
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(30, updatedPurchaseOrderLine.dmpl__Quantity__c, 'Quantity should be 30.');
        System.assertEquals(1500, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit cost should be 1500.');
        System.assertEquals(6300, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 should be 6300');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(6300, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 should be 6300');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(45000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'BaseAmount should be 45000');
        System.assertEquals(12600, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'TaxAmount should be 12600');
        System.assertEquals(57600.00, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'GrossAmount should be 57600.00');
    }

    @isTest
    static void deletePurchaseOrderLine() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        System.assertNotEquals(purchaseOrderLine, null, 'PurchaseOrderLine should exist before delete.');
        delete purchaseOrderLine;
        dmpl__PurchaseOrderLine__c deletedPOL = null;
        try {
            deletedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        } catch (Exception e) {
            deletedPOL = null;
        }
        System.assertEquals(null, deletedPOL, 'PurchaseOrderLine should be deleted and not found in query.');
    }

    @isTest
    static void purchaseOrderCreationWithInActiveSupplierAccEdit() {
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        Account supplier2 = TestDataHelpers.createSupplierAccount('Supplier 2');
        supplier2.dmpl__IsActive__c = false;
        update supplier2;
        purchaseOrder.dmpl__SupplierAccountId__c = supplier2.Id;
        try {
            update purchaseOrder;
            System.assert(false, 'Expected DmlException due to lookup filter on Supplier Account.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Value does not exist or does not match filter criteria'), 'Expected lookup filter error. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithNoEnteredQuantityNew() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.CreateItem('Item 3', 'Charge Item');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('price List 1');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 1500);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                purchaseOrder.Id, 
                item.Id, 
                null, 
                null
            );
            System.assert(false, 'Expected DmlException due to missing quantity.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') || e.getMessage().contains('Quantity'), 'Expected validation error for missing quantity. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createRequisitionLineWithZeroQuantity() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(partner.Id, branch.Id, supplier.Id);
        try {
            dmpl__PurchaseRequisitionLine__c line = PurchaseOrderTestDataHelpers.createPurchaseRequisitionLine(
                requisition.Id, 
                item.Id, 
                0
            );
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]'), 
                'Expected validation error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void requisitionLineWithZeroQuantityEdit() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(partnerAccount1.Id, branch1.Id, supplier1.Id);
        try {
            dmpl__PurchaseRequisitionLine__c line = PurchaseOrderTestDataHelpers.createPurchaseRequisitionLine(
                requisition.Id, 
                item.Id, 
                20
            );
            line.dmpl__Quantity__c = 0;
            update line;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]'), 'Expected validation error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithEnteredQuantityNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.purchaseOrderLineWithEnteredQuantityNew(partner.Id, branch.Id, priceList.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            10
        );
        Test.stopTest();
        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, insertedLine.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(4200, insertedLine.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, insertedLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(4200, insertedLine.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, insertedLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(30000, insertedLine.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, insertedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, insertedLine.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, insertedLine.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(50000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 50000');
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedPO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(10800, updatedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 10800');
        System.assertEquals(60800, updatedPO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 60800');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void purchaseOrderCreationWithInactiveBranchNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        try {
            dmpl__PurchaseOrder__c poWithInactiveBranch = PurchaseOrderTestDataHelpers.createPurchaseOrder(
                supplier.Id, 
                partner.Id, 
                branch3.Id
            );
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Branch is not active'), 'Expected inactive branch validation');
        }    
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithZeroQuantity() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.purchaseOrderLineWithEnteredQuantityNew(partner.Id, branch.Id, priceList.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        try {
            dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                purchaseOrder.Id, 
                item.Id, 
                taxGroup.Id, 
                0
            );
            System.assert(false, 'Expected exception for zero quantity but none was thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The input field dmpl__Quantity__c expects postive decimals!'), 'Expected validation error for zero quantity');
        }
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithDiscontinuedItem() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.purchaseOrderLineWithDiscontinuedItemData(partner.Id, branch.Id, priceList.Id);
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 3');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            activeItem.Id, 
            taxGroup.Id, 
            20
        );
        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__PurchaseOrder__c updatedPo = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, insertedLine.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(4200, insertedLine.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, insertedLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(4200, insertedLine.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, insertedLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(30000, insertedLine.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, insertedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, insertedLine.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, insertedLine.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(70000, updatedPo.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 70000');
        System.assertEquals(0, updatedPo.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedPo.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(13200, updatedPo.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 13200');
        System.assertEquals(83200, updatedPo.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 83200');
        System.assertEquals('Draft', updatedPo.dmpl__Status__c, 'Status should be Draft');
        dmpl__PurchaseOrderLine__c pol2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            inactiveItem.Id, 
            taxGroup.Id, 
            20
        );
        dmpl__PurchaseOrder__c poFetched = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(90000, poFetched.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 90000');
        System.assertEquals(0, poFetched.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, poFetched.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(15600, poFetched.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 15600');
        System.assertEquals(105600, poFetched.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 105600');
        System.assertEquals('Draft', poFetched.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void createPurchaseOrderLineWithAndWithoutPriceEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1'); 
        PurchaseOrderMasterData.purchaseOrderLineWithAndWithouPriceData(
            priceList.Id, 
            partner.Id, 
            branch.Id, 
            item1.Id
        );
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine1 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item1.Id, 
            taxGroup.Id, 
            10
        );
        purchaseOrderLine1 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, purchaseOrderLine1.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(4200, purchaseOrderLine1.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', purchaseOrderLine1.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, purchaseOrderLine1.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', purchaseOrderLine1.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(4200, purchaseOrderLine1.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', purchaseOrderLine1.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, purchaseOrderLine1.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', purchaseOrderLine1.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(30000, purchaseOrderLine1.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, purchaseOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, purchaseOrderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, purchaseOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, purchaseOrderLine1.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(45000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 45000');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(12600, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 12600');
        System.assertEquals(57600, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 57600');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft');
        delete  purchaseOrderLine1;
        dmpl__PurchaseOrderLine__c purchaseOrderLine2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item5.Id, 
            taxGroup.Id, 
            10
        );
        purchaseOrderLine2 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, purchaseOrderLine2.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(2100, purchaseOrderLine2.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals('CGST', purchaseOrderLine2.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, purchaseOrderLine2.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', purchaseOrderLine2.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(2100, purchaseOrderLine2.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals('SGST', purchaseOrderLine2.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, purchaseOrderLine2.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', purchaseOrderLine2.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(15000, purchaseOrderLine2.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, purchaseOrderLine2.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, purchaseOrderLine2.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, purchaseOrderLine2.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, purchaseOrderLine2.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        System.assertEquals(15000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 15000');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(4200, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 12600');
        System.assertEquals(19200, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 19200');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void createPurchaseOrderSchemeNotAppliedDueToExceedingBudgetEdit() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        PurchaseOrderMasterData.purchaseOrderSchemeNotAppliedDueToExceedingBudgetEdit(partnerAccount.Id, branch.Id, item.Id);
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            14
        );
        purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, purchaseOrderLine.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(4200, purchaseOrderLine.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(4200, purchaseOrderLine.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(30000, purchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, purchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, purchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, purchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, purchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(51000, purchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 51000');
        System.assertEquals(0, purchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, purchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(14280, purchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 14280');
        System.assertEquals(65280, purchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 65280');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        purchaseOrderLine.dmpl__Quantity__c = 10;
        update purchaseOrderLine;
        purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(1500, purchaseOrderLine.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(2100, purchaseOrderLine.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(2100, purchaseOrderLine.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(15000, purchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, purchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, purchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, purchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, purchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        System.assertEquals(36000, purchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 36000');
        System.assertEquals(0, purchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, purchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(10080, purchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 10080');
        System.assertEquals(46080, purchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 46080');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithSkuRequiredNegative() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c validItem = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup28 = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.purchaseOrderLineWithSkuRequiredData(
            partner.Id, 
            branch.Id, 
            priceList.Id, 
            validItem.Id
        );
        dmpl__Item__c itemRequiringSku = TestDataHelpers.getItem('Item 9'); 
        dmpl__TaxGroup__c taxGroup12 = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        Boolean exceptionThrown = false;
        try {
            dmpl__PurchaseOrderLine__c invalidPOL = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                purchaseOrder.Id, 
                itemRequiringSku.Id, 
                taxGroup12.Id, 
                10
            );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('mandates selection of SKU'), 'Expected SKU validation error.');
        }
        dmpl__PurchaseOrderLine__c validPOL = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            validItem.Id, 
            taxGroup28.Id, 
            10
        );
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for item without SKU.');
        dmpl__PurchaseOrderLine__c insertedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(validItem.Id, insertedPOL.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, insertedPOL.dmpl__UnitCost__c, 'Unit price should be 1500');
        System.assertEquals(2016, insertedPOL.dmpl__Tax1__c, 'Tax1 should be 2016');
        System.assertEquals('CGST', insertedPOL.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, insertedPOL.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', insertedPOL.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(2016, insertedPOL.dmpl__Tax2__c, 'Tax2 should be 2016');
        System.assertEquals('SGST', insertedPOL.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, insertedPOL.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', insertedPOL.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(15000, insertedPOL.dmpl__BaseAmount__c, 'BaseAmount should be 15000');
        System.assertEquals(600, insertedPOL.dmpl__NetDiscount__c, 'NetDiscount should be 600');
        System.assertEquals(4032, insertedPOL.dmpl__TaxAmount__c, 'TaxAmount should be 4032');
        System.assertEquals(18432, insertedPOL.dmpl__GrossAmount__c, 'GrossAmount should be 18432');
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(15000, updatedPO.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(600, updatedPO.dmpl__TotalDiscountAmount__c, 'Total discount amount should be 600');
        System.assertEquals(4032, updatedPO.dmpl__TotalTaxAmount__c, 'Total tax amount should be 4032');
        System.assertEquals(18432, updatedPO.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 18432');
        System.assertEquals(18432, updatedPO.dmpl__TotalOrderAmount__c, 'Total order amount should be 18432');
        System.assertEquals(Date.today(), updatedPO.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void taxApplicationObjectModelInlineTaxEdit() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        PurchaseOrderMasterData.taxApplicationObjectModelInlineTaxData(partner.Id, branch.Id, item.Id);
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            3
        );
        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(1500, insertedLine.dmpl__UnitCost__c, 'UnitCost should be 1500');
        System.assertEquals(604.80, insertedLine.dmpl__Tax1__c, 'Tax1 should be 604.80');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(14, insertedLine.dmpl__Tax1Rate__c, 'Tax1Rate should be 14');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(604.80, insertedLine.dmpl__Tax2__c, 'Tax2 should be 604.80');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(14, insertedLine.dmpl__Tax2Rate__c, 'Tax2Rate should be 14');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(4500, insertedLine.dmpl__BaseAmount__c, 'Base Amount should be 4500');
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(180, insertedLine.dmpl__NetDiscount__c, 'Net Discount should be 180');
        System.assertEquals(1209.60, insertedLine.dmpl__TaxAmount__c, 'Tax Amount should be 1209.60');
        System.assertEquals(5529.60, insertedLine.dmpl__GrossAmount__c, 'Gross Amount should be 5529.60');
        dmpl__PurchaseOrder__c updatedPO1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(4500, updatedPO1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 4500');
        System.assertEquals(0, updatedPO1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(180, updatedPO1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 180');
        System.assertEquals(1209.60, updatedPO1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 1209.60');
        System.assertEquals(5529.60, updatedPO1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 5529.60');
        System.assertEquals(5530, updatedPO1.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 5530');
        System.assertEquals(Date.today(), updatedPO1.dmpl__DocumentDate__c, 'DocumentDate should be today');
        System.assertEquals('Draft', updatedPO1.dmpl__Status__c, 'Status should be Draft');
        insertedLine.dmpl__Quantity__c = 10;
        update insertedLine;
        dmpl__PurchaseOrderLine__c updatedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(1500, updatedLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(2016, updatedLine.dmpl__Tax1__c, 'Tax 1 should be 2016');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Name__c, 'Tax 1 Name should be CGST');
        System.assertEquals(14, updatedLine.dmpl__Tax1Rate__c, 'Tax 1 Rate should be 14');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Type__c, 'Tax 1 Type should be CGST');
        System.assertEquals(2016, updatedLine.dmpl__Tax2__c, 'Tax 2 should be 2016');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Name__c, 'Tax 2 Name should be SGST');
        System.assertEquals(14, updatedLine.dmpl__Tax2Rate__c, 'Tax 2 Rate should be 14');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Type__c, 'Tax 2 Type should be SGST');
        System.assertEquals(15000, updatedLine.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, updatedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(600, updatedLine.dmpl__NetDiscount__c, 'Net Discount should be 600');
        System.assertEquals(4032, updatedLine.dmpl__TaxAmount__c, 'Tax Amount should be 4032');
        System.assertEquals(18432, updatedLine.dmpl__GrossAmount__c, 'Gross Amount should be 18432');
        dmpl__PurchaseOrder__c updatedPO2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(15000, updatedPO2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 15000');
        System.assertEquals(0, updatedPO2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(600, updatedPO2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 600');
        System.assertEquals(4032, updatedPO2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 4032');
        System.assertEquals(18432, updatedPO2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 18432');
        System.assertEquals(18432, updatedPO2.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 18432');
        System.assertEquals(Date.today(), updatedPO2.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', updatedPO2.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseOfSchemeNotApprovedEditNegative() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderMasterData.purchaseOrderLineWithQuantity(supplier.Id);
        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(2000, pol.dmpl__UnitCost__c, 'Unit cost should be 2000');
        System.assertEquals(600, pol.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals('CGST', pol.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(6, pol.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals('CGST', pol.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(600, pol.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals('SGST', pol.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(6, pol.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals('SGST', pol.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(10000, pol.dmpl__BaseAmount__c, 'Base amount should be 10000');
        System.assertEquals(0, pol.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, pol.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1200, pol.dmpl__TaxAmount__c, 'Tax amount should be 1200');
        System.assertEquals(11200, pol.dmpl__GrossAmount__c, 'Gross amount should be 11200');
        System.assertEquals(null, pol.dmpl__SchemeLineId__c, 'SchemeLineId should be null');
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(10000, purchaseOrder.dmpl__TotalLineBaseAmount__c, 'PO total base amount should be 10000');
        System.assertEquals(0, purchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'PO scheme discount should be 0');
        System.assertEquals(0, purchaseOrder.dmpl__TotalDiscountAmount__c, 'PO discount should be 0');
        System.assertEquals(1200, purchaseOrder.dmpl__TotalTaxAmount__c, 'PO tax amount should be 1200');
        System.assertEquals(11200, purchaseOrder.dmpl__TotalOrderAmount__c, 'PO total order amount should be 11200');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'PO status should be Draft');
        pol.dmpl__Quantity__c = 10;
        update pol;
        dmpl__PurchaseOrderLine__c updatedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(2000, updatedPOL.dmpl__UnitCost__c, 'Updated unit cost should be 2000');
        System.assertEquals(1200, updatedPOL.dmpl__Tax1__c, 'Updated Tax1 amount should be 1200');
        System.assertEquals('CGST', updatedPOL.dmpl__Tax1Name__c, 'Updated Tax1 name should be CGST');
        System.assertEquals(6, updatedPOL.dmpl__Tax1Rate__c, 'Updated Tax1 rate should be 6');
        System.assertEquals('CGST', updatedPOL.dmpl__Tax1Type__c, 'Updated Tax1 type should be CGST');
        System.assertEquals(1200, updatedPOL.dmpl__Tax2__c, 'Updated Tax2 amount should be 1200');
        System.assertEquals('SGST', updatedPOL.dmpl__Tax2Name__c, 'Updated Tax2 name should be SGST');
        System.assertEquals(6, updatedPOL.dmpl__Tax2Rate__c, 'Updated Tax2 rate should be 6');
        System.assertEquals('SGST', updatedPOL.dmpl__Tax2Type__c, 'Updated Tax2 type should be SGST');
        System.assertEquals(20000, updatedPOL.dmpl__BaseAmount__c, 'Updated base amount should be 20000');
        System.assertEquals(0, updatedPOL.dmpl__NetSchemeDiscount__c, 'Updated net scheme discount should be 0');
        System.assertEquals(0, updatedPOL.dmpl__NetDiscount__c, 'Updated net discount should be 0');
        System.assertEquals(2400, updatedPOL.dmpl__TaxAmount__c, 'Updated tax amount should be 2400');
        System.assertEquals(22400, updatedPOL.dmpl__GrossAmount__c, 'Updated gross amount should be 22400');
        System.assertEquals(null, updatedPOL.dmpl__SchemeLineId__c, 'Updated SchemeLineId should be null');
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(20000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Updated PO total base amount should be 20000');
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Updated PO scheme discount should be 0');
        System.assertEquals(0, updatedPO.dmpl__TotalDiscountAmount__c, 'Updated PO discount should be 0');
        System.assertEquals(2400, updatedPO.dmpl__TotalTaxAmount__c, 'Updated PO total tax should be 2400');
        System.assertEquals(22400, updatedPO.dmpl__TotalOrderAmount__c, 'Updated PO total order amount should be 22400');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Updated PO status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithEnteredQuantityEditPositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderMasterData.purchaseOrderLineWithQuantity(supplier.Id);
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1200, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(11200, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11200');
        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10000, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10000.');
        System.assertEquals(11200, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11200.');
        System.assertEquals(1200, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1200.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');
        createdPurchaseOrderLine.dmpl__Quantity__c = 10;
        update createdPurchaseOrderLine;
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1200, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 1200');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(1200, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 1200');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(2400, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 2400');
        System.assertEquals(20000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(22400, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 22400');
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, updatedPurchaseOrder, 'Expected purchase order to be found after updating purchase order line.');
        System.assertEquals(20000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 20000.');
        System.assertEquals(22400, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 22400.');
        System.assertEquals(2400, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should be 2400.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0.');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(System.today(), updatedPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should remain today.');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityWhenUnavailabilityofBudgetEditNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.schemeApplicabilityUnavailabilityofBudgetData(
            supplier.Id, 
            branch.Id, 
            partner.Id, 
            priceList.Id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 12');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            7
        );
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 1500.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(420, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 420');
        System.assertEquals(604.8, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 604.8');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(604.8, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 604.8');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1209.6, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1209.6');
        System.assertEquals(10500, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10500');
        System.assertEquals(11289.6, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11289.6');
        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10500, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10500.');
        System.assertEquals(11289.6, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11289.6.');
        System.assertEquals(1209.6, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1209.6.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0.');
        System.assertEquals(420, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 420.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');
        createdPurchaseOrderLine.dmpl__Quantity__c = 14;
        update createdPurchaseOrderLine;
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 1500.');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1209.6, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 1209.6');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(1209.6, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 1209.6');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(2419.2, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 2419.2');
        System.assertEquals(21000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 21000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(840, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 840');
        System.assertEquals(22579.2, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 22579.2');
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, updatedPurchaseOrder, 'Expected purchase order to be found after updating purchase order line.');
        System.assertEquals(21000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 21000.');
        System.assertEquals(22579.2, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 22579.2.');
        System.assertEquals(2419.2, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should be 2419.2.');
        System.assertEquals(2419.2, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2419.2.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0.');
        System.assertEquals(840, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 840.');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft after updating purchase order line.');
        System.assertEquals(System.today(), updatedPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should remain today.');
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithZeroQuantityEditNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderMasterData.purchaseOrderLineWithQuantity(supplier.Id);
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1200, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(11200, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11200');
        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10000, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10000.');
        System.assertEquals(11200, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11200.');
        System.assertEquals(1200, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1200.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');
        try {
            createdPurchaseOrderLine.dmpl__Quantity__c = 0;
            update createdPurchaseOrderLine;
            System.assert(false, 'Expected an exception due to zero quantity.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('The input field dmpl__Quantity__c expects postive decimals'), 'Expected exception for zero quantity: ' + e.getMessage());
        }
        Test.stopTest();
    }  
    @isTest
    static void purchaseOrderLineWithItemWithoutTaxGroupEditPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        PurchaseOrderMasterData.purchaseOrderLineWithItemWithoutTaxGroup(priceList.Id, partner.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            null, 
            20
        );
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(40000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1600, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(40000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 40000');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(1600, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1600');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(38400, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        purchaseOrderLine.dmpl__Quantity__c = 5;
        update purchaseOrderLine;
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000.00, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(400, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 400');
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(10000, purchaseOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(400, purchaseOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 400');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(9600, purchaseOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 9600');
        System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'Status should be Draft.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithInValidBranchNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner2.Id);
        partner2.dmpl__IsActive__c = false;
        update partner2;
        dmpl__PurchaseOrder__c purchaseOrder;
        try {
            purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        } catch (Exception e) {
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        }
        Test.stopTest();
    }
    
    @isTest 
    static void createPurchaseOrderWithActiveItemAndQuantityPositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            null, 
            20
        );
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptPositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner, 
            branch, 
            purchaseOrder, 
            supplier
        );
        System.assertNotEquals(null, goodsReceipt, 'Good Receipt must be created!');
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithInActivePartnerNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__PurchaseOrder__c purchaseOrder;
        try {
            purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        } catch (Exception e) {
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        }
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithInActiveItemAndQuantityNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        try {
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                purchaseOrder.Id, 
                item.Id, 
                null, 
                0
            );
            System.Assert(purchaseOrderLine == null, 'Must Not to be Created with Inactive Item');
        } catch (Exception e) {
            System.Assert(purchaseOrderLine == null, 'Must Not to be Created with Inactive Item');
        }
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithPurchaseOrderLineInValidItemNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 9', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8', 'Product');
        item8.dmpl__IsSKURequired__c = true;
        update item8;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2', item8.Id, false);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        try {
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                item, 
                sku, 
                purchaseOrder, 
                null, 
                10
            );
            System.Assert(purchaseOrderLine == null, 'Must Not to be Created with Inactive Item');
        } catch (Exception e) {
            System.Assert(purchaseOrderLine == null, 'Must Not to be Created with Inactive Item');
        }
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Account supplier2 = TestDataHelpers.createSupplierAccount('Supplier 2');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner2.dmpl__IsActive__c = false;
        update partner2;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__GoodsReceipt__c goodsReceipt;
        dmpl__GoodsReceiptLine__c goodsReceiptLine;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner2, 
                branch2, 
                purchaseOrder, 
                supplier2
            );
            goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, null);
            System.Assert(goodsReceipt == null, 'Good Receipt Should not get created');
            System.Assert(goodsReceiptLine == null, 'Good Receipt Line Should not get created');
        } catch (Exception e) {
            System.Assert(goodsReceipt == null, 'Good Receipt Should not get created' + e.getMessage());
            System.Assert(goodsReceiptLine == null, 'Good Receipt Line Should not get created' + e.getMessage());
        }
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptAndGoodReceiptLinePositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrder.Id);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, null);
        goodsReceiptLine.dmpl__OrderedQuantity__c = 10;
        goodsReceiptLine.dmpl__SupplierQuantity__c = 10;
        update goodsReceiptLine;
        System.assertNotEquals(null, goodsReceipt, 'Good Receipt must be created!');
        System.assertNotEquals(null, goodsReceiptLine, 'Good Receipt line must be created!');
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptAndGoodReceiptLineNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id, 
            item.Id, 
            null, 
            20
        );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine; 
        try {
            goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, null);
            goodsReceiptLine.dmpl__OrderedQuantity__c = 10;
            goodsReceiptLine.dmpl__SupplierQuantity__c = 0;
            update goodsReceiptLine;
            System.Assert(goodsReceiptLine == null, 'Good Receipt Line Should not get created');
        } catch (Exception e) {
            System.Assert(goodsReceiptLine == null, 'Good Receipt Line Should not get created' + e.getMessage());
        }
        System.assertNotEquals(null, goodsReceipt, 'Good Receipt must be created!');
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptGoodReceiptLineBillReturnAndBillReturnLinePositive() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        item7.dmpl__IsSKURequired__c = true;
        update item7;
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.Id, true);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10', 'Product');
        item10.dmpl__IsSKURequired__c = true;
        update item10;
        dmpl__SKU__c sku5 = TestDataHelpers.createSKU('SKU 5', item10.Id, false);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item7, 
            sku1, 
            purchaseOrder, 
            null, 
            10
        );
        dmpl__PurchaseOrderLine__c purchaseOrderLine2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item10, 
            sku5, 
            purchaseOrder, 
            null, 
            10
        );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item7, sku1);
        goodsReceiptLine.dmpl__SupplierQuantity__c = 10;
        update goodsReceiptLine;
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier.Id, 
            partner.Id, 
            branch.Id, 
            goodsReceipt.Id, 
            purchaseOrder.Id
        );
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item7.Id, sku1.Id);
        System.assertNotEquals(null, billReturn, 'Bill Return must be created!');
        System.assertNotEquals(null, billReturnLine, 'Bill Return Line must be created!');
        System.assertNotEquals(null, goodsReceipt, 'Good Receipt must be created!');
        System.assertNotEquals(null, goodsReceiptLine, 'Good Receipt Line must be created!');
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithGoodReceiptGoodReceiptLineBillReturnAndBillReturnLineNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item, 
            sku, 
            purchaseOrder, 
            null, 
            10
        );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        goodsReceiptLine.dmpl__SupplierQuantity__c = 10;
        update goodsReceiptLine;
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier.Id, 
            partner.Id, 
            branch.Id, 
            goodsReceipt.Id, 
            purchaseOrder.Id
        );
        dmpl__BillReturnLine__c billReturnLine;
        try {
            billReturnLine = BillTestDataHelpers.createBillReturnLine(null, item.Id, sku.Id);
            System.assertEquals(null, billReturnLine, 'Bill Return Line must not be created!');
        } catch (Exception e) {
            System.assertEquals(null, billReturnLine, 'Bill Return Line must not be created!');
        }
        System.assertNotEquals(null, billReturn, 'Bill Return must be created!');
        System.assertNotEquals(null, goodsReceiptLine, 'Good Receipt Line must be created!');
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(supplier.Id, purchaseOrder.dmpl__SupplierAccountId__c, 'Supplier Account Id should match.');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        Test.stopTest();
    }

    @isTest 
    static void createPurchaseOrderWithInValidPartnerNegative() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder;
        try {
            purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        } catch (Exception e) {
            System.AssertEquals(null, purchaseOrder, 'Purchase Order should not get Created.');
        }
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderWithValidPartnerAccountAndBranch(){
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku=TestDataHelpers.getSku('SKU 1');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            null,
            20
        );
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch, purchaseOrder);
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item,
            shipment,
            null,
            purchaseOrderLine
        );

          dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner, 
            branch, 
            purchaseOrder, 
            supplier
        );
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt.Id, item.Id, null);
        System.assertNotEquals(null, purchaseOrder, 'Purchase order must be created!');
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase order line must be created!');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should be null.');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should be null.');
        System.assertNotEquals(null, goodsReceipt, 'Good Receipt must be created!');
        System.assertNotEquals(null, goodsReceiptLine, 'Good Receipt line must be created!');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals(20, purchaseOrderLine.dmpl__Quantity__c, 'Quantity should be 20.');

        Test.stopTest();
    }
    
   @isTest
    static void endToEndPurchaseOrderFlowValidation() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c validBranch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c invalidBranch = TestDataHelpers.createBranch('Branch 2',partner.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(null, purchaseOrder, 'Purchase Order must be created!');
        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(validBranch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch Id should match.');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today.');
        Boolean invalidPOFailed = false;
        try {
        purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id,partner.Id,invalidBranch.Id);
        } catch (DmlException e) {
            invalidPOFailed = true;
        }
        System.assertEquals(true, invalidPOFailed, 'Purchase Order should not be created with invalid branch.');
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine, 'Purchase Order Line must be created.');
        System.assertEquals(item.Id, poLine.dmpl__ItemId__c, 'Item ID should match.');
        System.assertEquals(20, poLine.dmpl__Quantity__c, 'Quantity should be 20.');
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, validBranch, purchaseOrder);
        System.assertNotEquals(null, shipment, 'Shipment must be created.');
        System.assertEquals('Draft', shipment.dmpl__Status__c, 'Shipment status should be Draft.');
        System.assertEquals(validBranch.Id, shipment.dmpl__BranchId__c, 'Shipment Branch should match.');
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item,
            shipment,
            poLine,
            20
        );
        System.assertNotEquals(null, shipmentLine, 'Shipment Line must be created.');
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c, 'Shipment Line Item must match.');
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c, 'Shipment Line quantity must be 20.');
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID must match in Shipment Line.');
        shipmentLine.dmpl__Quantity__c = 10;
        update shipmentLine;
        shipmentLine =ShipmentTestDataHelper.getShipmentLine();
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c, 'Shipment Line quantity should be updated to 10.');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner,
            validBranch,
            purchaseOrder,
            supplier
        );
        System.assertNotEquals(null, goodsReceipt, 'Goods Receipt must be created.');
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'GR Partner Account must match.');
        System.assertEquals(validBranch.Id, goodsReceipt.dmpl__BranchId__c, 'GR Branch must match.');
        System.assertEquals('Draft', goodsReceipt.dmpl__Status__c, 'GR status must be Draft.');
        dmpl__GoodsReceiptLine__c grLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
            goodsReceipt.Id,
            item.Id,
            null
        );
        grLine.dmpl__OrderedQuantity__c = 10;
        grLine.dmpl__SupplierQuantity__c = 10;
        update grLine;
        grLine=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertEquals(10, grLine.dmpl__OrderedQuantity__c, 'Ordered Quantity must be 10.');
        System.assertEquals(10, grLine.dmpl__SupplierQuantity__c, 'Supplier Quantity must be 10.');
        Test.stopTest();
    }

    @isTest
   static void purchaseOrderFullFlowValidationWithEdgeCasesinvalidItemAndQuantity() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
        PurchaseOrderMasterData.purchaseOrderFullFlowValidationWithEdgeCasesinvalidItemAndQuantityData(partner1.Id);
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(null, po);
        System.assertEquals(partner1.Id, po.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, po.dmpl__BranchId__c);
        System.assertEquals('Draft', po.dmpl__Status__c);
        System.assertEquals(Date.today(), po.dmpl__DocumentDate__c);
        Boolean invalidPoLineFailed = false;
        try {
            dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            inactiveItem.Id,
            null,
            0
        );
        } catch (DmlException e) {
            invalidPoLineFailed = true;
        }
        System.assertEquals(true, invalidPoLineFailed);
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            activeItem.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine);
        System.assertEquals(20, poLine.dmpl__Quantity__c);
        System.assertEquals(activeItem.Id, poLine.dmpl__ItemId__c);
        Boolean invalidShipmentFailed = false;
        try {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch2, po);

        } catch (DmlException e) {
            invalidShipmentFailed = true;
        }
        System.assertEquals(true, invalidShipmentFailed);

        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch1, po);
        System.assertNotEquals(null, shipment);
        System.assertEquals(branch1.Id, shipment.dmpl__BranchId__c);
        System.assertEquals('Draft', shipment.dmpl__Status__c);

        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            activeItem,
            shipment,
            poLine,
            20
        );
        System.assertNotEquals(null, shipmentLine);
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(activeItem.Id, shipmentLine.dmpl__ItemId__c);
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c);
        shipmentLine.dmpl__Quantity__c = 10;
        update shipmentLine;
        shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c);
        dmpl__GoodsReceipt__c gr = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner1, branch1, po, supplier);
        System.assertNotEquals(null, gr);
        System.assertEquals('Draft', gr.dmpl__Status__c);
        System.assertEquals(branch1.Id, gr.dmpl__BranchId__c);
        System.assertEquals(partner1.Id, gr.dmpl__PartnerAccountId__c);
        dmpl__GoodsReceiptLine__c grLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
            gr.Id,
            activeItem.Id,
            null
        );
        grLine.dmpl__OrderedQuantity__c = 10;
        grLine.dmpl__SupplierQuantity__c = 10;
        update grLine;
        grLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertEquals(10, grLine.dmpl__OrderedQuantity__c);
        System.assertEquals(10, grLine.dmpl__SupplierQuantity__c);
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderAndGoodsReceiptwithOrderdAndSupplierQuantity() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseOrder__c po =PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(null, po);
        System.assertEquals(partner.Id, po.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, po.dmpl__BranchId__c);
        System.assertEquals('Draft', po.dmpl__Status__c);
        System.assertEquals(Date.today(), po.dmpl__DocumentDate__c);
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            item.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine);
        System.assertEquals(item.Id, poLine.dmpl__ItemId__c);
        System.assertEquals(20, poLine.dmpl__Quantity__c);
        dmpl__GoodsReceipt__c gr = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner,
            branch, 
            po, 
            supplier
        );
        System.assertNotEquals(null, gr);
        System.assertEquals('Draft', gr.dmpl__Status__c);
        System.assertEquals(branch.Id, gr.dmpl__BranchId__c);
        System.assertEquals(partner.Id, gr.dmpl__PartnerAccountId__c);
        dmpl__GoodsReceiptLine__c grLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
            gr.Id,
            item.Id,
            null
        );
        grLine.dmpl__OrderedQuantity__c = 10;
        grLine.dmpl__SupplierQuantity__c = 10;
        update grLine;
        System.assertNotEquals(null, grLine);
        System.assertEquals(item.Id, grLine.dmpl__ItemId__c);
        System.assertEquals(10, grLine.dmpl__OrderedQuantity__c);
        System.assertEquals(10, grLine.dmpl__SupplierQuantity__c);
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderToGoodsReceiptLineWithInactiveItem() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2','Product');
        inactiveItem.dmpl__IsActive__c = false;
        update inactiveItem;
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(null, po);
        System.assertEquals(partner.Id, po.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, po.dmpl__BranchId__c);
        System.assertEquals('Draft', po.dmpl__Status__c);
        System.assertEquals(Date.today(), po.dmpl__DocumentDate__c);
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            activeItem.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine);
        System.assertEquals(20, poLine.dmpl__Quantity__c);
        System.assertEquals(activeItem.Id, poLine.dmpl__ItemId__c);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch, po);
        System.assertNotEquals(null, shipment);
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c);
        System.assertEquals('Draft', shipment.dmpl__Status__c);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            activeItem,
            shipment,
            poLine,
            20
        );
        System.assertNotEquals(null, shipmentLine);
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(activeItem.Id, shipmentLine.dmpl__ItemId__c);
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c);
        shipmentLine.dmpl__Quantity__c = 10;
        update shipmentLine;
        shipmentLine =ShipmentTestDataHelper.getShipmentLine();
        dmpl__GoodsReceipt__c gr = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch, 
        po, 
        supplier
        );
        System.assertNotEquals(null, gr);
        System.assertEquals('Draft', gr.dmpl__Status__c);
        System.assertEquals(branch.Id, gr.dmpl__BranchId__c);
        System.assertEquals(partner.Id, gr.dmpl__PartnerAccountId__c);
        Boolean grLineFailed = false;
        try {
            dmpl__GoodsReceiptLine__c invalidGRLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
            gr.Id,
            inactiveItem.Id,
            null
        );
        } catch (DmlException e) {
            grLineFailed = true;
        }
        System.assertEquals(true, grLineFailed);
        Test.stopTest();
    }   

    @isTest
    static void purchaseOrderShipmentLineWithInactiveItem() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2', 'Product');
        inactiveItem.dmpl__IsActive__c = false;
        Test.startTest();
        dmpl__PurchaseOrder__c po =PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(null, po.Id);
        System.assertEquals(partner.Id, po.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, po.dmpl__BranchId__c);
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            activeItem.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine.Id);
        System.assertEquals(20, poLine.dmpl__Quantity__c);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch, po);
        System.assertNotEquals(null, shipment.Id);
        System.assertEquals(branch.Id, shipment.dmpl__BranchId__c);
        Boolean shipmentLineFail = false;
        try {
        dmpl__ShipmentLine__c invalidShipmentLine = ShipmentTestDataHelper.createShipmentLine(
            inactiveItem,
            shipment,
            poLine,
            0
        );
        } catch (DmlException e) {
            shipmentLineFail = true;
        }
        System.assertEquals(true, shipmentLineFail);
        dmpl__GoodsReceipt__c gr = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner,
            branch, 
            po, 
            supplier
        );
        System.assertNotEquals(null, gr.Id);
        System.assertEquals(partner.Id, gr.dmpl__PartnerAccountId__c);
        dmpl__GoodsReceiptLine__c grLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
            gr.Id,
            activeItem.Id,
            null
        );
        grLine.dmpl__OrderedQuantity__c = 10;
        grLine.dmpl__SupplierQuantity__c = 10;
        update grLine;
        System.assertNotEquals(null, grLine.Id);
        System.assertEquals(10, grLine.dmpl__OrderedQuantity__c);
        System.assertEquals(10, grLine.dmpl__SupplierQuantity__c);
        Test.stopTest();
    }
    
    @isTest
    static void purchaseOrderToInvalidGoodsReceiptAndGoodReceiptLine() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id);
        branch2.dmpl__IsActive__c = false;
        update branch2;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseOrder__c po =PurchaseOrderTestDataHelpers.getPurchaseOrder(); 
        System.assertNotEquals(null, po.Id);
        dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            item.Id,
            null,
            20
        );
        System.assertNotEquals(null, poLine.Id);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch1, po);
        System.assertNotEquals(null, shipment.Id);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item,
            shipment,
            poLine,
            20
        );
        System.assertNotEquals(null, shipmentLine.Id);
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c);
        shipmentLine.dmpl__Quantity__c = 10;
        update shipmentLine;
        shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c);
        Boolean invalidGRCreation = false;
        try {
        dmpl__GoodsReceipt__c grInvalid = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner2,
            branch2, 
            po, 
            supplier
        );
        } catch (DmlException e) {
            invalidGRCreation = true;
        }
        System.assertEquals(true, invalidGRCreation);
        Test.stopTest();
    }
    
    @isTest
    static void purchaseOrderToGoodsReceiptFlowWithInactiveItemAndInvalidQty() {
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
    dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2', 'Product');
    inactiveItem.dmpl__IsActive__c = false;
    update inactiveItem;
    Test.startTest();
    dmpl__PurchaseOrder__c po =PurchaseOrderTestDataHelpers.getPurchaseOrder(); 
    System.assertNotEquals(null, po.Id);
    System.assertEquals(partner.Id, po.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, po.dmpl__BranchId__c);
    System.assertEquals('Draft', po.dmpl__Status__c);
    Boolean poLineFailed = false;
    try {

     dmpl__PurchaseOrderLine__c poLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        po.Id,
        inactiveItem.Id,
        null,
        0
    );
    } catch (DmlException e) {
        poLineFailed = true;
    }
    System.assertEquals(true, poLineFailed);
    dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplier, branch, po);
    dmpl__GoodsReceipt__c gr = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch, 
        po, 
        supplier
    );
    dmpl__GoodsReceiptLine__c grLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(
        gr.Id,
        activeItem.Id,
        null
    );
    grLine.dmpl__OrderedQuantity__c = 10;
    grLine.dmpl__SupplierQuantity__c = 10;
    update grLine;
    System.assertNotEquals(null, grLine.Id);
    System.assertEquals(10, grLine.dmpl__OrderedQuantity__c);
    System.assertEquals(10, grLine.dmpl__SupplierQuantity__c);
    Test.stopTest();
}
}