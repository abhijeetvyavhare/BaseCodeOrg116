@isTest
public with sharing class ClaimBatchHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        Product2 serviceContract = ClaimDataHelper.createProduct('Contract 1', 'SC-001', true);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1','Product');
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.createClaimBatch(partnerAccount, branch, supplierAccount);
        dmpl__Claim__c claim = ClaimBatchDataHelper.createClaim();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.createClaimBatchLine(claimBatch, claim.Id);
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.createClaimLine(claim, claimBatch, claimBatchLine);
    }

    @isTest
    static void createClaimBatchPositive() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created.');
        System.assertEquals('Draft', claimBatch.dmpl__Status__c, 'Status should be Draft');
        System.assertNotEquals(null, claimBatch.dmpl__PartnerAccountId__c, 'Partner Account ID should not be null');
        System.assertNotEquals(null, claimBatch.dmpl__BranchId__c, 'Branch ID should not be null');
    }

    @isTest
    static void createClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();        
        System.assertNotEquals(batchLine, null, 'Expected claim batch line to be created');
        System.assertNotEquals(null, batchLine.dmpl__ClaimBatchId__c, 'Claim Batch ID should not be null');
        System.assertNotEquals(null, batchLine.dmpl__ClaimId__c, 'Claim ID should not be null');
    }

    @isTest
    static void updateClaimBatchPositive() {
        dmpl__ClaimBatch__c batch = ClaimBatchDataHelper.getClaimBatch();
        Test.startTest();
        batch.dmpl__Status__c = 'Invoice';
        batch.dmpl__Remarks__c = 'Test Remarks';
        update batch;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedBatch = ClaimBatchDataHelper.getClaimBatch(batch.Id);
        System.assertEquals('Invoice', updatedBatch.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals('Test Remarks', updatedBatch.dmpl__Remarks__c, 'Remarks should be updated to Test Remarks');
    }

    @isTest
    static void updateClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Claim__c newClaim = ClaimBatchDataHelper.createClaim();
        Test.startTest();
        batchLine.dmpl__ClaimId__c = newClaim.Id;
        update batchLine;
        Test.stopTest();
        dmpl__ClaimBatchLine__c updatedBatchLine = ClaimBatchDataHelper.getClaimBatchLine(batchLine.Id);
        System.assertEquals(newClaim.Id, updatedBatchLine.dmpl__ClaimId__c, 'Claim ID should be updated');
    }

    @isTest
    static void deleteClaimBatchPositive() {
        dmpl__ClaimBatch__c batch = ClaimBatchDataHelper.getClaimBatch();
        Test.startTest();
        delete batch;
        Test.stopTest();
        dmpl__ClaimBatch__c deletedBatch;
        try {
            deletedBatch = ClaimBatchDataHelper.getClaimBatch(batch.Id);
        } catch (QueryException e) {
            deletedBatch = null; 
        }
        System.assertEquals(null, deletedBatch, 'Claim Batch should be deleted');
    }

    @isTest
    static void deleteClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();
        Test.startTest();
        delete batchLine;
        Test.stopTest();
        dmpl__ClaimBatchLine__c deletedBatchLine;
        try {
            deletedBatchLine = ClaimBatchDataHelper.getClaimBatchLine(batchLine.Id);
        } catch (QueryException e) {
            deletedBatchLine = null;
        }
        System.assertEquals(null, deletedBatchLine, 'Claim Batch Line should be deleted');
    }

    // Claim Batch created with valid partner account
    @isTest
    static void createClaimBatchWithValidPartnerAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created with valid partner account.');
        System.assertEquals(partnerAccount.Id, claimBatch.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch.Id, claimBatch.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(supplier.Id, claimBatch.dmpl__SupplierNameId__c, 'Supplier ID should match');
    }

    //Claim Batch Created  with new Claim lines 
    @isTest
    static void createClaimBatchWithNewClaimLinesPositive() {
        dmpl__Claim__c claim = ClaimBatchDataHelper.getClaim();
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.getClaimLine();
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created with new claim lines.');
        System.assertNotEquals(claimBatchLine, null, 'Expected claim batch line to be created with new claim lines.');
        System.assertNotEquals(claimLine, null, 'Expected claim line to be created with new claim lines.');
        System.assertEquals(claim.Id, claimLine.dmpl__ClaimId__c, 'Claim ID should match in claim line');
        System.assertEquals(claimBatch.Id, claimLine.dmpl__ClaimBatchId__c, 'Claim Batch ID should match in claim line');
        System.assertEquals(claimBatchLine.Id, claimLine.dmpl__ClaimBatchLineId__c, 'Claim Batch Line ID should match in claim line');
    }

    //Claim lines in one Claim Batch should have same Claim Type
    @isTest
    static void claimLinesInBatchShouldHaveSameClaimTypePositive() {
        dmpl__Claim__c claim = ClaimBatchDataHelper.getClaim();
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.getClaimLine();
        claimLine.dmpl__ClaimType__c = 'Reimbursment';
        Test.startTest();
        update claimLine;
        Test.stopTest();
        dmpl__ClaimLine__c updatedClaimLine = ClaimBatchDataHelper.getClaimLine(claimLine.Id);
        System.assertNotEquals(claim, null, 'Expected claim to be created.');
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created.');
        System.assertNotEquals(claimLine, null, 'Expected claim line to be created.');
        System.assertEquals('Reimbursment', claimLine.dmpl__ClaimType__c, 'Claim Type Should Match');
    }

    //Claim lines in one Claim Batch without the same Claim Type
    @isTest
    static void claimLinesInBatchWithoutSameClaimTypePositive() {
        dmpl__Claim__c claim = ClaimBatchDataHelper.getClaim();
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.getClaimLine();
        System.assertNotEquals(claim, null, 'Expected claim to be created.');
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created.');
        System.assertNotEquals(claimLine, null, 'Expected claim line to be created.');
        System.assertNotEquals(claim.dmpl__ClaimType__c, claimLine.dmpl__ClaimType__c, 'Claim Type should Not match in claim line');
    }

    //Claim Batch created with editing Claim Lines
    @isTest
    static void createClaimBatchWithEditingClaimLinesPositive() {
        dmpl__Claim__c claim = ClaimBatchDataHelper.getClaim();
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.getClaimLine();
        claimLine.dmpl__ClaimType__c = ' Part To Part';
        dmpl__ClaimLine__c updatedClaimLine = ClaimBatchDataHelper.getClaimLine(claimLine.Id);
        System.assertNotEquals(updatedClaimLine, null, 'Expected claim line to be updated with editing claim lines.');
        System.assertEquals('Part To Part', updatedClaimLine.dmpl__ClaimType__c, 'Claim Type should be updated to Reimbursement');
        System.assertEquals(claim.Id, updatedClaimLine.dmpl__ClaimId__c, 'Claim ID should match in updated claim line');
        System.assertEquals(claimBatch.Id, updatedClaimLine.dmpl__ClaimBatchId__c, 'Claim Batch ID should match in updated claim line');
        System.assertEquals(claimBatchLine.Id, updatedClaimLine.dmpl__ClaimBatchLineId__c, 'Claim Batch Line ID should match in updated claim line');
    }

    //Claim Batch Created with new Service Contract 
    @isTest
    static void createClaimBatchWithNewServiceContractPositive() {
        Product2 serviceContract = ClaimBatchDataHelper.createServiceContract('Service Contract 1');
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        claimBatch.dmpl__ServiceContractId__c = serviceContract.Id;
        Test.startTest();
        update claimBatch;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedClaimBatch = ClaimBatchDataHelper.getClaimBatch(claimBatch.Id);
        System.assertNotEquals(updatedClaimBatch, null, 'Expected claim batch to be created with new service contract.');
        System.assertEquals(serviceContract.Id, updatedClaimBatch.dmpl__ServiceContractId__c, 'Service Contract ID should match in updated claim batch');
    }

    //Claim Batch Creation with editing Service Contract
    @isTest
    static void updateClaimBatchWithServiceContractPositive() {
        Product2 serviceContract = ClaimBatchDataHelper.createServiceContract('Service Contract 1');
        Product2 serviceContract2 = ClaimBatchDataHelper.createServiceContract('Service Contract 2');
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        claimBatch.dmpl__ServiceContractId__c = serviceContract.Id;
        update claimBatch;
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created.');
        System.assertEquals(serviceContract.Id, claimBatch.dmpl__ServiceContractId__c, 'Service Contract ID should match in claim batch');
        claimBatch.dmpl__ServiceContractId__c = serviceContract2.Id;
        update claimBatch;
        System.assertEquals(serviceContract2.Id, claimBatch.dmpl__ServiceContractId__c, 'Service Contract ID should not match in claim batch before update');
    }

    //Claim Batch created with valid Item
    @isTest
    static void createClaimBatchWithValidItemPositive() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        dmpl__ClaimLine__c claimLine = ClaimBatchDataHelper.getClaimLine();
        claimLine.dmpl__ItemId__c = item.Id;
        Test.startTest();
        update claimLine;
        Test.stopTest();
        dmpl__ClaimLine__c updatedClaimLine = ClaimBatchDataHelper.getClaimLine(claimLine.Id);
        System.assertNotEquals(updatedClaimLine, null, 'Expected claim line to be created with valid item.');
        System.assertEquals(item.Id, updatedClaimLine.dmpl__ItemId__c, 'Item ID should match in updated claim line');
        System.assertEquals(claimBatch.Id, updatedClaimLine.dmpl__ClaimBatchId__c, 'Claim Batch ID should match in updated claim line');
        System.assertEquals(claimBatchLine.Id, updatedClaimLine.dmpl__ClaimBatchLineId__c, 'Claim Batch Line ID should match in updated claim line');  
    }

    //Claim Batch created with Valid Amount
    @isTest
    static void createClaimBatchWithValidAmount() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        claimBatch.dmpl__TotalApprovedAmount__c = 500.00;
        Test.startTest();
        update claimBatch;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedClaimBatch = ClaimBatchDataHelper.getClaimBatch(claimBatch.Id);
        System.assertNotEquals(updatedClaimBatch, null, 'Expected claim batch to be created with valid amount.');
        System.assertEquals(500.00, updatedClaimBatch.dmpl__TotalApprovedAmount__c, 'Total Approved Amount should match in updated claim batch');        
    }
    //Claim Batch Created with Total Approved Quantity 
    @isTest
    static void createClaimBatchWithTotalApprovedQuantityPositive() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        claimBatch.dmpl__TotalApprovedQuantity__c = 10;
        Test.startTest();
        update claimBatch;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedClaimBatch = ClaimBatchDataHelper.getClaimBatch(claimBatch.Id);
        System.assertNotEquals(updatedClaimBatch, null, 'Expected claim batch to be created with total approved quantity.');
        System.assertEquals(10, updatedClaimBatch.dmpl__TotalApprovedQuantity__c, 'Total Approved Quantity should match in updated claim batch');
    }
    //Claim Batch Created with Quantity mentioned in minus
    @isTest
    static void createClaimBatchWithQuantityInMinusNegative() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        claimBatch.dmpl__TotalApprovedQuantity__c = -10;
        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            update claimBatch;
            System.assert(false, 'Expected an exception due to Quantity being negative.');
        } catch (DmlException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        System.assert(isExceptionThrown, 'Expected an exception to be thrown due to Quantity being negative.');
    }

    //Claim Batch Created with new Invoice
    @isTest
    static void createClaimBatchWithNewInvoicePositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1'); 
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount.Id, partnerAccount.Id, branch.Id);
        Test.startTest();
        saleInvoice.dmpl__ClaimBatchId__c = claimBatch.Id;
        update saleInvoice;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedClaimBatch = ClaimBatchDataHelper.getClaimBatch(claimBatch.Id);
        System.assertNotEquals(updatedClaimBatch, null, 'Expected claim batch to be created with new invoice.');
    }

    //Claim Batch Created with Total Approved Amount
    @isTest
    static void createClaimBatchWithTotalApprovedAmountPositive() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        claimBatch.dmpl__TotalApprovedAmount__c = 1000.00;
        Test.startTest();
        update claimBatch;
        Test.stopTest();
        dmpl__ClaimBatch__c updatedClaimBatch = ClaimBatchDataHelper.getClaimBatch(claimBatch.Id);
        System.assertNotEquals(updatedClaimBatch, null, 'Expected claim batch to be created with total approved amount.');
        System.assertEquals(1000.00, updatedClaimBatch.dmpl__TotalApprovedAmount__c, 'Total Approved Amount should match in updated claim batch');
    }

    //Claim Batch Created with Total Approved Amount as 0
    @isTest
    static void createClaimBatchWithTotalApprovedAmountZeroNegative() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        claimBatch.dmpl__TotalApprovedAmount__c = 0;
        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            update claimBatch;
            System.assert(false, 'Expected an exception due to Total Approved Amount being zero.');
        } catch (DmlException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        System.assert(isExceptionThrown, 'Expected an exception to be thrown due to Total Approved Amount being zero.');
    }

    // Claim Batch Created with Total Approved Quantity as 0
    @isTest
    static void createClaimBatchWithTotalApprovedQuantityZeroNegative() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.getClaimBatchLine();
        claimBatch.dmpl__TotalApprovedQuantity__c = 0;
        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            update claimBatch;
            System.assert(false, 'Expected an exception due to Total Approved Quantity being zero.');
        } catch (DmlException e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        System.assert(isExceptionThrown, 'Expected an exception to be thrown due to Total Approved Quantity being zero.');
    }
}