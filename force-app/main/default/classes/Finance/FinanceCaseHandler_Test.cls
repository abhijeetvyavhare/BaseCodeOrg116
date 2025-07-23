@isTest
public with sharing class FinanceCaseHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__ContactAddress__c contactAddress1 = TestDataHelpers.CreateContactAddress(customerAccount1);
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList(partnerAccount1, branch1);
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount1,
            branch1, 
            contactAddress1,
            priceList1
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(
            customerAccount1,
            branch1,
            saleOrder1,
            priceList1
        );
        dmpl__Financer__c financer = FinanceCaseDataHelper.createFinancer(customerAccount1.Id);
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.createFinancerScheme(financer, partnerAccount1.id, null);
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customerAccount1,
            branch1,saleOrder1,
            null,
            financer,
            scheme
        );
    }
    
    @isTest
    static void createFinanceCasePositive() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase();
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();        
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
            branch,
            financer,
            scheme,
            600,
            600,
            6,
            2,
            3,
            null,
            null
        );
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be created');
        System.assertEquals(financer.Id, financeCase.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, financeCase.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        System.assertEquals(3, financeCase.dmpl__EMIOnRequestedAmount__c, 'EMI on Requested Amount should match.');
        System.assertEquals(600, financeCase.dmpl__RequestedAmount__c, 'Requested Amount should match.');
        System.assertEquals(600, financeCase.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match.');
        System.assertEquals(6, financeCase.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should match.');
        System.assertEquals(2, financeCase.dmpl__RequestedTenureMonths__c, 'Requested Tenure Months should match.');
        Test.stopTest();
    }
    
    @isTest
    public static void tryCreatingFinanceCaseWithoutSelectingAFinanceProviderNegativeNew() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();        
        Boolean exceptionThrown = false;
        try {
            dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(customerAccount,branch,null,scheme,500,500,6,6,3,null,null);
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();  
        dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
            branch,
            financer,
            scheme,
            600,
            600,
            6,
            2,
            3,
            saleOrder,
            null
        );
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be created with valid Sale Order and Partner Account');
        System.assertEquals(saleOrder.Id, financeCase.dmpl__SaleOrderId__c, 'Sale Order reference should match');
        System.assertEquals(partnerAccount.Id, financeCase.dmpl__PartnerAccountId__c, 'Partner Account reference should match');
        System.assertEquals(600, financeCase.dmpl__RequestedAmount__c, 'Requested Amount should match.');
        System.assertEquals(600, financeCase.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match.');
        System.assertEquals(6, financeCase.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should match.');
        System.assertEquals(2, financeCase.dmpl__RequestedTenureMonths__c, 'Requested Tenure Months should match.');
        System.assertEquals(customerAccount.Id, financeCase.dmpl__AccountId__c, 'Account Id should match.');
        System.assertEquals(partnerAccount.Id, financeCase.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, financeCase.dmpl__BranchId__c, 'Branch Id should match.');
        System.assertEquals(saleOrder.Id, financeCase.dmpl__SaleOrderId__c, 'Sale Order Id should match.');
        System.assertEquals(financer.Id, financeCase.dmpl__FinanceProviderId__c, 'Finance Provider Id should match.');
        System.assertEquals(scheme.Id, financeCase.dmpl__FinanceSchemeId__c, 'Finance Scheme Id should match.');
        Test.stopTest();
    }
    
    @isTest
    public static void attemptToCreateAFinanceCaseWithInvalidOrUnlinkedBranchNegativeNew(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        Boolean exceptionThrown = false;
        try {
            dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
                customerAccount,
                null,
                financer,
                scheme,
                600,
                600,
                6,
                2,
                3,
                null,
                null
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
            branch,
            financer,
            scheme,
            104152.6,
            54152.6,
            2,
            12,
            null,
            null,
            null
        );
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);
        System.assertEquals(customerAccount.Id, financeCase.dmpl__AccountId__c, 'Account Id should match.');
        System.assertEquals(partnerAccount.Id, financeCase.dmpl__PartnerAccountId__c, 'Partner Account Id should match.');
        System.assertEquals(branch.Id, financeCase.dmpl__BranchId__c, 'Branch Id should match.');
        System.assertEquals(financer.Id, financeCase.dmpl__FinanceProviderId__c, 'Finance Provider Id should match.');
        System.assertEquals(scheme.Id, financeCase.dmpl__FinanceSchemeId__c, 'Finance Scheme Id should match.');
        System.assertEquals(104152.6, financeCase.dmpl__RequestedAmount__c, 'Requested Amount should match.');
        System.assertEquals(54152.6, financeCase.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match.');
        System.assertEquals(2, financeCase.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should match.');
        System.assertEquals(12, financeCase.dmpl__RequestedTenureMonths__c, 'Requested Tenure Months should match.');
        financeCase.dmpl__RequestedAmount__c = 1500;
        financeCase.dmpl__RequestedDownPayment__c = 300;
        financeCase.dmpl__RequestedTenureMonths__c = 10;
        update financeCase;
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertEquals(1500, updated.dmpl__RequestedAmount__c, 'Requested Amount should be updated');
        System.assertEquals(300, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should be updated');
        System.assertEquals(10, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should be updated');
        Test.stopTest();
    }
    
    @isTest
    public static void modifyTheCaseToHaveRequestedTenureAsZeroOrNegativeNegativeEdit(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();     
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
                customerAccount,
                branch,
                financer,
                scheme,
                600,
                600,
                6,
                2,
                3,
                saleOrder,
                null
            );
            dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);    
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();  
        dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
            customerAccount,
            branch,
            financer,
            scheme,
            132015,
            50000,
            7,
            30,
            4000,
            null,
            null
        );
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);
        System.assertEquals(132015, financeCase.dmpl__RequestedAmount__c, 'Requested Amount should match');
        System.assertEquals(50000, financeCase.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match');
        System.assertEquals(7, financeCase.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should be updated');
        System.assertEquals(30, financeCase.dmpl__RequestedTenureMonths__c, 'Requested Tenure should match');
        System.assertEquals(4000, financeCase.dmpl__EMIOnRequestedAmount__c, 'EMI On Requested Amount should be updated');
        System.assertEquals(customerAccount.Id, financeCase.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(partnerAccount.Id, financeCase.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, financeCase.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(financer.Id, financeCase.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, financeCase.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        financeCase.dmpl__RequestedInterestRate__c = 7.25;
        financeCase.dmpl__EMIOnRequestedAmount__c = 4500;
        update financeCase;
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        System.assertEquals(132015, updated.dmpl__RequestedAmount__c, 'Requested Amount should match');
        System.assertEquals(50000, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match');
        System.assertEquals(7.25, updated.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should be updated');
        System.assertEquals(30, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should match');
        System.assertEquals(4500, updated.dmpl__EMIOnRequestedAmount__c, 'EMI On Requested Amount should be updated');
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
        dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
            customer,
            branch,
            financer,
            scheme,
            600,
            600,
            6,
            2,
            3,
            saleOrder,
            saleInvoice
        );
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);
        System.assertEquals(saleInvoice.Id, updated.dmpl__SaleInvoiceId__c, 'Sale Invoice should be linked');
        System.assertEquals(saleOrder.Id, updated.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer.Id, updated.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(partner.Id, updated.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, updated.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(financer.Id, updated.dmpl__FinanceProviderId__c, 'Finance Provider should match');
        System.assertEquals(scheme.Id, updated.dmpl__FinanceSchemeId__c, 'Finance Scheme should match');
        System.assertEquals(600, updated.dmpl__RequestedAmount__c, 'Requested Amount should match');
        System.assertEquals(600, updated.dmpl__RequestedDownPayment__c, 'Requested Down Payment should match');
        System.assertEquals(6, updated.dmpl__RequestedInterestRate__c, 'Requested Interest Rate should match');
        System.assertEquals(2, updated.dmpl__RequestedTenureMonths__c, 'Requested Tenure should match');
        Test.stopTest();
    }
    @isTest
    public static void  attemptToEditAFinanceCaseWithMismatchedSaleOrderAndAccountHierarchyNegativeEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__FinanceCase__c financeCase1 = FinanceCaseDataHelper.createFinanceCase(
            customer,
            branch,
            financer,
            scheme,
            null,
            null,
            null,
            null,
            null,
            null,
            null
        );
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase1.Id);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
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