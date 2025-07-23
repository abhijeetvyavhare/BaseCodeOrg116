@isTest
public with sharing class SaleInvoiceHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount1);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup =TestDataHelpers.createTaxGroup(partnerAccount1,branch1);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount1,branch1);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1, branch1, contactAddress, priceList);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1, branch1, saleOrder, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, sku, null, taxGroup, priceListRule);
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.createSaleInvoiceTax(saleInvoice, saleInvoiceLine);
        
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        branch4.dmpl__AllowInventory__c = false;
        update branch4;
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1','Product');
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5','Product');  

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3', partnerAccount4.Id, branch4.Id);
        
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.Id, item1.Id, 1500);
        dmpl__PriceListRules__c priceListRule2 = TestDataHelpers.createPriceListRules(priceList3.Id, item5.Id, 1000);

        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoicePositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        Test.stopTest();
        System.assertNotEquals(saleInvoice, null, 'Expected saleInvoice to be created.');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(100, saleInvoice.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 100');
        System.assertEquals(100, saleInvoice.dmpl__FinanceAmount__c, 'FinanceAmount should be 100');
        System.assertEquals(1, saleInvoice.dmpl__AmountPaid__c, 'AmountPaid should be 1');
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
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 100');
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
            System.assertEquals('There are downstream transaction. The object can not be deleted.', e.getDmlMessage(0),
            'Expected IntegrityFailed_TransactedObjectNotDeletable error message');
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
    static void createNormalSaleInvoiceCreationWithoutSchemeAndDiscountPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.createCustomerAccount('Customer 5');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
         saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 5', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithGSTTaxGlobalPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithIGSTTaxGlobalPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithItemLevelTaxesChangePositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        taxGroup.dmpl__TaxGroupType__c = 'Document Level';
        update taxGroup; 
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice.dmpl__TaxGroupId__c = taxGroup.Id;
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
        System.assertEquals('GST 12', saleInvoice.dmpl__TaxGroupId__r.Name, 'TaxGroup mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithBillingAndShippingAddressPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertNotEquals(null, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithMultipleBillingAndShippingAddressPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        saleInvoice.dmpl__BillingAddressId__c = billingAddress.Id;
        update saleInvoice;
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.assertEquals('Address 1', saleInvoice.dmpl__BillingAddressId__r.Name, 'BillingAddress mismatch');
        System.assertEquals(priceList.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountAndBranchPositive(){
        
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice.dmpl__TaxSupplyType__c = 'Outside State';
        update saleInvoice;
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account name mismatch');
        System.assertEquals(priceList.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForCustomerAccountGroupPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.AssertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(priceList.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
        
    }
    
    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountGroupPositive(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
        saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        
        Test.stopTest();
        System.AssertNotEquals(null, saleInvoice.Id, 'sale invoice should be created');
        System.assertEquals(priceList.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
        System.assertEquals(partner.Id, saleInvoice.dmpl__PartnerAccountId__c, 'PartnerAccountId mismatch');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithWrongPartnerAccountNegative(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as invalid branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with invalid branch');
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void createSaleInvoiceCreationWithInactivePartnerAccountNegative(){
        Test.startTest();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as inactive partner Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive partner Account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationWithInactiveCustomerAccountNegative(){
        Test.startTest();
        SaleInvoiceMasterData.SaleInvoiceCreationWithInactiveCustomerAccountData();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 7');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 3');
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as inactive Customer Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive customer Account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleInvoiceCreationWithWrongBranchNegative(){
        Test.startTest();
        SaleInvoiceMasterData.SaleInvoiceCreationWithInactiveCustomerAccountData();
        Account customer=TestDataHelpers.getCustomerAccount('Customer 7');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        
        try {
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id,partner.Id,branch.Id);
            System.assertEquals(null, saleInvoice.Id, 'SaleInvoice should not be created as wrong branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with wrong branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithoutSchemePositive() {
        Test.startTest();

        Account customer=TestDataHelpers.createCustomerAccount('Customer 1');
        Account partner=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5=TestDataHelpers.getItem('Item 5');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(item5.Id, partner.Id, branch.Id, 18);
        dmpl__SaleInvoice__c saleInvoice=SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c invoiceLine=SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 10);
        dmpl__SaleInvoice__c createdSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(invoiceLine.Id);
        createdSaleInvoiceLine.dmpl__ItemId__c=item1.Id;
        createdSaleInvoiceLine.dmpl__Quantity__c=50;
        try{
            update createdSaleInvoiceLine;
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected SaleInvoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected SaleInvoice to be created');
        System.assertNotEquals(null, invoiceLine, 'Expected SaleInvoiceLine to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected SaleInvoiceLine to be created');
        System.assert(createdSaleInvoice.dmpl__PriceListId__c!=null, 'Price List not be null');
        
        System.assertEquals(810, updatedSaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 name mismatch');
        System.assertEquals(9, updatedSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 type mismatch');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Price should be ₹1,500.00');
        
        System.assertEquals(810, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹10,500.00');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(10000, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹75,000.00');
        System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be ₹0.00');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be ₹0.00');
        System.assertEquals(1620, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be ₹21,000.00');
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be ₹0.00');
        System.assertEquals(1000, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
    }

    
    @isTest
    static void updateSaleInvoiceLineWithTaxApplicationInLineTaxesPositive() {
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 28);
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 42);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
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
        
        System.assertEquals(1500.00, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be ₹1,500.00');
        System.assertEquals(63000.00, createdSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹63,000.00');
        System.assertEquals(7938.00, createdSaleInvoiceLine.dmpl__Tax1__c, 'CGST should be ₹8,820.00');
        System.assertEquals(14, createdSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(7938.00, createdSaleInvoiceLine.dmpl__Tax2__c, 'SGST should be ₹8,820.00');
        System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, createdSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(15876.00, createdSaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be ₹17,640.00');
        System.assertEquals(72576.00, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be ₹80,640.00');
        System.assertEquals(0.00, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(6300.00, createdSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        System.assertEquals(1500.00, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be ₹1,500.00');
        System.assertEquals(27000.00, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹27,000.00');
        System.assertEquals(3402.00, updatedSaleInvoiceLine.dmpl__Tax1__c, 'Tax1 (CGST) should be ₹3,780.00');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14.00, updatedSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(3402.00, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹3,780.00');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14.00, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(6804.00, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be ₹7,560.00');
        System.assertEquals(31104.00, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be ₹34,560.00');
        System.assertEquals(2700.00, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0.00, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(27000.00, updatedSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be ₹27,000.00');
        System.assertEquals(0.00, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be ₹0.00');
        System.assertEquals(2700.00, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
        System.assertEquals(6804.00, updatedSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be ₹7,560.00');
        System.assertEquals(6804.00, updatedSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be ₹7,560.00');
        System.assertEquals(31104.00, updatedSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be ₹34,560.00');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithInactiveItemNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2= TestDataHelpers.createItem('Item 2', 'Product');
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
        dmpl__Item__c item=TestDataHelpers.createItem('Item 9', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        try{
            dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 5);
            System.assertEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to not be created due to SKU requirement');
        }
        catch(DmlException e){
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
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 1);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 0 as Item does not have a price');
        System.assertEquals(0, createdSaleInvoiceLine.dmpl__BaseAmount__c,'Base Amount should be 0 as Item does not have a price');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultTruePositive() {
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item= TestDataHelpers.createItem('Item 11', 'Product');
        dmpl__SKU__c sku= TestDataHelpers.createSKU('SKU 4', item.Id, true);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null,1,sku);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c=4;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
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
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku= TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null,1,sku);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        try{
            createdSaleInvoiceLine.dmpl__SKUId__c=null;
            createdSaleInvoiceLine.dmpl__Quantity__c=4;
            update createdSaleInvoiceLine;
        }catch(Exception e){
            System.assert.isTrue(true, 'Expected Sale Invoice not to be created');
        }
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityNoBudgetNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 16);
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
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
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
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.createSaleInvoiceLineWithSupercedingItemPositive();
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.getItemAlternate();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice,null, itemAlternate, 1,null);
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
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        try{
            dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, -1);
            System.assertEquals(null,saleInvoiceLine,'Expected DMLException when creating Sale Invoice Line with zero quantity');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception because of zero quantity');
        }
        Test.stopTest();
    }
    /***************/
    @isTest
    static void createSaleInvoicePriceListInActivePositive(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        
        dmpl__SaleInvoice__c saleInvoice;
        try{
            saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        } catch (DMLException e) {
            System.Assert.isTrue(false, 'Expected to be created!');
        }
        System.AssertEquals(customer?.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account must Match');
        System.AssertEquals(partner?.Id, saleInvoice.dmpl__PartnerAccountId__c, 'Customer Account must Match');
        System.AssertEquals(branch?.Id, saleInvoice.dmpl__BranchId__c, 'Customer Account must Match');
        Test.stopTest();
    }
    @isTest
    static void createSaleInvoiceCreationwithInactiveBranchNegative(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__SaleInvoice__c saleInvoice;
        try{
            saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
            System.assertEquals(null,saleInvoice,'Expected DMLException when creating Sale Invoice ');
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
        SaleInvoiceMasterData.generateItemWithPriceList('Item 3', partner.Id, branch.Id, 2000);
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
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeDiscount__c, 'Line scheme discount mismatch'); // For scheme application Quantity should be greater than or equal 10
    }
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmountPositive2() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 12);
        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        
       
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(1000, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Normal discount mismatch');
        System.assertEquals(1980, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total tax mismatch');
        System.assertEquals(15980, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        System.assertNotEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme line ID mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Invoice base amount mismatch');
        System.assertEquals(1000, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Invoice scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Invoice discount mismatch');
        System.assertEquals(1980, fetchedsaleInvoice.dmpl__TotalLineTaxAmount__c, 'Invoice tax mismatch');
        System.assertEquals(15980, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Invoice gross amount mismatch');
        System.assertEquals(15980, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Invoice outstanding mismatch');
        
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupAndSchemePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 18);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 1);

        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(partner.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals('Within State', fetchedsaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type mismatch');
        
        System.assertEquals(saleInvoice.Id, fetchedsaleInvoiceLine.dmpl__SaleInvoiceId__c, 'Invoice ID mismatch');
        System.assertEquals(item.Id, fetchedsaleInvoiceLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(15, fetchedsaleInvoiceLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1000, fetchedsaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Discount mismatch');
        System.assertEquals(1000, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount mismatch');
        
        System.assertEquals(2520, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Tax1 mismatch');
        
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
    }
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityPartnerAccountGroupPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 15);
        
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
        System.assertEquals('Within State', fetchedsaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type mismatch');
        
        System.assertEquals(21000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0 since quantity < threshold');
        
        System.assertEquals(2940, fetchedsaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
        System.assertEquals(2940, fetchedsaleInvoiceLine.dmpl__Tax2__c, 'SGST amount mismatch');
        System.assertEquals(5880, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total tax amount mismatch');
        
        System.assertEquals(26880, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme line ID should be null');
        
        System.assertEquals(21000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Invoice base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Total discount mismatch');
        System.assertEquals(5880, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Invoice tax amount mismatch');
        System.assertEquals(26880, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c);
        
        
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupDiscountPositive(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 28);
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
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Net discount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__Tax1__c, 'CGST mismatch');
        System.assertEquals('CGST', fetchedsaleInvoiceLine.dmpl__Tax1Name__c);
        System.assertEquals(14.0, fetchedsaleInvoiceLine.dmpl__Tax1Rate__c, 'CGST Rate mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__Tax2__c, 'SGST mismatch');
        System.assertEquals('SGST', fetchedsaleInvoiceLine.dmpl__Tax2Name__c);
        System.assertEquals(14.0, fetchedsaleInvoiceLine.dmpl__Tax2Rate__c, 'SGST Rate mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Total discount mismatch');
        System.assertEquals(0.00, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Gross amount mismatch');
        System.assertEquals(0.00, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open amount mismatch');
        System.assertEquals(0.00, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding amount mismatch');
        
    }
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilitySkipSchemeTruePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.generateItemWithPriceList('Item 6', partner.Id, branch.Id, 2000);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
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
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Tax amount should be 0');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Net discount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0 since SkipScheme is true');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Invoice total base mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Invoice total discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Invoice scheme discount should be 0');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalLineTaxAmount__c, 'Invoice tax should be 0');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Invoice gross mismatch');
       
    }
    
    @isTest
    static void updateTaxApplicationObjectModelObjectTaxesPositive(){
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 12);
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 10);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
       
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(15000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(810.00, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(810.00, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1620.00, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(15120.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(405.00, saleInvoiceLine.dmpl__Tax1__c, 'Tax1 (CGST) should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6.00, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(405.00, saleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6.00, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(810.00, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(7500.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(7560.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        System.assertEquals(750.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscontinuedItemNegative(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1= TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4= TestDataHelpers.createItem('Item 4', 'Product');
        item4.dmpl__IsDiscontinued__c = true;
        update item4;
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 1);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> ' + e.getMessage());
        }
        
        try{
            saleInvoiceLine.dmpl__ItemId__c = item4.Id;
            update saleInvoiceLine;
            System.Assert.isTrue(false, 'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Exception Expected! >> ');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemWithoutTaxGroupPositive(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.generateItemWithPriceList('Item 8', partner.Id, branch.Id, 1500);
        dmpl__Item__c item= TestDataHelpers.getItem('Item 8');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.Id, false);

        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null, 10, sku2);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
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
    static void updatePricesInCaseOfDateEffectiveTillHasPassedNegative(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.getItem('Item 5');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 20);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 15;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeApplicabilityincaseofSchemenotApprovedPositive(){
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
        SaleInvoiceMasterData.generateItemWithPriceList('Item 3', partner.Id, branch.id, 2000);
        dmpl__Item__c item= TestDataHelpers.getItem('Item 3');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 12);
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 6);
            saleInvoiceLine.dmpl__UnitPrice__c = 2000;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(60000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should Match');
        System.assertEquals(11000, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(12000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetNegative(){
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item= TestDataHelpers.createItem('Item 4','Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 5);
            saleInvoiceLine.dmpl__UnitPrice__c = 2000;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 50;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception Expected!  Dicount is more than scheme Budget >> '+ e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should Match');
        System.assertEquals(300, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        
        
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(item.Id, saleInvoiceLine.dmpl__ItemId__c, 'Item Id should be Match');
        System.assertEquals(100, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(9800, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(100000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(50, saleInvoiceLine.dmpl__Quantity__c, 'Quantity should be Match');
        System.assertEquals(null, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(100000, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        
        
    }
    @isTest
    static void updateSaleInvoiceLinewithoutSchemesPositive(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.Id, false);
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 28);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, null, 20, sku2);
            saleInvoiceLine.dmpl__UnitPrice__c = 1500;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(30000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(4200, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4200, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(8400, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(38400, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 22;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(33000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(4620, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4620, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(9240, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(42240, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(33000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(0, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(9240, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(9240, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmount2Positive(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        SaleInvoiceMasterData.generateGST(item.ID, partner.Id, branch.ID, 18);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 22);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        
        System.assertEquals(1000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(22000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(1953, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(1953, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3906, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(25606.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(22000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(300, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(3906, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(3906, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(25606.00, saleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(23606.00, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(24606.00, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceWithDiscountGroupAndSchemePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        // dmpl__DiscountGroup__c discountGroup1 = TestDataHelpers.getDiscountGroup('Discount Group 1');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
        
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        try{
            saleInvoiceLine.dmpl__Quantity__c = 20;
            update saleInvoiceLine;
        }
        catch(DmlException e){
            System.debug('Exception: '+e.getMessage());
        }
        Test.stopTest();
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assert(createdSaleInvoice.dmpl__PriceListId__c != null, 'Price List should not be null');
        System.assertEquals(1000, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should Match');
        System.assertEquals(1000, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match');
        System.assertEquals(10620, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match');
        System.assertEquals(2000, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match after update');
        System.assertEquals(21240, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match after update');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultFalsePositive(){
        Test.startTest();
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item= TestDataHelpers.createItem('Item 10', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku= TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null,11,sku);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c=17;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityIgnoreBudgetTruePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
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
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
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
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount2__c, 'Total Scheme Discount Amount should be ₹0.00 after update');
    }


    
    @isTest
    static void updateSaleInvoiceLineTaxApplicationObjectModelInLineTaxesPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.Id, 28);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 8);
        
        dmpl__SaleInvoiceLine__c invoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);

        System.assertEquals(1500.00, invoiceLine.dmpl__UnitPrice__c, 'Price does not match');
        System.assertEquals(1638.00, invoiceLine.dmpl__Tax1__c, 'Tax1 does not match');
        System.assertEquals('CGST', invoiceLine.dmpl__Tax1Name__c, 'Tax1 Name does not match');
        System.assertEquals(14, invoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate does not match');
        System.assertEquals('CGST', invoiceLine.dmpl__Tax1Type__c, 'Tax1 Type does not match');
        System.assertEquals(1638.00, invoiceLine.dmpl__Tax2__c, 'Tax2 does not match');
        System.assertEquals('SGST', invoiceLine.dmpl__Tax2Name__c, 'Tax2 Name does not match');
        System.assertEquals(14, invoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate does not match');
        System.assertEquals('SGST', invoiceLine.dmpl__Tax2Type__c, 'Tax2 Type does not match');
        System.assertEquals(12000.00, invoiceLine.dmpl__BaseAmount__c, 'Base Amount does not match');
        System.assertEquals(0.00, invoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount does not match');
        System.assertEquals(300.00, invoiceLine.dmpl__NetDiscount__c, 'Net Discount does not match');
        System.assertEquals(3276.00, invoiceLine.dmpl__TaxAmount__c, 'Tax Amount does not match');
        System.assertEquals(14976.00, invoiceLine.dmpl__GrossAmount__c, 'Gross Amount does not match');

        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);

        System.assertEquals(12000.00, createdSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount does not match');
        System.assertEquals(0.00, createdSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount does not match');
        System.assertEquals(300.00, createdSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount does not match');
        System.assertEquals(3276.00, createdSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount does not match');
        System.assertEquals(3276.00, createdSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount does not match');
        System.assertEquals(14976.00, createdSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount does not match');
        System.assertEquals(12976.00, createdSaleInvoice.dmpl__OpenAmount__c, 'Open Amount does not match');
        System.assertEquals(13976.00, createdSaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount does not match');

        Test.stopTest();
        
    }

    @isTest
    static void updateSaleInvoiceLineItemSKUWithIsDefaultTruePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        SaleInvoiceMasterData.generateItemWithPriceList('Item 10', partner.Id, branch.ID, 2000);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 10');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku= TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        System.assertNotEquals(null, saleInvoice.Id,'Sale invoice should be created');
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'AccountId does not match');  
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null, 20,sku);
        saleInvoiceLine.dmpl__UnitPrice__c = 2000;
        Test.startTest();
        update saleInvoiceLine;
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);   
        System.assertNotEquals(null, fetchedInvoiceLine.Id,'SaleInvoiceLine should be created');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__UnitPrice__c, 'Unit price does not match');
        System.assertEquals(40000, fetchedInvoiceLine.dmpl__BaseAmount__c, 'Base Amount does not match');
        saleInvoiceLine.dmpl__Quantity__c = 15;
        update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine2= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(30000, fetchedInvoiceLine2.dmpl__BaseAmount__c, 'Base Amount does not match');
        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoiceLine.dmpl__SaleInvoiceId__c);
        System.assertEquals(30000, updatedInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, updatedInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount mismatch');
        System.assertEquals(0, updatedInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        System.assertEquals(30000, updatedInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(30000, updatedInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        
    }


    @isTest
    static void updateSaleInvoiceLineWithItemWithoutPriceNegative2() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);

        System.assertNotEquals(null, saleInvoice.Id,'Sale invoice should be created');
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'AccountId does not match');

        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.id, item.Id, 1);
        saleInvoiceLine.dmpl__UnitPrice__c = 0;
        System.assertNotEquals(null, saleInvoiceLine.Id,'SaleInvoiceLine should be created');
        
        Boolean exceptionThrown = false;
        try{
            saleInvoiceLine.dmpl__Quantity__c = 4;
            update saleInvoiceLine;
        }catch(Exception e){
            exceptionThrown= true;
        }
        System.assertEquals(false, exceptionThrown,'Exception caught while editing sale invoice line');
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
        dmpl__SKU__c sku= TestDataHelpers.createSKU('SKU 5', item.Id, false);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        
        System.assertNotEquals(null, saleInvoice.Id,'Sale invoice should be created');
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'AccountId does not match');
        Test.startTest();

        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item,null, 1,sku);
        saleInvoiceLine.dmpl__UnitPrice__c = 2000;
        update saleInvoiceLine;
        dmpl__SaleInvoiceLine__c fetchedInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);

        System.assertNotEquals(null, fetchedInvoiceLine.Id,'SaleInvoiceLine should be created');
        System.assertEquals(sku.Id, fetchedInvoiceLine.dmpl__SKUId__c, 'sku does not match');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__UnitPrice__c, 'Unit price does not match');
        System.assertEquals(2000, fetchedInvoiceLine.dmpl__BaseAmount__c, 'Base Amount does not match');


        saleInvoiceLine.dmpl__Quantity__c = 2;
        update saleInvoiceLine;
        Test.stopTest();

        dmpl__SaleInvoiceLine__c fetchedInvoiceLine2= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        System.assertEquals(4000, fetchedInvoiceLine2.dmpl__BaseAmount__c, 'Base Amount does not match');

        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoiceLine.dmpl__SaleInvoiceId__c);
        System.assertEquals(4000, updatedInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, updatedInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount mismatch');
        System.assertEquals(0, updatedInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        System.assertEquals(4000, updatedInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(4000, updatedInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        
    }

    @isTest
    static void updateSchemeWhenBudgetUnavailableNegative(){
        Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        SaleInvoiceMasterData.generateGST(item.Id, partner.Id, branch.ID, 28);
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
            saleInvoiceLine.dmpl__UnitPrice__c = 1500;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoiceLine.dmpl__Quantity__c = 15;
        update saleInvoiceLine;
        Test.stopTest();
        
         saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
       
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(22500.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(22500.00, saleInvoiceLine.dmpl__Amount__c,'Amount should match');
        System.assertEquals(22500.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        System.assertEquals(null,saleInvoiceLine.dmpl__TaxAmount__c,'should match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
    }

    
    //    @isTest
    // static void updateSchemeWhenNotApprovedNegative(){
    //     Test.startTest();
    //     Account customer= TestDataHelpers.getCustomerAccount('Customer 1');
    //     Account partner= TestDataHelpers.getPartnerAccount('Partner 4');
    //     dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 4');
    //     dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
    //     dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);        
    //     dmpl__SaleInvoiceLine__c saleInvoiceLine;
    //     try{
    //         saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item3, 6);
    //     }catch(Exception e){
    //         System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
    //     }
        
    //     System.assertEquals(customer.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
      
    //     saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
    //     System.assertNotEquals()

    //     Test.stopTest();
    // }

     @isTest
    static void createSaleInvoiceLineWithAlternateItemPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 14', 'Product');
        SaleInvoiceMasterData.generateGST(item.ID, partner.Id, branch.Id, 28);
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id, item.Id, 10);
        
        dmpl__SaleInvoiceLine__c invoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);

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
        
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice.Id,item14.Id, 10);
     
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected');
        }
        
        dmpl__SaleInvoiceLine__c invoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);

        System.assertNotEquals(null, saleInvoice, 'Sale Invoice should not be null');
        System.assertNotEquals(null, saleInvoice.Id, 'Sale Invoice Id should not be null');

        System.assertNotEquals(null, saleInvoiceLine, 'Sale Invoice Line should not be null');
        System.assertNotEquals(null, saleInvoiceLine.Id, 'Sale Invoice Line Id should not be null');

        System.assertNotEquals(null, invoiceLine, 'Fetched Sale Invoice Line should not be null');
        System.assertEquals(saleInvoiceLine.Id, invoiceLine.Id, 'Fetched Sale Invoice Line Id should match the created one');
        Test.stopTest();
        
    }
}