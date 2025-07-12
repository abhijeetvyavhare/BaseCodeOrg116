@isTest
public with sharing class BillHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount, branch, purchaseOrder, SupplierAccount);
        Test.StartTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList, purchaseOrder, goodsReceipt);
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(customerAccount, item, sku, itemLot, bill, priceListRule, taxGroup);
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(tax, bill);
        Test.StopTest();
 
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
 
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015','9988776564');
 
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,false,true,false);
 
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Purchase Price');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Purchase Price');
 
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false,false);
     
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
 
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule17 = TestDataHelpers.createPriceListRules(priceList3.id, item7.id,null,null,2000, System.today()-1,System.today()+9);
 
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);
 
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax('IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');
 
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleIGST18 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,null,null,null,null);  
        
        dmpl__ItemUnitOfMeasure__c uomCaseItem1 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem1 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item1.Id);
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
        bill.dmpl__Remarks__c='Hello';
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
        System.assertEquals(10, billLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(100, billLine.dmpl__UnitCost__c, 'Unit Cost should be 100');
        System.assertEquals(true, billLine.dmpl__IsCustomerBillable__c, 'IsCustomerBillable should be true');
    }
 
    @isTest
    static void updateBillLinePositive() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        System.assertNotEquals(billLine, null, 'BillLine should exist before update.');
        billLine.dmpl__Quantity__c = 5;
        billLine.dmpl__UnitCost__c = 190;
        update billLine;
        dmpl__BillLine__c updatedBillLine = BillTestDataHelpers.getBillLine();
        System.assertEquals(5, updatedBillLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(190, updatedBillLine.dmpl__UnitCost__c, 'UnitCost should be 190');
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
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before update.');
 
        billTax.dmpl__GLAmount__c = 100;
        billTax.dmpl__TaxAmount__c = 140;
        billTax.dmpl__TaxOnAmount__c = 120;
        Test.startTest();
        update billTax;
        Test.stopTest();
        dmpl__PurchaseInvoiceTax__c updatedBillTax = BillTestDataHelpers.getBillTax();      
        System.assertEquals(100, updatedBillTax.dmpl__GLAmount__c, 'GLAmount should be 100');
        System.assertEquals(140, updatedBillTax.dmpl__TaxAmount__c, 'TaxAmount should be 140');
        System.assertEquals(120, updatedBillTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be 120');
    }
 
    @isTest
    static void deleteBillTax() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before delete.');
        Test.startTest();
        delete bill;
        Test.stopTest();
        dmpl__PurchaseInvoiceTax__c deletedBillTax = null;
 
        try {
            deletedBillTax = BillTestDataHelpers.getBillTax();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedBillTax);
        } catch (Exception e) {
            deletedBillTax = null;
        }
        System.assertEquals(null, deletedBillTax, 'BillTax should be deleted and not found in query.');
    }
 
    @isTest()
    static void createBillLineWithActiveItem() {
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
 
        dmpl__Bill__c newBill = BillTestDataHelpers.createBill(supplier1.Id, branch4.Id, partner4.Id);
        
 		dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(partner4.Id, updatedBill.dmpl__PartnerAccountId__c);
        System.assertEquals(branch4.Id, updatedBill.dmpl__BranchId__c);
        //System.assertEquals(supplier1.Id, newBill.dmpl__AccountId__c);
 
        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__ShippingStreet__c);
        System.assertEquals('Hyderabad', updatedBill.dmpl__ShippingCity__c);
        System.assertEquals('Telangana', updatedBill.dmpl__ShippingState__c);
        System.assertEquals('500032', updatedBill.dmpl__ShippingPostalCode__c);
 
        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__BillingStreet__c);
        System.assertEquals('Hyderabad', updatedBill.dmpl__BillingCity__c);
        System.assertEquals('Telangana', updatedBill.dmpl__BillingState__c);
        System.assertEquals('India', updatedBill.dmpl__ShippingCountry__c);
        System.assertEquals('500032', updatedBill.dmpl__BillingPostalCode__c);
 
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c);
        System.assertEquals(null, updatedBill.dmpl__Status__c);
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c);  
    }
 
    @isTest
    static void BillCreationWithRequiredSKU() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
 
        Test.startTest();
 
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id, branch.Id, partner.Id);
 
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id, 10, sku.Id);
 
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
 
        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals('Hyderabad', updatedBill.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals('Telangana', updatedBill.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals('500032', updatedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        System.assertEquals('India', updatedBill.dmpl__ShippingCountry__c, 'Shipping country mismatch');
 
        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals('Hyderabad', updatedBill.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals('Telangana', updatedBill.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals('500032', updatedBill.dmpl__BillingPostalCode__c, 'Billing postal code mismatch'); 
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c, 'Account name should be Partner 4');
    }

    @isTest()
    static void createBillLineWithNoRequiredSKU() {
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__Bill__c newBill = BillTestDataHelpers.createBill(
            supplier1.Id, 
            branch4.Id, 
            partner4.Id
        );
        
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(partner4.Id, updatedBill.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch4.Id, updatedBill.dmpl__BranchId__c, 'Branch mismatch');
        //System.assertEquals(supplier1.Id, updatedBill.dmpl__AccountId__c, 'Supplier mismatch');

        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals('Hyderabad', updatedBill.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals('Telangana', updatedBill.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals('500032', updatedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        System.assertEquals('12 Industrial Zone', updatedBill.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals('Hyderabad', updatedBill.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals('Telangana', updatedBill.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals('India', updatedBill.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals('500032', updatedBill.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date mismatch');
        //System.assertEquals('Draft', updatedBill.dmpl__Status__c, 'Status mismatch');
        System.assertEquals('Partner 4', updatedBill.dmpl__AccountName__c, 'Account name mismatch');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            newBill.Id,
            item1.Id,
            10,
            null
        );
        
        billLine = BillTestDataHelpers.getBillLine(newBill.Id);
        System.assertEquals(item1.Id, billLine.dmpl__ItemId__c, 'Bill line item mismatch');
        System.assertEquals(10, billLine.dmpl__Quantity__c, 'Bill line quantity mismatch');
        System.assertEquals(1500, billLine.dmpl__UnitCost__c, 'Bill line unit cost mismatch');
        System.assertEquals(10, billLine.dmpl__InvoiceQuantity__c, 'Invoice quantity mismatch');
        System.assertEquals(10, billLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity mismatch');
        System.assertEquals(15000, billLine.dmpl__BaseAmount__c, 'Bill line base amount mismatch');
        System.assertEquals(15000, billLine.dmpl__Amount__c, 'Bill line amount mismatch');

        dmpl__Bill__c finalBill = BillTestDataHelpers.getBill(newBill.Id);
        System.assertEquals(15000, finalBill.dmpl__TotalLineBaseAmount__c, 'Final bill base amount mismatch');
        System.assertEquals(15000, finalBill.dmpl__TotalAmount__c, 'Final bill amount mismatch');
        //System.assertEquals(15000, finalBill.dmpl__GLAmount__c, 'Final GL amount mismatch');
        System.assertEquals(0, finalBill.dmpl__TotalDiscountAmount__c, 'Final net discount mismatch');
        System.assertEquals(0, finalBill.dmpl__TotalSchemeDiscountAmount__c, 'Final net scheme discount mismatch');
        Test.stopTest();
    } 
}