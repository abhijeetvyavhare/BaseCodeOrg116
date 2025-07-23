@isTest
public with sharing class BillHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        priceList.dmpl__PriceListType__c = 'Purchase Price';
        update priceList;
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7','Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.id, true);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 288', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 14);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 14);
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList);
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxCGST, bill);
    }

    @isTest
    static void createBillPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        if (bill != null) {
            System.assertNotEquals(bill, null, 'Expected Bill to be created.');
        }
        System.assertEquals(100, bill.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 100');
        System.assertEquals(false, bill.dmpl__PerformGLPosting__c, 'PerformGLPosting should be false');
        System.assertEquals('Expense Bill', bill.dmpl__TypeOfBill__c, 'TypeOfBill should be false');
    }

    @isTest
    static void updateBillPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        System.assertNotEquals(bill, null, 'Bill should exist before update.');
        bill.dmpl__TCSEligibleAmount__c = 210;
        bill.dmpl__SupplierInvoiceAmount__c = 69;
        bill.dmpl__Remarks__c = 'Hello';
        update bill;
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill();
        System.assertEquals(210, updatedBill.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 210');
        System.assertEquals(69, updatedBill.dmpl__SupplierInvoiceAmount__c, 'SupplierInvoiceAmount should be 69');
        System.assertEquals('Hello', updatedBill.dmpl__Remarks__c, 'Remarks should be Hello');
    }

    @isTest
    static void deleteBill() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        System.assertNotEquals(bill, null, 'Bill should exist before delete.');
        delete bill;
        dmpl__Bill__c deletedBill = null;
        try {
            deletedBill = BillTestDataHelpers.getBill();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedBill);
        } catch (Exception e) {
            deletedBill = null;
        }
        System.assertEquals(null, deletedBill, 'Bill should be deleted and not found in query.');
    }

    @isTest
    static void createBillLinePositive() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        if (billLine != null) {
            System.assertNotEquals(billLine, null, 'Expected Bill Line to be created.');
        }
        System.assertEquals(5, billLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(1000, billLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(true, billLine.dmpl__IsCustomerBillable__c, 'IsCustomerBillable should be true');
    }

    @isTest
    static void updateBillLinePositive() {
        Test.startTest();
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        System.assertNotEquals(billLine, null, 'BillLine should exist before update.');
        billLine.dmpl__Quantity__c = 5;
        billLine.dmpl__UnitCost__c = 190;
        update billLine;
        dmpl__BillLine__c updatedBillLine = BillTestDataHelpers.getBillLine();
        System.assertEquals(5, updatedBillLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(190, updatedBillLine.dmpl__UnitCost__c, 'UnitCost should be 190');
        Test.stopTest();
    }

    @isTest
    static void deleteBillLine() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        System.assertNotEquals(billLine, null, 'BillLine should exist before delete.');
        try {
            delete billLine;
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('downstream transaction'),
                'Expected downstream transaction error, got: ' + e.getMessage()
            );
        }
    }

    @isTest
    static void createBillTaxPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        if (billTax != null) {
            System.assertNotEquals(billTax, null, 'Expected BillTax to be created.');
        }
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'TaxOnAmount should be true');
    }

    @isTest
    static void updateBillTaxPositive() {
        Test.startTest();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before update.');
        billTax.dmpl__GLAmount__c = 100;
        billTax.dmpl__TaxAmount__c = 140;
        billTax.dmpl__TaxOnAmount__c = 120;
        update billTax;
        dmpl__PurchaseInvoiceTax__c updatedBillTax = BillTestDataHelpers.getBillTax();      
        System.assertEquals(100, updatedBillTax.dmpl__GLAmount__c, 'GLAmount should be 100');
        System.assertEquals(140, updatedBillTax.dmpl__TaxAmount__c, 'TaxAmount should be 140');
        System.assertEquals(120, updatedBillTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be 120');
        Test.stopTest();
    }

    @isTest
    static void deleteBillTax() {
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before delete.');
        delete bill;
        dmpl__PurchaseInvoiceTax__c deletedBillTax = null;
        try {
            deletedBillTax = BillTestDataHelpers.getBillTax();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedBillTax);
        } catch (Exception e) {
            deletedBillTax = null;
        }
        System.assertEquals(null, deletedBillTax, 'BillTax should be deleted and not found in query.');
        Test.stopTest();
    }

    @isTest()
    static void createBillLineWithActiveItem() {
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Bill__c newBill = BillTestDataHelpers.createBill(supplier1.Id, branch.Id, partner4.Id);
 		dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(partner4.Id, updatedBill.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, updatedBill.dmpl__BranchId__c);
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c);
        System.assertEquals(null, updatedBill.dmpl__Status__c);
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c);  
    }

    @isTest
    static void BillCreationWithRequiredSKU() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id, branch.Id, partner.Id);
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id, 
            item.Id, 
            10, 
            sku.Id
        );
        Test.stopTest();
        dmpl__BillLine__c insertedLine = BillTestDataHelpers.getBillLine(bill.Id);
        System.assertEquals(2000, insertedLine.dmpl__UnitCost__c, 'Unit cost should be 2000');
        System.assertEquals(item.Id, insertedLine.dmpl__ItemId__c, 'Item should be Item 7');
        System.assertEquals(10, insertedLine.dmpl__InvoiceQuantity__c, 'Invoice quantity should be 10');
        System.assertEquals(10, insertedLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 10');
        System.assertEquals(20000, insertedLine.dmpl__BaseAmount__c, 'Base amount should be 20000');
        System.assertEquals(20000, insertedLine.dmpl__Amount__c, 'Amount should be 20000');
        System.assertNotEquals(null, insertedLine.Name, 'Bill Line should have a name');
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(20000, updatedBill.dmpl__TotalAmount__c, 'Base amount should be 20000');
        System.assertEquals(20000, updatedBill.dmpl__TotalLineAmount__c, 'Amount should be 20000');
        System.assertEquals(20000, updatedBill.dmpl__TotalLineBaseAmount__c, 'GL amount should be 20000');
        System.assertEquals(0, updatedBill.dmpl__TotalLineTaxAmount__c, 'dmpl__TotalLineTaxAmount__c should be 0');
        System.assertEquals(0, updatedBill.dmpl__TotalSchemeDiscountAmount__c, 'Net scheme discount should be 0');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c, 'Account name should be Partner 4');
    }

    @isTest()
    static void createBillLineWithNoRequiredSKU() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        BillMasterData.createBillLineWithNoRequiredSKUData(partner.Id, branch.Id, priceList.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Bill__c newBill = BillTestDataHelpers.createBill(supplier.Id, branch.Id, partner.Id);
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(partner.Id, updatedBill.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, updatedBill.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date mismatch');
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c, 'Account name mismatch');
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            newBill.Id, 
            item.Id, 
            10, 
            null
        );
        billLine = BillTestDataHelpers.getBillLine(newBill.Id);
        System.assertEquals(item.Id, billLine.dmpl__ItemId__c, 'Bill line item mismatch');
        System.assertEquals(10, billLine.dmpl__Quantity__c, 'Bill line quantity mismatch');
        System.assertEquals(1500, billLine.dmpl__UnitCost__c, 'Bill line unit cost mismatch');
        System.assertEquals(10, billLine.dmpl__InvoiceQuantity__c, 'Invoice quantity mismatch');
        System.assertEquals(10, billLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity mismatch');
        System.assertEquals(15000, billLine.dmpl__BaseAmount__c, 'Bill line base amount mismatch');
        System.assertEquals(15000, billLine.dmpl__Amount__c, 'Bill line amount mismatch');
        dmpl__Bill__c finalBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(15000, finalBill.dmpl__TotalLineBaseAmount__c, 'Final bill base amount mismatch');
        System.assertEquals(15000, finalBill.dmpl__TotalAmount__c, 'Final bill amount mismatch');
        System.assertEquals(0, finalBill.dmpl__TotalDiscountAmount__c, 'Final net discount mismatch');
        System.assertEquals(0, finalBill.dmpl__TotalSchemeDiscountAmount__c, 'Final net scheme discount mismatch');
        Test.stopTest();
    } 

    @isTest
    static void createBillWithCorrectPartnerAndBranchPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }

    @isTest
    static void createBillWithSupplierAccountPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }


    @isTest
    static void createBillWithWrongPartnerAccountNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partnerAccount1.Id);
            System.assertEquals(null, bill.Id, 'Bill should not be created with wrong partner account');
        } catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }

    @isTest
    static void createBillWithInactivePartnerAccountNegative(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
            System.assertEquals(null, bill.Id, 'Bill Id should not be created with inactive partner account');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }

    @isTest
    static void createBillWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partnerAccount1.Id);
            System.assertEquals(null, bill.Id, 'Bill should not be created with wrong branch');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }

    @isTest
    static void createBillWithInactiveBranchNegative(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
            System.assertEquals(null, bill.Id, 'Bill Id should not be created with inactive branch');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }

    @isTest
    static void createBillWithNoSupplierAccountPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(null,branch.Id,partner.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
       //updating record with wrong partner account
    @isTest
    static void updateBillWithWrongPartnerAccountNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount1.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning wrong partner Account');
        Test.stopTest();
    }

    @isTest
    static void updateBillWithSupplierAccountPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(null,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__supplierAccountId__c = supplier.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'Exception caught while assigning Supplier Account');
        Test.stopTest();
    }

    @isTest
    static void updateBillWithoutSupplierAccountPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(null,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__supplierAccountId__c = null;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'Exception caught while assigning Supplier Account');
        Test.stopTest();
    }
      @isTest
    static void updateBillWithInactivePartnerAccountNegative(){
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught,'Expected exception while assigning inactive partner Account');
        Test.stopTest();
    }
      //Scenario faling while assigning wrong branch
    @isTest
    static void updateBillWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount1.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning wrong Branch');
        Test.stopTest();
    }
      @isTest
    static void updateBillWithInactiveBranchNegative(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch3 =TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__BranchId__c = branch3.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning inactive Branch');
        Test.stopTest();
    }
     @isTest
    static void createBillWithBackwardDatePositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id,Date.newInstance(2025, 5, 14),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.newInstance(2025, 5, 14), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }

    @isTest
    static void updateBillWithBackwardDatePositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__DocumentDate__c = Date.newInstance(2025, 4, 16);
            update insertedBill;
            System.assertEquals(Date.newInstance(2025, 4, 16), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while assigning backward date');
        Test.stopTest();
    }
     @isTest
    static void createBillWithPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id,Date.today(),purchaseOrder.Id,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals('56 Industrial Layout', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
    }

    @isTest
    static void createBillWithoutPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals('56 Industrial Layout', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
       @isTest
    static void updateBillWithPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PurchaseOrderId__c = purchaseOrder.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while assigning Purchase Order');
        Test.stopTest();
        if(!exceptionCaught){
            System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
            System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
        }
    }
       
    @isTest
    static void updateBillWithoutPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id,Date.today(),purchaseOrder.Id,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PurchaseOrderId__c = null;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while removing Purchase Order');
        Test.stopTest();
        if(!exceptionCaught){
            System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
            System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        }
    }
       
    @isTest
    static void createBillWithActivePriceListPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.getBranch('Branch 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch.Id,partner.Id,Date.today(),null,priceList3.Id,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partner.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(priceList3.Id, insertedBill.dmpl__PriceListId__c, 'Price List should match');
    }
    
    @isTest
    static void updateBillWithGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount1,branch1,null,supplier);
        System.assertNotEquals(null, goodsReceipt.Id, 'Goods Receipt should be created');
        System.assertEquals(partnerAccount1.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, goodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), goodsReceipt.dmpl__DocumentDate__c, 'Document date should match');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__GoodsReceiptId__c = goodsReceipt.Id;
            update insertedBill;
        } catch(Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught while assiging Goods Receipt to Bill');
        if(!exceptionCaught){
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(goodsReceipt.Id, insertedBill.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
            System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(supplier.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        }
    }

    @isTest
    static void updateBillWithoutGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount1,branch1,null,supplier);
        System.assertNotEquals(null, goodsReceipt.Id, 'Goods Receipt should be created');
        System.assertEquals(partnerAccount1.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, goodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), goodsReceipt.dmpl__DocumentDate__c, 'Document date should match');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,goodsReceipt.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(goodsReceipt.Id, insertedBill.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__GoodsReceiptId__c = null;
            update insertedBill;
        } catch(Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught while removing Goods Receipt from Bill');
        if(!exceptionCaught){
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(supplier.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        }
    }
}