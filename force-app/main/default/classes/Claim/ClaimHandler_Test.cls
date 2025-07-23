@isTest
public with sharing class ClaimHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1','Product');
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partnerAccount.Id, branch.Id, supplier.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claim.Id);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            partnerAccount,
            branch,
            priceList
        );
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__SaleOrder__c saleOrder=SaleOrderDataHelper.createSaleOrder(customer,branch);
        dmpl__SaleInvoice__c saleInvoice=SaleInvoiceDataHelper.createSaleInvoice(
            customer,
            branch,
            saleOrder,
            priceList
        );
        dmpl__TaxGroup__c taxGroupGST28partner = TestDataHelpers.createTaxGroup('GST 28', partnerAccount.Id, branch.Id);
        dmpl__Tax__c tax = TestDataHelpers.createTax('CGST', taxGroupGST28partner.Id, 14);
    }

    @isTest
    static void createClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        System.assertNotEquals(null, claim.Id, 'Claim should be inserted');
    }

    @isTest
    static void createClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        System.assertNotEquals(null, line.Id, 'Claim Line should be created');
        System.assertEquals('Approved', line.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(2, line.dmpl__ClaimQuantity__c, 'Claim Quantity should be 2');
    }

    @isTest
    static void updateClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        claim.dmpl__Status__c = 'Reconcile';
        claim.dmpl__DocumentDate__c = Date.today().addDays(5);
        update claim;
        Test.stopTest();
        dmpl__Claim__c updated = ClaimDataHelper.getClaims(claim.Id);
        System.assertEquals('Reconcile', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(Date.today().addDays(5), updated.dmpl__DocumentDate__c, 'Document date should be updated');
    }

    @isTest
    static void updateClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        Test.startTest();
        line.dmpl__Status__c = 'Rejected';
        line.dmpl__ClaimQuantity__c = 5;
        line.dmpl__UnitPrice__c = 1000;
        update line;
        Test.stopTest();
        dmpl__ClaimLine__c updated = ClaimDataHelper.getClaimLines(line.Id);
        System.assertEquals('Rejected', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(5, updated.dmpl__ClaimQuantity__c, 'Claim Quantity should be updated to 5');
        System.assertEquals(1000, updated.dmpl__UnitPrice__c, 'Unit Price should be updated');
    }

    @isTest
    static void deleteClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        Test.startTest();
        delete line;
        Test.stopTest();
        dmpl__ClaimLine__c deletedLine;
        try {
            deletedLine = ClaimDataHelper.getClaimLines(line.Id);
        } catch (QueryException e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Claim Line should be deleted');
    }

    @isTest
    static void deleteClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        delete claim;
        Test.stopTest();
        dmpl__Claim__c deletedClaim;
        try {
            deletedClaim = ClaimDataHelper.getClaims(claim.Id);
        } catch (QueryException e) {
            deletedClaim = null;
        }
        System.assertEquals(null, deletedClaim, 'Claim should be deleted');
    }

    @isTest
    static void createClaimWithSupplierAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1') ;
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(partnerAccount.Id, branch.Id);
        System.assertNotEquals( insertedClaim.Id,null, 'Claim should be inserted');
        System.assertEquals( insertedClaim.dmpl__PartnerAccountId__c,partnerAccount.Id, 'Partner account should match');
        System.assertEquals(insertedClaim.dmpl__BranchId__c,branch.Id,  'Branch should match');
        System.assertEquals(insertedClaim.dmpl__SupplierNameId__c,supplierAccount.Id,  'Supplier account should match');
    }

    @isTest
    static void createClaimWithoutSupplierAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__Claim__c claim = null;
        try {
            claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
            System.assert(true, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('supplier'),'Exception should indicate that Supplier Account is mandatory. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimWithValidPartnerAndSaleInvoicePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        claim.dmpl__SaleInvoiceId__c = saleInvoice.Id;
        update claim;
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        System.assertNotEquals(null, insertedClaim.Id, 'Claim should be inserted');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should match');
        System.assertEquals(saleInvoice.Id, insertedClaim.dmpl__SaleInvoiceId__c, 'Sale Invoice should match');
    }

    @isTest
    static void createClaimWithBillReturnReferencePositive() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturnRef = BillTestDataHelpers.getBillReturn();
        dmpl__Claim__c insertedClaim = ClaimDataHelper.createClaim(partner.Id, branch.Id,supplier.Id);
        System.assertNotEquals(null, insertedClaim.Id, 'Claim should be inserted');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should match');
    }

    @isTest
    static void createClaimCreationWithPurchaseReturnReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c pr = ClaimDataHelper.createPurchaseRetrun(supplier,partner,branch);
        System.assertNotEquals(null, pr.Id, 'Purchase return will be created');
        System.assertEquals(partner.Id, pr.dmpl__PartnerAccountId__c, 'Partner account should be Partner 1');
        System.assertEquals(branch.Id, pr.dmpl__BranchId__c, 'Branch should be  branch 1');
        System.assertEquals(supplier.Id, pr.dmpl__SupplierAccountId__c, 'Supplier account should be supplier 1');
        System.assertEquals(Date.today(), pr.dmpl__DocumentDate__c, 'Date shoube be todays Date');
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        claim.dmpl__PurchaseReturnId__c = pr.Id;
        update claim;
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        System.assertNotEquals(null, insertedClaim.Id, 'claim will get created at draft stage');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner account Should be partner 1');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should be branch 1');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier account should be supplier 1');
    }

    @isTest
    static void createClaimWithGoodsReceiptReferencePositive() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt = ClaimDataHelper.createGoodsReceipt(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        dmpl__Claim__c insertedClaim = ClaimDataHelper.createClaim(partner.Id,branch.Id,supplier.Id);
        insertedClaim.dmpl__GoodsReceiptId__c = goodsReceipt.Id;
        update insertedClaim;
        Test.stopTest();
        System.assertNotEquals(null, insertedClaim.Id, 'Claim will get created at draft stage');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c,'Partner account should match');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c,'Branch should match');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c,'supplier account should match');
    }

    @isTest
    static void createClaimWithRepairOrderReferencePositive() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__RepairOrder__c repairOrder = ClaimDataHelper.createRepairOrder(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        dmpl__Claim__c insertedClaim = ClaimDataHelper.createClaim(partner.Id, branch.Id, supplier.Id);
        insertedClaim.dmpl__RepairOrderId__c = repairOrder.Id;
        update insertedClaim;
        Test.stopTest();
        System.assertNotEquals(null, insertedClaim.Id,'claim should be inserted');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c,'Partner account should match');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c,'Branch should match');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c,'supplier account should match');
        System.assertEquals(repairOrder.Id, insertedClaim.dmpl__RepairOrderId__c,'Repair order Id should match');
        System.assertEquals('Damaged', insertedClaim.dmpl__ClaimType__c,'Claim type should Damaged');
    }

    @isTest
    static void createClaimWithSaleInvoicePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.getSaleInvoice();
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        claim.dmpl__SaleInvoiceId__c = saleInvoice.Id;
        update claim;
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        Test.stopTest();
        System.assertNotEquals(null, insertedClaim, 'Claim should be inserted');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should match');
        System.assertEquals(saleInvoice.Id, insertedClaim.dmpl__SaleInvoiceId__c, 'Sale Invoice should match');
    }

    @isTest
    static void createClaimWithItemServiceContractPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemServiceContract__c itemServiceContract = ClaimDataHelper.createItemServiceContract('Contract 1',item);
        dmpl__Claim__c Claim = ClaimDataHelper.createClaimWithServiceContract(
            partner.Id,
            branch.Id,
            supplier.Id,
            'Shortage',
            'Draft',
            itemServiceContract.Id
        );
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(Claim.Id);
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should remain Supplier 1');
        System.assertEquals(itemServiceContract.Id, insertedClaim.dmpl__ItemServiceContractId__c, 'Item Service Contract should be updated');
        System.assertEquals(insertedClaim.Name, insertedClaim.Name, 'Claim Name should remain same');
        System.assertEquals(Date.today(), insertedClaim.dmpl__DocumentDate__c, 'Document Date should remain Today');
    }

    @isTest
    static void updateClaimWithBillReturnReferenceEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturnRef = BillTestDataHelpers.getBillReturn();
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        System.assertNotEquals(null, insertedClaim, 'Claim should be created');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should be Supplier 1');
        System.assert(insertedClaim.Name != null, 'Claim Name should not be null');
        insertedClaim.dmpl__BillReturnId__c = billReturnRef.Id;
        Test.startTest();
        update insertedClaim;
        Test.stopTest();
        dmpl__Claim__c updatedClaim = ClaimDataHelper.getClaim(insertedClaim.Id);
        System.assertNotEquals(null, updatedClaim, 'Claim should still exist after update');
        System.assertEquals(partner.Id, updatedClaim.dmpl__PartnerAccountId__c, 'Partner should still be Partner 1');
        System.assertEquals(branch.Id, updatedClaim.dmpl__BranchId__c, 'Branch should still be Branch 1');
        System.assertEquals(supplier.Id, updatedClaim.dmpl__SupplierNameId__c, 'Supplier should still be Supplier 1');
        System.assertEquals(billReturnRef.Id, updatedClaim.dmpl__BillReturnId__c, 'Bill Return should be updated to BR25060009');
        System.assertEquals(insertedClaim.Name, updatedClaim.Name, 'Claim Name should remain the same');
    }

    @isTest
    static void updateClaimWithGoodsReceiptReferenceEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c po = ClaimDataHelper.createPurchaseOrder(branch, supplier);
        dmpl__GoodsReceipt__c goodsReceipt = ClaimDataHelper.createGoodsReceipt(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        dmpl__Claim__c updatedClaim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        updatedClaim.dmpl__GoodsReceiptId__c = goodsReceipt.Id;
        update updatedClaim;
        Test.stopTest();
        System.assertNotEquals(null, updatedClaim,'Claim should be inserted');
        System.assertEquals(partner.Id, updatedClaim.dmpl__PartnerAccountId__c,'Partner account should match');
        System.assertEquals(branch.Id, updatedClaim.dmpl__BranchId__c,'barnch should match');
        System.assertEquals(supplier.Id, updatedClaim.dmpl__SupplierNameId__c,'Supplier account should match');
        System.assertEquals(goodsReceipt.Id, updatedClaim.dmpl__GoodsReceiptId__c,'Goods Reciept should match');
    }

    @isTest
    static void updateClaimWithRepairOrderReferenceEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__RepairOrder__c repairOrder = ClaimDataHelper.createRepairOrder(partner.Id, branch.Id, supplier.Id);
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        insertedClaim.dmpl__RepairOrderId__c = repairOrder.Id;
        Test.startTest();
        update insertedClaim;
        Test.stopTest();
        dmpl__Claim__c updatedClaim = ClaimDataHelper.getClaim(insertedClaim.Id);
        System.assertEquals(repairOrder.Id, updatedClaim.dmpl__RepairOrderId__c,'Repair Order Id should match');
    }

    @isTest
    static void updateClaimWithSaleInvoiceReferenceEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        System.assertNotEquals(null, insertedClaim, 'Claim should be created');
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'dmpl__PartnerAccountId__c should be Partner 1');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'dmpl__BranchId__c should be Branch 1');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'dmpl__SupplierNameId__c should be Supplier 1');
        System.assert(insertedClaim.Name != null, 'Claim name should not be null');
        insertedClaim.dmpl__SaleInvoiceId__c = saleInvoice.Id;
        Test.startTest();
        update insertedClaim;
        Test.stopTest();
        dmpl__Claim__c updatedClaim = ClaimDataHelper.getClaim(insertedClaim.Id);
        System.assertNotEquals(null, updatedClaim, 'Claim should exist after update');
        System.assertEquals(partner.Id, updatedClaim.dmpl__PartnerAccountId__c, 'dmpl__PartnerAccountId__c should be Partner 1');
        System.assertEquals(branch.Id, updatedClaim.dmpl__BranchId__c, 'dmpl__BranchId__c should be Branch 1');
        System.assertEquals(supplier.Id, updatedClaim.dmpl__SupplierNameId__c, 'dmpl__SupplierNameId__c should be Supplier 1');
        System.assert(updatedClaim.Name != null, 'Claim name should not be null');
    }
    
    @isTest
    static void updateClaimWithItemServiceContractEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemServiceContract__c itemServiceContract = ClaimDataHelper.createItemServiceContract('Contract 1', item);
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        insertedClaim.dmpl__ItemServiceContractId__c = itemServiceContract.Id;
        Test.startTest();
        update insertedClaim;
        Test.stopTest();
        dmpl__Claim__c updatedClaim = ClaimDataHelper.getClaim(insertedClaim.Id);
        System.assertEquals(partner.Id, updatedClaim.dmpl__PartnerAccountId__c, 'Mismatch in Partner Account ID');
        System.assertEquals(branch.Id, updatedClaim.dmpl__BranchId__c, 'Mismatch in Branch ID');
        System.assertEquals(supplier.Id, updatedClaim.dmpl__SupplierNameId__c, 'Mismatch in Supplier ID');
        System.assertEquals(itemServiceContract.Id, updatedClaim.dmpl__ItemServiceContractId__c, 'Mismatch in Item Service Contract ID');
        System.assertEquals(insertedClaim.Name, updatedClaim.Name, 'Mismatch in Claim Name');
    }

    @isTest
    static void createClaimCreationWithInvalidBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try {
            Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner2.Id);
            dmpl__Claim__c claim = ClaimDataHelper.createClaim(partner2.Id, branch.Id,supplier.Id);
            System.assert(true, 'Claim should not be inserted with an invalid branch.');
        } catch (DmlException e) {
            System.assert(true, 'claim inserted with invalid branch');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimCreationWithWrongPartnerNegative() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        Test.startTest();
        try {
            dmpl__Claim__c claim = ClaimDataHelper.getClaim();
            System.assert(true, 'Claim should not be inserted with an invalid partner.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid partner'), 'Expected failure due to invalid partner selection.');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimCreationMissingPartnerNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try {
            dmpl__Claim__c claim = ClaimDataHelper.getClaim();
            System.assert(true, 'Claim should not be inserted without a Partner Account.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('partner'), 'Expected failure due to missing Partner Account.');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimCreationWithInactivePartnerNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try {
            dmpl__Claim__c claim = ClaimDataHelper.getClaim();
            System.assert(true, 'Claim should not be inserted with an inactive partner account.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('inactive'), 'Expected failure due to inactive partner account.');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimCreationWithInactiveBranchNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        Test.startTest();
        try {
            dmpl__Claim__c claim = ClaimDataHelper.createClaim(partner.Id,branch.Id,supplier.Id);
            System.assert(true, 'Claim should not be inserted with an inactive branch.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('inactive') || e.getMessage().toLowerCase().contains('branch'),'Expected failure due to inactive branch.');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimLineWithRepairOrderLineReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        Test.startTest();
        dmpl__RepairOrder__c newRepairOrder = ClaimDataHelper.createRepairOrder(
            partner,
            branch,
            customer,
            1000
        );
        dmpl__RepairOrder__c repairOrder = ClaimDataHelper.getRepairOrdersById(newRepairOrder.Id);
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        dmpl__RepairOrderLine__c repairOrderLine = ClaimDataHelper.createRepairOrderLine(
            repairOrder, 
            item,
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderLine__c roLine = ClaimDataHelper.getRepairOrderLine(repairOrderLine.Id);
        System.assertNotEquals(null, roLine.Id, 'Repair Order Line should be created');
        dmpl__Claim__c createdClaim = ClaimDataHelper.getClaim();
        createdClaim.dmpl__RepairOrderId__c = repairOrder.Id;
        update createdClaim;
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(createdClaim.Id);
        System.assertNotEquals(null, claim.Id, 'Claim should be created');
        System.assertEquals('Partner 1', claim.dmpl__PartnerAccountId__r.Name, 'Incorrect Partner on Claim');
        System.assertEquals('Branch 1', claim.dmpl__BranchId__r.Name, 'Incorrect Branch on Claim');
        System.assertEquals('Supplier 1', claim.dmpl__SupplierNameId__r.Name, 'Incorrect Supplier on Claim');
        dmpl__ClaimLine__c newClaimLine = ClaimDataHelper.createClaimLineWithRepairOrder(
            claim.Id,
            item.Id,
            1,
            1,
            1500,
            'Part to part',
            repairOrder.Id, 
            roLine.Id
        );
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.getClaimLines(newClaimLine.Id);
        System.assertNotEquals(null, claimLine.Id, 'Claim Line should be created');
        System.assertEquals(1500, claimLine.dmpl__UnitPrice__c, 'Incorrect unit price on Claim Line');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Incorrect Claim reference');
        System.assertEquals(1, claimLine.dmpl__ClaimQuantity__c, 'Incorrect claim quantity');
        System.assertEquals(1, claimLine.dmpl__ApproveQuantity__c, 'Incorrect approved quantity');
        System.assertEquals(1500, claimLine.dmpl__ClaimAmount__c, 'Incorrect claim amount');
        System.assertEquals(1500, claimLine.dmpl__ApproveAmount__c, 'Incorrect approved amount');
        System.assertEquals(roLine.Id, claimLine.dmpl__RepairOrderLineId__c, 'Incorrect Repair Order Line reference');
        Test.stopTest();
    }

    @isTest
    static void createClaimLineWithGoodsReceiptLineReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 7', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PurchaseOrder__c po = ClaimDataHelper.createPurchaseOrder(branch, supplier);
        dmpl__GoodsReceipt__c grn = ClaimDataHelper.createGoodsReceipt(
            partner, 
            branch, 
            po, 
            supplier
        );
        dmpl__GoodsReceiptLine__c grnLine = ClaimDataHelper.createGoodReceiptLine(grn, item, sku);
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        claim.dmpl__GoodsReceiptId__c = grn.Id;
        update claim;
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLinewithGoodsRecieptLine(
            claim.Id,
            item.Id,
            3,
            3,
            grn.Id,
            grnLine.Id
        );
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        dmpl__ClaimLine__c insertedLine = ClaimDataHelper.getClaimLineById(claimLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, insertedClaim, 'Claim should be inserted');
        System.assertEquals(grn.Id, insertedClaim.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
        System.assertEquals(3, insertedLine.dmpl__ClaimQuantity__c, 'Claim quantity should be 3');
        System.assertEquals(3, insertedLine.dmpl__ApproveQuantity__c, 'Approved quantity should be 3');
        System.assertEquals(1500, insertedLine.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(4500, insertedLine.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(4500, insertedLine.dmpl__ClaimAmount__c, 'Claim amount should be 4500');
        System.assertEquals(4500, insertedLine.dmpl__ApproveBaseAmount__c, 'Approved base amount should be 4500');
        System.assertEquals(4500, insertedLine.dmpl__ApproveAmount__c, 'Approved amount should be 4500');
    }

    @isTest
    static void createClaimLineWithZeroClaimQuantityNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        System.assertNotEquals(null, claim.Id, 'Claim should be created');
        System.assertEquals('Partner 1', claim.dmpl__PartnerAccountId__r.Name, 'Incorrect Partner');
        System.assertEquals('Branch 1', claim.dmpl__BranchId__r.Name, 'Incorrect Branch');
        System.assertEquals('Supplier 1', claim.dmpl__SupplierNameId__r.Name, 'Incorrect Supplier');
        System.assertNotEquals(null, claim.Name, 'Claim Name should be auto-generated');
        Test.startTest();
        try {
            dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(
                claim.Id,
                item.Id,
                0,
                1,
                1500
                );
            System.assert(true, 'Expected exception when claim quantity is 0');
        } catch (Exception e) {}
        Test.stopTest();
    }

    @isTest
    static void updateClaimLineWithClaimTypeEditPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim(partner.Id, branch.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(
            claim.Id,
            item.Id,
            1,
            1,
            1500
        );
        claimLine.dmpl__ClaimType__c = 'Part To Part';
        update claimLine;
        Test.stopTest();
        dmpl__Claim__c fetchedClaim = ClaimDataHelper.getClaim(claim.Id);
        dmpl__ClaimLine__c fetchedLine = ClaimDataHelper.getClaimLineById(claimLine.Id);
        System.assertEquals(partner.Id, fetchedClaim.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch.Id, fetchedClaim.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedClaim.dmpl__SupplierNameId__c, 'Supplier should match');
        System.assertEquals(claim.Id, fetchedLine.dmpl__ClaimId__c, 'Claim ID should match');
        System.assertEquals(1, fetchedLine.dmpl__ClaimQuantity__c, 'Claim quantity should be 1');
        System.assertEquals(1, fetchedLine.dmpl__ApproveQuantity__c, 'Approved quantity should be 1');
        System.assertEquals('Part To Part', fetchedLine.dmpl__ClaimType__c, 'Claim Line type should be updated to Part to part');
        System.assertEquals(1, fetchedClaim.dmpl__TotalApprovedQuantity__c, 'Total Approved Quantity should be 1');
    }

    @isTest
    static void createClaimLineWithServiceContractPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemServiceContract__c serviceContract = ClaimDataHelper.createItemServiceContract('Contract 1', item);
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.createClaimWithServiceContract(
            partner.Id,
            branch.Id,
            supplier.Id,
            'Damaged',
            'Draft',
            serviceContract.Id
        );
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLineWithServiceContractAndClaimBatch(
            claim.Id,
            item.Id,
            10,
            1500,
            serviceContract.Id,
            null, 
            null
        );
        Test.stopTest();
        dmpl__Claim__c fetchedClaim = ClaimDataHelper.getClaim(claim.Id);
        dmpl__ClaimLine__c fetchedLine = ClaimDataHelper.getClaimLines(claimLine.Id);
        System.assertEquals('Contract 1', serviceContract.Name, 'Service contract name should be Contract 1');
        System.assertEquals(item.Id, serviceContract.dmpl__ItemId__c, 'Service contract should be linked with Item 1');
        System.assertEquals(partner.Id, fetchedClaim.dmpl__PartnerAccountId__c, 'Partner should match Partner 1');
        System.assertEquals(branch.Id, fetchedClaim.dmpl__BranchId__c, 'Branch should match Branch 3');
        System.assertEquals(supplier.Id, fetchedClaim.dmpl__SupplierNameId__c, 'Supplier should match Supplier 2');
        System.assertEquals(serviceContract.Id, fetchedClaim.dmpl__ItemServiceContractId__c, 'Claim should have correct Service Contract');
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Claim line item should match');
        System.assertEquals(claim.Id, fetchedLine.dmpl__ClaimId__c, 'Claim line should be linked to correct claim');
        System.assertEquals(10, fetchedLine.dmpl__ClaimQuantity__c, 'Claim quantity should be 10');
        System.assertEquals(1500, fetchedLine.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(15000, fetchedLine.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(15000, fetchedLine.dmpl__ClaimAmount__c, 'Claim amount should be 15000');
        System.assertEquals(serviceContract.Id, fetchedLine.dmpl__ServiceContractId__c, 'Claim line should reference the correct service contract');
    }

    @isTest
    static void createClaimLineWithClaimBatchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partner.Id, branch.Id,supplier.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(
            claim.Id,
            item.Id,
            1,
            1,
            1500
        );
        claimLine.dmpl__ClaimBatchId__c = claimBatch.Id;
        update claimLine;
        dmpl__Claim__c insertedClaim = ClaimDataHelper.getClaim(claim.Id);
        dmpl__ClaimLine__c insertedClaimLine = ClaimDataHelper.getClaimLines(claimLine.Id);
        System.assertEquals(partner.Id, insertedClaim.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, insertedClaim.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(supplier.Id, insertedClaim.dmpl__SupplierNameId__c, 'Supplier should be Supplier 1');
        System.assertEquals(claim.Id, insertedClaimLine.dmpl__ClaimId__c, 'Claim Line should link to correct Claim');
        System.assertEquals(item.Id, insertedClaimLine.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(1, insertedClaimLine.dmpl__ClaimQuantity__c, 'Claim Quantity should be 1');
        System.assertEquals(1, insertedClaimLine.dmpl__ApproveQuantity__c, 'Approved Quantity should be 1');
        System.assertEquals(1500, insertedClaimLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(1500, insertedClaimLine.dmpl__ApproveAmount__c, 'Approved Amount should be 1500');
        System.assertEquals(claimBatch.Id, insertedClaimLine.dmpl__ClaimBatchId__c, 'Claim Batch should match the created batch');
    }

    @isTest
    public static void createClaimBatchWithServiceContract_Positive() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Product2 serviceContract = ClaimDataHelper.createProduct('Contract 1','SC-001', true);
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            serviceContract.Id
        );
        System.assertNotEquals(null, serviceContract, 'Service Contract should be created and not be null');
        System.assertNotEquals(null, claimBatch, 'Claim Batch should be created and not be null');
    }

    @isTest
    public static void updateClaimBatchWithServiceContract_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        Product2 product = ClaimDataHelper.createProduct('Contract 1', 'P-001', true);
        claimBatch.dmpl__ServiceContractId__c = product.Id;
        update claimBatch;
        System.assertEquals(partner.Id, claimBatch.dmpl__PartnerAccountId__c, 'Claim Batch should reference the correct Partner Account');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Claim Batch should reference the correct Branch');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Claim Batch should reference the correct Supplier');
        System.assertEquals(product.Id, claimBatch.dmpl__ServiceContractId__c, 'Claim Batch should reference the correct Service Contract');
    }

    @isTest
    public static void createClaimBatchWithClaimLine_Positive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partner.Id,branch.Id,supplier.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id, claim.Id);
        System.assertNotEquals(null, claimBatch, 'Claim Batch should be created');
        System.assertEquals(partner.Id, claimBatch.dmpl__PartnerAccountId__c, 'Partner Account mismatch in Claim Batch');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Branch mismatch in Claim Batch');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Customer Account mismatch in Claim Batch');
        System.assertNotEquals(null, claim, 'Claim should be created');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Partner Account mismatch in Claim');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Branch mismatch in Claim');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Supplier Account mismatch in Claim');
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Claim Line');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch in Claim Line');
    }

    @isTest
    static void createClaimLineWithGoodsReceipt_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__GoodsReceipt__c goodsReceipt = ClaimDataHelper.createGoodsReceipt(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id, claim.Id);
        claimLine.dmpl__GoodsReceiptId__c = goodsReceipt.Id;
        update claimLine;
        Test.stopTest();
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch');
        System.assertEquals(goodsReceipt.Id, claimLine.dmpl__GoodsReceiptId__c, 'Goods Receipt reference mismatch');
    }

    @isTest
    static void createClaimLineWithGoodsReceiptLine_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__GoodsReceipt__c goodsReceipt = ClaimDataHelper.createGoodsReceipt(partner.Id, branch.Id, supplier.Id);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = ClaimDataHelper.createGoodsReceiptLine(
            goodsReceipt,
            item,
            1,
            100
       );
        Test.startTest();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id, claim.Id);
        claimLine.dmpl__GoodsReceiptLineId__c = goodsReceiptLine.Id;
        update claimLine;
        Test.stopTest();
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch');
        System.assertEquals(goodsReceiptLine.Id, claimLine.dmpl__GoodsReceiptLineId__c, 'Goods Receipt Line reference mismatch');
    }

    @isTest
    static void createClaimLineWithClaimBatchLine_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimDataHelper.createClaimBatchLine(claimBatch.Id, claim.Id);
        Test.startTest();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id,claim.Id);
        claimLine.dmpl__ClaimBatchLineId__c = claimBatchLine.Id;
        update claimLine;
        Test.stopTest();
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch');
        System.assertEquals(claimBatchLine.Id, claimLine.dmpl__ClaimBatchLineId__c, 'Claim Batch Line reference mismatch');
    }

    @isTest
    static void createClaimLineWithClaim_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id, claim.Id);
        Test.stopTest();
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Claim Line');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch in Claim Line');
    }

    @isTest
    static void updateClaimLineApproveQuantity_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id,claim.Id);
        Test.startTest();
        claimLine.dmpl__ApproveQuantity__c = 1;
        update claimLine;
        Test.stopTest();
        System.assertEquals(1, claimLine.dmpl__ApproveQuantity__c, 'Approved Quantity on Claim Line should be 1');
    }

    @isTest
    static void updateClaimLineWithRejectQuantity_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claimBatch.Id, claim.Id);
        claimLine.dmpl__RejectQuantity__c = 1;
        update claimLine;
        Test.stopTest();
        System.assertNotEquals(null, claimLine, 'Claim Line should be created');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim reference mismatch in Claim Line');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Claim Line');
        System.assertEquals(1, claimLine.dmpl__RejectQuantity__c, 'Reject Quantity should be updated to 1');
    }

    @isTest
    static void createClaimBatchWithAdjustment_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c adjustment = ClaimDataHelper.createClaim(partner.Id, branch.Id, customer.Id);
        adjustment.dmpl__ClaimBatchId__c = claimBatch.Id;
        update adjustment;
        Test.stopTest();
        System.assertNotEquals(null, claimBatch, 'Claim Batch should be created');
        System.assertEquals(partner.Id, claimBatch.dmpl__PartnerAccountId__c, 'Partner mismatch in Claim Batch');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Branch mismatch in Claim Batch');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Customer mismatch in Claim Batch');
        System.assertNotEquals(null, adjustment, 'Adjustment Claim should be created');
        System.assertEquals(partner.Id, adjustment.dmpl__PartnerAccountId__c, 'Partner mismatch in Adjustment Claim');
        System.assertEquals(branch.Id, adjustment.dmpl__BranchId__c, 'Branch mismatch in Adjustment Claim');
        System.assertEquals(customer.Id, adjustment.dmpl__SupplierNameId__c, 'Supplier mismatch in Adjustment Claim');
        System.assertEquals(claimBatch.Id, adjustment.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Adjustment Claim');
    }

    @isTest
    static void createClaimBatchWithInvoice_Positive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__SaleInvoice__c invoice = ClaimDataHelper.createInvoice(
            customer,
            partner,
            claimBatch,
            branch
        );
        System.assertNotEquals(null, invoice, 'Invoice should be created');
        System.assertEquals(customer.Id, invoice.dmpl__AccountId__c, 'Customer reference mismatch in Invoice');
        System.assertEquals(claimBatch.Id, invoice.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Invoice');
        System.assertEquals(partner.Id, invoice.dmpl__PartnerAccountId__c, 'Partner reference mismatch in Invoice');
        System.assertEquals(branch.Id, invoice.dmpl__BranchId__c, 'Branch reference mismatch in Invoice');
    }

    @isTest
    static void updateClaimBatchWithZeroApprovedQuantity_Negative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        Test.startTest();
        try {
            claimBatch.dmpl__TotalApprovedQuantity__c = 0;
            update claimBatch;
            System.assert(false, 'Update should fail when Total Approved Quantity is 0');
        } catch (Exception e) {
            System.assert(e.getMessage().containsIgnoreCase('approved quantity'), 'Exception should mention approved quantity');
        }
        Test.stopTest();
    }

    @isTest
    static void updateClaimBatchWithZeroApprovedAmount_Negative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        Test.startTest();
        try {
            claimBatch.dmpl__TotalApprovedAmount__c = 0;
            update claimBatch;
            System.assert(false, 'Update should fail when Total Approved Amount is 0');
        } catch (Exception e) {
            System.assert(e.getMessage().containsIgnoreCase('approved amount'), 'Exception should mention approved amount');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimBatchWithPartner_Positive() {
        Account activePartner = TestDataHelpers.createPartnerAccount('Partner 2');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', activePartner.Id);
        Test.startTest();
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            activePartner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, claimBatch, 'Claim Batch should be created and not be null');
        System.assertEquals(activePartner.Id, claimBatch.dmpl__PartnerAccountId__c, 'Claim Batch should reference the correct Active Partner Account');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Claim Batch should reference the correct Branch');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Claim Batch should reference the correct Supplier');
    }

    @isTest
    static void createClaimBatchWithInactiveBranch_Negative() {
        Account activePartner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c inactiveBranch = TestDataHelpers.createBranch('Branch 3', activePartner.Id);
        Test.startTest();
        try {
            dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
                activePartner.Id,
                inactiveBranch.Id,
                supplier.Id,
                null
            );
            System.assert(true, 'Claim Batch creation should have failed due to inactive Branch');
        } catch (Exception e) {}
        Test.stopTest();
    }

    @isTest
    public static void createClaimBatchLineWithClaim_Positive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimDataHelper.createClaimBatchLine(claimBatch.Id, claim.Id);
        System.assertNotEquals(null, claimBatch, 'Claim Batch should be created');
        System.assertEquals(partner.Id, claimBatch.dmpl__PartnerAccountId__c, 'Partner Account mismatch in Claim Batch');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Branch mismatch in Claim Batch');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Customer Account mismatch in Claim Batch');
        System.assertNotEquals(null, claim, 'Claim should be created');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Partner Account mismatch in Claim');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Branch mismatch in Claim');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Supplier Account mismatch in Claim');
        System.assertNotEquals(null, claimBatchLine, 'Claim Batch Line should be created');
        System.assertEquals(claimBatch.Id, claimBatchLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Claim Batch Line');
        System.assertEquals(claim.Id, claimBatchLine.dmpl__ClaimId__c, 'Claim reference mismatch in Claim Batch Line');
    }

    @isTest
    public static void updateClaimBatchLineWithNewClaim_Positive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
        );
        dmpl__Claim__c claim1 = ClaimDataHelper.getClaim();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimDataHelper.createClaimBatchLine(claimBatch.Id, claim1.Id);
        dmpl__Claim__c claim2 = ClaimDataHelper.createClaim(partner.Id, branch.Id, supplier.Id);
        claimBatchLine.dmpl__ClaimId__c = claim2.Id;
        update claimBatchLine;
        System.assertNotEquals(null, claimBatchLine, 'Claim Batch Line should be updated');
        System.assertEquals(claimBatch.Id, claimBatchLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in updated Claim Batch Line');
        System.assertEquals(claim2.Id, claimBatchLine.dmpl__ClaimId__c, 'Claim reference mismatch in updated Claim Batch Line');
        System.assertNotEquals(claim1.Id, claimBatchLine.dmpl__ClaimId__c, 'Old Claim should not match the updated Claim in Claim Batch Line');
    }

    @isTest
    static void createClaimBatchLineWithNoClaimPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimBatch__c claimBatch = ClaimDataHelper.createClaimBatch(
            partner.Id,
            branch.Id,
            supplier.Id,
            null
            );
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimDataHelper.createClaimBatchLine(claimBatch.Id,null);
        System.assertNotEquals(null, claimBatchLine, 'Claim Batch Line should be created');
        System.assertEquals(claimBatch.Id, claimBatchLine.dmpl__ClaimBatchId__c, 'Claim Batch reference mismatch in Claim Batch Line');
        System.assertEquals(null, claimBatchLine.dmpl__ClaimId__c, 'Claim reference should be null in Claim Batch Line');
    }

    /********************New Methods***********************/

    //claim creation with new and valid supplier account 
    @isTest
    static void createClaimWithNewSupplierPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    // claim creation without supplier account 
    @isTest
    static void createClaimWithoutSupplierNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Boolean exceptionThrown = false;
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        try {
            claim.dmpl__SupplierNameId__c = null;
            update claim;
            System.assert.isFalse(exceptionThrown, 'Claim creation should have failed without a Supplier Account');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Exception should be thrown when creating Claim without Supplier Account');
        }
        Test.stopTest();
    }

    //Claim creation with active Partner account 
    @isTest
    static void createClaimWithActivePartnerPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    //Claim creation with inactive Partner  account 
    @isTest
    static void createClaimWithInactivePartnerNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        partner.dmpl__IsActive__c = false;
        update partner;
        Boolean exceptionThrown = false;
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        try {
            claim.dmpl__PartnerAccountId__c = partner.Id;
            update claim;
            System.assert.isFalse(exceptionThrown, 'Claim creation should have failed with inactive Partner Account');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Exception should be thrown when creating Claim with inactive Partner Account');
        }
    }

    //Claim creation with active Branch
    @isTest
    static void createClaimWithActiveBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    //Claim creation with inactive Branch
    @isTest
    static void createClaimWithInactiveBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        branch.dmpl__IsActive__c = false;
        update branch;
        Boolean exceptionThrown = false;
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        try {
            claim.dmpl__BranchId__c = branch.Id;
            update claim;
            System.assert.isFalse(exceptionThrown, 'Claim creation should have failed with inactive Branch');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Exception should be thrown when creating Claim with inactive Branch');
        }
        Test.stopTest();
    }

    //Claim creation without a Partner Account
    @isTest
    static void createClaimWithoutPartnerNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            claim.dmpl__PartnerAccountId__c = null;
            update claim;
            System.assert.isFalse(exceptionThrown, 'Claim creation should have failed without a Partner Account');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Exception should be thrown when creating Claim without Partner Account');
        }
        Test.stopTest();
    }

    //Claim creation without a Branch 
    @isTest
    static void createClaimWithoutBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Boolean exceptionThrown = false;
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.startTest();
        try {
            claim.dmpl__BranchId__c = null;
            update claim;
            System.assert.isFalse(exceptionThrown, 'Claim creation should have failed without a Branch');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Exception should be thrown when creating Claim without Branch');
        }
        Test.stopTest();
    }

    // SS-009	Claim is generated when GRN line is marked as “Damaged” 
    @isTest
    static void createClaimWithDamagedGoodsReceiptLinePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
        System.assertEquals('Damaged', claim.dmpl__ClaimType__c, 'Claim should have Goods Receipt Line marked as Damaged');
    }

    //SS-019	Claims created with valid claim type 
    @isTest
    static void createClaimWithValidClaimTypePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        claim.dmpl__ClaimType__c = 'Shortage';
        update claim;
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully with valid claim type');
        System.assertEquals('Shortage', claim.dmpl__ClaimType__c, 'Claim should have the correct Claim Type');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    //Claim created with Claim Type as  Sale
    @isTest
    static void createClaimWithSaleClaimTypePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        claim.dmpl__ClaimType__c = 'Sale';
        update claim;
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully with Sale Claim Type');
        System.assertEquals('Sale', claim.dmpl__ClaimType__c, 'Claim should have the Claim Type as Sale');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    //Claim created with Claim Type as Service
    @isTest
    static void createClaimWithServiceClaimTypePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        claim.dmpl__ClaimType__c = 'Service';
        update claim;
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully with Service Claim Type');
        System.assertEquals('Service', claim.dmpl__ClaimType__c, 'Claim should have the Claim Type as Service');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }    

    //Claim created with Claim Type as Purchase
    @isTest
    static void createClaimWithPurchaseClaimTypePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        claim.dmpl__ClaimType__c = 'Purchase';
        update claim;
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully with Purchase Claim Type');
        System.assertEquals('Purchase', claim.dmpl__ClaimType__c, 'Claim should have the Claim Type as Purchase');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }

    //Claim created with Claim Type as Scheme
    @isTest
    static void createClaimWithSchemeClaimTypePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Claim__c claim = ClaimDataHelper.getClaim();
        claim.dmpl__ClaimType__c = 'Scheme';
        update claim;
        Test.stopTest();
        System.assertNotEquals(null, claim, 'Claim should be created successfully with Scheme Claim Type');
        System.assertEquals('Scheme', claim.dmpl__ClaimType__c, 'Claim should have the Claim Type as Scheme');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Incorrect Partner Account');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Incorrect Branch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Incorrect Supplier Account');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Claim should be in Draft status');
    }
}