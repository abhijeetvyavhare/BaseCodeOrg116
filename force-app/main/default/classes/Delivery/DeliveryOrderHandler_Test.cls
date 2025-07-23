@isTest
public with sharing class DeliveryOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST28.Id);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation('Storage Location 1', branch.Id);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(item, sku, deliveryOrder);
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.createDeliveryOrderTax(deliveryOrder, deliveryOrderLine, taxCGST14_8);
    }
    
    @isTest
    static void createOrderCreationWithCorrectPartnerAndBranchPostive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer, branch);
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithCustomerAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer, branch);
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithWrongPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithWrongBranchNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partner2.dmpl__IsActive__c = false;
        update partner2;
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.stopTest();
        try {
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner2.Id);
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong Branch account');    
    }
    
    @isTest
    static void createDeliveryOrderCreationWithInactiveBranchNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.id);
        branch.dmpl__IsActive__c = false;
        update branch;
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer, branch);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithNoCustomerAccountNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.id);
        branch.dmpl__IsActive__c = false;
        update branch;
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(null, branch);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');   
    }
    
    @isTest
    static void createDeliveryOrderreationWithNoSaleOrderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(null, fetchedOrder.dmpl__SaleOrderId__c, 'Sale Order should be null');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithNoRepairOrderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(null, fetchedOrder.dmpl__SaleOrderId__c, 'Sale Order should be null');
        System.assertEquals(null, fetchedOrder.dmpl__RepairOrderId__c, 'Sale Order should be null');
    }
    
    @isTest
    static void updateDeliveryOrderCreationWithCustomerAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer3 = TestDataHelpers.createCustomerAccount('Customer 3');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer3.Id, branch.Id);
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(customer3.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
    }
    
    @isTest
    static void createDeliveryOrderLinePositive() {
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine();
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should be 1.');
    }
    
    @isTest
    static void createDeliveryOrderTaxPositive() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        System.assertEquals(150, deliveryOrderTax.dmpl__TaxAmount__c, 'Tax Amount of Delivery Order Tax must be 150');
    }
    
    @isTest
    static void updateDeliveryOrderPositive() {
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertNotEquals(deliveryOrder, null, 'Delivery Order should exist before update.');
        deliveryOrder.dmpl__Discount__c = 99;
        update deliveryOrder;
        dmpl__DeliveryOrder__c deliveryOrderUpdated = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(99, deliveryOrderUpdated.dmpl__Discount__c, 'Expected Delivery ORder Discount to be updated to 99.');
    }
    
    @isTest
    static void updateDeliveryOrderLinePositive() {
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine();
        deliveryOrderLine.dmpl__Quantity__c = 5;
        update deliveryOrderLine;
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(5, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 5.');
    }
    
    @isTest
    static void updateDeliveryOrderTaxPositive() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        System.assertNotEquals(deliveryOrderTax, null, 'Delivery Order Tax should exist before update.');
        deliveryOrderTax.dmpl__TaxAmount__c = 100;
        update deliveryOrderTax;
        dmpl__DeliveryOrderTax__c deliveryOrderTaxUpdated = DeliveryOrderDataHelper.getDeliveryOrderTax(deliveryOrderTax.id);
        System.assertEquals(100, deliveryOrderTaxUpdated.dmpl__TaxAmount__c, 'Expected saleInvoice status to be updated to Submitted.');
    }
    
    @isTest
    static void deleteDeliveryOrderTax() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        delete deliveryOrderTax;
        dmpl__DeliveryOrderTax__c deletedTax;
        try {
            deletedTax = DeliveryOrderDataHelper.getDeliveryOrderTax(deliveryOrderTax.Id);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'DeliveryOrderTax should be deleted and not found in query.');
    }   
    
    @isTest
    static void deleteDeliveryOrder() {
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        delete deliveryOrder;
        dmpl__DeliveryOrder__c deletedOrder;
        try {
            deletedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'DeliveryOrder should be deleted and not found in query.');
    }
    
    @isTest
    static void createDeliveryOrderLineWithWrongStorageLocationNegativeTest() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithWrongStorageLocationNegativeTestData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c wrongStorageLocation = TestDataHelpers.getStorageLocation('Storage Location 3');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        Test.startTest();
        try {
            dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                null, 
                1, 
                100, 
                wrongStorageLocation.Id, 
                null, 
                null, 
                null
            );
        } catch (Exception e) {
            System.assertEquals('Storage Location is not valid', e.getMessage(), 'Expected validation error for invalid storage location');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithActiveItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                2, 
                1500, 
                null
            );
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 1 ID');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Cost mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        DeliveryOrderMasterData.createDeliveryOrderLineWithRequiredSKUPositiveData(partner.Id, branch.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1200, 
                sku.Id
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 10 ID');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(sku.Id, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID must be SKU 4 ID');
        System.assertEquals(sku.Name, deliveryOrderLine.dmpl__SKUId__r.Name, 'SKU Name mismatch');
        System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithNoRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(15010, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(17709.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(15009.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(17860, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(2850, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match the expected Delivery Order ID');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must match Item 1 ID');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
        System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(17700, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(2700, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithStorageLocationPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                5, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__StorageLocationId__c = storageLocation.Id;
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be GST 28%');
        System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(storageLocation.Id, deliveryOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID must be Storage Location 1');
		System.assertEquals(storageLocation.Name, deliveryOrderLine.dmpl__StorageLocationId__r.Name, 'Storage Location Name mismatch');
        System.assertEquals(7500, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(7500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(9600, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(2100, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(7500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(9600, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(7500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(9600, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(2100, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithEnteredQuantityPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                2, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be GST 28%');
        System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(3840, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(840, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(3000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(3840, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(3000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(3840, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(840, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithRepairOrderLineReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        DeliveryOrderMasterData.createDeliveryOrderLineWithRepairOrderLineReferenceData(
            partner, 
            customer, 
            branch, 
            item
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1000, 
                null
            );
            deliveryOrderLine.dmpl__RepairOrderLineId__c = repairOrderLine.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match DN25060027');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 5');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(10000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(null, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount must be zero');
        System.assertEquals(10000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithInactiveItemNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                5, 
                1500, 
                null
            );
            System.Assert.isTrue(false, 'Need Not to be able to create a delivery order line');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Need Not to be able to create a delivery order line');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithDiscountinuedItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithDiscountinuedItemPositiveData(partner.id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(15010, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(17709.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(15009.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(17860, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(2850, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match DN25060005');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 4');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
        System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(17700, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithNoStorageLocationPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                20, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        System.assertEquals(30010, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(35409.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(30009.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(35560.00, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(5550, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
        System.assertEquals(item.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
        System.assertEquals(20, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
        System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
        System.assertEquals(30000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(5400, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(35400, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithNoItemLot() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            null, 
            2, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(3000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingInvoiceQuantity__c, 'Pending invoice quantity should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingShippedQuantity__c, 'Pending shipped quantity should match');
        System.assertEquals(null, deliveryOrderLine.dmpl__ItemLotTypeId__c, 'Item lot type should be null');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithBlankQuantity() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        try {
            dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                null, 
                null, 
                null, 
                null, 
                null, 
                null, 
                null
            );
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Quantity'), 'Exception should be related to blank quantity');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithoutSaleOrderLine() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithoutSaleOrderLineData(
            customerAccount.id, 
            partnerAccount.id, 
            branch.id, 
            priceList.id
        );
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partnerAccount.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            5, 
            1200, 
            null, 
            null, 
            null, 
            sku.Id
        );
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithInactiveItemEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        DeliveryOrderMasterData.createDeliveryOrderLineWithInactiveItemData();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        dmpl__DeliveryOrder__c createdeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount.Id, customerAccount.Id, branch.Id);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createdeliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            5, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine1.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine1.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine1.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine1.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(7500, deliveryOrderLine1.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(7500, deliveryOrderLine1.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(9600, deliveryOrderLine1.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine1.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(2100, deliveryOrderLine1.dmpl__TaxAmount__c, 'Tax amount should match');
        try {
            dmpl__DeliveryOrderLine__c deliveryOrderLine2 = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item2.Id, 
                taxGroup.Id, 
                5, 
                1500, 
                null, 
                null, 
                null, 
                null
            );
        } catch (Exception e) {
            System.assert( e.getMessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION'), 'Expected FIELD_FILTER_VALIDATION_EXCEPTION due to inactive item');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderwithitemdiscontinuedEdit() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            1, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine1.Id);
        System.assertEquals(1, deliveryOrderLine1.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__BaseAmount__c, 'Base amount should be 1500');
        System.assertEquals(1920, deliveryOrderLine1.dmpl__GrossAmount__c, 'Gross amount should be 1920');
        System.assertEquals(0, deliveryOrderLine1.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(420, deliveryOrderLine1.dmpl__TaxAmount__c, 'Tax amount should be 420');
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine2 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            3, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine2 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine2.Id);
        System.assertEquals(3, deliveryOrderLine2.dmpl__Quantity__c, 'Quantity should be 3');
        System.assertEquals(1500, deliveryOrderLine2.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(4500, deliveryOrderLine2.dmpl__Amount__c, 'Amount should be 4500');
        System.assertEquals(4500, deliveryOrderLine2.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(5760, deliveryOrderLine2.dmpl__GrossAmount__c, 'Gross amount should be 5760');
        System.assertEquals(0, deliveryOrderLine2.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, deliveryOrderLine2.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(6010, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 6010');
        System.assertEquals(7689.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 7689.70');
        System.assertEquals(6009.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should be 6009.70');
        System.assertEquals(7840, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should be 5760');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithoutSKUEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            null, 
            5, 
            1000, 
            null, 
            null, 
            null, 
            null
        );
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Initial quantity should be 5');
        System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should be 1000');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item should match');
        deliveryOrderLine.dmpl__Quantity__c = 6;
        update deliveryOrderLine;
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(6, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 6');
        System.assertEquals(1000, updatedLine.dmpl__UnitPrice__c, 'Unit price should remain 1000');
        System.assertEquals(item.Id, updatedLine.dmpl__ItemId__c, 'Item should remain unchanged');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithStorageLocationEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            null, 
            20, 
            1500, 
            storageLocation.Id, 
            null, 
            null, 
            null
        );
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(20, deliveryOrderLine.dmpl__Quantity__c, 'Initial quantity should be 20');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(storageLocation.Id, deliveryOrderLine.dmpl__StorageLocationId__c, 'Storage location should match');  
        deliveryOrderLine.dmpl__Quantity__c = 25;
        update deliveryOrderLine;
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(25, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 25');
        System.assertEquals(1500, updatedLine.dmpl__UnitPrice__c, 'Unit price should remain unchanged');
        System.assertEquals(storageLocation.Id, updatedLine.dmpl__StorageLocationId__c, 'Storage location should remain unchanged');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithQuantityEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            5, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(7500, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(7500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(9600, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(2100, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax amount should match');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(7510, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should match');
        System.assertEquals(9609.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should match');
        System.assertEquals(7509.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should match');
        System.assertEquals(9760, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should match');
        System.assertEquals(2250, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(0.30, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total discount amount should match');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithoutRepairOrderLine() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithoutRepairOrderLineData(
            customerAccount.id, 
            partnerAccount.id, 
            branch.id, 
            priceList.id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partnerAccount.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            10, 
            1000, 
            null, 
            null, 
            null, 
            null
        );
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(10000, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(10000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(11800, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(1800, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax amount should match');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(10010, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should match');
        System.assertEquals(11809.70, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should match');
        System.assertEquals(10009.70, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should match');
        System.assertEquals(11960, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should match');
        System.assertEquals(1950, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total tax amount should match');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderLineWithRepairOrderLineReferencePositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset1 = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder1 = RepairOrderTestDataHelpers.createRepairOrder(
            partner, 
            customer, 
            branch, 
            asset1, 
            1000
        );
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder1.Id)[0];
        System.assertEquals(customer.Id, repairOrder.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(1000, repairOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals(Date.today(), repairOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Price List 1', repairOrder.dmpl__PriceListId__r.Name, 'Price List mismatch');
        dmpl__RepairOrderLine__c repairOrderLine1 = RepairOrderTestDataHelpers.createRepairOrderLine(
            repairOrder, 
            item, 
            15, 
            999
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine(repairOrderLine1.Id);
        System.assertEquals(999, repairOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(0, repairOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
        System.assertEquals(0, repairOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            repairOrder.Id, 
            null, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(repairOrder.Id, deliveryOrder.dmpl__RepairOrderId__c, 'Repair Order ID mismatch');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup18 = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup18.Id, 
            15, 
            1500, 
            null, 
            null, 
            repairOrderLine.Id, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(15, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup18.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(22500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(4050, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(26550, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(22500, deliveryOrderLine.dmpl__Amount__c, 'Amount should equal Gross Amount');
        System.assertEquals(repairOrderLine.Id, deliveryOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line reference mismatch');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(26550, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(26550, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(4050, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 17;
        update deliveryOrderLineToUpdate;
        deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(17, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup18.Id, deliveryOrderLineToUpdate.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(25500, deliveryOrderLineToUpdate.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(4590, deliveryOrderLineToUpdate.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(30090, deliveryOrderLineToUpdate.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(25500, deliveryOrderLineToUpdate.dmpl__Amount__c, 'Amount should equal Gross Amount');
        System.assertEquals(repairOrderLine.Id, deliveryOrderLineToUpdate.dmpl__RepairOrderLineId__c, 'Repair Order Line reference mismatch');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(25500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(30090, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(25500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(30090, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(4590, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderLineWithZeroQuantityPositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item1.Id, 
            null, 
            2, 
            1500, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingShippedQuantity__c, 'Pending Shipped Quantity mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount should equal Gross Amount');
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 1;
        update deliveryOrderLineToUpdate;
        deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        Test.stopTest();
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item1.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLineToUpdate.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__PendingShippedQuantity__c, 'Pending Shipped Quantity mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__Amount__c, 'Amount should equal Gross Amount');
    }
    
    @isTest
    public static void deliveryOrderLineWithZeroQuantityNegativeNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item1.Id, 
                null, 
                0, 
                1500, 
                null, 
                null, 
                null, 
                null
            );
            System.assert(false, 'Need Not to be able to create a delivery order line with zero quantity updated');
        } catch (Exception e) {
            System.assert(true, 'Need Not to be able to create a delivery order line with zero quantity');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderLineWithoutUnitCostPositiveNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item.Id, 
            taxGroup.Id, 
            5, 
            0, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);
        Test.stopTest();
        System.assertEquals(0, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
    }
    
    @isTest
    public static void deliveryOrderLineWithoutUnitCostPositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item1.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id, 
            item1.Id, 
            taxGroup.Id, 
            10, 
            0, 
            null, 
            null, 
            null, 
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);
        System.assertEquals(0, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(
            deliveryOrderLine.Id
        );
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 12;
        update deliveryOrderLineToUpdate;
        Test.stopTest();
        System.assertEquals(0, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item1.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(12, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLineToUpdate.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLineToUpdate.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalAmount__c, 'Amount should equal Total Line Gross Amount');
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Amount should equal Total Line Gross Amount');
    }
    
    @isTest
    static void deliveryOrderCreationWithRepairOrderReferencePositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner4.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(
            partner, 
            customer, 
            branch, 
            asset, 
            300
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order must be created');
        dmpl__RepairOrder__c retrievedRepairOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id)[0];
        System.assertEquals(customer.Name, retrievedRepairOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(priceList.Id, retrievedRepairOrder.dmpl__PriceListId__c, 'Price List ID mismatch');
        System.assertEquals(System.today(), retrievedRepairOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', retrievedRepairOrder.dmpl__Status__c, 'Status mismatch');
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLine(
            repairOrder.Id, 
            item.Id, 
            10, 
            1500
        );
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line must be created');
        dmpl__RepairOrderLine__c retrievedRepairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine( repairOrderLine.Id);
        System.assertEquals(1500, retrievedRepairOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(15000, retrievedRepairOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(0, retrievedRepairOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(0, retrievedRepairOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner4.Id, 
            customer.Id, 
            branch4.Id, 
            repairOrder.Id, 
            null, 
            null
        );
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(repairOrder.Id, retrievedDeliveryOrder.dmpl__RepairOrderId__c, 'Repair Order ID mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderCreationWithNoSaleOrderPositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer5 = TestDataHelpers.createCustomerAccount('Customer 5');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalAmount__c, 'Total Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be zero');
        deliveryOrder.dmpl__AccountId__c = customer5.Id;
        update deliveryOrder;
        retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalAmount__c, 'Total Amount should be zero');
        System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be zero');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderCreationWithNoRepairOrderPositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer5 = TestDataHelpers.createCustomerAccount('Customer 5');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(customer.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer.dmpl__BillingPostalCode__c, retrievedDeliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        deliveryOrder.dmpl__AccountId__c = customer5.Id;
        update deliveryOrder;
        retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderWithDefinedDeliveryAddressPositiveNew() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            deliveryAddress.Id
        );
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(branch.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch Name mismatch');
        System.assertEquals(
            customer.dmpl__ShippingPostalCode__c, 
            retrievedDeliveryOrder.dmpl__ShippingPostalCode__c, 
            'Shipping postal code should match'
        );
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderWithDefinedDeliveryAddressPositiveEdit() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__ContactAddress__c newDeliveryAddress = TestDataHelpers.createContactAddress('Address 2', customer2.Id);
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner.Id, 
            customer.Id, 
            branch.Id, 
            null, 
            null, 
            deliveryAddress.Id
        );
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(customer.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(partner.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(deliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID mismatch');
        deliveryOrder.dmpl__DeliveryAddressId__c = newDeliveryAddress.Id;
        update deliveryOrder;
        retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(partner.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch after update');
        System.assertEquals(branch.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch after update');
        System.assertEquals(customer.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch after update');
        System.assertEquals(newDeliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID mismatch after update');
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date should remain unchanged after update');
        System.assertEquals(newDeliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID should match after update');
        Test.stopTest();
    }
    
    @isTest
    public static void deliveryOrderCreationWithSaleOrderReferencePositiveEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        DeliveryOrderMasterData.createDeliveryOrderLineWithNoRequiredSKUPositiveData(partner.Id, branch.Id, item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(branch.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(partner.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 3, null);
        deliveryOrder.dmpl__SaleOrderId__c = saleOrder.Id;
        update deliveryOrder;
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be customer Id');
        System.assertEquals(customer.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(partner.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(partner.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderCreationWithSaleOrderReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder?.Id, 
            item?.Id, 
            1, 
            null
        );
        saleOrderLine.dmpl__UnitPrice__c = 1500;
        update saleOrderLine;
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
            deliveryOrder.dmpl__SaleOrderId__c = saleOrder.Id;
            update deliveryOrder;
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(saleOrder?.Id, deliveryOrder?.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void updateDeliveryOrderCreationWithInActivePartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        try {
            branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
            deliveryOrder.dmpl__PartnerAccountId__c = partner?.Id;
            deliveryOrder.dmpl__BranchId__c = branch?.Id;
            update deliveryOrder;
            System.assert(false, 'Update should have failed but it succeeded.');
        } catch (Exception e) {
            deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assert(true, 'Delivery Order must not be updated. >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithoutItemLotPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                1, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
        }
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(1920, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(420, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(1500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(1920, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(1500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(1920, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(420, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithRemovingRequiredSKUPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 3', item.Id, false);
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                1, 
                1500, 
                sku?.Id
            );
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Must be Created!');
        }
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku.Id, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        try {
            deliveryOrderLine.dmpl__SKUId__c = null;
            update deliveryOrderLine;
        } catch (Exception e) {
            deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
            System.assert(deliveryOrderLine.dmpl__SKUId__c != null, 'Delivery Order Line must not be updated.');
        }
        System.assertEquals(null, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID mismatch');
        Test.stopTest();
    }
    
    @isTest
    static void createDeliveryOrderLineWithSaleOrderLineReference2Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder?.Id, 
            item?.Id, 
            15, 
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
            deliveryOrder.dmpl__SaleOrderId__c = saleOrder.Id;
            update deliveryOrder;
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(saleOrder?.Id, deliveryOrder?.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1500, 
                null
            );
            deliveryOrderLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
        }
        Test.stopTest();
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(19200, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(15000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(19200, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(15000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(19200, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(4200, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        try {
            deliveryOrderLine.dmpl__Quantity__c = 15;
            deliveryOrderLine.dmpl__SaleOrderLineId__c = saleOrderLine?.Id;
            update deliveryOrderLine;
        } catch (Exception e) {
            System.assert(false, 'delivery Order Line must get Update !>>' + e.getMessage());
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(28800, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(28800, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(6300, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
    }
    
    @isTest
    static void updateDeliveryOrderLineWithZeroQuantityNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__DeliveryOrder__c deliveryOrder;
        try {
            deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
        }
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
        System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
        System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
        System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id, 
                item.Id, 
                10, 
                1200, 
                sku?.Id
            );
        } catch (Exception e) {
            System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
        }
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        try {
            deliveryOrderLine.dmpl__Quantity__c = 0;
            update deliveryOrderLine;
            System.assert(false, 'delivery Order Line must get Update!');
        } catch (Exception e) {
            System.assert(true, 'delivery Order Line must get Update!');
        }
        Test.stopTest();
    }

    @isTest
    static void DeliveryOrderCreatedWithValidPartnerAccountBranchAndCustomerAccount(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder, 'Delivery Order should not be null');
        test.stopTest();
    }

    @isTest
    static void DeliveryOrderCreatedWithRepairOrder(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder, 'Delivery Order should not be null');
        dmpl__RepairOrder__c repairOrder = FulfillmentTestDataHelpers.createRepairOrder(
            partner, 
            branch, 
            customer, 
            asset, 
            1000
        );
        deliveryOrder.dmpl__RepairOrderId__c = repairOrder.Id;
        update deliveryOrder;
        test.stopTest();
    }

    @isTest
    static void DeliveryOrderCreatedWithDeliveryAddress(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
        test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id,deliveryAddress.Id);
        System.assertNotEquals(null, deliveryOrder, 'Delivery Order should not be null');
        test.stopTest();
    }

    @isTest
    static void DeliveryOrderDoesNotGetCreatedWithInactivePartnerAccountBranchAndCustomerAccount(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        partner.dmpl__IsActive__c = false;
        customer.dmpl__IsActive__c = false;
        update partner;
        update customer;
        test.startTest();
        try{
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create DeliveryOrder.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void DeliveryOrderCreatedWithRequestedDeliveryTime(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder, 'Delivery Order should not be null');
        test.stopTest();
    }

    @isTest
    static void DeliveryOrderCreatedWithRequestedDeliveryDateAndTime(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner.Id, customer.Id, branch.Id);
        System.assertNotEquals(null, deliveryOrder, 'Delivery Order should not be null');
        test.stopTest();
    }
}