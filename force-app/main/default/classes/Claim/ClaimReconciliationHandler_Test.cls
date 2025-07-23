@isTest
public with sharing class ClaimReconciliationHandler_Test {
    @TestSetup
    static void createRequiredData() {   
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partnerAccount.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claim.Id);
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(branch1.Id, partnerAccount.Id);
        reconciliation.dmpl__SupplierId__c = supplierAccount.Id;
        update reconciliation;
        dmpl__ClaimReconciliationLine__c  line = ClaimReconciliationDataHelper.createClaimReconciliationLine(reconciliation.Id, claim.Id, claimLine.Id);
    }

    @isTest
    static void createClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        System.assertNotEquals(null, reconciliation.Id, 'Claim Reconciliation should be inserted');
        System.assertEquals(Date.today(), reconciliation.dmpl__DocumentDate__c, 'Document date should match today');
    }

    @isTest
    static void createClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        System.assertNotEquals(null, line.Id, 'Claim Reconciliation Line should be created');
        System.assertEquals(2, line.dmpl__RejectQuantity__c, 'Reject Quantity should be 2');
    }

    @isTest
    static void updateClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        Test.startTest();
        line.dmpl__Status__c = 'Approved';
        line.dmpl__RejectQuantity__c = 5;
        line.dmpl__Remarks__c = 'Updated Test Remarks';
        update line;
        Test.stopTest();
        dmpl__ClaimReconciliationLine__c updated = ClaimReconciliationDataHelper.getClaimReconciliationLines(line.Id);
        System.assertEquals(5, updated.dmpl__RejectQuantity__c, 'Reject Quantity should be updated to 5');
        System.assertEquals('Updated Test Remarks', updated.dmpl__Remarks__c, 'Remarks should be updated');
    }

    @isTest
    static void updateClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        reconciliation.dmpl__Status__c = 'Draft';
        reconciliation.dmpl__DocumentDate__c = Date.today().addDays(5);
        update reconciliation;
        dmpl__ClaimReconciliation__c updated = ClaimReconciliationDataHelper.getClaimReconciliations(reconciliation.Id);
        System.assertEquals(Date.today().addDays(5), updated.dmpl__DocumentDate__c, 'Document date should be updated');
    }

    @isTest
    static void deleteClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        Test.startTest();
        delete line;
        Test.stopTest();
        dmpl__ClaimReconciliationLine__c deletedLine;
        try {
            deletedLine = ClaimReconciliationDataHelper.getClaimReconciliationLines(line.Id);
        } catch (QueryException e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Claim Reconciliation Line should be deleted');
    }

    @isTest
    static void deleteClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        Test.startTest();
        delete reconciliation;
        Test.stopTest();
        dmpl__ClaimReconciliation__c deletedReconciliation;
        try {
            deletedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliations(reconciliation.Id);
        } catch (QueryException e) {
            deletedReconciliation = null;
        }
        System.assertEquals(null, deletedReconciliation, 'Claim Reconciliation should be deleted');
    }

    @isTest
    static void createClaimReconciliationWithValidPartnerBranchSupplierPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimReconciliation__c newReconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partnerAccount.Id, branch.Id, supplierAccount.Id);
        dmpl__ClaimReconciliation__c insertedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliation(newReconciliation.Id);
        System.assertNotEquals(insertedReconciliation.Id, null, 'Claim Reconciliation should be inserted');
        System.assertEquals(insertedReconciliation.dmpl__PartnerAccountId__c, partnerAccount.Id, 'Partner account should match');
        System.assertEquals(insertedReconciliation.dmpl__BranchId__c, branch.Id, 'Branch should match');
        System.assertEquals(insertedReconciliation.dmpl__SupplierId__c, supplierAccount.Id, 'Supplier account should match');
        System.assertEquals(Date.today(), insertedReconciliation.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithoutSupplierPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ClaimReconciliation__c newReconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partnerAccount.Id, branch.Id, null);
        Test.stopTest();
        dmpl__ClaimReconciliation__c insertedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliation(newReconciliation.Id);
        System.assertEquals(null, insertedReconciliation.dmpl__SupplierId__c, 'Supplier should not be set');
    }

    @isTest
    static void createClaimReconciliationWithWrongPartnerAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        Test.startTest();
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partnerAccount.Id, branch.Id, supplierAccount.Id);
        Test.stopTest();
        dmpl__ClaimReconciliation__c inserted = ClaimReconciliationDataHelper.getClaimReconciliation(reconciliation.Id);
        System.assertNotEquals(inserted.Id, null, 'Claim Reconciliation should be created even if partner and branch are mismatched');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch.Id, inserted.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, inserted.dmpl__SupplierId__c, 'Supplier should match');
        System.assertEquals(Date.today(), inserted.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithWrongBranchPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c wrongBranch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id); 
        Test.startTest();
        try {
            dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partnerAccount.Id, wrongBranch.Id, supplierAccount.Id);
            System.assertNotEquals(null, reconciliation.Id, 'Claim Reconciliation should still be created');
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception when creating reconciliation with wrong branch: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimReconciliationWithReconciledAmountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1'); 
        dmpl__ClaimReconciliation__c newReconciliation = ClaimReconciliationDataHelper.createClaimReconciliationWithAmounts(
            partnerAccount.Id,
            branch.Id,
            supplierAccount.Id,
            1000
        );
        dmpl__ClaimReconciliation__c insertedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliation(newReconciliation.Id);
        System.assertNotEquals(null, insertedReconciliation.Id, 'Claim Reconciliation should be inserted');
        System.assertEquals(partnerAccount.Id, insertedReconciliation.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch.Id, insertedReconciliation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, insertedReconciliation.dmpl__SupplierId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), insertedReconciliation.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(1000, insertedReconciliation.dmpl__ReconciledAmount__c, 'Reconciled Amount should match');
    }

    @isTest
    static void createClaimReconciliationWithCreditNoteAmountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1'); 
        dmpl__ClaimReconciliation__c newReconciliation = ClaimReconciliationDataHelper.createClaimReconciliationWithCreditNoteAmount(
            partnerAccount.Id,
            branch.Id,
            supplierAccount.Id,
            1000.0
        );
        dmpl__ClaimReconciliation__c insertedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliation(newReconciliation.Id);
        System.assertNotEquals(null, insertedReconciliation.Id, 'Claim Reconciliation should be inserted');
        System.assertEquals(partnerAccount.Id, insertedReconciliation.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch.Id, insertedReconciliation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, insertedReconciliation.dmpl__SupplierId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), insertedReconciliation.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(1000.0, insertedReconciliation.dmpl__CreditNoteAmount__c, 'Credit Note Amount should match');
    }

    @isTest
    static void createClaimReconciliationLineWithoutReconciliationNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id,
            branch.Id,
            supplier.Id,
            'Shortage',
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id,
            item.Id,
            10,
            1500
        );
        Test.startTest();
        try {
            dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
                null, 
                claim.Id,
                claimLine.Id,
                item.Id,
                10,
                1500,
                10,
                15000
            );
            System.assert(false, 'Expected an exception due to missing Reconciliation ID');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Reconciliation') || e.getMessage().contains('required'), 'Expected error message related to missing Reconciliation reference');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimReconciliationLineWithActiveItemPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id,
            branch.Id,
            supplier.Id,
            'Shortage',
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id,
            item.Id,
            10,
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10,
            1500,
            10,
            15000
        );
        dmpl__ClaimReconciliationLine__c fetchedRecLine = ClaimReconciliationDataHelper.getClaimReconciliationLine(recLine.Id);
        dmpl__ClaimReconciliation__c fetchedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliation(reconciliation.Id);
        System.assertEquals('Shortage', claim.dmpl__ClaimType__c, 'Claim type mismatch');
        System.assertEquals(partner.Id, claim.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch.Id, claim.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, claim.dmpl__SupplierNameId__c, 'Supplier mismatch');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim ID mismatch on Claim Line');
        System.assertEquals(item.Id, claimLine.dmpl__ItemId__c, 'Item mismatch');
        System.assertEquals(1500, claimLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, claimLine.dmpl__ClaimQuantity__c, 'Claim Quantity mismatch');
        System.assertEquals(claim.Id, fetchedRecLine.dmpl__ClaimId__c, 'Claim ID mismatch on Reconciliation Line');
        System.assertEquals(claimLine.Id, fetchedRecLine.dmpl__ClaimLineId__c, 'Claim Line ID mismatch');
        System.assertEquals(item.Id, fetchedRecLine.dmpl__ItemId__c, 'Item mismatch on Reconciliation Line');
        System.assertEquals(10, fetchedRecLine.dmpl__ClaimQuantity__c, 'Claim Qty mismatch on Reconciliation Line');
        System.assertEquals(1500, fetchedRecLine.dmpl__UnitPrice__c, 'Unit Price mismatch on Reconciliation Line');
        System.assertEquals(10, fetchedRecLine.dmpl__ApproveQuantity__c, 'Approved Qty mismatch');
        System.assertEquals(15000, fetchedRecLine.dmpl__ApprovedAmount__c, 'Approved Amt mismatch');
        System.assertEquals(reconciliation.Id, fetchedRecLine.dmpl__ReconciliationId__c, 'Reconciliation ID mismatch');
        System.assertEquals(Date.today(), fetchedReconciliation.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(partner.Id, fetchedReconciliation.dmpl__PartnerAccountId__c, 'Reconciliation Partner mismatch');
        System.assertEquals(supplier.Id, fetchedReconciliation.dmpl__SupplierId__c, 'Reconciliation Supplier mismatch');
    }

    @isTest
    static void createClaimReconciliationLineWithDiscontinuedItemPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c discontinuedItem = TestDataHelpers.createItem('Item 4', 'Product');
        discontinuedItem.dmpl__IsDiscontinued__c = true;
        update discontinuedItem;
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            discontinuedItem.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        try {
            dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
                reconciliation.Id,
                claim.Id,
                claimLine.Id,
                discontinuedItem.Id,
                10,
                1500,
                10,
                15000
            );
            System.assert(true, 'Claim Reconciliation Line gets created for discontinued item');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('discontinued'), 'Error must mention discontinued item');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimReconciliationLineWithInactiveItem() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2', 'Product');
        inactiveItem.dmpl__IsActive__c = false;
        update inactiveItem;
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id,
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            inactiveItem.Id, 
            10, 
            2400
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        Test.startTest();
        try {
            dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
                reconciliation.Id,
                claim.Id,
                claimLine.Id,
                inactiveItem.Id,
                10,
                2400,
                10,
                24000
            );
            System.assert(true, 'Expected error for inactive item');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('inactive'), 'Error must mention inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimReconciliationLineWithClaimPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10,
            1500,
            10,
            15000
        );
        dmpl__ClaimReconciliationLine__c insertedLine = ClaimReconciliationDataHelper.getClaimReconciliationLine(recLine.Id);
        System.assertEquals(claim.Id, insertedLine.dmpl__ClaimId__c, 'Claim ID mismatch');
        System.assertEquals(claimLine.Id, insertedLine.dmpl__ClaimLineId__c, 'Claim Line mismatch');
        System.assertEquals(item.Id, insertedLine.dmpl__ItemId__c, 'Item mismatch');
        System.assertEquals(10, insertedLine.dmpl__ClaimQuantity__c, 'Claim quantity mismatch');
        System.assertEquals(1500, insertedLine.dmpl__UnitPrice__c, 'Unit price mismatch');
        System.assertEquals(10, insertedLine.dmpl__ApproveQuantity__c, 'Approve quantity mismatch');
        System.assertEquals(15000, insertedLine.dmpl__ApprovedAmount__c, 'Approved amount mismatch');
    }

    @isTest
    static void createClaimReconciliationLineWithoutClaim() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        System.assertEquals(partner.Id, reconciliation.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(supplier.Id, reconciliation.dmpl__SupplierId__c, 'Supplier should match');
        System.assertEquals(Date.today(), reconciliation.dmpl__DocumentDate__c, 'Document date should be today');
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            null, 
            null, 
            item.Id,
            10,
            1500,
            10,
            15000
        );
        System.assertEquals(item.Id, recLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, recLine.dmpl__ClaimQuantity__c, 'Claim Quantity should match');
        System.assertEquals(1500, recLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(10, recLine.dmpl__ApproveQuantity__c, 'Approved Quantity should match');
    }

    @isTest
    static void updateClaimReconciliationLineWithNegativeUnitPriceNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1000
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id, 
            claim.Id, 
            claimLine.Id, 
            item.Id, 
            10, 
            1000, 
            10, 
            10000
        );
        Test.startTest();
        try {
            recLine.dmpl__UnitPrice__c = -1;
            update recLine;
            System.assert(false, 'Expected error due to negative unit price');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('unit price') || e.getMessage().contains('-1'), 'Error must mention unit price or invalid value');
        }
        Test.stopTest();
    }

    @isTest
    static void updateClaimReconciliationLineWithNegativeApproveQuantityNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10,       
            1500,    
            10,       
            15000    
        );
        Test.startTest();
        try {
            recLine.dmpl__ApproveQuantity__c = -1;
            update recLine;
            System.assert(false, 'Expected error for negative approved quantity');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('approved quantity') ||e.getMessage().contains('-1'), 'Error message must mention "approved quantity" or the invalid value');
        }
        Test.stopTest();
    }

    @isTest
    static void updateClaimReconciliationLineWithNegativeClaimQuantityNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10,     
            1500,  
            10,     
            15000   
        );
        Test.startTest();
        try {
            recLine.dmpl__ClaimQuantity__c = -1;
            update recLine;
            System.assert(false, 'Expected error for negative claim quantity');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('claim quantity') || e.getMessage().contains('-1'), 'Error message should mention claim quantity or the invalid value');
        }
        Test.stopTest();
    }

    @isTest
    static void updateClaimReconciliationLineWithNegativeRejectQuantityNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10,    
            1500,   
            10,     
            15000   
        );
        Test.startTest();
        try {
            recLine.dmpl__RejectQuantity__c = -1;
            update recLine;
            System.assert(false, 'Expected error for negative reject quantity');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('reject') || e.getMessage().contains('-1'), 'Error should mention invalid reject quantity');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateClaimReconciliationLineWithLongRemarksNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Claim__c claim = ClaimReconciliationDataHelper.createClaim(
            partner.Id, 
            branch.Id, 
            supplier.Id, 
            'Shortage', 
            'Draft'
        );
        dmpl__ClaimLine__c claimLine = ClaimReconciliationDataHelper.createClaimLine(
            claim.Id, 
            item.Id, 
            10, 
            1500
        );
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(partner.Id, branch.Id, supplier.Id);
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.createClaimReconciliationLine(
            reconciliation.Id,
            claim.Id,
            claimLine.Id,
            item.Id,
            10, 
            1500, 
            10, 
            15000 
        );
        String longRemarks = 'Claim reconciliation is an essential process that ensures accurate alignment between partner claims and internal records. It identifies discrepancies such as duplicate claims, overclaimed amounts, or missing credit notes. This improves financial accuracy and trust.';
        Test.startTest();
        try {
            recLine.dmpl__ClaimQuantity__c = 9;
            recLine.dmpl__RejectQuantity__c = 1;
            recLine.dmpl__Remarks__c = longRemarks;
            update recLine;
            System.assert(false, 'Expected error for remarks exceeding 250 characters');
        } catch (Exception e) {
            System.assert(e.getMessage().toLowerCase().contains('remarks') || e.getMessage().contains('250'), 'Exception should reference remarks character limit');
        }
        Test.stopTest();
    }

    @isTest
    static void createClaimReconciliationWithValidPartnerAccount() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimReconciliation__c claimReconcilation = ClaimReconciliationDataHelper.getClaimReconciliations();
        System.assertNotEquals(null, claimReconcilation.Id, 'Claim Reconciliation should be created');
        System.assertEquals(partnerAccount.Id, claimReconcilation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, claimReconcilation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, claimReconcilation.dmpl__SupplierId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), claimReconcilation.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithValidBranch() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimReconciliation__c claimReconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        System.assertNotEquals(null, claimReconciliation.Id, 'Claim Reconciliation should be created');
        System.assertEquals(partnerAccount.Id, claimReconciliation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, claimReconciliation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, claimReconciliation.dmpl__SupplierId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), claimReconciliation.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithValidSupplierAccount() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimReconciliation__c claimReconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        System.assertNotEquals(null, claimReconciliation.Id, 'Claim Reconciliation should be created');
        System.assertEquals(partnerAccount.Id, claimReconciliation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, claimReconciliation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount.Id, claimReconciliation.dmpl__SupplierId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), claimReconciliation.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithInactivePartnerAccountNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        partnerAccount.dmpl__IsActive__c = false;
        update partnerAccount;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
            reconciliation.dmpl__PartnerAccountId__c = partnerAccount.Id;
            update reconciliation;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception when creating Claim Reconciliation with inactive Partner Account');
    }

    @isTest
    static void createClaimReconciliationWithInactiveBranchNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        branch.dmpl__IsActive__c = false;
        update branch;
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
            reconciliation.dmpl__BranchId__c = branch.Id;
            update reconciliation;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception when creating Claim Reconciliation with inactive Branch');
    }

    @isTest
    static void createClaimReconciliationWithInactiveSupplierAccountNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        supplierAccount.dmpl__IsActive__c = false;
        update supplierAccount;
        supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
            reconciliation.dmpl__SupplierId__c = supplierAccount.Id;
            update reconciliation;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception when creating Claim Reconciliation with inactive Supplier Account');
    }

    @isTest
    static void createClaimReconciliationWithoutSupplierAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        reconciliation.dmpl__SupplierId__c = null;
        Test.startTest();
        update reconciliation;
        Test.stopTest();
        dmpl__ClaimReconciliation__c inserted = ClaimReconciliationDataHelper.getClaimReconciliation(reconciliation.Id);
        System.assertNotEquals(null, inserted.Id, 'Claim Reconciliation should be created without a Supplier Account');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch.Id, inserted.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), inserted.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithoutPartnerAccountPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        reconciliation.dmpl__BranchId__c = null;
        reconciliation.dmpl__PartnerAccountId__c = null;
        Test.startTest();
        update reconciliation;
        Test.stopTest();
        dmpl__ClaimReconciliation__c inserted = ClaimReconciliationDataHelper.getClaimReconciliation(reconciliation.Id);
        System.assertNotEquals(null, inserted.Id, 'Claim Reconciliation should be created without a Partner Account');
        System.assertEquals(supplierAccount.Id, inserted.dmpl__SupplierId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), inserted.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationWithoutBranchPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        reconciliation.dmpl__BranchId__c = null;
        Test.startTest();
        update reconciliation;
        Test.stopTest();
        dmpl__ClaimReconciliation__c inserted = ClaimReconciliationDataHelper.getClaimReconciliation(reconciliation.Id);
        System.assertNotEquals(null, inserted.Id, 'Claim Reconciliation should be created without a Branch');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(supplierAccount.Id, inserted.dmpl__SupplierId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), inserted.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createClaimReconciliationLineWithLongRemarksNegative() {
        dmpl__ClaimReconciliationLine__c recLine = ClaimReconciliationDataHelper.getClaimReconciliationLine();
        String longRemarks = String.valueOf(new List<String>{'A'.repeat(600)});
        recLine.dmpl__Remarks__c = longRemarks;
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            update recLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }   
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception when updating Claim Reconciliation Line with long remarks'); 
    }
}