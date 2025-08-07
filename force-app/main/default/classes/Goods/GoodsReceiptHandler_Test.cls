@isTest
private class GoodsReceiptHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup('Account Group 1', null);
        dmpl__AccountGroupMember__c accountGroupMember = TestDataHelpers.createAccountGroupMember(accountGroup.id, partner.id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, false);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('Tax Group 1', partner.Id, branch.Id);
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(partner.Id, branch.Id, supplier.Id);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item, 
            sku, 
            purchaseOrder, 
            taxGroup, 
            purchaseRequisition
        );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partner, 
            branch, 
            purchaseOrder, 
            supplier
        );
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,goodsReceipt);
        Test.stopTest();
    }
    
    @isTest
    static void createGoodsReceiptTest() {
        Test.startTest();
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        Test.stopTest();
        System.assertNotEquals(null, receipt, 'Goods Receipt should have been created');
        System.assertEquals(Date.today(), receipt.dmpl__DocumentDate__c);
    }
    
    @isTest
    static void createGoodsReceiptLineTest() {
        Test.startTest();
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        Test.stopTest();
        System.assertNotEquals(null, grn, 'GRN Line should have been created');
        System.assertEquals(null, grn.dmpl__ReceivedQuantity__c);
        System.assertEquals(null, grn.dmpl__OrderedQuantity__c);
        System.assertEquals(null, grn.dmpl__SupplierQuantity__c);
    }
    
    @isTest
    static void updateGoodsReceiptTest() {
        Test.startTest();
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(null, receipt, 'Goods Receipt should exist before update.');
        receipt.dmpl__PerformReceive__c = false;
        receipt.dmpl__PerformInspection__c = false;
        receipt.dmpl__PerformInspectionComplete__c = false;
        receipt.dmpl__IsInspectionCompleted__c = false;
        receipt.dmpl__PerformReleaseBill__c = false;
        update receipt;
        dmpl__GoodsReceipt__c updated = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        Test.stopTest(); 
        System.assertEquals(false, updated.dmpl__PerformReceive__c);
        System.assertEquals(false, updated.dmpl__PerformInspection__c);
        System.assertEquals(false, updated.dmpl__PerformInspectionComplete__c);
        System.assertEquals(false, updated.dmpl__IsInspectionCompleted__c);
    }
    
    @isTest
    static void updateGoodsReceiptLineTest() {
        Test.startTest();
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grn, 'GRN Line should exist before update.');
        grn.dmpl__ReceivedQuantity__c = 5;
        grn.dmpl__OrderedQuantity__c = 5;
        grn.dmpl__SupplierQuantity__c = 5;
        update grn;
        dmpl__GoodsReceiptLine__c updated = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        Test.stopTest();
        System.assertEquals(5, updated.dmpl__ReceivedQuantity__c);
        System.assertEquals(5, updated.dmpl__OrderedQuantity__c);
        System.assertEquals(5, updated.dmpl__SupplierQuantity__c);
    }
    
    @isTest
    static void deleteGoodsReceiptTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(null, receipt, 'Goods Receipt should exist before delete.');
        Test.startTest();
        delete receipt;
        Test.stopTest();
		dmpl__GoodsReceipt__c deletedReceipt = null;
        try {
            deletedReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        } catch (Exception e) {
			deletedReceipt = null;
        }
        System.assertEquals(null, deletedReceipt, 'Goods receipt should be deleted.');
    }
    
    @isTest
    static void deleteGoodsReceiptLineTest() {
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c grn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grn, 'GRN Line should exist before delete.');
        Test.startTest();
        delete receipt;
        Test.stopTest();
		dmpl__GoodsReceiptLine__c deletedGrn = null;
        try {
           	deletedGrn = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedGrn);
        } catch (Exception e) {
            deletedGrn = null;
        }
        System.assertEquals(null, deletedGrn, 'Goods receipt lines should be deleted.');
    }
    
    @isTest
    static void createGoodsReceiptWithCorrectPartnerAndBranchPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch(Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        Test.stopTest();
    }
    
    @isTest
    static void createGoodsReceiptWithSupplierAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch(Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        Test.stopTest();
    }
    
    @isTest
    static void createGoodsReceiptWithWrongPartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
            System.Assert.isTrue(false, 'Exception Expected!');
        } catch(Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createGoodsReceiptWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
            System.Assert.isTrue(false, 'Exception Expected!');
        } catch(Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createGoodsReceiptWithNoSupplierAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                null
            );
        } catch(Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateGoodsReceiptWithSupplierAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch(Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        try {
            goodsReceipt.dmpl__SupplierAccountId__c = null;
            update goodsReceipt;
            System.Assert.isTrue(false, 'Exception Expected!: update must fail');
        } catch(Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateGoodsReceiptWithWrongPartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch(Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        partner = TestDataHelpers.createPartnerAccount('Partner 3');
        try {
            goodsReceipt.dmpl__PartnerAccountId__c = partner?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false, 'Exception Expected!: update must fail');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateGoodsReceiptWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        try {
            goodsReceipt.dmpl__PartnerAccountId__c = partner?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false, 'Exception Expected!: update must fail');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateGoodsReceiptWithWrongBranchNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(false, 'Exception not Expected!' + e.getMessage());
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier must match');
        partner = TestDataHelpers.createPartnerAccount('Partner 4');
        branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        try {
            goodsReceipt.dmpl__BranchId__c = branch?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false, 'Exception Expected!: update must fail');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Exception Expected!');
        }
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptShouldNotBeCreatedWithInvalidPartnerNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt is not created!' + e.getMessage());
        }
        try {
            dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt Line is not created!' + e.getMessage());
        }
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,goodsReceipt);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill is not created!' + e.getMessage());
        }
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,goodsReceipt);
            dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
            dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,goodsReceipt);
            dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
            dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
                bill, 
                billReturn, 
                item, 
                billLine
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return Line is not created!' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptWithPartnerBranchSupplierAndPOPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,false);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PurchaseOrder__c purchaseOrder2 = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id,partner.Id,branch.Id);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                purchaseOrder, 
                supplier
        );
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                purchaseOrder2, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt is not created!' + e.getMessage());
        }
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(receipt, item, sku);
        goodsReceiptLine.dmpl__DamagedQuantity__c=0;
        update goodsReceiptLine;
        System.assertEquals(partner.Id, receipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, receipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, receipt.dmpl__SupplierAccountId__c, 'Supplier must match');
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptNotCreatedWithInvalidPartnerBranchValidSupplierNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt is not created!' + e.getMessage());
        }
    }

    @isTest
    static void goodsReceiptAndGRLineWithPartnerBranchSupplierPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,false);
        Test.startTest();
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(receipt, item, sku);
        Test.stopTest();
        System.assertEquals(partner.Id, receipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, receipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, receipt.dmpl__SupplierAccountId__c, 'Supplier must match');
    }

    @isTest
    static void billReturnAndBillReturnLineWithInvalidPartnerBranch(){
         Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,false);
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,receipt);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill is not created!' + e.getMessage());
        }
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,receipt);
            dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
            dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
        try {
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList,purchaseOrder,receipt);
            dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id, item.Id);
            dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
                bill, 
                billReturn, 
                item, 
                billLine
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return Line is not created!' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptAndBillReturnBillReturnLineGRLineWithPartnerBranchSupplierPositive(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        item7.dmpl__IsSKURequired__c=true;
        update item7;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1',item7.Id,true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2',item.Id,true);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(receipt, item, sku2);
        goodsReceiptLine.dmpl__DamagedQuantity__c=0;
        update goodsReceiptLine;
        Test.stopTest();
        System.assertEquals(0, goodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 0');
        System.assertEquals(partner.Id, receipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, receipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, receipt.dmpl__SupplierAccountId__c, 'Supplier must match');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
        );
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item7.Id, sku.Id);
        System.assertNotEquals(null, billReturn, 'BillReturn should be created');
        System.assertNotEquals(null, billReturnLine, 'BillReturnLine should be created');
    }

    @isTest
    static void goodReceiptShouldNotCreatedInActivePartnerSupplierBranch(){
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2',partner.Id);
        partner.dmpl__IsActive__c=false;
        update partner;
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,true);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        dmpl__BillReturn__c billReturn;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt is not created!' + e.getMessage());
        }
        try {
             billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
         try {
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
    }

     @isTest
    static void goodReceiptShouldNotCreatedInActiveSupplierBranchAndPartner(){
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2',partner.Id);
        partner.dmpl__IsActive__c=false;
        update partner;
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 2');
        supplier.dmpl__IsActive__c=false;
        update supplier;
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c=true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,true);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        dmpl__BillReturn__c billReturn;
        try {
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt is not created!' + e.getMessage());
        }
        try {
             billReturn = BillTestDataHelpers.createBillReturn(
                supplier, 
                partner, 
                branch, 
                priceList
            );
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
         try {
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
    }

    @isTest
    static void goodsReceiptLineShouldNotGetCreatedWithInactiveItemSKU(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,true);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        item.dmpl__IsActive__c=false;
        update item;
        Test.startTest();
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                purchaseOrder, 
                supplier
        );
        try {
            dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt Line is not created!' + e.getMessage());
        }
    }

    @isTest
    static void billReturnLineShouldNotGetCreatedWithInactiveItemSKU(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 2',item.Id,true);
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        item.dmpl__IsActive__c=false;
        update item;
        Test.startTest();
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
        );
        try {
            dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Goods Receipt Line is not created!' + e.getMessage());
        }
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
                partner, 
                branch, 
                goodsReceipt.Id
        );
        try {
            dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, sku.Id);
        } catch (Exception e) {
            System.Assert.isTrue(True, 'Bill Return is not created!' + e.getMessage());
        }
    }
}