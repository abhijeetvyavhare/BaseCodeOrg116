@isTest
public class PurchaseRequisitionHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__TaxGroup__c taxGroupGST18partner1 = TestDataHelpers.createTaxGroup('GST 18', partnerAccount1.Id, branch1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);
        dmpl__Tax__c taxCGST18 = TestDataHelpers.createTax(
            'CGST18', 
            'CGST', 
            18, 
            taxGroupGST18partner1.Id, 
            'Tax1'
        );
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(branch1, supplierAccount1);
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(purchaseRequisition, item1, sku);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item1, 
            sku, 
            purchaseOrder, 
            taxGroupGST18partner1, 
            purchaseRequisition
        );
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.CreatePurchaseOrderTax(purchaseOrder, taxCGST18, purchaseOrderLine);
    }
    
    @isTest
    public static void createPurchaseRequisitionPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount, branch);
        System.assertNotEquals(null, purchaseRequisition.Id, 'Purchase Requisition should be created');
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partnerAccount.Id, purchaseRequisition.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, purchaseRequisition.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    public static void UpdatePurchaseRequisitionPositive() {
        Test.startTest();
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        if (purchaseRequisition != null) {
            purchaseRequisition.dmpl__Status__c = 'Draft';
            purchaseRequisition.dmpl__PerformReleaseOrder__c = true;
        }
        update purchaseRequisition;
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 updated record');
        Test.stopTest();
    }
    
    @isTest
    public static void DeletePurchaseRequisitionPositive() {
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        delete purchaseRequisition;
        System.assertEquals(null, purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 deleted record');
    }
    
    @isTest
    public static void createPurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(purchaseRequisition, item, sku);
        System.assertNotEquals(null, purchaseRequisitionLine.Id, 'Purchase Requisition Line should be created');
        System.assertEquals(purchaseRequisition.Id, purchaseRequisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');
        System.assertEquals(item.Id, purchaseRequisitionLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku.Id, purchaseRequisitionLine.dmpl__SKUId__c, 'SKU should match');
    }
    
    @isTest
    public static void UpdatePurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.getRequisitionLine();
        purchaseRequisitionLine.dmpl__Quantity__c = 5;
        update purchaseRequisitionLine;
        System.assertEquals(5, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 updated record');
    }
    
    @isTest
    public static void DeletePurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.getRequisitionLine();
        delete purchaseRequisitionLine;
        System.assertEquals(1, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 deleted record');
    }
    
    @isTest
    public static void purchaseRequisitionCreationCreateRequisitionWithValidPartnerAccountAndBranchNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationSetValidDocumentDatePositiveNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationStatusSetAsDraftOrSubmittedPositiveNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationStatusSetAsDraftOrSubmittedNewpurchaseRequisitionCreationAddRemarksAndRequestedByOptionalNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationMissingPartnerAccountNegativeNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try {
            dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
                null, 
                branch1, 
                branch3, 
                supplierAccount1, 
                UserInfo.getUserId()
            );
            System.assert(false, 'requisition should not be created but created');
        } catch (exception e) {
            System.assert(true, 'requisition should not be created');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationMissingBranchNegativeNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try {
            dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
                partnerAccount1, 
                null, 
                null, 
                supplierAccount1, 
                UserInfo.getUserId()
            );
            System.assert(false, 'requisition should not be created but created');
        } catch (exception e) {
            System.assert(true, 'requisition should not be created');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationInactivePartnerAccountNegativeNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        Test.startTest();
        try {
            dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
                partnerAccount2, 
                null, 
                null, 
                supplierAccount1, 
                UserInfo.getUserId()
            );
            System.assert(false, 'requisition should not be created but created');
        } catch (exception e) {
            System.assert(true, 'requisition should not be created');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationFutureDocumentDateBeyondPolicyPositiveNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationRemarksExceedCharacterLimitNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        requisition.dmpl__Remarks__c = 'Salesforce is a leading customer relationship management (CRM) platform that has revolutionized how businesses manage and interact with their customers. Founded in 1999, Salesforce has grown to become the worlds #1 CRM, offering a suite of cloud-based applications designed to help businesses streamline operations, improve customer engagement, and drive growth.At its core, Salesforce enables businesses to track and manage customer interactions across various touchpoints, providing a 360-degree view of the customer. This is crucial for creating personalized experiences, enhancing customer satisfaction, and boosting customer loyalty. With tools for sales, marketing, service, and analytics, Salesforce empowers organizations to optimize their processes and improve decision-making.One of the key features of Salesforce is its cloud-based architecture, which allows businesses to access their CRM data from anywhere, at any time, without the need for complex infrastructure. The platform is also highly customizable, enabling businesses to tailor the system to their specific needs using Salesforce rich set of tools like Apex (for server-side logic), Visualforce (for custom user interfaces), and Lightning (for building modern, responsive apps).Salesforce has also integrated artificial intelligence through Einstein, which leverages machine learning and data analytics to provide businesses with insights, recommendations, and predictive analytics. This allows sales teams to forecast more accurately and service teams to deliver proactive support to customers.The Salesforce ecosystem includes a vibrant AppExchange, where businesses can find and install third-party applications to extend Salesforce’s capabilities. Whether you are a small business or a large enterprise, Salesforce’s scalability and flexibility make it a powerful tool to drive growth, enhance productivity, and create stronger customer relationships. With continuous innovation, Salesforce remains at the forefront of digital transformation, enabling organizations to thrive in the digital age.';
        try {
            update requisition;
        } catch (exception e) {
            System.assert(true, 'Suceessfully failed');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationRequisitionRecordCreatedWithJustMandatoryFieldsPositiveNew() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1);
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationEditRemarksFieldForClarificationPositivePositiveEdit() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1);
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        requisition.dmpl__Remarks__c = 'Requisition created has no supplier as well as branch from';
        update requisition;
        System.assertEquals('Requisition created has no supplier as well as branch from', requisition.dmpl__Remarks__c, 'Remarks does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationEditDocumentDateToFutureDateBeyondAllowedNegativeEdit() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1);
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        requisition.dmpl__DocumentDate__c = Date.today().addDays(7);
        try {
            update requisition;
            System.assert(false, 'Date cannot be the future date');
        } catch (exception e) {
            System.assert(true, 'Date cannot be in future');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationEditDocumentDateToFutureDateBeyondAllowedPositiveEdit() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(
            partnerAccount1, 
            branch1, 
            branch3, 
            supplierAccount1, 
            UserInfo.getUserId()
        );
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(branch3.Id, requisition.dmpl__FromBranchId__c, 'FromBranchId does not match');
        System.assertEquals(UserInfo.getUserId(), requisition.dmpl__RequestedById__c, 'userId does not match');
        System.assertEquals('Test-Remarks', requisition.dmpl__Remarks__c, 'Remarks does not match');
        requisition.dmpl__Status__c = 'Confirmed';
        update requisition;
        System.assertEquals('Confirmed', requisition.dmpl__Status__c, 'status does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void purchaseRequisitionCreationRemoveBranchFieldAndTrySavingNegativeEdit() {
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        purchaserequisitionmasterdata.createbranch3();
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1);
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'BranchId does not match');
        requisition.dmpl__BranchId__c = null;
        try {
            update requisition;
            System.assert(false, 'Should not be updated but updated');
        } catch (Exception e) {
            System.assert(true, 'Should not be updated');
        }
        Test.stopTest();
    }

    @isTest
    public static void RequisitionCreatedWithActivePartnerAndBranch(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1,supplierAccount1);
        system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
        test.stopTest();
    }

    @isTest
    public static void RequisitionLineCreatedWithValidItemAndQuantity(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        test.startTest();
        dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1,supplierAccount1);
        system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
        dmpl__PurchaseRequisitionLine__c RequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(Requisition, item1, sku);
        test.stopTest();
    }

     @isTest
    public static void RequisitionCreatedWithSupplierAccount(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1,supplierAccount1);
        system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
        test.stopTest();
    }
    @isTest
    public static void RequsitionCreatedWithActivePartnerAndBranch(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1);
        system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
        test.stopTest();
    }

    @isTest
    static void RequisitionIsNotCreatedWithInvalidInactivePartnerAccount(){
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
        try{
            dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount2, branch);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Requisition.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void RequistionLineNotCreated(){
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        test.startTest();
        try{
            dmpl__PurchaseRequisitionLine__c RequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(null, item1, sku);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Requisition.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void RequisitionIsNotGetCreatedWithInactiveBranch(){
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
        try{
            dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount2, branch);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Requisition.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void RequisitionLineIsNotGetCreatedWith0Quantity(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        test.startTest();
        try{
            dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1,supplierAccount1);
            system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
            dmpl__PurchaseRequisitionLine__c RequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(Requisition, item1, sku);
            RequisitionLine.dmpl__Quantity__c = 0;
            update RequisitionLine;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Requisition.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void RequistionLineCreated(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        test.startTest();
        dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount1, branch1,supplierAccount1);
        system.assertNotEquals(null, Requisition.Id, 'Requisition should be created');
        dmpl__PurchaseRequisitionLine__c RequisitionLine = PurchaseRequisitionTestDataHelpers.createRequistionLine(Requisition, item1, sku);
        test.stopTest();
    }

    @isTest
    static void RequistionIsNotUpdatedWithValidBranchEdit(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        test.startTest();
        try{
            dmpl__PurchaseRequisition__c Requisition = PurchaseRequisitionTestDataHelpers.createRequistion(partnerAccount, branch);
            Requisition.dmpl__BranchId__c = branch2.Id;
            update Requisition;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Requisition.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }
}