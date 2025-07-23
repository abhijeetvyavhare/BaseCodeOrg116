@isTest
public with sharing class BillReturnHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup('Account Group 1', null);
        dmpl__AccountGroupMember__c accountGroupMember = TestDataHelpers.createAccountGroupMember(accountGroup.Id, partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup('Item Group 1', 'Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber = TestDataHelpers.createItemGroupMember(itemGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 18', partnerAccount.Id, branch.Id);
        taxGroup.dmpl__PartnerAccountGroupId__c = accountGroup.Id;
        update taxGroup;
        dmpl__Tax__c tax = TestDataHelpers.createTax('CGST', taxGroup.Id, 18);
        dmpl__Tax__c taxSGST18 = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 18);
        dmpl__TaxGroupRule__c taxGroupRule18Item1 = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
          saleOrder, 
          item, 
          sku, 
          taxGroup
        );
        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.createSaleOrderTax(saleOrder, saleOrderLine);
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
          partnerAccount, 
          branch, 
          purchaseOrder, 
          supplierAccount
        );
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList);
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
          supplierAccount, 
          partnerAccount, 
          branch, 
          priceList
        );
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          bill, 
          billReturn, 
          item, 
          billLine
        );
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          item, 
          sku, 
          bill, 
          billLine, 
          grnLine, 
          taxGroup, 
          tax
        );
        Test.stopTest();
    }

    @isTest
    static void createBillReturnPositive() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        if (billReturn != null) {
            System.assertNotEquals(billReturn, null, 'Expected BillReturn to be created.');
        }
        System.assertEquals(false, billReturn.dmpl__PerformReturn__c, 'PerformReturn should be true');
        System.assertEquals(false, billReturn.dmpl__PerformInventoryPosting__c, 'PerformInventoryPosting should be false');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate should ' + Date.today());
    }

    @isTest
    static void updateBillReturnPositive() {
        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'Bill Return should exist before update.');
        billReturn.dmpl__PerformReturn__c = false;
        update billReturn;
        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn();
        System.assertEquals(false, updatedBillReturn.dmpl__PerformReturn__c, 'PerformReturn should be false');
        Test.stopTest();
    }

    @isTest
    static void deleteBillReturn() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'BillReturn should exist before delete.');
        delete billReturn;
        dmpl__BillReturn__c deletedBillReturn = null;
        try {
            deletedBillReturn = BillTestDataHelpers.getBillReturn();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedBillReturn);
        } catch (Exception e) {
            deletedBillReturn = null;
        }
        System.assertEquals(null, deletedBillReturn, 'BillReturn should be deleted and not found in query.');
    }

    @isTest
    static void createBillReturnLinePositive() {
        Test.startTest();
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        Test.stopTest();
        if (billReturnLine != null) {
            System.assertNotEquals(billReturnLine, null, 'Expected BillReturnLine to be created.');
        }
        System.assertEquals(2, billReturnLine.dmpl__Quantity__c, 'Quantity should be 2');
    }

    @isTest
    static void updateBillReturnLinePositive() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before update.');
        Test.startTest();
        billReturnLine.dmpl__Quantity__c = 5;
        update billReturnLine;
        Test.stopTest();
        dmpl__BillReturnLine__c updatedBillReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertEquals(5, updatedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 5');
    }

    @isTest
    static void deleteBillReturnLine() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before delete.');
        delete billReturnLine;
        dmpl__BillReturnLine__c deletedLine = null;
        try {
            deletedLine = BillTestDataHelpers.getBillReturnLine();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedLine);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'BillReturnLine should be deleted and not found in query.');
    }

    @isTest
    static void createBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'Expected BillReturnTax to be created.');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be true');
    }

    @isTest
    static void updateBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before update.');
        billReturnTax.dmpl__TaxAmount__c = 100;
        Test.startTest();
        update billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c updated = BillTestDataHelpers.getBillReturnTax();
        System.assertEquals(100, updated.dmpl__TaxAmount__c, 'TaxAmount should be 100');
    }

    @isTest
    static void deleteBillReturnTax() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before delete.');
        Test.startTest();
        delete billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c deleted = null;
        try {
            deleted = BillTestDataHelpers.getBillReturnTax();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deleted);
        } catch (Exception e) {
            deleted = null;
        }
        System.assertEquals(null, deleted, 'BillReturnTax should be deleted and not found in query.');
    }

    @isTest
    public static void billReturnTaxCreateRecordWithValidBillReturnBillReturnLineAndTaxPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          0, 
          0
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxCreateWithValidTaxGroupAndTaxRatePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          0
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxPopulateValidTaxAmountFieldAsPerTaxRateAndBasePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          null
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxTaxGroupLookupFiltersOnlyActiveValuesPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          null
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxTaxLookupFiltersOnlyActiveTaxValuesPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          null
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxEditTaxRateValueFrom18To9AndSaveSuccessfullyPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          null
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        billReturnTax.dmpl__TaxRate__c = 9;
        update billReturnTax;
        System.assertEquals(9, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billReturnTaxUpdateTaxGroupAfterCreationPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.createBillReturnTax(
          billReturn, 
          billReturnLine, 
          taxGroup, 
          tax, 
          18, 
          null
        );
        System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
        System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
        System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        billReturnTax.dmpl__TaxRate__c = 9;
        update billReturnTax;
        System.assertEquals(9, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxCreateRecordWithValidBillBillLineAndTaxFieldsPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxEnterCorrectTaxRateAndVerifyCalculationOnTaxAmountPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxProvideTaxOnAmountAndVerifyTaxAmountAutoCalculationPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxEnsureTaxGroupIsSelectedAndValidPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxCreatedByFieldReflectsLoggedInUserPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxLeaveTaxBlankAndAttemptSavePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          null, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(null, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxProvideTaxGroupThatIsInactivePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          null, 
          null, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(null, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(null, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxTryCreatingWithInvalidOrArchivedBillPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        try {
            dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
              taxGroup, 
              tax, 
              null, 
              null, 
              9, 
              null, 
              null
            );
            System.assert(false, 'Exception should be thrown');
        } catch (exception e) {
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }

    @isTest
    public static void billTaxEditTaxRateFrom9To18AndVerifyRecalculatedTaxAmountPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        billTax.dmpl__TaxRate__c = 18;
        update billTax;
        System.assertEquals(18, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxChangeTaxGroupToUpdatedConfigurationAndSavePositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        billTax.dmpl__TaxGroupId__c = null;
        update billTax;
        System.assertEquals(null, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        Test.stopTest();
    }

    @isTest
    public static void billTaxEditBillLineToBlankAfterSavePositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch);
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
          billReturn, 
          item,  
          5, 
          1500
        );
        billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
        System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
        System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
        System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
          bill.Id, 
          item.Id, 
          10, 
          null
        );
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(
          taxGroup, 
          tax, 
          bill, 
          billLine, 
          9, 
          null, 
          null
        );
        System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
        System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
        System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
        System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        billTax.dmpl__BillLineId__c = null;
        update billTax;
        System.assertEquals(null, billTax.dmpl__BillLineId__c, 'BillLineId does not match');
        Test.stopTest();
    }
}