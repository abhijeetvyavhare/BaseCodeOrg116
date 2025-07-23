@isTest
public with sharing class InsuranceOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
    }
    
    @isTest
    public static void insuranceSchemeCreationInsuranceSchemeCreationWithValidSchemeNamePositiveNew() {
        Test.startTest();
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        System.assertEquals('Scheme 1', insuranceScheme.Name, 'Scheme Name mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationInsuranceSchemeCreationWithSpecialCharactersInNamePositiveNew() {
        Test.startTest();
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        System.assertEquals('Scheme 1', insuranceScheme.Name, 'Scheme Name mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationInsuranceSchemeCreationWithEmptySchemeNameNegativeNew() {
        Test.startTest();
        try{
            dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme(null);
            system.assert(true, 'Expected exception not thrown');
        } catch(exception e){
            system.assert(true, 'Exception message mismatch');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationInsuranceSchemeCreationWithNoOwnerAssignedNegativeNew() {
        Test.startTest();
        try{
            dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme(null);
            system.assert(true, 'Expected exception not thrown');
        } catch(exception e){
            system.assert(true, 'Exception message mismatch');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationEditInsuranceSchemeUpdateSchemeNameToANewValidNameEdit() {
        Test.startTest();
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        System.assertEquals('Scheme 1', insuranceScheme.Name, 'Scheme Name mismatch');
        insuranceScheme.Name = 'Scheme 2';
        update insuranceScheme;
        System.assertEquals('Scheme 2', insuranceScheme.Name, 'Scheme Name mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationEditInsuranceSchemeUpdateOwnerFieldPositiveEdit() {
        Test.startTest();
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        System.assertEquals('Scheme 1', insuranceScheme.Name, 'Scheme Name mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceSchemeCreationEditInsuranceSchemeClearSchemeNameFieldNegativeEdit() {
        Test.startTest();
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        System.assertEquals('Scheme 1', insuranceScheme.Name, 'Scheme Name mismatch');
        try{
            insuranceScheme.Name = null;
            update insuranceScheme;
            system.assert(true, 'Expected exception not thrown');
        } catch(exception e){
            system.assert(true, 'Exception message mismatch');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderCreationCreateInsuranceOrderWithValidPartnerAccountBranchAndPriceListPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithLookupToValidAccountAndInsuranceSchemePositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithValidDescriptionTextPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        System.assertEquals('test', insurer.Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithOptionalSaleOrderFilledPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithoutInsurerNamePositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            null, 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals(null, insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithoutInsuranceSchemeLookupPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            null, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(null, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationInsurerCreationWithInvalidAccountLookupPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            null, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(null, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationEditInsurerUpdateDescriptionFieldWithValidTextPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        insurer.Description__c = 'Updated Description';
        update insurer;
        System.assertEquals('Updated Description', insurer.Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insurerCreationEditInsurerClearInsurerNameFieldPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        insurer.Name = null;
        update insurer;
        System.assertEquals(null, insurer.Name, 'Name mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationInsuranceOrderLineWithValidInsurerSaleOrderSaleOrderLinePositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationInsuranceOrderLineWithValidInsuranceAmountAndPolicyNumberPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            1200, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(1200, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationInsuranceOrderLineWithInsuranceDateAndExpiryDateFilledPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationWithDocumentDateTodayPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationInsuranceOrderLineWithStatusBlankOrNotSelectedPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        insuranceOrderLine.dmpl__Status__c = null;
        update insuranceOrderLine;
        System.assertEquals(null, insuranceOrderLine.dmpl__Status__c, 'Status mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationEditInsuranceOrderLineUpdateStatusToIssuedPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        insuranceOrderLine.dmpl__Status__c = 'Approved';
        update insuranceOrderLine;
        System.assertEquals('Approved', insuranceOrderLine.dmpl__Status__c, 'Status mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationEditInsuranceOrderLineModifyInsuranceAmountPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        insuranceOrderLine.dmpl__InsuranceAmount__c = 200;
        update insuranceOrderLine;
        System.assertEquals(200, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationEditInsuranceOrderLineUpdateRemarksFieldPositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        insuranceOrderLine.dmpl__Remarks__c = null;
        update insuranceOrderLine;
        System.assertEquals(null, insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void insuranceOrderLineCreationEditInsuranceOrderLineClearRequiredFieldSaleOrderLinePositiveEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__InsuranceScheme__c insuranceScheme = InsuranceSchemeDataHelper.createInsuranceScheme('Scheme 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false, 
            null
        );
        dmpl__Insurer__c insurer = InsuranceTestDataHelper.createInsuranceOrder(
            'HDFC Bank', 
            insuranceScheme, 
            customerAccount1, 
            'test', 
            saleOrder
        );
        System.assertEquals('HDFC Bank', insurer.Name, 'Name mismatch');
        System.assertEquals(customerAccount1.Id, insurer.dmpl__AccountId__c, 'Customer Account Id mismatch');
        System.assertEquals(insuranceScheme.Id, insurer.dmpl__Insurance_Scheme__c, 'Insurance Scheme Id mismatch');
        System.assertEquals(saleOrder.Id, insurer.dmpl__Sale_Order__c, 'Sale Order Id mismatch');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            15, 
            null
        );
        dmpl__InsuranceOrderLine__c insuranceOrderLine = InsuranceTestDataHelper.createInsuranceOrderLine(
            insurer, 
            100, 
            'Test-Policy', 
            'Test-Remarks', 
            saleOrderLine
        );
        System.assertEquals(insurer.Id, insuranceOrderLine.dmpl__InsurerId__c, 'Insurer Id mismatch');
        System.assertEquals(100, insuranceOrderLine.dmpl__InsuranceAmount__c, 'Insurance Amount mismatch');
        System.assertEquals('Test-Policy', insuranceOrderLine.dmpl__PolicyNumber__c, 'Policy Number mismatch');
        System.assertEquals('Test-Remarks', insuranceOrderLine.dmpl__Remarks__c, 'Remarks mismatch');
        System.assertEquals(saleOrderLine.Id, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(Date.today().addDays(30), insuranceOrderLine.dmpl__ExpiryDate__c, 'Expiry Date mismatch');
        System.assertEquals(Date.today(), insuranceOrderLine.dmpl__InsuranceDate__c, 'Insurance Date mismatch');
        insuranceOrderLine.dmpl__SaleOrderLineId__c = null;
        update insuranceOrderLine;
        System.assertEquals(null, insuranceOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line Id mismatch');
        Test.stopTest();
    }
}