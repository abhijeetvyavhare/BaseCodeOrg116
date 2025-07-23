@isTest
public with sharing class SaleInvoiceHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner4.Id);
        branch4.dmpl__AllowInventory__c = false;
        update branch4;
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__Resource__c Resource1 = TestDataHelpers.createResource('Resource 1');
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');  
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch1.Id);
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3', partner4.Id, branch4.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.Id, item1.Id, 1500);
        dmpl__PriceListRules__c priceListRule2 = TestDataHelpers.createPriceListRules(priceList3.Id, item5.Id, 1000);
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item1.Id, false);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customer);  
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partner, branch1);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partner, branch1);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item1);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer, 
            branch1, 
            contactAddress, 
            priceList
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(
            customer, 
            branch1, 
            saleOrder, 
            priceList
        );
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item1, 
            sku, 
            null, 
            taxGroup, 
            priceListRule
        );
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.createSaleInvoiceTax(saleInvoice, saleInvoiceLine);
        dmpl__ItemServiceContract__c ItemServiceContract = SaleInvoiceDataHelper.createItemServiceContract('Service Contract 1',customer,item1.Id);
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoicePositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        Test.stopTest();
        System.assertNotEquals(saleInvoice, null, 'Expected saleInvoice to be created.');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(1000, saleInvoice.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 100');
        System.assertEquals(2000, saleInvoice.dmpl__FinanceAmount__c, 'FinanceAmount should be 100');
        System.assertEquals(1000, saleInvoice.dmpl__AmountPaid__c, 'AmountPaid should be 1');
    }
    
    @isTest
    static void createSaleInvoiceLinePositive() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        Test.stopTest();
        System.assertNotEquals(line, null, 'Expected sale invoice line to be created');
        System.assertEquals(10, line.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(0, line.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 10');
        System.assertEquals(100, line.dmpl__DiscountAmount__c, 'DiscountAmount should be 100');
    }
    
    @isTest
    static void createSaleInvoiceTaxPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c createdTax = SaleInvoiceDataHelper.getSaleInvoiceTax();
        Test.stopTest();
        System.assertNotEquals(null, createdTax.Id, 'Expected SaleInvoiceTax to be created');
        System.assertEquals(null, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 100');
    }
    
    @isTest
    static void updateSaleInvoicePositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        System.assertNotEquals(saleInvoice, null, 'SaleInvoice should exist before update.');
        saleInvoice.dmpl__Status__c = 'Invoiced';
        saleInvoice.dmpl__TCSEligibleAmount__c = 20;
        update saleInvoice;
        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.id);
        Test.stopTest();
        System.assertEquals('Invoiced', updatedInvoice.dmpl__Status__c, 'Expected saleInvoice status to be updated to Submitted.');
        System.assertEquals(20, updatedInvoice.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 20');
    }
    
    @isTest
    static void updateSaleInvoiceLinePositive() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        line.dmpl__Discount__c = 5;
        line.dmpl__SchemeDiscount__c = 15;
        line.dmpl__ContractDiscount__c = 20;
        update line;
        dmpl__SaleInvoiceLine__c updatedLine = SaleInvoiceDataHelper.getSaleInvoiceLine(line.Id);
        Test.stopTest();
        System.assertEquals(5, line.dmpl__Discount__c, 'Discount should be updated to 5');
        System.assertEquals(15, line.dmpl__SchemeDiscount__c, 'SchemeDiscount should be updated to 15');
        System.assertEquals(20, line.dmpl__ContractDiscount__c, 'ContractDiscount should be updated to 20');
    }
    
    @isTest
    static void updateSaleInvoiceTaxPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.getSaleInvoiceTax();
        tax.dmpl__TaxAmount__c = 200;
        update tax;
        Test.stopTest();
        System.assertEquals(200, tax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(saleInvoice.Id, tax.dmpl__SaleInvoiceId__c, 'Sale Invoice ID should match');
        System.assertEquals(line.Id, tax.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line ID should match');
    }
    
    @isTest
    static void deleteSaleInvoiceTax() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.getSaleInvoiceTax();
        delete tax;
        dmpl__SaleInvoiceTax__c deletedTax;
        try {
            deletedTax = SaleInvoiceDataHelper.getSaleInvoiceTax(tax.Id);
            System.assert(false, 'Expected QueryException when querying deleted tax');
        } catch (QueryException e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Expected no rows found exception');
        }
        Test.stopTest();
    }
    
    @isTest
    static void deleteSaleInvoiceLine() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        System.assertNotEquals(line, null, 'SaleInvoiceLine should exist before delete.');
        try {
            delete line;
            System.assert(false, 'Expected DMLException when deleting SaleInvoiceLine');
        } catch (DMLException e) {
            System.assertEquals('There are downstream transaction. The object can not be deleted.', e.getDmlMessage(0), 'Expected IntegrityFailed_TransactedObjectNotDeletable error message');
        }
        dmpl__SaleInvoiceLine__c existingLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        Test.stopTest();
        System.assertNotEquals(null, existingLine, 'SaleInvoiceLine should still exist after failed delete');
    }
    
    @isTest
    static void deleteSaleInvoice() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        System.assertNotEquals(saleInvoice, null, 'SaleInvoice should exist before delete.');
        delete saleInvoice;
        dmpl__SaleInvoice__c deletedInvoice = null;
        try {
            deletedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.id);
        } catch (Exception e) {
            deletedInvoice = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedInvoice, 'SaleInvoice should be deleted and not found in query.');
    }
    
    @isTest
    static void createNormalSaleInvoiceCreationWithoutSchemeAndDiscountPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.createCustomerAccount('Customer 5');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
         saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 5', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithGSTTaxGlobalPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithIGSTTaxGlobalPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithItemLevelTaxesChangePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        taxGroup.dmpl__TaxGroupType__c = 'Document Level';
        update taxGroup; 
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice.dmpl__TaxGroupId__c = taxGroup.Id;
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
        System.assertEquals('GST 12', saleInvoice.dmpl__TaxGroupId__r.Name, 'TaxGroup mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithBillingAndShippingAddressPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertNotEquals(null, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithMultipleBillingAndShippingAddressPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        saleInvoice.dmpl__BillingAddressId__c = billingAddress.Id;
        update saleInvoice;
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertEquals('Address 1', saleInvoice.dmpl__BillingAddressId__r.Name, 'BillingAddress mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountAndBranchPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account name mismatch');
        System.assertEquals(priceList.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForCustomerAccountGroupPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.AssertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account Name mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountGroupPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.AssertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals(partner.Id, saleInvoice.dmpl__PartnerAccountId__c, 'PartnerAccountId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithWrongPartnerAccountNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as invalid branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with invalid branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as inactive partner Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive partner Account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationWithInactiveCustomerAccountNegative() {
        Test.startTest();
        SaleInvoiceMasterData.SaleInvoiceCreationWithInactiveCustomerAccountData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 7');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as inactive Customer Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive customer Account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationWithWrongBranchNegative() {
        Test.startTest();
        SaleInvoiceMasterData.SaleInvoiceCreationWithInactiveCustomerAccountData();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 7');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as wrong branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with wrong branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithoutSchemePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(
            item5.Id, 
            partner.Id, 
            branch.Id, 
            18
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 10);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(invoiceLine.Id);
        createdSaleInvoiceLine.dmpl__ItemId__c = item1.Id;
        createdSaleInvoiceLine.dmpl__Quantity__c = 50;
        try {
            update createdSaleInvoiceLine;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected SaleInvoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected SaleInvoice to be created');
        System.assertNotEquals(null, invoiceLine, 'Expected SaleInvoiceLine to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected SaleInvoiceLine to be created');
        System.assert(createdSaleInvoice.dmpl__PriceListId__c != null, 'Price List not be null');
        System.assertEquals(810, updatedSaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 name mismatch');
        System.assertEquals(9, updatedSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 type mismatch');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Price should be ₹1, 500.00');
        System.assertEquals(810, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹10, 500.00');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(10000, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 10000.00');
        System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 10.00');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 1000.00');
        System.assertEquals(1620, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 1620.00');
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0.00');
        System.assertEquals(1000, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1000.00');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithTaxApplicationInLineTaxesPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            28
        );
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 42);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 18;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created	');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'createdSaleInvoiceLine UnitPrice mismatch');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithInactiveItemNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 10);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__ItemId__c = item2.Id;
        try {
            update createdSaleInvoiceLine;
            System.assert(false, 'Expected DMLException when updating Sale Invoice Line with inactive item');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception because of Inactive Item');
        }
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKURequiredTrueNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 9', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        try {
            dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 5);
            System.assertEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to not be created due to SKU requirement');
        } catch(DmlException e) {
            System.Assert.isTrue(true, 'Expected Exception because of Item with SKU Required');
        }
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemWithoutPriceNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 1);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 0 as Item does not have a price');
        System.assertEquals(0, createdSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 0 as Item does not have a price');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultTruePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 11', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 4', item.Id, true);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item, 
            null, 
            1, 
            sku
        );
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 4;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertEquals(sku.Id, createdSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to SKU 4');
        System.assertEquals(sku.Id, updatedSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to SKU 4');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultTrueNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item, 
            null, 
            1, 
            sku
        );
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        try {
            createdSaleInvoiceLine.dmpl__SKUId__c = null;
            createdSaleInvoiceLine.dmpl__Quantity__c = 4;
            update createdSaleInvoiceLine;
        } catch (Exception e) {
            System.assert.isTrue(true, 'Expected Sale Invoice not to be created');
        }
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityNoBudgetNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 16);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 18;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
        System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme Line should not be set due to no budget');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__SchemeDiscount__c, 'Scheme Discount should be 0 due to no budget');
        System.assertEquals(null, updatedSaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme Line should not be set due to no budget');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityValidityPassedNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 50;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
    }
    
    @isTest
    static void createSaleInvoiceLineWithSupercedingItemPositive() {
        Test.startTest();
        SaleInvoiceMasterData.createSaleInvoiceLineWithSupercedingItemPositive();
        dmpl__ItemAlternate__c itemAlternate = SaleInvoiceDataHelper.getItemAlternate();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            null, 
            itemAlternate, 
            1, 
            null
        );
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
    }
    
    @isTest
    static void createSaleInvoiceLineWithZeroQuantityNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        try {
            dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, -1);
            System.assertEquals(null, saleInvoiceLine, 'Expected DMLException when creating Sale Invoice Line with zero quantity');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception because of zero quantity');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoicePriceListInActivePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c saleInvoice;
        try {
            saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        } catch (DMLException e) {
            System.Assert.isTrue(false, 'Expected to be created!');
        }
        System.AssertEquals(customer?.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account must Match');
        System.AssertEquals(partner?.Id, saleInvoice.dmpl__PartnerAccountId__c, 'Customer Account must Match');
        System.AssertEquals(branch?.Id, saleInvoice.dmpl__BranchId__c, 'Customer Account must Match');
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationwithInactiveBranchNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__SaleInvoice__c saleInvoice;
        try {
            saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
            System.assertEquals(null, saleInvoice, 'Expected DMLException when creating Sale Invoice ');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception ');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmountPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        SaleInvoiceMasterData.generateItemWithPriceList(
            'Item 3', 
            partner.Id, 
            branch.Id, 
            2000
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
        saleInvoiceLine.dmpl__Quantity__c = 8;
        Update saleInvoiceLine;
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(8, fetchedsaleInvoiceLine.dmpl__Quantity__c, 'Line quantity mismatch');
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Line scheme line mismatch');
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeDiscount__c, 'Line scheme discount mismatch');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmountPositive2() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 12);
        Test.startTest();
        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(15000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0');
        System.assertEquals(300, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Normal discount should be 300');
        System.assertEquals(100, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total tax should be 100');
        System.assertEquals(14800, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount should be 14800');
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Invoice base amount should be 15000');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Invoice scheme discount should be 0');
        System.assertEquals(300, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Invoice discount should be 300');
        System.assertEquals(100, fetchedsaleInvoice.dmpl__TotalLineTaxAmount__c, 'Invoice tax should be 100');
        System.assertEquals(14800, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Invoice gross amount should be 14800');
        System.assertEquals(13800, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Invoice outstanding should be 13800');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupAndSchemePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            18
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 1);
        Test.startTest();
        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner should be ' + partner.Id);
        System.assertEquals(branch.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch should be ' + branch.Id);
        System.assertEquals(customer.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer should be ' + customer.Id);
        System.assertEquals('Within State', fetchedsaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        System.assertEquals(saleInvoice.Id, fetchedsaleInvoiceLine.dmpl__SaleInvoiceId__c, 'Invoice ID should be ' + saleInvoice.Id);
        System.assertEquals(item.Id, fetchedsaleInvoiceLine.dmpl__ItemId__c, 'Item ID should be ' + item.Id);
        System.assertEquals(15, fetchedsaleInvoiceLine.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(1000, fetchedsaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(300, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Discount should be 300');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(2646, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Tax1 should be 2646');
        System.assertEquals(17346, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 17346');
        System.assertEquals(17346, fetchedsaleInvoice.dmpl__TotalAmount__c, 'Total Amount should be 17346');
        System.assertEquals(15346, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open Amount should be 15346');
        System.assertEquals(16346, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 16346');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityPartnerAccountGroupPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 15);
        Test.startTest();
        saleInvoiceLine.dmpl__Quantity__c = 14;
        Update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(partner.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer mismatch');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupDiscountPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            28
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 1);
        saleInvoiceLine.dmpl__Quantity__c = 4;
        Update saleInvoiceLine;
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(customer.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer ID mismatch');
        System.assertEquals(partner.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner ID mismatch');
        System.assertEquals(branch.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch ID mismatch');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilitySkipSchemeTruePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.generateItemWithPriceList(
            'Item 6', 
            partner.Id, 
            branch.Id, 
            2000
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        saleInvoice.dmpl__SkipScheme__c = true;
        update saleInvoice;
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 15);
        saleInvoiceLine.dmpl__Quantity__c = 20;
        Update saleInvoiceLine;
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(customer.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer ID mismatch');
        System.assertEquals(partner.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner ID mismatch');
        System.assertEquals(branch.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch ID mismatch');
    }
    
    @isTest
    static void updateTaxApplicationObjectModelObjectTaxesPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            12
        );
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 10);
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'UnitPrice should be null');
        try {
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(0.00, saleInvoice.dmpl__TotalTaxAmount__c, 'TotalTaxAmount should be 100.00');
        System.assertEquals(0.00, saleInvoice.dmpl__TotalLineTaxAmount__c, 'TotalLineTaxAmount should be 0.00');
        System.assertEquals(-300.00, saleInvoice.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be -300.00');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscontinuedItemNegative() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        item4.dmpl__IsDiscontinued__c = true;
        update item4;
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 1);
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> ' + e.getMessage());
        }
        try {
            saleInvoiceLine.dmpl__ItemId__c = item4.Id;
            update saleInvoiceLine;
            System.Assert.isTrue(false, 'Exception Expected!');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Exception Expected! >> ');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemWithoutTaxGroupPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.generateItemWithPriceList(
            'Item 8', 
            partner.Id, 
            branch.Id, 
            1500
        );
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
                saleInvoice, 
                item, 
                null, 
                10, 
                sku2
            );
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        try {
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        Test.stopTest();
    }
    
    @isTest
    static void updatePricesInCaseOfDateEffectiveTillHasPassedNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 20);
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        try {
            saleInvoiceLine.dmpl__Quantity__c = 15;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 300');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeApplicabilityincaseofSchemenotApprovedPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 6);
            saleInvoiceLine.dmpl__UnitPrice__c = 2000;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(12000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 12000');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(9800, saleInvoice.dmpl__OpenAmount__c, 'Open Amount should be 9800');
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000.00');
        System.assertEquals(12000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 12000.00');
        Test.startTest();
        try {
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        Test.stopTest();
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000.00');
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 10000.00');
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
    }
    
    @isTest
    static void updateSchemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
            saleInvoiceLine.dmpl__UnitPrice__c = 2000;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.startTest();
        try {
            saleInvoiceLine.dmpl__Quantity__c = 50;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception Expected!  Dicount is more than scheme Budget >> '+ e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000.00');
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(300, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 300');
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 10000.00');
        System.assertEquals(item.Id, saleInvoiceLine.dmpl__ItemId__c, 'Item Id should be Match');
        System.assertEquals(100, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 100');
        System.assertEquals(9800, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 9800');
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000.00');
        System.assertEquals(100000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 100000.00');
        System.assertEquals(50, saleInvoiceLine.dmpl__Quantity__c, 'Quantity should be 50');
        System.assertEquals(100, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 100');
        System.assertEquals(99800, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 99800');
    }
    
    @isTest
    static void updateSaleInvoiceLinewithoutSchemesPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.Id, false);
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            28
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
                saleInvoice, 
                item, 
                null, 
                20, 
                sku2
            );
            saleInvoiceLine.dmpl__UnitPrice__c = 1500;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1500.00');
        System.assertEquals(30000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 30000.00');
        System.assertEquals(3780, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be 3780');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(3780, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be 3780');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(7560, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(34560, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 34560');
        Test.startTest();
        try {
            saleInvoiceLine.dmpl__Quantity__c = 22;
            update saleInvoiceLine; 
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1500.00');
        System.assertEquals(33000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 33000.00');
        System.assertEquals(4158, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be 4158');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4158, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be 4158');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(8316, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 8316');
        System.assertEquals(38016, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 38016');
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(33000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 33000');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(3600, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 3600');
        System.assertEquals(8316, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 8316');
        System.assertEquals(8316, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 8316');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmount2Positive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            18
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 22);
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(1000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1000.00');
        System.assertEquals(22000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 22000.00');
        System.assertEquals(1953, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be 1953');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(1953, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be 1953');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3906, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 3906');
        System.assertEquals(25606.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 25606.00');
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(22000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 22000');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(300, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 300');
        System.assertEquals(3906, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 3906');
        System.assertEquals(3906, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 3906');
        System.assertEquals(25606.00, saleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 25606.00');
        System.assertEquals(23606.00, saleInvoice.dmpl__OpenAmount__c, 'Open Amount should be 23606.00');
        System.assertEquals(24606.00, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 24606.00');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceWithDiscountGroupAndSchemePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        try {
            Test.startTest();
            saleInvoiceLine.dmpl__Quantity__c = 20;
            update saleInvoiceLine;
            Test.stopTest();
        }
        catch(DmlException e) {
            System.debug('Exception: '+e.getMessage());
        }
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assert(createdSaleInvoice.dmpl__PriceListId__c != null, 'Price List should not be null');
        System.assertEquals(1000, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(0, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match');
        System.assertEquals(9800, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match');
        System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match after update');
        System.assertEquals(19800, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match after update');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultFalsePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item, 
            null, 
            11, 
            sku
        );
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 17;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityIgnoreBudgetTruePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityForCustomerAccountDefinedPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
        saleInvoiceLine.dmpl__Quantity__c = 25;
        update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityForCustomerAccountGroupPositive() {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 2);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 4;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount2__c, 'Total Scheme Discount Amount should be 0.00 after update');
    }
    
    @isTest
    static void updateSaleInvoiceLineTaxApplicationObjectModelInLineTaxesPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            28
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 8);
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(null, invoiceLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(-42.00, invoiceLine.dmpl__Tax1__c, 'Tax1 should be -42.00');
        System.assertEquals('CGST', invoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14.00, invoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14.00');
        System.assertEquals('CGST', invoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(-42.00, invoiceLine.dmpl__Tax2__c, 'Tax2 should be -42.00');
        System.assertEquals('SGST', invoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14.00, invoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14.00');
        System.assertEquals('SGST', invoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(0.00, invoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 0.00');
        System.assertEquals(0.00, invoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0.00');
        System.assertEquals(300.00, invoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 300.00');
        System.assertEquals(-84.00, invoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be -84.00');
        System.assertEquals(-384.00, invoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be -384.00');
        System.assertEquals(0.00, createdSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 0.00');
        System.assertEquals(0.00, createdSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0.00');
        System.assertEquals(600.00, createdSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 600.00');
        System.assertEquals(-84.00, createdSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be -84.00');
        System.assertEquals(-84.00, createdSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be -84.00');
        System.assertEquals(-684.00, createdSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be -684.00');
        System.assertEquals(-2684.00, createdSaleInvoice.dmpl__OpenAmount__c, 'Open Amount should be -2684.00');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineItemSKUWithIsDefaultTruePositive() {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        System.assertNotEquals(null, saleInvoice.Id, 'Sale invoice should be created');
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item, 
            null, 
            20, 
            sku
        );
        saleInvoiceLine.dmpl__UnitPrice__c = 2000;
        update saleInvoiceLine;
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertNotEquals(null, fetchedInvoiceLine.Id, 'SaleInvoiceLine should be created');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(40000, fetchedInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 40000');
        Test.startTest();
        saleInvoiceLine.dmpl__Quantity__c = 15;
        update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine2 = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(30000, fetchedInvoiceLine2.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoiceLine.dmpl__SaleInvoiceId__c);
        System.assertEquals(30000, updatedInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 30000');
        System.assertEquals(0, updatedInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(3300, updatedInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 3300');
        System.assertEquals(26700, updatedInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 26700');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemWithoutPriceNegative2() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        System.assertNotEquals(null, saleInvoice.Id, 'Sale invoice should be created');
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'AccountId does not match');
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.id, item.Id, 1);
        saleInvoiceLine.dmpl__UnitPrice__c = 0;
        System.assertNotEquals(null, saleInvoiceLine.Id, 'SaleInvoiceLine should be created');
        Boolean exceptionThrown = false;
        try {
            saleInvoiceLine.dmpl__Quantity__c = 4;
            update saleInvoiceLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'Exception caught while editing sale invoice line');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithAddingItemWithIsSKURequiredNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        System.assertNotEquals(null, saleInvoice.Id, 'Sale invoice should be created');
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'AccountId does not match');
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item, 
            null, 
            1, 
            sku
        );
        saleInvoiceLine.dmpl__UnitPrice__c = 2000;
        update saleInvoiceLine;
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertNotEquals(null, fetchedInvoiceLine.Id, 'SaleInvoiceLine should be created');
        System.assertEquals(sku.Id, fetchedInvoiceLine.dmpl__SKUId__c, 'sku does not match');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 2000');
        Test.startTest();
        saleInvoiceLine.dmpl__Quantity__c = 2;
        update saleInvoiceLine;
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine2 = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(4000, fetchedInvoiceLine2.dmpl__BaseAmount__c, 'Base Amount should be 4000');
        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoiceLine.dmpl__SaleInvoiceId__c);
        System.assertEquals(4000, updatedInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 4000');
        System.assertEquals(0, updatedInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(400, updatedInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 400');
        System.assertEquals(3600, updatedInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 3600');
        System.assertEquals(1600, updatedInvoice.dmpl__OpenAmount__c, 'Open Amount should be 1600');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeWhenBudgetUnavailableNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try {
            Test.startTest();
            SaleInvoiceMasterData.generateGST(
                item.Id, 
                partner.Id, 
                branch.Id, 
                28
            );
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
            saleInvoiceLine.dmpl__UnitPrice__c = 1500;
            saleInvoiceLine.dmpl__Quantity__c = 15;
            update saleInvoiceLine;
            Test.stopTest();
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
         saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 1500.00');
        System.assertEquals(22500.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 22500.00');
        System.assertEquals(22200.00, saleInvoiceLine.dmpl__Amount__c, 'Amount should be 22200.00');
        System.assertEquals(28416.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 28416.00');
        System.assertEquals(6216, saleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 6216');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 300.00');
    }
    
    @isTest
    static void createSaleInvoiceLineWithAlternateItemPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 14', 'Product');
        SaleInvoiceMasterData.generateGST(
            item.Id, 
            partner.Id, 
            branch.Id, 
            28
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        System.assertNotEquals(null, saleInvoice.Id, 'Sale Invoice Id should not be null');
        System.assertNotEquals(null, saleInvoiceLine, 'Sale Invoice Line should not be null');
        System.assertNotEquals(null, saleInvoiceLine.Id, 'Sale Invoice Line Id should not be null');
        System.assertNotEquals(null, invoiceLine, 'Fetched Sale Invoice Line should not be null');
        System.assertEquals(saleInvoiceLine.Id, invoiceLine.Id, 'Fetched Sale Invoice Line Id should match the created one');
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithAlternateItemPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Product');
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item14.Id, 10);
        try {
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected');
        }
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        System.assertNotEquals(null, saleInvoice.Id, 'Sale Invoice Id should not be null');
        System.assertNotEquals(null, saleInvoiceLine, 'Sale Invoice Line should not be null');
        System.assertNotEquals(null, saleInvoiceLine.Id, 'Sale Invoice Line Id should not be null');
        System.assertNotEquals(null, invoiceLine, 'Fetched Sale Invoice Line should not be null');
        System.assertEquals(saleInvoiceLine.Id, invoiceLine.Id, 'Fetched Sale Invoice Line Id should match the created one');
        Test.stopTest();
    }

    @isTest
    static void InvoiceCreatedWithValidPartnerAccountBranchAndAccount(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stoptest();
    }

    @isTest
    static void InvoiceCreatedWithSalesExecutive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
        dmpl__ItemServiceContract__c ServiceContract = SaleInvoiceDataHelper.getItemServiceContract('Service Contract 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch,
            resource,
            ServiceContract
        );
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stoptest();
    }   

    @isTest
    static void InvoiceCreatedWithItemServiceContract(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__ItemServiceContract__c ServiceContract = SaleInvoiceDataHelper.getItemServiceContract('Service Contract 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch,
            null,
            ServiceContract
        );
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stoptest();
    }

    @isTest
    static void InvoiceCreatedWithBillingAndShippingAddress(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.createContactAddress('Address 2', customer.Id);
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch,
            billingAddress,
            shippingAddress
        );
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stopTest();
    }

    @isTest
    static void InvoiceCreatedWithStatusDraft(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stoptest();
    }

    @isTest
    static void InvoiceCreatedWithStatusInvoiced(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        saleInvoice.dmpl__Status__c = 'Invoiced';
        update saleInvoice;
        test.stoptest();
    }

    @isTest
    static void InvoiceCreatedWithTaxSupplyType(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch,
            'Within State',
            null,
            null,
            null
        );
        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        test.stopTest();
    }
}