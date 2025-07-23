@isTest
public class KYCDocumentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1','Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount, 
            branch, 
            null,
            priceList
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            15,
            sku.Id
        );
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.createKYCDocuments(saleOrder);
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, partnerAccount.ID, accountGroup.Id);
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
            branch,
            saleOrder,
            null,
            financer,
            scheme
        );        
    }
    
    @isTest
    static void createKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertEquals('3534534', KYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void updateKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        KYCDocument.dmpl__DocumentNumber__c = '343434';
        update KYCDocument;
        dmpl__KYCDocument__c updatedKYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertEquals('343434', updatedKYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void deleteKYCDocument() {
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertNotEquals(null, kycDocument, 'KYC Document should exist before deletion.');
        Id docId = kycDocument.Id;
        delete kycDocument;
        dmpl__KYCDocument__c deletedDoc;
        try {
            deletedDoc = KYCDocumentsTestDataHelpers.getKYCDocument(docId);
        } catch (Exception e) {
            deletedDoc = null;
        }
        System.assertEquals(null, deletedDoc, 'KYC Document should be deleted and not found in query.');
    }
    
    @isTest
    static void createKYCDocumentWithValidDocumentTypeAndKYCTypeLinkedToASaleOrderAndBranchPositiveNew() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertNotEquals(null, kycDocument, 'KYC Document should be created');
        System.assertEquals(saleOrder.Id, kycDocument.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals('Sample', kycDocument.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Address Proof', kycDocument.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('3534534', kycDocument.dmpl__DocumentNumber__c, 'Document Number should match');
        Test.stopTest();
    }
    
    @isTest
    public static void linkTheKYCDocumentToAnExistingFinanceCaseForValidationTrackingPositiveNew(){
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        kycDocument.dmpl__FinanceCaseId__c = financeCase.Id;
        update kycDocument;
        System.assertNotEquals(null, kycDocument, 'KYC Document should be created');
        System.assertEquals(financeCase.Id, kycDocument.dmpl__FinanceCaseId__c, 'Finance Case should match');
        System.assertEquals('Sample', kycDocument.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Address Proof', kycDocument.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('3534534', kycDocument.dmpl__DocumentNumber__c, 'Document Number should match');
        Test.stopTest();
    }
    
    @isTest
    public static void verifyAndMarkTheIsVerifiedCheckboxAfterCrossVerifyingTheAttachedDocumentsPositiveEdit() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        kycDocument.dmpl__IsVerified__c = true;
        update kycDocument;
        dmpl__KYCDocument__c updated = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        System.assertEquals('3534534', updated.dmpl__DocumentNumber__c, 'Document Number should match');
        System.assertEquals('Sample', updated.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals(true, updated.dmpl__IsVerified__c, 'Is Verified should be true');
        System.assertEquals('Address Proof', updated.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals(saleOrder.Id, updated.dmpl__SaleOrderId__c, 'Sale Order should match');
        Test.stopTest();
    }
    
    @isTest
    public static void updateExistingKYCRecordWithNewDocumentNumberForAuditTrailPositiveEdit() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        kycDocument.dmpl__FinanceCaseId__c = financeCase.Id;
        kycDocument.dmpl__DocumentNumber__c = 'DOC25060016';
        update kycDocument;
        dmpl__KYCDocument__c updated = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        System.assertEquals(financeCase.Id, updated.dmpl__FinanceCaseId__c, 'Finance Case should match');
        System.assertEquals('Sample', updated.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals(false, updated.dmpl__IsVerified__c, 'Is Verified should be true');
        System.assertEquals('Address Proof', updated.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('DOC25060016', updated.dmpl__DocumentNumber__c, 'Document Number should be updated');
        Test.stopTest();
    }
    
    @isTest
    public static void tryLinkingKYCDocumentToSaleOrderNotAssociatedWithBranchNegativeNew() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        Boolean exceptionThrown = false;
        try {
            saleOrder.dmpl__BranchId__c = null;
        	update saleOrder;
            saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
            kycDocument.dmpl__SaleOrderId__c = saleOrder.Id;
            kycDocument.dmpl__BranchId__c = saleOrder.dmpl__BranchId__c;
            System.assert(false, 'Exception should be thrown when Sale Order is not associated with the Branch, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Sale Order is not associated with the Branch');
        Test.stopTest();
    }
    
    @isTest
    public static void populateSaleOrderLineFieldToRelateDocumentToSpecificProductLinesPositiveEdit() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        kycDocument.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
        update kycDocument;
        dmpl__KYCDocument__c updatedKyc = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        System.assertEquals('3534534', updatedKyc.dmpl__DocumentNumber__c, 'Document Number should match');
        System.assertEquals('Sample', updatedKyc.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Address Proof', updatedKyc.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals(saleOrder.Id, updatedKyc.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(saleOrderLine.Id, updatedKyc.dmpl__SaleOrderLineId__c, 'Sale Order Line should match');
        Test.stopTest();
    }
    
    @isTest
    public static void leaveMandatoryFieldsLikeBranchOrSaleOrderEmptyNegativeNew() {
        Test.startTest();
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        Boolean exceptionThrown = false;
        try {
            kycDocument.dmpl__SaleOrderId__c = null;
            update kycDocument;
            System.assert(false, 'Exception should be thrown when mandatory Sale Order is missing, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when mandatory Sale Order is missing');
        Test.stopTest();
    }
}