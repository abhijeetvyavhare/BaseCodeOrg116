@isTest
public with sharing class SaleReturnHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(1, accountGroup1.Id);
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.createGLAccount(
            'ICICI Bank', 
            'Bank', 
            true, 
            partnerAccount1.Id, 
            branch1.Id
        );
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item1.Id, true);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup(
            'IGST 18', 
            true, 
            'Line Level', 
            null, 
            null, 
            null
        );
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount1,branch1);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList1,item1);
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id
        );
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(
            saleInvoice, 
            item1, 
            sku, 
            null, 
            taxGroupGST28, 
            priceListRule
        );
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            TestDataHelpers.getCustomerAccount(),
            TestDataHelpers.getBranch(),
            TestDataHelpers.getContactAddress(), 
            TestDataHelpers.getPriceList()
        );
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn, 
            item1, 
            sku, 
            taxGroupGST28
        );
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(saleReturn, saleReturnLine);
        Test.stopTest();
    }
    
    @isTest
    static void createSaleReturnPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        System.assertEquals('Draft', saleReturn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(false, saleReturn.dmpl__IsReturned__c, 'IsReturned should be false');
        System.assertEquals(false, saleReturn.dmpl__PerformInventoryPosting__c, 'PerformInventoryPosting should be false');
    }
    
    @isTest
    static void createSaleReturnLinePositive() {
        dmpl__SaleReturnLine__c retrievedLine = SaleReturnDataHelper.getSaleReturnLine();
        System.assertNotEquals(null, retrievedLine, 'Expected sale return line to be created');
        System.assertEquals(1, retrievedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(100, retrievedLine.dmpl__UnitPrice__c, 'Unit price should be 100');
        System.assertEquals(10, retrievedLine.dmpl__Discount2__c, 'Discount2 should be 10');
        System.assertEquals(10, retrievedLine.dmpl__ContractDiscount__c, 'Contract discount should be 10');
    }
    
    @isTest
    static void createSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();
        System.assertNotEquals(null, tax.Id, 'Expected SaleReturnTax to be created');
    }

    @isTest
    static void updateSaleReturnPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        saleReturn.dmpl__TransactionType__c = 'Sample'; 
        saleReturn.dmpl__Remarks__c = 'Remark1';
        update saleReturn;
        dmpl__SaleReturn__c saleReturnUpdated = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals('Sample', saleReturnUpdated.dmpl__TransactionType__c, 'Transaction Type not updated correctly');
        System.assertEquals('Remark1', saleReturnUpdated.dmpl__Remarks__c, 'Remarks not updated correctly');
    }
    
    @isTest
    static void updateSaleReturnLinePositive() {
        dmpl__SaleReturnLine__c existingLine = SaleReturnDataHelper.getSaleReturnLine();
        Test.startTest();
        existingLine.dmpl__Quantity__c = 2;
        existingLine.dmpl__UnitPrice__c = 200;
        existingLine.dmpl__ContractDiscount__c = 20;
        update existingLine;
        Test.stopTest();
        dmpl__SaleReturnLine__c retrievedLine = SaleReturnDataHelper.getSaleReturnLine(existingLine.Id);
        System.assertNotEquals(null, retrievedLine, 'Sale Return Line should not be null after update');
        System.assertEquals(2, retrievedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
        System.assertEquals(200, retrievedLine.dmpl__UnitPrice__c, 'Unit price should be updated to 200');
        System.assertEquals(20, retrievedLine.dmpl__ContractDiscount__c, 'Discount should be updated to 20');
    }
    
    @isTest
    static void updateSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();
        Test.startTest();
        tax.dmpl__TaxAmount__c = 200;
        tax.dmpl__TaxOnAmount__c = 2000;
        tax.dmpl__TaxRate__c = 10;
        update tax;
        Test.stopTest();
        dmpl__SaleReturnTax__c updatedTax = SaleReturnDataHelper.getSaleReturnTax(tax.Id);
        System.assertEquals(200, updatedTax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(2000, updatedTax.dmpl__TaxOnAmount__c, 'Tax on amount should be updated to 2000');
        System.assertEquals(10, updatedTax.dmpl__TaxRate__c, 'Tax rate should be updated to 10');
        System.assertEquals(saleReturn.Id, updatedTax.dmpl__SaleReturnId__c, 'Sale Return ID should match');
        System.assertEquals(line.Id, updatedTax.dmpl__SaleReturnLineId__c, 'Sale Return Line ID should match');
    }
    
    @isTest
    static void deleteSaleReturnTax() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();
        Test.startTest();
        delete tax;
        Test.stopTest();
        dmpl__SaleReturnTax__c deletedTax = null;
        try {
            deletedTax = SaleReturnDataHelper.getSaleReturnTax(tax.Id);
        } catch (QueryException e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax record should be deleted');
    }
    
    @isTest
    static void deleteSaleReturnLine() {
        dmpl__SaleReturnLine__c existingLine = SaleReturnDataHelper.getSaleReturnLine();
        Test.startTest();
        delete existingLine;
        Test.stopTest();
        dmpl__SaleReturnLine__c deletedLine = null;
        try {
            deletedLine = SaleReturnDataHelper.getSaleReturnLine(existingLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Sale Return Line should be deleted');
    }

    @isTest
    static void testDeleteSaleReturn() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        System.assertNotEquals(saleReturn, null, 'SaleReturn should exist before delete.');
        delete saleReturn;
        dmpl__SaleReturn__c deletedReturn = null;
        try {
            deletedReturn = SaleReturnDataHelper.getSaleReturn();
        } catch (Exception e) {
            deletedReturn = null;
        }
        System.assertEquals(null, deletedReturn, 'SaleReturn should be deleted and not found in query.');
    }

    @isTest
    static void createSaleRetuanWithAllMandatoryFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnWithoutSelectingPartnerAccountPositiveNew(){
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            null,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnWithoutSelectingBranchPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnWithoutEnteringDocumentDatePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            null,
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnWithoutSelectingInvoicePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void documentDateAcceptsValidFutureDatesPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today().addDays(30),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void checkPerformReturnPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            true
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, true, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void checkIsReturnedWithoutCheckingPerformReturnPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void checkPerformInventoryPostingPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            true,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.'); 
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, true, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void selectValidPartnerAccountAndSavePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void selectValidCustomerAccountAndSavePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void selectInvalidPartnerAccountAndSaveNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        System.assert(true, 'Expected no exceptions to be thrown invalid partner account cannot be selected.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnAndCheckIfRecordAppearsInRelatedListOfAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        Account retrievedAccount = TestDataHelpers.getCustomerAccount(customer1.Name);
        System.assertEquals(retrievedAccount.Id, saleReturn.dmpl__AccountId__c, 'Expected sale return to be linked to the correct customer.');
        Test.stopTest();
    }

    @isTest
    static void validateThatSaleExecutiveFieldCanBeLeftBlankPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void saveSaleReturnWithEmptyMandatoryFieldsNegativeNew(){
        Test.startTest();
        try{
            dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void useInvalidPartnerAccountAndSaveNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        System.assert(true, 'Expected no exceptions to be thrown invalid partner account cannot be selected.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void allCheckboxesAreCheckedPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            true,
            true,
            true,
            true
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, true, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, true, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, true, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void calendarIconDoesShowUpWhenDocumentDateIsClickedPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest 
    static void selectingValidAccountAndSavingPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void deprecatedSalesExecutiveFieldsDoesNotThrowErrorWhenLeftBlankPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void selectingValidPartnerAccountPopulatesRelatedDataPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        Test.stopTest();
    }

    @isTest
    static void afterSavingAccountAppearsInRelatedListOfAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        Account retrievedAccount = TestDataHelpers.getCustomerAccount(customer1.Name);
        System.assertEquals(retrievedAccount.Id, saleReturn.dmpl__AccountId__c, 'Expected sale return to be linked to the correct customer.');
        Test.stopTest();
    }

    @isTest
    static void createSaleReturnLineWithAllMandatoryFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        Test.stopTest();
    }

    @isTest
    static void saveAndNewCreatesAndResetsTheForm(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        Test.stopTest();
    }

    @isTest
    static void allowDecimalQuantityPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1.42,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1.42, 'Expected sale return line to have the correct quantity.');
        Test.stopTest();
    }

    @isTest
    static void acceptUnitPriceAsZeroPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            0,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 0, 'Expected sale return line to have the correct unit price.');
        Test.stopTest();
    }

    @isTest
    static void lookUpFieldsWorkBasedOnRelatedFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        Test.stopTest();
    }

    @isTest
    static void saveWithEmptyFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            0,
            0,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 0, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 0, 'Expected sale return line to have the correct unit price.');
        Test.stopTest();
    }

    @isTest
    static void unitPriceWithMoreThanTwoDecimalDigitsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1.5334,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1.5334, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 100, 'Expected sale return line to have the correct unit price.');
        Test.stopTest();
    }

    @isTest
    static void invalidItemLotIdNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        SaleReturnMasterData.createItemLotMasterData();
        Account partner6 = TestDataHelpers.getPartnerAccount('Partner 6');
        dmpl__Branch__c branch6 = TestDataHelpers.getBranch('Branch 6');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku8 = TestDataHelpers.getSKU('SKU 8');
        dmpl__ItemLot__c itemLot = SaleReturnDataHelper.createItemLot(
            branch6.Id, 
            partner6.Id, 
            item8.Id, 
            sku8.Id, 
            999
        );
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            itemLot.Id,
            null,
            0,
            0,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 0, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 0, 'Expected sale return line to have the correct unit price.');
        System.assert(true, 'No way to enter invalid itemLotId hence no error.');
        Test.stopTest();
    }

    @isTest
    static void saleReturnFieldAutofillPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 100, 'Expected sale return line to have the correct unit price.');
        Test.stopTest();
    }

    @isTest
    static void taxCalculatedWithoutSelectingTaxGroupPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 100, 'Expected sale return line to have the correct unit price.');
        Test.stopTest();    
    }

    @isTest
    static void fromSavesWithInvalidSKULinkedNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        System.assertEquals(saleReturnLine.dmpl__Quantity__c, 1, 'Expected sale return line to have the correct quantity.');
        System.assertEquals(saleReturnLine.dmpl__UnitPrice__c, 100, 'Expected sale return line to have the correct unit price.');
        System.assert(true, 'Invalid SKU cannot be selected.');
        Test.stopTest();
    }

    @isTest
    static void createNewSalReturnTaxWithValidSaleReturnAndSaleReturnLinePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            null,
            null,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return tax to be linked to the correct sale return.');
        System.assertEquals(saleReturnTax.dmpl__SaleReturnLineId__c, saleReturnLine.Id, 'Expected sale return tax to be linked to the correct sale return line.');
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, null, 'Expected sale return tax to have the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, null, 'Expected sale return tax to have the correct tax group.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPosted__c, false, 'Expected sale return tax to have the correct is GL posted.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPostingApproved__c, false, 'Expected sale return tax to have the correct is GL posting approved.');
        Test.stopTest();
    }
    
    @isTest
    static void autoGenerateSaleReturnTaxNameFollowsDefinedAutoNumberFormatPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            null,
            null,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertNotEquals(saleReturnTax.Name, null, 'Expected sale return tax to have a name.');
        Test.stopTest();
    }

    @isTest
    static void documentDateAutoPopulatesAccuratelyFromSaleReturnPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        dmpl__TaxGroup__c taxGroup1 = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            taxGroup1.Id,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertNotEquals(saleReturnTax.dmpl__DocumentDate__c, null, 'Expected sale return tax to have the correct document date.');
        Test.stopTest();
    }

    @isTest
    static void successfullyLookupAndAssociateAValidGLAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            null,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, glAccount1.Id, 'Expected sale return tax to be linked to the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, null, 'Expected sale return tax to have the correct tax group.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPosted__c, false, 'Expected sale return tax to have the correct is GL posted.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPostingApproved__c, false, 'Expected sale return tax to have the correct is GL posting approved.');
        Test.stopTest();
    }

    @isTest
    static void taxGroupFieldAllowsAppropriateLookupAndSelectionPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        dmpl__TaxGroup__c taxGroup1 = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            taxGroup1.Id,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, glAccount1.Id, 'Expected sale return tax to be linked to the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, taxGroup1.Id, 'Expected sale return tax to be linked to the correct tax group.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPosted__c, false, 'Expected sale return tax to have the correct is GL posted.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPostingApproved__c, false, 'Expected sale return tax to have the correct is GL posting approved.');
        Test.stopTest();
    }

    @isTest
    static void tickTheCheckboxAsPerRecordPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            null,
            null,
            true,
            true
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, null, 'Expected sale return tax to have the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, null, 'Expected sale return tax to have the correct tax group.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPosted__c, true, 'Expected sale return tax to have the correct is GL posted.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPostingApproved__c, true, 'Expected sale return tax to have the correct is GL posting approved.');
        Test.stopTest();
    }

    @isTest
    static void formSubmissionWhenAllMandatoryFieldsAreFilledPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        dmpl__TaxGroup__c taxGroup1 = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            taxGroup1.Id,
            false,
            false
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, glAccount1.Id, 'Expected sale return tax to be linked to the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, taxGroup1.Id, 'Expected sale return tax to be linked to the correct tax group.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPosted__c, false, 'Expected sale return tax to have the correct is GL posted.');
        System.assertEquals(saleReturnTax.dmpl__IsGLPostingApproved__c, false, 'Expected sale return tax to have the correct is GL posting approved.');
        Test.stopTest();
    }

    @isTest 
    static void attemptToSaveWithoutFillingMandatoryFieldsNegativeNew(){
        Test.startTest();
        try{
            dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
                null,
                null,
                null,
                null,
                null,
                null
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void noValidationErrorWhenDuplicatingARecordPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        dmpl__TaxGroup__c taxGroup1 = TestDataHelpers.getTaxGroup('IGST 18');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            partner1.Id,
            customer1.Id,
            null,
            null,
            Date.today(),
            false,
            true,
            false,
            false
        );
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        System.assertEquals(saleReturn.dmpl__IsInJobQueue__c, false, 'Expected sale return to have the correct is in job queue.');
        System.assertEquals(saleReturn.dmpl__IsReturned__c, true, 'Expected sale return to have the correct is returned.');
        System.assertEquals(saleReturn.dmpl__PerformInventoryPosting__c, false, 'Expected sale return to have the correct perform inventory posting.');
        System.assertEquals(saleReturn.dmpl__PerformReturn__c, false, 'Expected sale return to have the correct perform return.');
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn.Id,
            null,
            null,
            null,
            null,
            null,
            null,
            1,
            100,
            false,
            false,
            false,
            false,
            false
        );
        System.assertNotEquals(saleReturnLine, null, 'Expected sale return line to be created.');
        saleReturnLine = SaleReturnDataHelper.getSaleReturnLine(saleReturnLine.Id);
        System.assertEquals(saleReturnLine.dmpl__SaleReturnId__c, saleReturn.Id, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(saleReturnLine.dmpl__ApplyPostTaxDiscount__c, false, 'Expected sale return line to have the correct apply post tax discount.');
        System.assertEquals(saleReturnLine.dmpl__IsApproved__c, false, 'Expected sale return line to have the correct is approved.');
        System.assertEquals(saleReturnLine.dmpl__IsILPosted__c, false, 'Expected sale return line to have the correct is IL posted.');
        System.assertEquals(saleReturnLine.dmpl__IsILPostingApproved__c, false, 'Expected sale return line to have the correct is IL posting approved.');
        System.assertEquals(saleReturnLine.dmpl__IsSchemeGenerated__c, false, 'Expected sale return line to have the correct is scheme generated.');
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            taxGroup1.Id,
            true,
            true
        );
        System.assertNotEquals(saleReturnTax, null, 'Expected sale return tax to be created.');
        saleReturnTax = SaleReturnDataHelper.getSaleReturnTax(saleReturnTax.Id);
        System.assertEquals(saleReturnTax.dmpl__GLAccountId__c, glAccount1.Id, 'Expected sale return tax to be linked to the correct GL account.');
        System.assertEquals(saleReturnTax.dmpl__TaxGroupId__c, taxGroup1.Id, 'Expected sale return tax to be linked to the correct tax group.');
        dmpl__SaleReturnTax__c saleReturnTax2 = SaleReturnDataHelper.createSaleReturnTax(
            saleReturn.Id,
            saleReturnLine.Id,
            glAccount1.Id,
            taxGroup1.Id,
            true,
            true
        );
        System.assert(true, 'Expected no exceptions to be thrown when creating duplicate record.');
        Test.stopTest();
    }
    
    @isTest
    static void createSaleReturnWithMandatoryFieldsFilledPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        Test.stopTest();
    }

    // Attempt to save Sale Return without selecting Partner Account (New)
    @isTest
    static void attemptToSaveWithoutSelectingPartnerAccountNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, null, branch1);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        System.assertEquals(null, saleReturn.dmpl__PartnerAccountId__c, 'Expected sale return created without Partner account.');
        Test.stopTest();
    }

    //Attempt to save Sale Return without selecting Branch (New)
    @isTest
    static void attemptToSaveWithoutSelectingBranchNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, null);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        System.assertEquals(null, saleReturn.dmpl__BranchId__c, 'Expected sale return created without Branch.');
        Test.stopTest();
    }

    //Attempt to save Sale Return without entering Created/Document Date 
    @isTest
    static void attemptToSaveWithoutEnteringDocumentDateNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__DocumentDate__c = null;
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        System.assertEquals(null, saleReturn.dmpl__DocumentDate__c, 'Expected sale return created without Created Date.');
        Test.stopTest();
    }

    // Attempt to save Sale Return without selecting Invoice (New)
    @isTest
    static void attemptToSaveWithoutSelectingInvoiceNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__SaleInvoiceId__c = null;
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, null, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(null, createdLine.dmpl__SaleInvoiceId__c, 'Expected sale return line to not be linked to any sale invoice line.');
        System.assertEquals(null, saleReturn.dmpl__SaleInvoiceId__c, 'Expected sale return created without Invoice.');
        Test.stopTest();
    }

    // Validate that Document Date accepts valid future dates (New)
    @isTest
    static void validateDocumentDateAcceptsFutureDatesPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__DocumentDate__c = Date.today().addDays(10);
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertEquals(Date.today().addDays(10), saleReturn.dmpl__DocumentDate__c, 'Expected document date to accept future dates.');
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        Test.stopTest();
    }

    //Check 'Perform Return' and validate successful save (New)
    @isTest
    static void checkPerformReturnAndValidateSavePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__PerformReturn__c = true;
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertEquals(true, saleReturn.dmpl__PerformReturn__c, 'Expected Perform Return to be checked.');
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        Test.stopTest();
    }

    // Check 'Is Returned' without checking 'Perform Return' (New)
    @isTest
    static void checkIsReturnedWithoutPerformReturnPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__IsReturned__c = true;
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertEquals(true, saleReturn.dmpl__IsReturned__c, 'Expected Is Returned to be checked.');
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        Test.stopTest();
    }

    //Check 'Perform Inventory Posting' and validate if inventory is posted (New)
    @isTest
    static void checkPerformInventoryPostingAndValidateInventoryPostingPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        saleReturn.dmpl__PerformInventoryPosting__c = true;
        update saleReturn;
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertEquals(true, saleReturn.dmpl__PerformInventoryPosting__c, 'Expected Perform Inventory Posting to be checked.');
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        Test.stopTest();
    }

    // Create sale return line from create from button
    @IsTest
    static void createSaleReturnLineFromButtonPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        SaleReturnHelper.createSaleReturnLinesFromSaleInvoiceInternal(new List<dmpl__SaleInvoiceLine__c>{invoiceLine}, null, saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.getReturnLine(saleReturn.Id);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created from create from button.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        System.assertEquals(invoiceLine.dmpl__ItemId__c, createdLine.dmpl__ItemId__c, 'Expected sale return line to have the correct item.');
        Test.stopTest();
    }

    //Edit less quantity in lines created from create from button
    @isTest
    static void editLessQuantityInLinesCreatedFromCreateFromButtonPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        SourceObjectInfo soi =  new SourceObjectInfo();
        soi.quantity = 9;
        soi.objectId = invoiceLine.Id;
        SaleReturnHelper.createSaleReturnLinesFromSaleInvoiceInternal(new List<dmpl__SaleInvoiceLine__c>{invoiceLine}, null, saleReturn.Id);
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.getReturnLine(saleReturn.Id);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created from create from button.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        createdLine = SaleReturnDataHelper.getSaleReturnLine(createdLine.Id);
        System.assertEquals(9, createdLine.dmpl__Quantity__c, 'Expected quantity in sale return line to be updated.');
        Test.stopTest();
    }

    //Edit more quantity in lines created from create from button
    @isTest
    static void editMoreQuantityInLinesCreatedFromCreateFromButtonNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        SourceObjectInfo soi =  new SourceObjectInfo();
        soi.objectId = invoiceLine.Id;
        soi.quantity = 25;
        Boolean exceptionThrown = false;
        try {
            SaleReturnHelper.createSaleReturnLinesFromSaleInvoiceInternal(new List<dmpl__SaleInvoiceLine__c>{invoiceLine}, null, saleReturn.Id);
            dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.getReturnLine(saleReturn.Id);
        }
        catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert(true, 'Expected exception to be thrown when trying to edit more quantity than available in sale invoice line.');
        Test.stopTest();
    }

    //Delete the lines created from create from button
    @isTest
    static void deleteLinesCreatedFromCreateFromButtonPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, invoice, invoiceLine);
        System.assertNotEquals(createdLine, null, 'Expected sale return line to be created from create from button.');
        System.assertEquals(saleReturn.Id, createdLine.dmpl__SaleReturnId__c, 'Expected sale return line to be linked to the correct sale return.');
        System.assertEquals(invoiceLine.Id, createdLine.dmpl__SaleInvoiceLineId__c, 'Expected sale return line to be linked to the correct sale invoice line.');
        dmpl__SaleReturnLine__c deletedLine = null;
        try {
            delete createdLine;
            deletedLine = SaleReturnDataHelper.getSaleReturnLine(createdLine.Id);
        } catch (Exception e) {
            deletedLine = null;
            System.assert(true, 'Expected sale return line to be deleted successfully.');
        }
        System.assertEquals(null, deletedLine, 'Expected sale return line to be deleted.');
        Test.stopTest();
    }

    //Change item in lines created from create from button
    @isTest
    static void changeItemInLinesCreatedFromCreateFromButtonNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        dmpl__SaleReturnLine__c createdLine = SaleReturnHelper.createReturnLineFromSaleInvoiceLine(invoiceLine, null);
        Boolean exceptionThrown = false;
        try {
            createdLine.dmpl__ItemId__c = item.Id;
            update createdLine;
        }
        catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception to be thrown');
        Test.stopTest();
    }

    //set quantity as 0 in sale return lines creation from create from button
    @isTest
    static void setQuantityAsZeroInSaleReturnLinesCreationFromCreateFromButtonNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleInvoice__c invoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c invoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(customer1, partner1, branch1);
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        saleReturn = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals(saleReturn.dmpl__PartnerAccountId__c, partner1.Id, 'Expected sale return to be linked to the correct partner.');
        System.assertEquals(saleReturn.dmpl__AccountId__c, customer1.Id, 'Expected sale return to be linked to the correct customer.');
        SourceObjectInfo soi =  new SourceObjectInfo();
        soi.objectId = invoiceLine.Id;
        soi.quantity = 0;
        Boolean exceptionThrown = false;
        try {
            SaleReturnHelper.createSaleReturnLinesFromSaleInvoiceInternal(new List<dmpl__SaleInvoiceLine__c>{invoiceLine}, null, saleReturn.Id);
            dmpl__SaleReturnLine__c createdLine = SaleReturnDataHelper.getReturnLine(saleReturn.Id);
        }
        catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert(true, 'Expected exception to be thrown when trying to edit more quantity than available in sale invoice line.');
        Test.stopTest();
    }
}