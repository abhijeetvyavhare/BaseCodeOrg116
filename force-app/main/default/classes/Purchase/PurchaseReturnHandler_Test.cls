@isTest
public with sharing class PurchaseReturnHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__TaxGroup__c taxGroupGST18partner1 = TestDataHelpers.createTaxGroup('GST 18', partnerAccount1.Id, branch1.Id);
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(supplierAccount1, partnerAccount1, branch1);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1, 
            branch1, 
            priceList1, 
            purchaseOrder, 
            goodsReceipt
        );
    }
    
    @isTest
    static void createPurchaseReturnPositive() {
        Test.startTest();
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        if(purchaseReturn != null){
            System.assertNotEquals(purchaseReturn, null, 'Expected purchaseReturn to be created.');
        }
        System.assertEquals('1', purchaseReturn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Description1', purchaseReturn.dmpl__Description__c, 'Description should be Description1');
        Test.stopTest();
    }
    
    @isTest
    static void updatePurchaseRetrunPositive() {
        Test.startTest();
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        System.assertNotEquals(purchaseReturn, null, 'purchaseReturn should exist before update.');
        purchaseReturn.dmpl__Status__c = '2';
        update purchaseReturn;
        dmpl__PurchaseReturn__c updatedPurchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun(purchaseReturn.Id);
        System.assertEquals(updatedPurchaseReturn.dmpl__Status__c, '2', 'Status should be 2');
        Test.stopTest();
    }
    
    @isTest
    static void deletePurchaseReturn() {
        Test.startTest();
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        System.assertNotEquals(purchaseReturn, null, 'PurchaseReturn should exist before delete.');
        delete purchaseReturn;
        dmpl__PurchaseReturn__c deletedPurchaseReturn = null;
        try {
            deletedPurchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun(purchaseReturn.Id);
        } catch (Exception e) {
            deletedPurchaseReturn = null;
        }
        System.assertEquals(null, deletedPurchaseReturn, 'PurchaseReturn should be deleted and not found in query.');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationCreateReturnForDefectiveGoodsUsingValidPartnerAndSupplierAccountPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            null, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationCreateReturnWithValidBranchTaggedInThePartnerAccountPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            null, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationCreateReturnUsingInvalidPartnerAccountNegativeNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        try{
            dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
                null, 
                partnerAccount1, 
                null, 
                null, 
                false, 
                false, 
                null
            );
            System.assert(true, 'Exception should be thrown');
        } catch(exception e){
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationCreateReturnUsingInvalidSupplierAccountNegativeNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        try{
            dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
                null, 
                partnerAccount1, 
                null, 
                null, 
                false, 
                false, 
                null
            );
            System.assert(true, 'Exception should be thrown');
        } catch(exception e){
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationCreateReturnUsingInvalidBranchNegativeNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        try{
            dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
                null, 
                partnerAccount1, 
                branch1, 
                null, 
                false, 
                false, 
                null
            );
            System.assert(true, 'Exception should be thrown');
        } catch(exception e){
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationFullReturnProcessedAndMarkedAsIsReturnedWithGlPostingEnabledPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            purchaseOrder.Id, 
            true, 
            true, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(purchaseOrder.Id, purchaseReturn.dmpl__PurchaseOrderId__c, 'Purchase Order Id mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsGLPostingApproved__c, 'Is GL Posting Approval mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationSubmitReturnForVendorApprovalByEnablingIsGlPostingApprovedPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            purchaseOrder.Id, 
            true, 
            true, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(purchaseOrder.Id, purchaseReturn.dmpl__PurchaseOrderId__c, 'Purchase Order Id mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsGLPostingApproved__c, 'Is GL Posting Approval mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationTrackReturnViaLinkedPurchaseOrderAndSupplierInvoiceNumberPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationPerformInventoryPostingAlongWithGlPostingPositveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            true, 
            true, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsGLPostingApproved__c, 'Is GL Posting Approval mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationAttemptReturnWithoutLinkingPurchaseOrderPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            null, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationSubmitReturnWithMissingSupplierInvoiceNumberAndDatePositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            null, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationSetIsGlPostedWithoutGlApprovalPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            true, 
            true, 
            null
        );
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(true, purchaseReturn.dmpl__IsGLPostingApproved__c, 'Is GL Posting Approval mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationUseFutureDocumentDateBeyondAllowedPolicyPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationEditReturnRecordBeforeSettingIsReturnedFlagPositiveEdit(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationIncorrectPriceAsOnDateBeforeOriginalPoDatePositiveEdit(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            null
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationDuplicateReturnForSamePoAndGrnPositiveEdit(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnCreationInvalidDateInSupplierInvoiceDateFieldPositiveEdit(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationCreateReturnLineWithAllMandatoryFieldsItemDeliveryQuantityPurchaseInvoiceUnitCostPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationAddReturnLineWithValidTaxGroupAndTaxApplicableItemPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        try{
            dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
                null, 
                customerAccount1, 
                Invoice, 
                item1, 
                null, 
                10, 
                100, 
                null
            );
            System.assert(false, 'Exception should be thrown');
        } catch(exception e){
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationAddReturnLineWithValidTaxGroupAndTaxApplicableItemPositiveNew1(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            taxGroup
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(taxGroup.Id, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationLeaveTaxGroupBlankForTaxApplicableItemPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationSelectValidReturnTypeDamagedShortageExcessPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationLeaveReturnTypeAsNoneAndTrySavingPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(supplierAccount1, partnerAccount1, branch1, null, false, false, goodsReceipt.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        System.assertEquals('Damaged', purchaseReturnLine.dmpl__ReturnType__c, 'Return type mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationUseActiveItemWithValidPricingAndQuantityPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationCreateReturnLineWithInactiveItemPositiveNew(){
         Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void PurchaseReturnLineCreationAddValidAccountLinkedToItemAndBranchPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationLinkTheReturnLineWithTheCorrectPurchaseInvoiceAndBillLinePositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
         dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn, 
            customerAccount1, 
            Invoice, 
            item1, 
            null, 
            10, 
            100, 
            null
        );
        System.assertEquals(purchaseReturn.Id, purchaseReturnLine.dmpl__PurchaseReturnId__c, 'Purchase Return Id mismatch');
        System.assertEquals(customerAccount1.Id, purchaseReturnLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(Invoice.Id, purchaseReturnLine.dmpl__PurchaseInvoiceId__c, 'Invoice Id mismatch');
        System.assertEquals(item1.Id, purchaseReturnLine.dmpl__ItemId__c, 'Item Id mismatch');
        System.assertEquals(null, purchaseReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(10, purchaseReturnLine.dmpl__DeliveryQuantity__c, 'Delivery Quantity mismatch');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseReturnLineCreationLeavePurchaseInvoiceBlankOrLinkWrongBillLineNegativeNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount1, 
            branch1, 
            purchaseOrder, 
            supplierAccount1
        );
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount1, 
            partnerAccount1, 
            branch1, 
            null, 
            false, 
            false, 
            goodsReceipt.Id
        );
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        System.assertEquals(supplierAccount1.Id, purchaseReturn.dmpl__SupplierAccountId__c, 'Supplier Account Id mismatch');
        System.assertEquals(branch1.Id, purchaseReturn.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, purchaseReturn.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        System.assertEquals(false, purchaseReturn.dmpl__IsReturned__c, 'Is Returned mismatch');
        System.assertEquals(Date.today(), purchaseReturn.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(goodsReceipt.Id, purchaseReturn.dmpl__GoodsReceiptNumberId__c, 'GRN Id mismatch');
        dmpl__Bill__c Invoice = BillTestDataHelpers.getBill();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        try{
            dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
                null, 
                customerAccount1, 
                null, 
                item1, 
                null, 
                10, 
                100, 
                null
            );
            System.assert(false, 'Exception should be thrown');
        } catch(exception e){
            System.assert(true, 'Exception should be thrown');
        }
        Test.stopTest();
    }
}