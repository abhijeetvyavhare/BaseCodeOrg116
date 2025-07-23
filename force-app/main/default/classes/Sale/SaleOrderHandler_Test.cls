@isTest
public with sharing class SaleOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.Id, item1.Id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false,
            null
        );
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplierAccount1.Id, partnerAccount1.id, branch1.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item1.Id,
            taxGroupGST28.Id,
            10
        );
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partnerAccount1.Id, supplierAccount1.Id, branch1.Id);
        dmpl__ShipmentLine__c shipmentLine2 = ShipmentTestDataHelper.createShipmentLine(
            item1,
            shipment,
            null,
            purchaseOrderLine
        );
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderPositive() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        Test.stopTest();
        System.assertNotEquals(null, saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
    }

    @isTest
    static void createSaleOrderLinePositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            15,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(line, null, 'Expected Sale Order Line to be created.');
        System.assertEquals(15, line.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(null, line.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, line.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(22500, line.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(6300, line.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(28800, line.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(14, line.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, line.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', line.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', line.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', line.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', line.dmpl__Tax2Type__c, 'Tax 2 Type should match');
    }

    @isTest
    static void updateSaleOrderLinePositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c createdLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            15,
            null
        );
        dmpl__SaleOrderLine__c lineBeforeUpdate = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(lineBeforeUpdate, null, 'Line should exist before update');
        System.assertEquals(15, lineBeforeUpdate.dmpl__Quantity__c, 'Initial quantity should be 15');
        System.assertEquals(null, lineBeforeUpdate.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, lineBeforeUpdate.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(22500, lineBeforeUpdate.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(6300, lineBeforeUpdate.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(28800, lineBeforeUpdate.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(14, lineBeforeUpdate.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, lineBeforeUpdate.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', lineBeforeUpdate.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', lineBeforeUpdate.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', lineBeforeUpdate.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', lineBeforeUpdate.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        lineBeforeUpdate.dmpl__Quantity__c = 20;
        update lineBeforeUpdate;
        dmpl__SaleOrderLine__c lineAfterUpdate = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(lineAfterUpdate, null, 'Line should exist after update');
        System.assertEquals(20, lineAfterUpdate.dmpl__Quantity__c, 'Updated quantity should be 20');
        System.assertEquals(null, lineAfterUpdate.dmpl__Discount__c, 'Discount should remain null');
        System.assertEquals(1500, lineAfterUpdate.dmpl__UnitPrice__c, 'Unit Price should remain unchanged');
        System.assertEquals(30000, lineAfterUpdate.dmpl__BaseAmount__c, 'Updated Base Amount should match');
        System.assertEquals(8400, lineAfterUpdate.dmpl__TaxAmount__c, 'Updated Tax Amount should match');
        System.assertEquals(38400, lineAfterUpdate.dmpl__GrossAmount__c, 'Updated Gross Amount should match');
        System.assertEquals(4200.00, lineAfterUpdate.dmpl__Tax1__c, 'Tax 1 should match after update');
        System.assertEquals(4200.00, lineAfterUpdate.dmpl__Tax2__c, 'Tax 2 should match after update');
        System.assertEquals(14, lineAfterUpdate.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, lineAfterUpdate.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', lineAfterUpdate.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', lineAfterUpdate.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', lineAfterUpdate.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', lineAfterUpdate.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        Test.stopTest();
    }

    @isTest
    static void deleteSaleOrderLinePositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        delete line;
        Test.stopTest();
        dmpl__SaleOrderLine__c deletedLine = null;
        try {
            deletedLine = SaleOrderDataHelper.getSaleOrderLine(line.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'SaleOrderLine should be deleted.');
    }

    @isTest
    static void deleteSaleOrderPositive() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        delete saleOrder;
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder1 = null;
        try {
            saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        } catch (Exception e) {
            saleOrder1 = null;
        }
        System.assertEquals(null, saleOrder1, 'Sale Order should be deleted');
    }

    @isTest
    static void createSaleOrderWithGSTTaxGlobalPositive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithPriceList() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c createdLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            10,
            null
        );
        System.assertNotEquals(null, saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals(priceList1.Id, saleOrder1.dmpl__PriceListId__c, 'Price List should match');
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertNotEquals(saleOrderLine, null, 'Line should exist before update');
        System.assertEquals(10, saleOrderLine.dmpl__Quantity__c, 'Initial quantity should be 10');
        System.assertEquals(null, saleOrderLine.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(15000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(4200, saleOrderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderLineWithAlternateItem() {
        Test.startTest();
        SaleOrderMasterData.createSaleOrderLineWithAlternateItemData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item13 = TestDataHelpers.getItem('Item 13');
        dmpl__Item__c item14 = TestDataHelpers.getItem('Item 14');
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.getItemAlternate(item14.Id);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item14.Id,
            10,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item13.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 4200');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
    }
 
    @isTest
    static void createSaleOrderWithInactiveBranchNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__ContactAddress__c address = TestDataHelpers.getContactAddress('Address 1');
        dmpl__Branch__c inactiveBranch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        inactiveBranch.dmpl__IsActive__c = false;
        update inactiveBranch;
        System.assertEquals(false, inactiveBranch.dmpl__IsActive__c, 'Branch should be inactive for this test'); 
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount.Id,
                partnerAccount.Id,
                inactiveBranch.Id,
                address.Id,
                null,
                false,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive branch');
        } catch (Exception e) {
            System.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The specified Branch is not active!: []', 
                e.getMessage(),
                'Expected valIdation error for inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderWithBillingShippingAddressPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customerAccount.Id);
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );
        Test.stopTest();
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals(customerAccount.Id, saleOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(partnerAccount.Id, saleOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, saleOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price List should match');
    }

    @isTest
    static void createSaleOrderWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        SaleOrderMasterData.createSaleOrderWithInactivePartnerAccountNegativeData(customerAccount.Id);
        Account inactivePartnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address = TestDataHelpers.getContactAddress('Address 1');
        inactivePartnerAccount.IsActive__c = false;
        update inactivePartnerAccount;
        System.assertEquals(false, inactivePartnerAccount.IsActive__c, 'Partner account should be inactive for this test');
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount.Id,
                inactivePartnerAccount.Id,
                branch.Id,
                address.Id,
                null,
                false,
                null
            );
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') &&
                                    errorMsg.contains('The partner account is not active!');
            System.assertEquals(true, correctException,
                'Expected valIdation error for inactive partner account but got: ' + errorMsg);
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithNoCustomerAccountNegative() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') &&
                                     errorMsg.contains('Please Select a Customer Account');
            System.assert(correctException,
                'Expected valIdation error for missing customer account but got: ' + errorMsg);
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleOrderWithPriceListForPartnerAccountAndBranchPositive() {
        Test.startTest();
        SaleOrderMasterData.createSaleOrderWithPriceListForPartnerAccountAndBranchPositiveData();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Price List 3', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match'); 
    }
    
    @isTest
    static void saleOrderWithPriceListForPartnerAccountGroupPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        Test.stopTest();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
    }

    @isTest
    static void createSaleOrderWithPriceListForCustomerAccGrp() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Group should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
    }

    @isTest
    static void createSaleOrderWithInactiveSalesExecutive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2');
        try {
            dmpl__SaleOrder__c  saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                branch1.Id,
                null,
                null,
                false,
                resource2.Id
            );
        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION'),
                'Expected FIELD_FILTER_VALIDATION_EXCEPTION, but got: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }  
    
    @isTest
    static void createSaleOrderLineItemWithoutTaxGroupNewNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createSaleOrderLineItemWithoutTaxGroupNewNegativeData(
            customer.Id,
            partner.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__ContactAddress__c address2 = TestDataHelpers.getContactAddress('Address 2');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2000, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(20000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(null, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should be null');
        System.assertEquals(20000, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(20000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void saleOrderLineItemWithoutTaxGroupEditNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createSaleOrderLineItemWithoutTaxGroupEditNegativeData(
            customer.Id,
            partner.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__ContactAddress__c address2 = TestDataHelpers.getContactAddress('Address 2');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 12;
        update saleOrderLine;
        Test.stopTest();
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(12, line.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2000, line.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(24000, line.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(null, line.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, line.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(0, line.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, line.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(null, line.dmpl__TaxAmount__c, 'Tax Amount should be null');
        System.assertEquals(24000, line.dmpl__GrossAmount__c, 'Gross Amount should match');
        dmpl__SaleOrder__c order = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(24000, order.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(24000, order.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should match');
        System.assertEquals(0, order.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(0, order.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(0, order.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(24000, order.dmpl__TotalLineGrossAmount__c, 'Total Gross should match');
        System.assertEquals(24000, order.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(24000, order.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void schemeApplicabilityInCaseOfIgnoreBudgetTrueNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            20,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(30000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(20, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(8400, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(38400, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(4200.00, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(4200.00, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        saleOrder1= SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertEquals(30000, saleOrder1.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(30000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, saleOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(8400, saleOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void createSaleOrderLineWithInactiveItem() {
        SaleOrderMasterData.createSaleOrderLineWithInactiveItemData();
        Account customerAccount3 = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount3.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );
        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                inactiveItem.Id,
                3,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive item');
        } catch (Exception e) {
            System.assertEquals(
                'Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, Item needs to be active and not set to be sold only on package!: [dmpl__ItemId__c]',
                e.getMessage(),
                'Expected valIdation error for inactive item'
            );
        }
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
    }
   
    @isTest
    static void createSaleOrderWithInLineTaxes() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            3,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(630, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }
         
    @isTest
    static void createSaleOrderWithPassedDateEffectiveNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c priceListRules = TestDataHelpers.getPriceListRules(priceList.Id);
        priceListRules.dmpl__DateEffectiveTill__c = Date.today().addDays(-1);
        update priceListRules;
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            2,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(2, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(0, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(null, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(0, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }
       
    @isTest
    static void createSaleOrderWithSchemeNotApproved() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            10,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
    }

    @isTest
    static void createSaleOrderWithInLineTaxesEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id, 
            branch.Id,
            null,
            null,
            true,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 10;
        update saleOrderLine;
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should be updated to 10');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void createSaleOrderWithSkipSchemeTrue() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            3,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');
    }

    @isTest
    static void editSaleOrderWithSkipSchemeTrue() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            3,
            null
        );
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(630, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');
        orderLine1.dmpl__Quantity__c = 6;
        update orderLine1;
        dmpl__SaleOrderLine__c orderLine2 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(6, orderLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1260, orderLine2.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(1260, orderLine2.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine2.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine2.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine2.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine2.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine2.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine2.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine2.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2520, orderLine2.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(11520, orderLine2.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(9000, orderLine2.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine2.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine2.dmpl__NetDiscount__c, 'Net discount should match');
        Test.stopTest();
    }
    
    @isTest
    static void createSaleOrderWithPassedDateEffectiveNegativeEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceListRules__c priceListRules = TestDataHelpers.getPriceListRules(priceList.Id);
        priceListRules.dmpl__DateEffectiveTill__c = Date.today().addDays(-1);
        update priceListRules;
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 10;
        update saleOrderLine;
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(0, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(0, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(null, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(0, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void saleOrderLineWithDiscontinuedItem() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.saleOrderLineWithDiscontinuedItemData(priceList.Id);
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Item__c discontinuedItem = TestDataHelpers.getItem('Item 4'); 
        Test.startTest();        
          dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id, 
            branch.Id,
            null,
            null,
            true,
            null
        );
        saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 2', saleOrder.dmpl__AccountName__c, 'Account Name should be Customer 2');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            discontinuedItem.Id,
            5,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(null, createdSOL.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(null, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(null, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(null, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(null, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 10000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be null');
        System.assertEquals(10000, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 10000');
    }

    @isTest
    static void saleOrderLineWithDiscontinuedItemEditNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.saleOrderLineWithDiscontinuedItemData(priceList.Id);
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4'); 
        Test.startTest();
        dmpl__SaleOrder__c order = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            true,
            null
        );
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            order.Id,
            item.Id,
            5,
            null
        );
        System.assertNotEquals(null, line.Id, 'Sale Order Line should be created');
        line.dmpl__Quantity__c = 7;
        update line;
        Test.stopTest();
        dmpl__SaleOrderLine__c updated = SaleOrderDataHelper.getSaleOrderLine(order.Id);
        System.assertEquals(2000, updated.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(14000, updated.dmpl__BaseAmount__c, 'Base amount should be 14000');
        System.assertEquals(0, updated.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, updated.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, updated.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, updated.dmpl__Tax1Rate__c, 'Tax1 rate should be null');
        System.assertEquals(null, updated.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(null, updated.dmpl__Tax2Rate__c, 'Tax2 rate should be null');
        System.assertEquals(null, updated.dmpl__TaxAmount__c, 'Tax amount should be null');
        System.assertEquals(14000, updated.dmpl__GrossAmount__c, 'Gross amount should be 14000');
    }

    @isTest
    static void createSaleOrderWithInactiveCustomerAccountNegative() {
        SaleOrderMasterData.createSaleOrderWithInactiveCustomerAccountNegativeData();
        Account customerAccount7 = TestDataHelpers.getCustomerAccount('Customer 7');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        System.assertEquals(false, customerAccount7.dmpl__IsActive__c, 'Customer account should be inactive for this test');
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount7.Id,
                partnerAccount2.Id,
                branch2.Id,
                null,
                null,
                false,
                null
            );
            dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
            System.assertEquals('Customer 7', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
            System.assertEquals(null, createdSaleOrder.dmpl__PriceListId__c, 'Price list should be null');
            System.assert(false, 'Expected an exception to be thrown for inactive customer account');
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_FILTER_VALIDATION_EXCEPTION') &&
                                    errorMsg.contains('dmpl__AccountId__c');
            System.assert(correctException, 'Expected FIELD_FILTER_VALIDATION_EXCEPTION related to dmpl__AccountId__c but got: ' + errorMsg);
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithMultipleBillingAndShippingAddress() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        SaleOrderMasterData.saleOrderWithMultipleBillingAndShippingAddressData(customerAccount1.Id, partnerAccount1.Id, branch1.Id, priceList1.Id, billingAddress.Id );
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 3');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                branch1.Id,
                billingAddress.Id,
                shippingAddress.Id,
                false,
                null
            );
        Test.stopTest();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(customerAccount1.Id, createdSaleOrder.dmpl__AccountId__c);
        System.assertEquals(partnerAccount1.Id, createdSaleOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, createdSaleOrder.dmpl__BranchId__c);
        System.assertEquals(billingAddress.Id, createdSaleOrder.dmpl__BillingAddressId__c);
        System.assertEquals(shippingAddress.Id, createdSaleOrder.dmpl__ShippingAddressId__c);
    }

    @isTest
    static void saleOrderWithWrongPartnerAndBranchSelectionNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.saleOrderWithWrongPartnerAndBranchSelectionNegativeData();
        Account wrongPartnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c Branch3 = TestDataHelpers.getBranch('Branch 3');
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount.Id,
                wrongPartnerAccount.Id,
                Branch3.Id,
                null,
                null,
                false,
                null
            );
            System.assert(false, 'Sale order should not be created with mismatched partner and branch.');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('partner account is wrong') ||
                                            errorMsg.contains('field_custom_valIdation_exception') ||
                                            errorMsg.contains('partner') ||
                                            errorMsg.contains('branch');
            System.assert(correctExceptionThrown,
                'Expected valIdation failure due to mismatched Partner and Branch, but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithWrongBranchSelectionNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        SaleOrderMasterData.saleOrderWithWrongBranchSelectionNegativeData();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount.Id,
                partnerAccount.Id,
                branch.Id,
                null,
                null,
                false,
                null
            );
            System.assert(false, 'Sale order should not be created with a branch that does not belong to the same partner.');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('field_custom_validation_exception') &&
                                            errorMsg.contains('branch');
            System.assert(correctExceptionThrown,
                'Expected FIELD_CUSTOM_VALIDATION_EXCEPTION related to Branch but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithoutSchemesNewPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        Test.stopTest();
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
    }


    @isTest
    static void saleOrderLineWithStorageLocationNewPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder,
            item.Id,
            5,
            storageLocation.Id
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        Test.stopTest();    
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1008, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1008');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(7500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 7500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(300, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 300');
        System.assertEquals(2016, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 2016');
        System.assertEquals(9216, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 9216');
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void saleOrderLineWithStorageLocationEditPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder,
            item.Id,
            5,
            storageLocation.Id
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        Test.stopTest();    
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1008, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1008');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(7500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 7500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(300, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 300');
        System.assertEquals(2016, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 2016');
        System.assertEquals(9216, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 9216');
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__StorageLocation__c storageLocation5 = TestDataHelpers.createStorageLocation('Storage Location 5', branch, 'Warehouse');
        createdSOL.dmpl__StorageLocationId__c = storageLocation5.Id;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(storageLocation5.Id, updatedSOL.dmpl__StorageLocationId__c, 'Storage Location should be updated');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1008, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1008');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(7500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 7500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(300, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 300');
        System.assertEquals(2016, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 2016');
        System.assertEquals(9216, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 9216');
        System.assertEquals('Storage Location 5', updatedSOL.dmpl__StorageLocationId__r.Name, 'Storage Location name should be Storage Location 5');
    }

    @isTest
    static void saleOrderWithItemLevelTaxChangesPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c createdSaleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item.Id,
            3,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should be Customer 1');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price list should be Price List 1');
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');
    }

    @isTest
    static void saleOrderWithIgnoreBudgetEditNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            14,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price list should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2940, orderLine1.dmpl__Tax1__c, 'Tax1 amount should match');
        System.assertEquals(21000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(5880, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(26880, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'Scheme Line should be null');
        saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(21000, saleOrder.dmpl__LineSubTotal__c, 'Line subtotal should match');
        System.assertEquals(21000, saleOrder.dmpl__TotalLineBaseAmount__c, 'Total base amount should match');
        System.assertEquals(0, saleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should match');
        System.assertEquals(0, saleOrder.dmpl__TotalDiscountAmount__c, 'Total discount should match');
        System.assertEquals(5880, saleOrder.dmpl__TotalLineTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(5880, saleOrder.dmpl__TotalTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(26880, saleOrder.dmpl__TotalLineGrossAmount__c, 'Total gross should match');
        System.assertEquals(26880, saleOrder.dmpl__OpenAmount__c, 'Open amount should match');
        System.assertEquals(26880, saleOrder.dmpl__OutstandingAmount__c, 'Outstanding amount should match');
    }
    
    @isTest
    static void saleOrderWithTaxAppObjectModelObjectTaxesNewPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals('GST 28', createdSOL.dmpl__TaxGroupId__r.Name, 'Tax group should match');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(630, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 630');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');
        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.getSaleOrderTaxes(saleOrder.Id);
        System.assertEquals(630, saleOrderTax.dmpl__TaxAmount__c, 'Tax amount should be 630');
        System.assertEquals(4500, saleOrderTax.dmpl__TaxOnAmount__c, 'Tax on amount should be 4500');
        System.assertEquals('GST 28', saleOrderTax.dmpl__TaxGroupId__r.Name, 'Tax group should be GST 28%');
        System.assertEquals(14, saleOrderTax.dmpl__TaxRate__c, 'Tax rate should be 14');
        System.assertEquals(saleOrder.Id, saleOrderTax.dmpl__SaleOrderId__c, 'Sale Order ID should match');
        System.assertEquals(saleOrderLine.Id, saleOrderTax.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4500, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line subtotal should be 4500');
        System.assertEquals(4500, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 4500');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(1260, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 1260');
        System.assertEquals(1260, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total tax amount should be 1260');
        System.assertEquals(5760, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total gross amount should be 5760');
        System.assertEquals(5760, createdSaleOrder2.dmpl__OpenAmount__c, 'Open amount should be 5760');
        System.assertEquals(5760, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding amount should be 5760');
    }

    @isTest
    static void saleOrderWithTaxAppObjectModelObjectTaxesEditPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        saleOrderLine.dmpl__Quantity__c =2;
        update saleOrderLine;
        Test.stopTest();
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);        
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals('GST 28', createdSOL.dmpl__TaxGroupId__r.Name, 'Tax group should match');
        System.assertEquals(420, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(420, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 420');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(3000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 3000');
        System.assertEquals(840, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 840');
        System.assertEquals(3840, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 3840');
        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.getSaleOrderTaxes(saleOrder.Id);
        System.assertEquals(420, saleOrderTax.dmpl__TaxAmount__c, 'Tax amount should be 420');
        System.assertEquals(3000, saleOrderTax.dmpl__TaxOnAmount__c, 'Tax on amount should be 3000');
        System.assertEquals('GST 28', saleOrderTax.dmpl__TaxGroupId__r.Name, 'Tax group should be GST 28%');
        System.assertEquals(14, saleOrderTax.dmpl__TaxRate__c, 'Tax rate should be 14');
        System.assertEquals(saleOrder.Id, saleOrderTax.dmpl__SaleOrderId__c, 'Sale Order ID should match');
        System.assertEquals(saleOrderLine.Id, saleOrderTax.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(3000, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line subtotal should be 3000');
        System.assertEquals(3000, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 3000');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(840, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 840');
        System.assertEquals(840, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total tax amount should be 840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total gross amount should be 3840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__OpenAmount__c, 'Open amount should be 3840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding amount should be 3840');
    }

    @isTest
    static void saleOrderWithSchemeNotApprovedEdit() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        orderLine1.dmpl__Quantity__c = 5;
        update orderLine1;
        orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1050, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(1050, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(7500, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(2100, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(9600, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        dmpl__SaleOrder__c saleOrder3 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(7500, saleOrder3.dmpl__LineSubTotal__c, 'Line Sub Total should match');
        System.assertEquals(7500, saleOrder3.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder3.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, saleOrder3.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(2100, saleOrder3.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(2100, saleOrder3.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }
 
    @isTest
    static void saleOrderLineWithoutSchemesEditPositive(){
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'tax1 name should be cgst');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'tax2 name should be sgst');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be cgst');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax1 type should be sgst');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(630, createdSOL.dmpl__Tax2__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');
        saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        createdSOL.dmpl__Quantity__c = 6;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(6, updatedSOL.dmpl__Quantity__c, 'Unit price should be 6');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1260, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 1260');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(9000, updatedSOL.dmpl__BaseAmount__c, 'Base amount should be 9000');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(2520, updatedSOL.dmpl__TaxAmount__c, 'Tax amount should be 2520');
        System.assertEquals(11520, updatedSOL.dmpl__GrossAmount__c, 'Gross amount should be 11520');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'tax1 name should be cgst');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'tax2 name should be sgst');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 type should be cgst');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax1 type should be sgst');
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(9000, updatedSO.dmpl__LineSubTotal__c, 'Line subtotal should be 9000');
        System.assertEquals(9000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 9000');
        System.assertEquals(0, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, updatedSO.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(2520, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total tax amount should be 2520');
        System.assertEquals(2520, updatedSO.dmpl__TotalTaxAmount__c, 'Total tax amount should be 2520');
        System.assertEquals(11520, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total gross should be 11520');
        System.assertEquals(11520, updatedSO.dmpl__OpenAmount__c, 'Open amount should be 11520');
        System.assertEquals(11520, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding amount should be 11520');
        Test.stopTest();
    }

    @isTest
    static void saleOrderwithInActivePriceListNegative(){
        SaleOrderMasterData.saleOrderwithInActivePriceListNegativeData();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 6');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 6');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 5');
        Test.startTest();
    	Boolean exceptionCaught = false;
    	String exceptionMessage = '';
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount.Id,
                partnerAccount.Id,
                branch.Id,
                null,
                null,
                false,
                null
            );
            System.assertNotEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price List 5 should be used for the order');
        } catch (Exception e) {
            exceptionCaught = true;
        	exceptionMessage = e.getMessage();
        	System.assert(exceptionMessage.containsIgnoreCase('inactive') && 
                     exceptionMessage.containsIgnoreCase('price') && 
                     exceptionMessage.containsIgnoreCase('list'), 
                     'Exception message should contain inactive price list valIdation: ' + exceptionMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetNewPositive(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('item 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item.Id, 
            20,
            null
        );
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrsderWithDiscountGroup() {
        SaleOrderMasterData.saleOrsderWithDiscountGroupData();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item.Id, 
            20,
            null
        );
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList.Id, saleOrder.dmpl__PriceListId__c, 'Price list should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2000, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(38400, saleOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(2304, saleOrderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', saleOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, saleOrderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals(2304, saleOrderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', saleOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, saleOrderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals(40000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, saleOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(1600, saleOrderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(4608, saleOrderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(43008, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(40000, saleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(1600, saleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(4608, saleOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(4608, saleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(43008, saleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(43008, saleOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(43008, saleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudget() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleOrderMasterData.createschemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetData(partner.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            1100, 
            null
        );
        Test.stopTest();
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1100, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(66000, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(66000, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(1100000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1232000, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(1100000, saleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(1100000, saleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(132000, saleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(132000, saleOrder.dmpl__TotalTaxAmount2__c, 'Total Tax Amount 2 should match');
        System.assertEquals(1232000, saleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should match');
        System.assertEquals(1232000, saleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(1232000, saleOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(1232000, saleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void saleOrderWithDiscountGroupAndSchemeNewPositive() {
        SaleOrderMasterData.createSaleOrderWithDiscountGroupAndSchemeNewData();
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        dmpl__SaleOrder__c order = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c lineFetched = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('Customer 3', order.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals('Draft', order.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('Price List 3', order.dmpl__PriceListId__r.Name, 'Price list mismatch');
        System.assertEquals(10, lineFetched.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1000, lineFetched.dmpl__UnitPrice__c, 'Unit price mismatch');
        System.assertEquals(516, lineFetched.dmpl__Tax1__c, 'Tax1 mismatch');
        System.assertEquals('CGST', lineFetched.dmpl__Tax1Name__c, 'Tax1 name mismatch');
        System.assertEquals(6, lineFetched.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
        System.assertEquals('CGST', lineFetched.dmpl__Tax1Type__c, 'Tax1 type mismatch');
        System.assertEquals(516, lineFetched.dmpl__Tax2__c, 'Tax2 mismatch');
        System.assertEquals('SGST', lineFetched.dmpl__Tax2Name__c, 'Tax2 name mismatch');
        System.assertEquals(6, lineFetched.dmpl__Tax2Rate__c, 'Tax2 rate mismatch');
        System.assertEquals('SGST', lineFetched.dmpl__Tax2Type__c, 'Tax2 type mismatch');
        System.assertEquals(10000, lineFetched.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(1000, lineFetched.dmpl__NetSchemeDiscount__c, 'Scheme discount mismatch');
        System.assertEquals(400, lineFetched.dmpl__NetDiscount__c, 'Item discount mismatch');
        System.assertEquals(1032, lineFetched.dmpl__TaxAmount__c, 'Tax amount mismatch');
        System.assertEquals(9632, lineFetched.dmpl__GrossAmount__c, 'Gross amount mismatch');
        System.assertEquals(8600, order.dmpl__LineSubTotal__c, 'Line subtotal mismatch');
        System.assertEquals(10000, order.dmpl__TotalLineBaseAmount__c, 'Base total mismatch');
        System.assertEquals(1000, order.dmpl__TotalSchemeDiscountAmount__c, 'Scheme discount total mismatch');
        System.assertEquals(400, order.dmpl__TotalDiscountAmount__c, 'Discount total mismatch');
        System.assertEquals(1032, order.dmpl__TotalTaxAmount__c, 'Tax total mismatch');
        System.assertEquals(9632, order.dmpl__TotalLineGrossAmount__c, 'Gross total mismatch');
        System.assertEquals(9632, order.dmpl__OpenAmount__c, 'Open amount mismatch');
        System.assertEquals(9632, order.dmpl__OutstandingAmount__c, 'Outstanding amount mismatch');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithDiscountGroupandSchemeEdit() {
        SaleOrderMasterData.createSaleOrderWithDiscountGroupAndSchemeNewData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            20,
            null
        );
        dmpl__SaleOrderLine__c initialSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, initialSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(20000, initialSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(800, initialSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals(2064, initialSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2064');
        System.assertEquals(19264, initialSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19264');
        initialSOL.dmpl__Quantity__c = 30;
        update initialSOL;
        Test.stopTest();
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(30000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(1200, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 1200');
        System.assertEquals(3096, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 3096');
        System.assertEquals(28896, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28896');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(25800, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 27000');
        System.assertEquals(30000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 30000');
        System.assertEquals(3000, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 3000');
        System.assertEquals(1200, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1200');
        System.assertEquals(3096, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 3096');
        System.assertEquals(28896, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 28896');
        System.assertEquals(28896, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 28896');
        System.assertEquals(28896, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 28896');
    }

    @isTest
    static void schemeApplicabilityCustomerAccountGroupNewPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item.Id,
            2,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 576');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4368, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 4368');
        System.assertEquals(4800, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 4800');
        System.assertEquals(240, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
    }

    @isTest
    static void schemeApplicabilityCustomerAccountGroupEditPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item6.Id,
            2,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 262.08');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 262.08');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');
        createdSOL.dmpl__Quantity__c = 3;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(2400, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(414.72, updatedSOL.dmpl__Tax1__c, 'Tax1 amount should be 414.72');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(414.72, updatedSOL.dmpl__Tax2__c, 'Tax2 amount should be 414.72');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(6912, updatedSOL.dmpl__Amount__c, 'Amount should be 6912');
        System.assertEquals(7200, updatedSOL.dmpl__BaseAmount__c, 'Base amount should be 7200');
        System.assertEquals(7741.44, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 7741.44');
        System.assertEquals(288, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 288');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(829.44, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 829.44');
        System.assert(updatedSOL.Name.startsWith('DOC'), 'Name should start with DOC');
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(6912, updatedSO.dmpl__LineSubTotal__c, 'Line SubTotal should be 6912');
        System.assertEquals(7200, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 7200');
        System.assertEquals(0, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(7741.44, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 7741.44');
        System.assertEquals(7741, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 7741');
        System.assertEquals(7741.44, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 7741.44');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetEdit() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleOrderMasterData.createschemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetEditData(
            customer.Id,
            partner.Id,
            branch.Id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            1,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 1200;
        update saleOrderLine;
        Test.stopTest();
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c updatedSaleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1200, updatedSaleOrderLine.dmpl__Quantity__c, 'Quantity should be 1200');
        System.assertEquals(1000, updatedSaleOrderLine.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(72000, updatedSaleOrderLine.dmpl__Tax1__c, 'Tax1 should be 72000');
        System.assertEquals('CGST', updatedSaleOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedSaleOrderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', updatedSaleOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(72000, updatedSaleOrderLine.dmpl__Tax2__c, 'Tax2 should be 72000');
        System.assertEquals('SGST', updatedSaleOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedSaleOrderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', updatedSaleOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1344000, updatedSaleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 1344000');
        System.assertEquals(1200000, updatedSaleOrderLine.dmpl__Amount__c, 'Amount should be 1200000');
        System.assertEquals(1200000, updatedSaleOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 1200000');
        System.assertEquals(1200000, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 1200000');
        System.assertEquals(1200000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 1200000');
        System.assertEquals(144000, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 144000');
        System.assertEquals(144000, updatedSaleOrder.dmpl__TotalTaxAmount2__c, 'Total Tax Amount 2 should be 144000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 1344000');      
    }

    @isTest
    static void saleOrderWithDiscountGroupEdit() {
        SaleOrderMasterData.createSaleOrderWithDiscountGroupEditData();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            20,
            null
        );
        Test.stopTest();
        line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(20, line.dmpl__Quantity__c, 'Initial quantity should be 20');
        System.assertEquals(40000, line.dmpl__BaseAmount__c, 'Base amount mismatch for 20 qty');
        System.assertEquals(1600, line.dmpl__NetDiscount__c, 'Discount mismatch for 20 qty');
        System.assertEquals(4608, line.dmpl__TaxAmount__c, 'Tax mismatch for 20 qty');
        System.assertEquals(43008, line.dmpl__GrossAmount__c, 'Gross mismatch for 20 qty');
        line.dmpl__Quantity__c = 30;
        update line;
        dmpl__SaleOrderLine__c updatedLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(30, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 30');
        System.assertEquals(60000, updatedLine.dmpl__BaseAmount__c, 'Base amount mismatch for 30 qty');
        System.assertEquals(2400, updatedLine.dmpl__NetDiscount__c, 'Discount mismatch for 30 qty');
        System.assertEquals(6912, updatedLine.dmpl__TaxAmount__c, 'Tax mismatch for 30 qty');
        System.assertEquals(64512, updatedLine.dmpl__GrossAmount__c, 'Gross mismatch for 30 qty');
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(57600.00, finalOrder.dmpl__LineSubTotal__c);
        System.assertEquals(60000.00, finalOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(2400, finalOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(6912, finalOrder.dmpl__TotalLineTaxAmount__c);
        System.assertEquals(6912, finalOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__OpenAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__OutstandingAmount__c);
    }
   
    @isTest
    static void saleOrderLineWithInactiveItemEdit() {
        SaleOrderMasterData.saleOrderLineWithInactiveItemEditData();
        Account customerAccount3 = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount3.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine1 = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item1.Id,
            5,
            null
        );
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, orderLine1.Id, 'Sale Order Line should be created');
        System.assertEquals(5, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(450, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(450, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(7500, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(900, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(8400, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        try {
            dmpl__SaleOrderLine__c saleOrderLine2 = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                inactiveItem.Id,
                3,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive item');
        } catch (Exception e) {
            System.assertEquals(
                'Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, Item needs to be active and not set to be sold only on package!: [dmpl__ItemId__c]',
                e.getMessage(),
                'Expected valIdation error for inactive item'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithAutoApplySchemeDiscountPercentage() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__Scheme__c scheme9 = TestDataHelpers.getScheme('Scheme 9');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item6.Id,
            2,
            null
        );
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2, orderLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(2400, orderLine.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(262.08, orderLine.dmpl__Tax1__c, 'Tax1 should be 262.08');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, orderLine.dmpl__Tax2__c, 'Tax2 should be 262.08');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4800, orderLine.dmpl__BaseAmount__c, 'Base Amount should be 4800');
        System.assertEquals(240, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(524.16, orderLine.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');
        System.assertEquals(4892.16, orderLine.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', updatedSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Within State', updatedSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('Draft', updatedSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(4368, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 4368');
        System.assertEquals(4800, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 4800');
        System.assertEquals(240, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192.0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithAutoApplySchemeDiscountPercentageEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme9 = TestDataHelpers.getScheme('Scheme 9');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c line1 = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item6.Id, 
            2, 
            null
        );
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2, line.dmpl__Quantity__c, 'Initial quantity should be 2');
        System.assertEquals(2400, line.dmpl__UnitPrice__c, 'Unit price should be 2400');
        System.assertEquals(262.08, line.dmpl__Tax1__c, 'Tax1 should be 262.08');
        System.assertEquals('CGST', line.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, line.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', line.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, line.dmpl__Tax2__c, 'Tax2 should be 262.08');
        System.assertEquals('SGST', line.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, line.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', line.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4800, line.dmpl__BaseAmount__c, 'Base Amount should be 4800');
        System.assertEquals(240, line.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(524.16, line.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');
        System.assertEquals(4892.16, line.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertNotEquals(null, line.dmpl__SchemeLineId__c, 'SchemeLineId should not be null');
        System.assertEquals(5.0, line.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5%');
        line.dmpl__Quantity__c = 1;
        update line;
        dmpl__SaleOrderLine__c updatedLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2400, updatedLine.dmpl__UnitPrice__c, 'Updated Unit price should be 2400');
        System.assertEquals(1, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 1');
        System.assertEquals(138.24, updatedLine.dmpl__Tax1__c, 'Updated Tax1 should be 138.24');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Name__c, 'Updated Tax1 Name should be CGST');
        System.assertEquals(6, updatedLine.dmpl__Tax1Rate__c, 'Updated Tax1 Rate should be 6%');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Type__c, 'Updated Tax1 Type should be CGST');
        System.assertEquals(138.24, updatedLine.dmpl__Tax2__c, 'Updated Tax2 should be 138.24');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Name__c, 'Updated Tax2 Name should be SGST');
        System.assertEquals(6, updatedLine.dmpl__Tax2Rate__c, 'Updated Tax2 Rate should be 6%');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Type__c, 'Updated Tax2 Type should be SGST');
        System.assertEquals(2400, updatedLine.dmpl__BaseAmount__c, 'Updated Base Amount should be 2400');
        System.assertEquals(0, updatedLine.dmpl__NetSchemeDiscount__c, 'Updated Net Scheme Discount should be 0');
        System.assertEquals(276.48, updatedLine.dmpl__TaxAmount__c, 'Updated Tax Amount should be 276.48');
        System.assertEquals(2580.48, updatedLine.dmpl__GrossAmount__c, 'Updated Gross Amount should be 2580.48');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(2304, updatedSaleOrder.dmpl__LineSubTotal__c, 'SaleOrder Line Sub Total should be 2304');
        System.assertEquals(2400, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'SaleOrder Base Amount should be 2400');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'SaleOrder Scheme Discount should be 0');
        System.assertEquals(96, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'SaleOrder Discount Amount should be 96');
        System.assertEquals(276.48, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'SaleOrder Tax Amount should be 276.48');
        System.assertEquals(2580.48, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'SaleOrder Gross Amount should be 2580.48');
        System.assertEquals(2580, updatedSaleOrder.dmpl__OpenAmount__c, 'SaleOrder Open Amount should be 2580');
        System.assertEquals(2580.48, updatedSaleOrder.dmpl__OutstandingAmount__c, 'SaleOrder Outstanding Amount should be 2580.48');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderWithSchemeAutoApplyDiscountAmount() {
        SaleOrderMasterData.schemeAutoApplyDiscountAmountData();
        Account customerAccount2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount2.Id,
            partnerAccount4.Id, 
            branch4.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item5.Id,
            10,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(1000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(1000, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 1000');
        System.assertEquals(400, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(516, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 540');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(516, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 540');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1032, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 1080');
        System.assertEquals(9632, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 10080');
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(8600, updatedSO.dmpl__LineSubTotal__c, 'Line Sub Total should be 8600');
        System.assertEquals(10000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
        System.assertEquals(1000, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 1000');
        System.assertEquals(400, updatedSO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 400');
        System.assertEquals(1032, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 1032');
        System.assertEquals(1032, updatedSO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 1032');
        System.assertEquals(9632, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 9632');
        System.assertEquals(9632, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 9632');
        System.assertEquals(9632, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 9632');
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithSchemeAutoApplyDiscountAmountEdit() {
        SaleOrderMasterData.schemeAutoApplyDiscountAmountData();
        Account customerAccount2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount2.Id,
            partnerAccount4.Id, 
            branch4.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item5.Id,
            10,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(1000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(1000, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 1000');
        System.assertEquals(400, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(516, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 516');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(516, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 516');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1032, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 1032');
        System.assertEquals(9632, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9632');
        createdSOL.dmpl__Quantity__c = 20;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(20000.00, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(2000, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 2000');
        System.assertEquals(800, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1032, updatedSOL.dmpl__Tax1__c, 'Tax1 amount should be 1032');
        System.assertEquals(6, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(1032, updatedSOL.dmpl__Tax2__c, 'Tax2 amount should be 1032');
        System.assertEquals(6, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(2064, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2064');
        System.assertEquals(19264, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19264 ');
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(17200, updatedSO.dmpl__LineSubTotal__c, 'Line Sub Total should be 17200');
        System.assertEquals(20000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 20000');
        System.assertEquals(2000, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 2000');
        System.assertEquals(800, updatedSO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 800');
        System.assertEquals(2064, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2064');
        System.assertEquals(2064, updatedSO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 2064');
        System.assertEquals(19264, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 19264');
        System.assertEquals(19264, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 19264');
        System.assertEquals(19264, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 19264');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountAmountNew() {
        Test.startTest();
        SaleOrderMasterData.saleOrderLineWithSchemeAutoApplyDiscountAmountNewData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Discount 1', finalOrder.dmpl__DiscountGroupId__r.Name, 'Discount Group should match');
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(12, orderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(12000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(480, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(1262.40, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(10520.00, finalOrder.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(12000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should match');
        System.assertEquals(480, finalOrder.dmpl__TotalDiscountAmount__c, 'Discount Amount should match');
        System.assertEquals(1262.40, finalOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, finalOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should match');
        System.assertEquals(11782, finalOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(11782.40, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountPercentageNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item.Id,
            2,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 576');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4368, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 4368');
        System.assertEquals(4800, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 4800');
        System.assertEquals(240, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
    }

    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountPercentageEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        SaleOrderMasterData.createAutoApplySchemeDiscountPercentageData(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            priceList.Id
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item.Id,
            2,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 576');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4368, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 4368');
        System.assertEquals(4800, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 4800');
        System.assertEquals(240, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
        createdSOL.dmpl__Quantity__c = 1;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2400, updatedSOL.dmpl__UnitPrice__c, 'Updated Unit Price should be 2400');
        System.assertEquals(1, updatedSOL.dmpl__Quantity__c, 'Updated Quantity should be 1');
        System.assertEquals(138.24, updatedSOL.dmpl__Tax1__c, 'Updated Tax1 should be 138.24');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Updated Tax1 Name should be CGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax1Rate__c, 'Updated Tax1 Rate should be 6%');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Updated Tax1 Type should be CGST');
        System.assertEquals(138.24, updatedSOL.dmpl__Tax2__c, 'Updated Tax2 should be 138.24');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Updated Tax2 Name should be SGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax2Rate__c, 'Updated Tax2 Rate should be 6%');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Updated Tax2 Type should be SGST');
        System.assertEquals(2400, updatedSOL.dmpl__BaseAmount__c, 'Updated Base Amount should be 2400');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Updated Net Scheme Discount should be 0');
        System.assertEquals(276.48, updatedSOL.dmpl__TaxAmount__c, 'Updated Tax Amount should be 276.48');
        System.assertEquals(2580.48, updatedSOL.dmpl__GrossAmount__c, 'Updated Gross Amount should be 2580.48');
    }
 
    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountAmountEdit() {
        SaleOrderMasterData.saleOrderLineWithSchemeAutoApplyDiscountAmountNewData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );
        saleOrderLine.dmpl__Quantity__c = 5;
        update saleOrderLine;
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        Test.stopTest();
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(288, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(288,orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST',orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6,orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST',orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(5000,orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0,orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(200,orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(576,orderLine.dmpl__TaxAmount__c, 'Net TaxAmount should match');
        System.assertEquals(5376,orderLine.dmpl__GrossAmount__c,'Net Gross Amount should match');
        dmpl__SaleOrder__c so =SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4800.00, so.dmpl__LineSubTotal__c, 'Line Subtotal mismatch');
        System.assertEquals(5000.00, so.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0.00, so.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount mismatch');
        System.assertEquals(200.00, so.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        System.assertEquals(576.00, so.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(576.00, so.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');      
    }
    
    @isTest
    static void saleOrderLineAddingItemWithIsSKURequiredTrueNewNegative() {
        SaleOrderMasterData.saleOrderLineAddingItemWithIsSKURequiredTrueNewNegativeData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                createdSaleOrder.Id,
                item.Id,
                3,
                null
            );
            System.assert(false, 'Expected exception was not thrown.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('The product you selected mandates selection of SKU'),
                'Expected SKU valIdation error not thrown. Actual: ' + e.getMessage()
            );
        }
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void addingItemWithIsSKURequiredTrueEditNegative() {
        SaleOrderMasterData.saleOrderLineAddingItemWithIsSKURequiredTrueEditNegativeData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8'); 
        dmpl__SKU__c sku = TestDataHelpers.getSku('SKU 2');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            42,
            sku.Id
        );
        dmpl__SaleOrderLine__c soLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500.00, soLine.dmpl__UnitPrice__c, 'Price should match');
        System.assertEquals(8820.00, soLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', soLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, soLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', soLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(8820.00, soLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', soLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, soLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', soLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(63000.00, soLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0.00, soLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(0.00, soLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(17640.00, soLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(80640.00, soLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(63000.00, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(63000.00, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0.00, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(0.00, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(17640.00, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(17640.00, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        try {
            soLine.dmpl__SKUId__c = null;
            update soLine;
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('The product you selected mandates selection of SKU'),
                'Expected SKU valIdation error not thrown. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void SchemeApplicabilityForPartnerAccDefinedNew(){
        SaleOrderMasterData.SchemeApplicabilityForPartnerAccDefinedNewData();
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 4', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(12, orderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(12000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(480, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(1262.40, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        Test.stopTest();
    }
 
    @isTest
	static void schemeApplicabilityForPartnerAccDefinedEditQuantity1() {
        SaleOrderMasterData.SchemeApplicabilityForPartnerAccDefinedNewData();
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 8;
        update saleOrderLine;
        saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(8, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 8');
        System.assertEquals(1000, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(8000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(460.8, saleOrderLine.dmpl__Tax1__c, 'Tax1 mismatch');
        System.assertEquals(460.8, saleOrderLine.dmpl__Tax2__c, 'Tax2 mismatch');
        System.assertEquals(320, saleOrderLine.dmpl__NetDiscount__c, 'Net Discount should be null');
        System.assertEquals(0, saleOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be null');
        System.assertEquals(7680, saleOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(8601.6, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        Test.stopTest();
    }
 
 	@isTest
	static void schemeApplicabilityForPartnerAccDefinedEditQuantity2() {
        SaleOrderMasterData.SchemeApplicabilityForPartnerAccDefinedNewData();
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null
        );
        saleOrderLine.dmpl__Quantity__c = 14;
        update saleOrderLine;
        saleOrderLine = SaleOrderDataHelper.getSaleOrderLine( saleOrder.Id);
        System.assertEquals(14, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 14');
        System.assertEquals(1000, saleOrderLine.dmpl__UnitPrice__c);
        System.assertEquals(14000, saleOrderLine.dmpl__BaseAmount__c);
        System.assertEquals(746.4, saleOrderLine.dmpl__Tax1__c);
        System.assertEquals(746.4, saleOrderLine.dmpl__Tax2__c);
        System.assertEquals(560, saleOrderLine.dmpl__NetDiscount__c);
        System.assertEquals(1000, saleOrderLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(12440, saleOrderLine.dmpl__Amount__c);
        System.assertEquals(13932.80, saleOrderLine.dmpl__GrossAmount__c);
        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(12440, updatedOrder.dmpl__LineSubTotal__c);
        System.assertEquals(14000, updatedOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(1000, updatedOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(560, updatedOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(1492.8, updatedOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(13932.8, updatedOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(13933, updatedOrder.dmpl__OpenAmount__c);
        System.assertEquals(13932.8, updatedOrder.dmpl__OutstandingAmount__c);
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityValIditySchemeHasPassedNewNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item.Id,
            15,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3150, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(3150, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(6300, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 6300');
        System.assertEquals(22500, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 22500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(28800, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28800');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder();
        System.assertEquals(22500, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 22500');
        System.assertEquals(22500, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 28800');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(6300, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(28800, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 28800');
        System.assertEquals(28800, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 28800');
    }

    @isTest
    static void schemeApplicabilityValIditySchemeHasPassedEditNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item.Id,
            15,
            null
        );   
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3150, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(3150, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(6300, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 6300');
        System.assertEquals(22500, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 22500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(28800, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28800');
        createdSOL.dmpl__Quantity__c = 20;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);     
        System.assertNotEquals(null, updatedSOL.Id, 'Sale Order Line should be updated');   
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(30000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(4200, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals(4200, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(38400, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(8400, updatedSOL.dmpl__TaxAmount__c, 'Net Scheme Discount should be 8400');
        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder();
        System.assertEquals(30000, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 38400');
        System.assertEquals(30000, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 38400');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 8400');
        System.assertEquals(8400, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(38400, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 38400');
        System.assertEquals(38400, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 38400');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithSupercedingItemPositive() {
        SaleOrderMasterData.editSaleOrderLineWithSupercedingItemPositiveData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item15 = TestDataHelpers.getItem('Item 15');
        dmpl__Item__c item16 = TestDataHelpers.getItem('Item 16');
        Test.startTest();
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item15.Id,
            10,
            null
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item16.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 2100');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2100');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');  
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertEquals(15000, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 15000');
        System.assertEquals(15000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 15000');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(4200, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(19200, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 19200');
        System.assertEquals(19200.00, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 19200.00');
        System.assertEquals(19200, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 19200');
        System.assertEquals(19200.00, updatedSaleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 19200.00');
    }
    
    @isTest
    static void editSaleOrderLineWithSupercedingItemPositive() {
        Test.startTest();
        SaleOrderMasterData.editSaleOrderLineWithSupercedingItemPositiveData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item15 = TestDataHelpers.getItem('Item 15');
        dmpl__Item__c item16 = TestDataHelpers.getItem('Item 16');
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item15.Id,
            10,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        createdSOL.dmpl__Quantity__c = 5;
        update createdSOL;
        Test.stopTest();
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(item16.Id, updatedSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(5, updatedSOL.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(7500, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 7500');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1050, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 1050');
        System.assertEquals(1050, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 1050');
        System.assertEquals(2100, updatedSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(9600, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9600');
    }
    
    @isTest
    static void saleOrderLineWithAlternateItemEditPositive() {
        Test.startTest();
        SaleOrderMasterData.createSaleOrderLineWithAlternateItemData();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item13 = TestDataHelpers.getItem('Item 13');
        dmpl__Item__c item14 = TestDataHelpers.getItem('Item 14');
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.getItemAlternate(item14.Id);
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item14.Id,
            10,
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item13.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 4200');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        createdSOL.dmpl__Quantity__c = 5;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, updatedSOL.Id, 'Sale Order Line should be updated');
        System.assertEquals(item13.Id, updatedSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1050, updatedSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(1050, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 1050');
        System.assertEquals(2100, updatedSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(7500, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 7500');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(9600, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9600');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(7500, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 7500');
        System.assertEquals(7500, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 7500');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(2100, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(2100, updatedSaleOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2100');
        System.assertEquals(9600, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 9600');
        System.assertEquals(9600, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 9600');
        System.assertEquals(9600, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 9600');
    }

    @isTest
    static void saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        SaleOrderMasterData.saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetData(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            item1.Id
        );
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item1.Id,
            20,  
            null
        );
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(4200, createdSOL.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4200, createdSOL.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(30000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(null, createdSOL.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(30000, updatedOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 30000');
        System.assertEquals(30000, updatedOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 30000');
        System.assertEquals(0, updatedOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, updatedOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 8400');
        System.assertEquals(8400, updatedOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 8400');
        System.assertEquals(38400, updatedOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals(38400, updatedOrder.dmpl__OpenAmount__c, 'Open Amount should be 38400');
        System.assertEquals(38400, updatedOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 38400');
        createdSOL.dmpl__Quantity__c = 12;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);  
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(2520, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 2520');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2520, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 2520');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(18000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 18000');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(5040, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 23040');
        System.assertEquals(null, updatedSOL.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(18000, finalOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 18000');
        System.assertEquals(18000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 18000');
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, finalOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(5040, finalOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 5040');
        System.assertEquals(5040, finalOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 5040');
        System.assertEquals(23040, finalOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 23040');
        System.assertEquals(23040, finalOrder.dmpl__OpenAmount__c, 'Open Amount should be 23040');
        System.assertEquals(23040, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 23040');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineQtyAsZeroNewNegative(){       
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
            try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                item.Id,
                0, 
                null
            );
            System.assert(false, 'Exception should have been thrown for zero quantity');
            }catch (DmlException e) {
                System.assert(
                e.getMessage().contains('Quantity should not be less than 0') || 
                e.getMessage().toLowerCase().contains('quantity'), 
                'Expected quantity-related error. Actual message: ' + e.getMessage()
            );
        }
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals(Date.today(), saleOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineQuantityZeroEditNegative() {
        Test.startTest();
        SaleOrderMasterData.saleOrderLineQuantityZeroEditNegativeData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            5,
            null    
        );
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(finalOrder.Id);
        System.assertEquals('Draft', finalOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals(System.today(), finalOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(5, orderLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(288, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(288, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(5000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(200, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(576, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(5376, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(4800, finalOrder.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(5000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should match');
        System.assertEquals(200, finalOrder.dmpl__TotalDiscountAmount__c, 'Total Discount should match');
        System.assertEquals(576, finalOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax should match');
        System.assertEquals(576, finalOrder.dmpl__TotalTaxAmount__c, 'Total Tax should match');
        System.assertEquals(5376, finalOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross should match');
        System.assertEquals(5376, finalOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(5376, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        try {
            orderLine.dmpl__Quantity__c = 0;
            update orderLine;
            System.assert(false, 'Exception should have been thrown for zero quantity');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Quantity should not be less than 0') ||
                e.getMessage().toLowerCase().contains('quantity'),
                'Expected quantity-related error. Actual message: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void itemSKUWithIsDefaultTrueAddingValIdationNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7','Product');
        item.dmpl__ItemCode__c = '876543';
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 3', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                createdSaleOrder.Id,
                item.Id,
                3,
                null
            );
            System.assert(false, 'Exception should have been thrown for default SKU');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The product you selected mandates selection of SKU'), 
                          'Expected error message for default SKU. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createDeliveryOrderFromReleaseButtonPositive() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals(branch1.Id, saleOrder.dmpl__BranchId__c, 'Account Name should match');
        System.assertEquals(partnerAccount1.Id, saleOrder.dmpl__PartnerAccountId__c, 'Account Name should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item7.id, 2000);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item7.Id, taxGroupGST12.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1',partnerAccount1.Id,branch1.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item7.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch1, 'Warehouse');
        dmpl__SaleOrderLine__c saleOrderline = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder,
            item7,
            10,
            taxGroupGST12,
            storageLocation
        );
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(item7.Id, orderLine.dmpl__ItemId__c, 'item 7');
        System.assertEquals(taxGroupGST12.Id, orderLine.dmpl__TaxGroupId__c, 'Tax group');
        System.assertEquals(storageLocation.Id, orderLine.dmpl__StorageLocationId__c, 'Tax group');

        System.assertEquals(10, orderLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(2000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(1152, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(1152, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(20000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(800, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(2304, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(21504, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        dmpl__SaleOrder__c autoUpdatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', autoUpdatedSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals(System.today(), autoUpdatedSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', autoUpdatedSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(21504, autoUpdatedSaleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should Match');
        System.assertEquals(21504, autoUpdatedSaleOrder.dmpl__OutstandingAmount__c, 'Total Outstanding Amount should Match');
        System.assertEquals(2304, autoUpdatedSaleOrder.dmpl__TotalLineTaxAmount__c, 'Total Line tax Amount should Match');
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, true);
        System.debug('Before update');
        System.debug('PerformReleaseFulfilment:'+autoUpdatedSaleOrder.dmpl__PerformReleaseFulfilment__c);
        System.debug('Status:'+autoUpdatedSaleOrder.dmpl__Status__c);
        System.debug('IsFulfilmentReleased:'+autoUpdatedSaleOrder.dmpl__IsFulfilmentReleased__c);
        autoUpdatedSaleOrder.dmpl__SalesExecutiveId__c = resource2.Id;
        autoUpdatedSaleOrder.dmpl__PerformReleaseFulfilment__c = true;
        autoUpdatedSaleOrder.dmpl__Status__c = 'Fulfilment';
        update autoUpdatedSaleOrder;
        System.debug('After update 1');
        System.debug('PerformReleaseFulfilment'+autoUpdatedSaleOrder.dmpl__PerformReleaseFulfilment__c);
        System.debug('Status'+autoUpdatedSaleOrder.dmpl__Status__c);
        System.debug('IsFulfilmentReleased:'+autoUpdatedSaleOrder.dmpl__IsFulfilmentReleased__c);
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.debug('After update 2');
        System.debug('PerformReleaseFulfilment'+updatedSaleOrder.dmpl__PerformReleaseFulfilment__c);
        System.debug('Status'+updatedSaleOrder.dmpl__Status__c);
        System.debug('IsFulfilmentReleased:'+updatedSaleOrder.dmpl__IsFulfilmentReleased__c);
        System.debug('Inventory Fulfillments: '+[Select Id FROM dmpl__InventoryFulfillment__c]);
        dmpl__InventoryFulfillment__c inventoryFulfilment = SaleOrderDataHelper.getInventoryFulfillment(updatedSaleOrder.Id);
        System.assertEquals(updatedSaleOrder.dmpl__PartnerAccountId__c, inventoryFulfilment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(updatedSaleOrder.dmpl__BranchId__c, inventoryFulfilment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(updatedSaleOrder.dmpl__AccountId__c, inventoryFulfilment.dmpl__AccountId__c, 'Account should match');
        System.assertEquals(updatedSaleOrder.Id, inventoryFulfilment.dmpl__SaleOrderId__c, 'Sale Order should match');
        dmpl__InventoryFulfillmentOrderLine__c inventoryFulfilmentLine = SaleOrderDataHelper.getInventoryFulfillmentLine(inventoryFulfilment.Id);
        System.assertEquals(inventoryFulfilment.Id, inventoryFulfilmentLine.dmpl__FulfillmentId__c, 'Inventory Fulfilment should match');
        System.assertEquals(item7.Id, inventoryFulfilmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, inventoryFulfilmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(updatedSaleOrder.Id, inventoryFulfilmentLine.dmpl__SaleOrderLineId__c, 'Sale Order should match');
        System.assertEquals(storageLocation.Id, inventoryFulfilmentLine.dmpl__StorageLocationId__c, 'Storage Location should match');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderwithNegativeQuantityNegative(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        SaleOrderMasterData.createSaleOrderwithNegativeQuantityNegativeData(partnerAccount.Id, branch);
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        try {
            dmpl__SaleOrderLine__c saleOrderline = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder,
                item7,
                -1,
                taxGroupGST12,
                storageLocation
            );
            System.assert(false, 'Expected an exception to be thrown for Negative quantity');
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('The input field dmpl__PendingAllocatedInvoicedQuantity__c expects postive decimals');
            System.assertEquals(true, correctException, 'Expected validation error for Negatice quantity but got: ' + errorMsg);
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoiceFromReleaseButtonWithoutAllocation() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 14);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2100');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseInvoice__c = true;
        updatedSaleOrder.dmpl__Status__c = 'Invoicing';
        update updatedSaleOrder;
        dmpl__SaleInvoice__c createdInvoice = SaleOrderDataHelper.getSaleInvoice(saleOrder.Id);
        System.assertNotEquals(null, createdInvoice.Id, 'Sale Invoice should be created');
        System.assertEquals('Customer 1', createdInvoice.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdInvoice.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', createdInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(0, createdInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(19200, createdInvoice.dmpl__TotalAmount__c, 'Total Amount should be 19200');
        System.assertEquals(19200, createdInvoice.dmpl__OpenAmount__c, 'Open Amount should be 19200');
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoiceFromReleaseButtonWithoutAllocationManual() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 14);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2100');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseInvoice__c = true;
        updatedSaleOrder.dmpl__Status__c = 'Invoicing';
        update updatedSaleOrder;
        dmpl__SaleInvoice__c createdInvoice = SaleOrderDataHelper.getSaleInvoice(saleOrder.Id);
        System.assertNotEquals(null, createdInvoice.Id, 'Sale Invoice should be created');
        System.assertEquals('Customer 1', createdInvoice.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdInvoice.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', createdInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(0, createdInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(19200, createdInvoice.dmpl__TotalAmount__c, 'Total Amount should be 19200');
        System.assertEquals(19200, createdInvoice.dmpl__OpenAmount__c, 'Open Amount should be 19200');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithoutPriceListNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 21', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(null, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 0');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(0, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 0');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(0, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 0');
    }

    @isTest
    static void createSaleOrderWithoutPriceListEdit() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 21', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(null, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 0');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(0, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 0');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(0, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 0');
        System.assertEquals(0, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 0');
        createdSOL.dmpl__Quantity__c = 5;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(5, updatedSOL.dmpl__Quantity__c, 'Quantity should be updated to 0');
        System.assertEquals(null, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should remain null');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
    }

    @isTest
    static void createFulfillmentFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Product');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2000);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(1152, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1152');
        System.assertEquals(1152, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 1152');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(20000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(800, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals(2304, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2304');
        System.assertEquals(21504, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 21504');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseFulfilment__c = true;
        update updatedSaleOrder;
        dmpl__SaleOrder__c modifiedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__InventoryFulfillment__c inventoryFulfilment = SaleOrderDataHelper.getInventoryFulfillment(modifiedSaleOrder.Id);
        System.assertEquals('Partner 1', inventoryFulfilment.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', inventoryFulfilment.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', inventoryFulfilment.dmpl__AccountId__r.Name, 'Account should match');
        System.assertEquals(modifiedSaleOrder.Id, inventoryFulfilment.dmpl__SaleOrderId__c, 'Sale Order should match');
        Test.stopTest();
    }
    
    @isTest
    static void createAllocationFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(partner.Id, null, branch.Id);
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            shipment.Id,
            item.Id,
            null,
            10
        );
        dmpl__ShipmentLine__c updatedShipMentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.debug('Before'+ item);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2000);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(1152, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1152');
        System.assertEquals(1152, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 1152');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(20000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(800, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals(2304, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2304');
        System.assertEquals(21504, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 21504');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseFulfilment__c = true;
        update updatedSaleOrder;
        // dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner.Id,
            supplierAccount.Id,
            branch.Id,
            purchaseOrder.Id,
            shipment.Id
        );
        dmpl__GoodsReceipt__c updatedGoodReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        // System.debug(item.Id);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(goodsReceipt.Id, item.Id, 10, 10, 10);
        // dmpl__GoodsReceiptLine__c goodReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        //     goodReceipt.Id,
        //     item.Id,
        //     null,
        //     2
        // );
        dmpl__GoodsReceipt__c modifiedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        modifiedGoodsReceipt.dmpl__PerformReceive__c = true;
        modifiedGoodsReceipt.dmpl__Status__c = 'Receive';
        update modifiedGoodsReceipt;
        // System.debug('After goods receipt');
        System.debug('GRN' + [Select Id, dmpl__Status__c, dmpl__PerformReceive__c FROM dmpl__GoodsReceipt__c]);
        System.debug('Goods Receipt Line: ' + [SELECT Id, dmpl__ItemId__c, dmpl__ReceivedQuantity__c, dmpl__OrderedQuantity__c, dmpl__SupplierQuantity__c, dmpl__IsILPostingApproved__c, dmpl__IsApproved__c, dmpl__DamagedQuantity__c FROM dmpl__GoodsReceiptLine__c]);
        System.debug('Inventory stock after goods receipt: ' + [SELECT Id, dmpl__QuantityAvailable__c FROM dmpl__InventoryStock__c]);
        dmpl__SaleOrder__c modifiedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__InventoryFulfillment__c inventoryFulfilment = SaleOrderDataHelper.getInventoryFulfillment(modifiedSaleOrder.Id);
        System.assertEquals('Partner 1', inventoryFulfilment.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', inventoryFulfilment.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', inventoryFulfilment.dmpl__AccountId__r.Name, 'Account should match');
        System.assertEquals(modifiedSaleOrder.Id, inventoryFulfilment.dmpl__SaleOrderId__c, 'Sale Order should match');
        dmpl__InventoryFulfillmentOrderLine__c inventoryFulfilmentLine = SaleOrderDataHelper.getInventoryFulfillmentLine(inventoryFulfilment.Id);
        System.assertEquals(inventoryFulfilment.Id, inventoryFulfilmentLine.dmpl__FulfillmentId__c, 'Inventory Fulfillment should match');
        System.assertEquals(item.Id, inventoryFulfilmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, inventoryFulfilmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(createdSOL.Id, inventoryFulfilmentLine.dmpl__SaleOrderLineId__c, 'Sale Order should match');
        inventoryFulfilment.dmpl__PerformAllocation__c = true;
        update inventoryFulfilment;
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = SaleOrderDataHelper.getInventoryFulfillmentAllocationLine(inventoryFulfilment.Id);
        System.assertNotEquals(null, allocationLine, 'Allocation Line should be created');
        System.assertEquals(inventoryFulfilment.Id, allocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(item.Id, allocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, allocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(createdSOL.Id, allocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
        Test.stopTest();
    }

    @isTest
    static void saleInvoiceCreationFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2400);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, 10, storageLocation);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(1382.4, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1382.4');
        System.assertEquals(1382.4, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 1382.4');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(24000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 24000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(960, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 960');
        System.assertEquals(2764.8, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2764.8');
        System.assertEquals(25804.8, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 25804.8');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseInvoice__c = true;
        updatedSaleOrder.dmpl__Status__c = 'Invoicing';
        update updatedSaleOrder;
        Test.stopTest();
        dmpl__SaleInvoice__c createdInvoice = SaleOrderDataHelper.getSaleInvoice(saleOrder.Id);
        System.assertNotEquals(null, createdInvoice.Id, 'Sale Invoice should be created');
        System.assertEquals('Customer 1', createdInvoice.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdInvoice.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', createdInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(25805, createdInvoice.dmpl__TotalAmount__c, 'Total Amount should be 25805');
        System.assertEquals(24000, createdInvoice.dmpl__TotalLineBaseAmount__c, 'Line Base Amount should be 24000');
        System.assertEquals(960, createdInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 960');
        System.assertEquals(25805, createdInvoice.dmpl__OpenAmount__c, 'Open Amount should be 25805');
        dmpl__SaleInvoiceLine__c createdInvoiceLine = SaleOrderDataHelper.getSaleInvoiceLine(createdInvoice.Id);
        System.assertNotEquals(null, createdInvoiceLine.Id, 'Sale Invoice Line should be created');
        System.assertEquals(2400, createdInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(10, createdInvoiceLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(24000, createdInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 24000');
        System.assertEquals(0, createdInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(960, createdInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 960');
        System.assertEquals(2764.8, createdInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 2764.8');
        System.assertEquals(25804.8, createdInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 25804.8');
    }

    @isTest
    static void createSaleOrderWithFulfillmentFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Product');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2000);
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST14_6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST12.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item.Id, 10);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(10, createdSOL.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(1152, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 1152');
        System.assertEquals(1152, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 1152');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(20000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(800, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals(2304, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2304');
        System.assertEquals(21504, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 21504');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseFulfilment__c = true;
        update updatedSaleOrder;
        dmpl__SaleOrder__c modifiedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__InventoryFulfillment__c inventoryFulfilment = SaleOrderDataHelper.getInventoryFulfillment(modifiedSaleOrder.Id);
        System.assertEquals('Partner 1', inventoryFulfilment.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', inventoryFulfilment.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', inventoryFulfilment.dmpl__AccountId__r.Name, 'Account should match');
        System.assertEquals(modifiedSaleOrder.Id, inventoryFulfilment.dmpl__SaleOrderId__c, 'Sale Order should match');
        dmpl__InventoryFulfillmentOrderLine__c inventoryFulfilmentLine = SaleOrderDataHelper.getInventoryFulfillmentLine(inventoryFulfilment.Id);
        System.assertEquals(inventoryFulfilment.Id, inventoryFulfilmentLine.dmpl__FulfillmentId__c, 'Inventory Fulfilment should match');
        System.assertEquals(item.Id, inventoryFulfilmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, inventoryFulfilmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(createdSOL.Id, inventoryFulfilmentLine.dmpl__SaleOrderLineId__c, 'Sale Order should match');
        System.assertEquals(inventoryFulfilment.Id, inventoryFulfilmentLine.dmpl__FulfillmentId__c, 'Fulfillment ID should match');
        Test.stopTest();
    }

    @isTest
    static void saleOrderPartialCancelFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, 20, storageLocation);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.debug('Created Sale Order Line: ' + createdSOL);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20, createdSOL.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(4032, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 4032');
        System.assertEquals(4032, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2016');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(30000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1200, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 1200');
        System.assertEquals(8064, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 8064');
        System.assertEquals(36864, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 36864');
        System.assertEquals(28800, createdSOL.dmpl__Amount__c, 'Amount should be 28800');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseFulfilment__c = true;
        update updatedSaleOrder;
        dmpl__SaleOrder__c modifiedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__InventoryFulfillment__c inventoryFulfilment = SaleOrderDataHelper.getInventoryFulfillment(modifiedSaleOrder.Id);
        System.assertEquals('Partner 1', inventoryFulfilment.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', inventoryFulfilment.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', inventoryFulfilment.dmpl__AccountId__r.Name, 'Account should match');
        System.assertEquals(modifiedSaleOrder.Id, inventoryFulfilment.dmpl__SaleOrderId__c, 'Sale Order should match');
        Test.stopTest();
    }

    @isTest()
    static void createDeliveryOrderFromReleaseButton() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        item.dmpl__TrackInventory__c = true;
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partner.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, 20, storageLocation);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.debug('Created Sale Order Line: ' + createdSOL);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2000');
        System.assertEquals(20, createdSOL.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(4032, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 4032');
        System.assertEquals(4032, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2016');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(30000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1200, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 1200');
        System.assertEquals(8064, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 8064');
        System.assertEquals(36864, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 36864');
        System.assertEquals(28800, createdSOL.dmpl__Amount__c, 'Amount should be 28800');
        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.startTest();
        updatedSaleOrder.dmpl__PerformReleaseInvoice__c = true;
        updatedSaleOrder.dmpl__Status__c = 'Invoicing';
        update updatedSaleOrder;
        Test.stopTest();
        dmpl__SaleInvoice__c createdInvoice = SaleOrderDataHelper.getSaleInvoice(saleOrder.Id);
        System.assertNotEquals(null, createdInvoice.Id, 'Sale Invoice should be created');
        System.assertEquals('Customer 1', createdInvoice.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdInvoice.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Draft', createdInvoice.dmpl__Status__c, 'Status should be Draft');
        dmpl__SaleInvoiceLine__c createdInvoiceLine = SaleOrderDataHelper.getSaleInvoiceLine(createdInvoice.Id);
        System.assertEquals(20, createdInvoiceLine.dmpl__Quantity__c, 'Total Line Quantity should be 20');
        System.assertEquals(1500, createdInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, createdInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(4032, createdInvoiceLine.dmpl__Tax1__c, 'Tax1 amount should be 4032');
        System.assertEquals(4032, createdInvoiceLine.dmpl__Tax2__c, 'Tax2 amount should be 2016');
        System.assertEquals('CGST', createdInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1200, createdInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 1200');
        System.assertEquals(8064, createdInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 8064');
        System.assertEquals(36864, createdInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 36864');
        updatedSaleOrder.dmpl__PerformReleaseDelivery__c = true;
        updatedSaleOrder.dmpl__Status__c = 'Delivery';
        update updatedSaleOrder;
        dmpl__DeliveryOrder__c createdDeliveryOrder = SaleOrderDataHelper.getDeliveryOrder(saleOrder.Id);
        System.assertNotEquals(null, createdDeliveryOrder.Id, 'Delivery Order should be created');
    }
}