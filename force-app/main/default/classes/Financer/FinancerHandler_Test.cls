@isTest
public with sharing class FinancerHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
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
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, partnerAccount.ID, accGroup.Id);
        dmpl__FinanceCase__c financeCase = FinancerDataHelper.createFinanceCase(customerAccount, branch, saleOrder, saleInvoice, financer, scheme);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        
    }
    
    @isTest
    static void createFinanceCasePositive() {
        Test.startTest();
        dmpl__FinanceCase__c financeCase = FinancerDataHelper.getFinanceCase();
        Test.stopTest();
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be inserted');
        System.assertEquals('Draft', financeCase.dmpl__Status__c, 'Finance case should default to Draft');
    }
    
    @isTest
    static void updateFinanceCasePositive() {
        dmpl__FinanceCase__c fc = FinancerDataHelper.getFinanceCase();
        fc.dmpl__RequestedAmount__c = 12000;
        update fc;
        dmpl__FinanceCase__c updated = FinancerDataHelper.getFinanceCase(fc.Id);
        System.assertEquals(12000, updated.dmpl__RequestedAmount__c, 'Requested amount should update');
    }
    
    @isTest
    static void deleteFinanceCase() {
        dmpl__FinanceCase__c fc = FinancerDataHelper.getFinanceCase();
        Id financeCaseId = fc.Id;
        delete fc;
        
        try {
            dmpl__FinanceCase__c deletedCase = FinancerDataHelper.getFinanceCase(financeCaseId);
            System.assert(false, 'Expected Finance Case to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Finance Case successfully deleted.');
        }
    }
    
    @isTest
    static void createFinancerPositive() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        System.assertNotEquals(f1, null, 'Expected financer to be created.');
    }
    
    @isTest
    static void updateFinancerPositive() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        f1.Name = 'updated-financer';
        update f1;
        dmpl__Financer__c updated = FinancerDataHelper.getFinancer(f1.Id);
        System.assertEquals('updated-financer', updated.Name, 'Expected financer name to be updated.');
    }
    
    @isTest
    static void deleteFinancer() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        Id financerId = f1.Id;
        delete f1;
        
        try {
            dmpl__Financer__c deleted = FinancerDataHelper.getFinancer(financerId);
            System.assert(false, 'Expected Financer to be deleted, but record still exists.');
        } catch (QueryException ex) {
            System.assert(true, 'Financer successfully deleted.');
        }
    }
    
    @isTest
    static void createFinancerSchemePositive() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        System.assert(fs != null, 'Financer Scheme should be retrieved');
        System.assert(fs.Id != null, 'Financer Scheme should be inserted');
    }
    
    @isTest
    static void updateFinancerSchemePositive() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        fs.Name = 'Updated Scheme Name';
        update fs;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(fs.Id);
        System.assertEquals('Updated Scheme Name', updated.Name);
    }
    
    @isTest
    static void deleteFinancerScheme() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        Id schemeId = fs.Id;
        delete fs;
        try {
            dmpl__FinancerScheme__c deleted = FinancerDataHelper.getFinancerScheme(schemeId);
            System.assert(false, 'Expected Financer Scheme to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Financer Scheme successfully deleted.');
        }
    }
    
    @isTest
    public static void createNewFinancerByEnteringValidFinancerNameAccountAndBranchPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(
            customerAccount.Id,
        'HDFC',
        null
            );
        
        financer = FinancerDataHelper.getFinancer(financer.Id);
        
        System.assertNotEquals(null, financer, 'Financer should be created successfully');
        System.assertEquals('HDFC', financer.Name, 'Financer name should match');
        System.assertEquals(customerAccount.Id, financer.dmpl__AccountId__c, 'Customer Account should match');
        
    }
    
    @isTest
    public static void addValidAddressWhileCreatingAFinancerPositiveNew(){
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(
            customerAccount.Id,
        'HDFC',
        'Ring Rd Pune Maharashtra Customer 1 Billing Address 440001'
            );
        
        financer = FinancerDataHelper.getFinancer(financer.Id);
        
        System.assertNotEquals(null, financer, 'Financer should be created successfully');
        System.assertEquals('HDFC', financer.Name, 'Financer name should match');
        System.assertEquals(customerAccount.Id, financer.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals('Ring Rd Pune Maharashtra Customer 1 Billing Address 440001', financer.dmpl__Address__c, 'Address should match');
        
        Test.stopTest();
    }
    
    @isTest
    public static void removeAccountFieldFromAnExistingFinancerAndTryToSaveNegativeEdit(){
        
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        financer.dmpl__AccountId__c = null;
        Boolean exceptionThrown = false;
        try {
            update financer;
            System.assert(false, 'Expected exception when removing mandatory Account field, but update succeeded.');
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when mandatory Account field is removed');
        Test.stopTest();
        
    }
    
    @isTest
    public static void enterAddressLongerThanFieldLimitNegativeEdit() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(
            customerAccount.Id,
        'HDFC',
        'Ring Rd Pune Maharashtra Customer 1 Billing Address 440001'
            );
        financer = FinancerDataHelper.getFinancer();
        String longAddress = String.valueOf('A').repeat(256);
        
        Boolean exceptionThrown = false;
        try {
            financer.dmpl__Address__c = longAddress;
            update financer;
            System.assert(false, 'Expected exception for address longer than 255 characters, but update succeeded.');
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for address longer than 255 characters');
        Test.stopTest();
    }
    
    @isTest
    public static void editFinancerAndLinkAnInvalidAccountIDNegativeEdit(){
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(
            customerAccount.Id,
        'HDFC',
        'Mission Rd  Bengaluru  India  560027 Indiranagar  Bengaluru'
            );
        financer = FinancerDataHelper.getFinancer();
        
        
        Boolean exceptionThrown = false;
        try {
            financer.dmpl__AccountId__c = '001000000000000AAA';
            update financer;
            System.assert(false, 'Expected exception for invalid Account ID, but update succeeded.');
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for invalid Account ID');
        Test.stopTest();
    }
    
    @isTest
    public static void createNewSchemeWithValidFinancerNameTenureAndInterestRatePositiveNew(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer,'HDFC',500,10,6,6,partnerAccount.id,null);
        
        
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertNotEquals(null, scheme, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', scheme.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, scheme.dmpl__FinancerId__c, 'Financer ID should match');
        System.assertEquals(500, scheme.dmpl__MinimumAmount__c, 'Minimum Amount should match');
        System.assertEquals(10, scheme.dmpl__MaximumTenure__c, 'MaximumTeure should match');
        System.assertEquals(6, scheme.dmpl__InterestRate__c, 'Interest Rate should match');
        System.assertEquals(6, scheme.dmpl__MinimumTenure__c, 'Minimum Tenure should match');
        Test.stopTest();
    }
    
    @isTest
    public static void attemptToCreateSchemeWithoutSelectingAnApplicablePartnerAccountNegativeNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        
        Boolean exceptionThrown = false;
        try {
            dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, 'HDFC', 500, 10000, 6, 6,null,null);
            System.assert(false, 'Expected exception for missing Applicable Partner Account');
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.AssertEquals(true, exceptionThrown, 'Expected exception for missing Applicable Partner Account');
        Test.stopTest();
    }
    
    @isTest
    public static void LinkSchemeToValidPartnerAccountGroupForGroupWideApplicabilityPositiveNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, 'HDFC', 500, 10, 6, 6,partnerAccount.id,accGroup.Id);
        
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertNotEquals(null, scheme, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', scheme.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, scheme.dmpl__FinancerId__c, 'Financer ID should match');
        System.assertEquals(accGroup.Id, scheme.dmpl__ApplicableToPartnerAccountGroupId__c, 'Applicable Partner Account Group ID should match');
        Test.stopTest();
    }
    
    @isTest
    public static void EditSchemeToUpdateTheInterestRateDueToRevisedPolicyPositiveEdit(){
        
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
            financer, 'HDFC', 500, 10, 6, 6,partnerAccount.id,null
            );
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        
        scheme.dmpl__InterestRate__c = 7.5;
        update scheme;
        
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals(7.5, updated.dmpl__InterestRate__c, 'Interest Rate should be updated as per revised policy');
        Test.stopTest();
        
    }
    
    @isTest
    public static void leaveTheExternalIDFieldBlankIfRequiredAsUniqueIdentifierNeagtiveNew(){
        
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        Boolean exceptionThrown = false;
        try {
            dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerSchemeCustomize(
                financer, 'HDFC', 500,10, 6, 6,partnerAccount.id,null
                );
            
            System.Assert(false, 'Expected exception for blank External ID field');
        }
        catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.AssertEquals(true, exceptionThrown, 'Exception should be thrown for blank External ID field');
        
        Test.stopTest();
    }
    
    @isTest
    public static void updateTheFeaturesFieldToDescribeBenefitsOfTheSchemePositiveEdit(){
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
            financer, 'HDFC', 500, 10, 6, 6,partnerAccount.id,null
            );
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        
        scheme.dmpl__Features__c = 'Plan is to have good return to investment';
        update scheme;
        
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals('Plan is to have good return to investment', updated.dmpl__Features__c, 'Features should be updated to describe scheme benefits');
        Test.stopTest();
    }
    
    @isTest
    public static void addDetailedDescriptionForSchemeWithDifferentFinancingOptionsPositiveEdit() {
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
            financer, 'HDFC', 500, 10, 6, 2,partnerAccount.id,null
            );
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        
        scheme.dmpl__Description__c = 'This scheme offers multiple financing options including fixed and floating rates, flexible tenure, and special offers for select partners.';
        update scheme;
        
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals(
            'This scheme offers multiple financing options including fixed and floating rates, flexible tenure, and special offers for select partners.',
        updated.dmpl__Description__c,
        'Description should be updated with detailed financing options'
            );
        Test.stopTest();
    }
    
    @isTest
    public static void TryLinkingTheSchemeToDeletedOrInactiveFinancerRecordNegativeNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        
        List<dmpl__FinanceCase__c> cases = [SELECT Id FROM dmpl__FinanceCase__c WHERE dmpl__FinanceProviderId__c = :financer.Id];
        if (!cases.isEmpty()) {
            delete cases;
        }
        delete financer;
        
        Boolean exceptionThrown = false;
        
        try{
            dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
                financer,
            'Plane 1',
            12,
            6,
            6,
            2,
            partnerAccount.id,
            null
                );
            System.assert(false, 'Expected exception for linking scheme to deleted financer');
        }
        
        catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for linking scheme to deleted financer');
        Test.stopTest();
        
        
    }
    
}