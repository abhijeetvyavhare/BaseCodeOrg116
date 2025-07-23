@isTest
public with sharing class FinanceCaseHandler_Test {
    
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, sku, taxGroup);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__Financer__c financer = FinanceCaseDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.createFinancerScheme(financer, partnerAccount.id, null);
        FinanceCaseDataHelper.createFinanceCase(customerAccount, branch, saleOrder, saleInvoice, financer, scheme);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);

        
    }
    
    @isTest
    static void createFinanceCasePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
        branch,
        saleOrder,
        saleInvoice,
        financer,
        scheme
            );
        Test.stopTest();
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be inserted');
        System.assertEquals('Draft', financeCase.dmpl__Status__c, 'Finance case should default to Draft');
        System.assertEquals(saleOrder.Id, financeCase.dmpl__SaleOrderId__c, 'Sale Order reference should be correct');
    }
    
    @isTest
    static void updateFinanceCasePositive() {
        Test.startTest();
        dmpl__FinanceCase__c fc = FinanceCaseDataHelper.getFinanceCase();
        fc.dmpl__RequestedAmount__c = 12000;
        update fc;
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(fc.Id);
        System.assertEquals(12000, updated.dmpl__RequestedAmount__c, 'Requested amount should update');
        Test.stopTest();
    }
    
    @isTest
    static void deleteFinanceCase() {
        Test.startTest();
        dmpl__FinanceCase__c fc = FinanceCaseDataHelper.getFinanceCase();
        Id financeCaseId = fc.Id;
        delete fc;
        try {
            dmpl__FinanceCase__c deletedFinanceCase = FinanceCaseDataHelper.getFinanceCase(financeCaseId);
            System.assert(false, 'Expected finance case to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Finance case successfully deleted.');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void createAFinanceCaseBySelectingValidFinanceProviderAndFinanceSchemePositiveNew() {
        Test.startTest();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
        branch,
        financer,
        scheme
            );
        financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be created');
        System.assertEquals(financer.Id, financeCase.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, financeCase.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        Test.stopTest();
    }
    
    @isTest
    public static void tryCreatingFinanceCaseWithoutSelectingAFinanceProviderNegativeNew() {
        
        Test.startTest();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        
        
        Boolean exceptionThrown = false;
        try {
            FinanceCaseDataHelper.createFinanceCase(
                null,
            scheme
                );
            System.assert(false, 'Exception should be thrown when Finance Provider is missing, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Finance Provider is missing');
        Test.stopTest();
    }
    
    @isTest
    
    public static void  createAFinanceCaseByLinkingItWithAValidSaleOrderAndPartnerAccountPositiveNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();  
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();	

        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
        branch,
        saleOrder,
        null,
        financer,
        scheme
            );
        financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be created with valid Sale Order and Partner Account');
        System.assertEquals(saleOrder.Id, financeCase.dmpl__SaleOrderId__c, 'Sale Order reference should match');
        System.assertEquals(partnerAccount.Id, financeCase.dmpl__PartnerAccountId__c, 'Partner Account reference should match');
        Test.stopTest();
    }
    
    @isTest
    public static void attemptToCreateAFinanceCaseWithInvalidOrUnlinkedBranchNegativeNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        // dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 23');
        
        Boolean exceptionThrown = false;
        try {
            FinanceCaseDataHelper.createFinanceCase(
                customerAccount,
            null,
            financer,
            scheme
                );
            System.assert(false, 'Exception should be thrown when Branch is invalid or unlinked, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Branch is invalid or unlinked');
        Test.stopTest();
    }
    
    @isTest
    public static void enterAppropriateRequestedDownPaymentAndRequestedAmountWithValidTenurePositiveEdit() {
        Test.startTest();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase();
        financeCase.dmpl__RequestedAmount__c = 1500;
        financeCase.dmpl__RequestedDownPayment__c = 300;
        financeCase.dmpl__RequestedTenureMonths__c = 12;
        
        update financeCase;
        
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertEquals(1500, updated.dmpl__RequestedAmount__c, 'Requested Amount should be updated');
        System.assertEquals(300, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should be updated');
        System.assertEquals(12, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should be updated');
        Test.stopTest();
    }
    
    @isTest
    public static void modifyTheCaseToHaveRequestedTenureAsZeroOrNegativeNegativeEdit(){
        
        Account customer = TestDataHelpers.getCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        
        dmpl__FinanceCase__c financeCase  = FinanceCaseDataHelper.createFinanceCase(
            customer,
        branch,
        financer,
        scheme,
        104152.6,
        54152.6,
        2,
        2,
        4500
            );
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            financeCase = FinanceCaseDataHelper.getFinanceCase(financer.Id);
            financeCase.dmpl__RequestedTenureMonths__c = 0;
            update financeCase;
            System.assert(false, 'Exception should be thrown when Tenure is zero or negative, but record was updated.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.AssertEquals(true, exceptionThrown, 'Exception should be thrown when Tenure is zero or negative');
        Test.stopTest();
    }
    
    @isTest
    public static void  addOrCorrectRequestedInterestRateAndRecalculateEMIOnRequestedAmountPositiveEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
        branch,
        financer,
        scheme,
        132015,
        50000,
        7,
        30,
        4000
            );
        
        financeCase.dmpl__RequestedInterestRate__c = 7.25;
        financeCase.dmpl__EMIOnRequestedAmount__c = 4500;
        update financeCase;
        
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertEquals(132015, updated.dmpl__RequestedAmount__c, 'Requested Amount should match');
        System.assertEquals(50000, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match');
        System.assertEquals(7.25, updated.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should be updated');
        System.assertEquals(30, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should match');
        System.assertEquals(4500, updated.dmpl__EMIOnRequestedAmount__c, 'EMI On Requested Amount should be updated');
        System.assertEquals(customer.Id, updated.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(partner.Id, updated.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, updated.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(financer.Id, updated.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, updated.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        Test.stopTest();
    }
    
    @isTest
    public static void linkSaleInvoicePostCreationToAssociateFinancialDocumentationPositiveEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        
        // dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
        //     customer,
        // branch,
        // financer,
        // scheme,
        // 600,
        // 600,
        // 6,
        // 2,
        // 3
        //     );

        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
        branch,
        saleOrder,
        saleInvoice,
        financer,
        scheme);




        // financeCase.dmpl__SaleOrderId__c = saleOrder.Id;
        // update financeCase;
        
        // financeCase.dmpl__SaleInvoiceId__c = saleInvoice.Id;
        // update financeCase;
        
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertEquals(saleInvoice.Id, updated.dmpl__SaleInvoiceId__c, 'Sale Invoice should be linked');
        System.assertEquals(saleOrder.Id, updated.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer.Id, updated.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(partner.Id, updated.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, updated.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(financer.Id, updated.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, updated.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        System.assertEquals(10000, updated.dmpl__RequestedAmount__c, 'Requested Amount should match');
        System.assertEquals(1000, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match');
        System.assertEquals(5, updated.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should match');
        System.assertEquals(12, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should match');
        Test.stopTest();
    }


    @isTest
    public static void  attemptToEditAFinanceCaseWithMismatchedSaleOrderAndAccountHierarchyNegativeEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3'); 
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();

        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
            branch1,
            financer,
            scheme,
            600,
            600,
            6,
            2,
            3
        );

        Boolean exceptionThrown = false;
        try {
            financeCase.dmpl__BranchId__c = branch3.Id;
            update financeCase;
            System.assert(false, 'Exception should be thrown when mismatched Branch is set, but record was updated.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when mismatched Branch is set');
        Test.stopTest();
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}