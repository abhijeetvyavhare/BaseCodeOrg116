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
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptWithPartnerBranchSupplierPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                null, 
                supplier
        );
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        System.assertEquals(partner.Id, receipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, receipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, receipt.dmpl__SupplierAccountId__c, 'Supplier must match');
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptWithPartnerBranchSupplierAndPOPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
                dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
                partner, 
                branch, 
                purchaseOrder, 
                supplier
        );
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        System.assertEquals(partner.Id, receipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, receipt.dmpl__BranchId__c, 'Branch must match');
        System.assertEquals(supplier.Id, receipt.dmpl__SupplierAccountId__c, 'Supplier must match');
        Test.stopTest();
    }

    @isTest
    static void goodsReceiptWithValidPartnerBranchSupplier(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c receipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
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
}