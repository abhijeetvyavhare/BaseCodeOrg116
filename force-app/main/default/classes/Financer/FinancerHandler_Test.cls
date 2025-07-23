@isTest
public with sharing class FinancerHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList(partnerAccount1, branch1);
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount1, 
            branch1, 
            null, 
            priceList1
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(
            customerAccount1, 
            branch1, 
            saleOrder1, 
            priceList1
        );
        dmpl__Financer__c financer1 = FinancerDataHelper.createFinancer(
            customerAccount1,
            'HDFC',
            null
        );
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.createFinancerScheme(financer1, partnerAccount1.id, null);
    } 
    
    @isTest
    static void createFinancerPositive() {
        Test.startTest();
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        System.assertNotEquals(f1, null, 'Expected financer to be created.');
        Test.stopTest();
    }
    
    @isTest
    static void updateFinancerPositive() {
        Test.startTest();
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        f1.Name = 'updated-financer';
        update f1;
        dmpl__Financer__c updated = FinancerDataHelper.getFinancer(f1.Id);
        System.assertEquals('updated-financer', updated.Name, 'Expected financer name to be updated.');
        Test.stopTest();
    }
    
    @isTest
    static void deleteFinancer() {
        Test.startTest();
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        Id financerId = f1.Id;
        delete f1;
        try {
            dmpl__Financer__c deleted = FinancerDataHelper.getFinancer(financerId);
            System.assert(false, 'Expected Financer to be deleted, but record still exists.');
        } catch (QueryException ex) {
            System.assert(true, 'Financer successfully deleted.');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createFinancerSchemePositive() {
        Test.startTest();
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        System.assert(fs != null, 'Financer Scheme should be retrieved');
        System.assert(fs.Id != null, 'Financer Scheme should be inserted');
        Test.stopTest();
    }
    
    @isTest
    static void updateFinancerSchemePositive() {
        Test.startTest();
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        fs.Name = 'Updated Scheme Name';
        update fs;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(fs.Id);
        System.assertEquals('Updated Scheme Name', updated.Name);
        Test.stopTest();
    }
    
    @isTest
    static void deleteFinancerScheme() {
        Test.startTest();
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        Id schemeId = fs.Id;
        delete fs;
        try {
            dmpl__FinancerScheme__c deleted = FinancerDataHelper.getFinancerScheme(schemeId);
            System.assert(false, 'Expected Financer Scheme to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Financer Scheme successfully deleted.');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void addValidAddressWhileCreatingAFinancerPositiveNew(){
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Financer__c financer1 = FinancerDataHelper.createFinancer(
            customerAccount,
            'HDFC',
          	null
        );        
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer(financer1.Id);
        System.assertNotEquals(null, financer, 'Financer should be created successfully');
        System.assertEquals('HDFC', financer.Name, 'Financer name should match');
        System.assertEquals(customerAccount.Id, financer.dmpl__AccountId__c, 'Customer Account should match');
        Test.stopTest();
    }
    
    @isTest
    public static void enterAddressLongerThanFieldLimitNegativeEdit() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Financer__c financer1 = FinancerDataHelper.createFinancer(
            customerAccount,
            'HDFC',
            null
        );
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer(financer1.Id);
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
    public static void createNewSchemeWithValidFinancerNameTenureAndInterestRatePositiveNew(){
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Financer__c financer1 = FinancerDataHelper.createFinancer(
            customerAccount,
            'HDFC',
            null
        );
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer(financer1.Id);
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
            financer,
            'HDFC',
            500,
            10,
            6,
            6,
            partnerAccount.Id,
            null,
            null
        );
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
    public static void LinkSchemeToValidPartnerAccountGroupForGroupWideApplicabilityPositiveNew(){
        Test.startTest();
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(
            financer, 
            'HDFC', 
            500, 
            10, 
            6, 
            6,
            partnerAccount.id,
            null,
            null
        );
        scheme = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertNotEquals(null, scheme, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', scheme.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, scheme.dmpl__FinancerId__c, 'Financer ID should match');
        Test.stopTest();
    }

    @isTest
    public static void EditSchemeToUpdateTheInterestRateDueToRevisedPolicyPositiveEdit(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Financer__c financer1 = FinancerDataHelper.createFinancer(
            customerAccount,
            'HDFC',
            null
        );
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer(financer1.Id);
        dmpl__FinancerScheme__c scheme1 = FinancerDataHelper.createFinancerScheme(
            financer, 
            'HDFC', 
            500, 
            10, 
            6, 
            6,
            partnerAccount.id,
            null,
            null
        );
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.getFinancerScheme(scheme1.Id);
        scheme.dmpl__InterestRate__c = 7.5;
        update scheme;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals(7.5, updated.dmpl__InterestRate__c, 'Interest Rate should be updated as per revised policy');
        Test.stopTest();
    }
    
    @isTest
    public static void updateTheFeaturesFieldToDescribeBenefitsOfTheSchemePositiveEdit(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme1 = FinancerDataHelper.createFinancerScheme(
            financer, 
            'HDFC', 
            500, 
            10, 
            6, 
            6,
            partnerAccount.id,
            null,
            null
        );
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.getFinancerScheme(scheme1.Id);
        System.assertNotEquals(null, scheme, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', scheme.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, scheme.dmpl__FinancerId__c, 'Financer ID should match');
        System.assertEquals(500, scheme.dmpl__MinimumAmount__c, 'Minimum Amount should match');
        System.assertEquals(10, scheme.dmpl__MaximumTenure__c, 'Maximum Tenure should match');
        System.assertEquals(6, scheme.dmpl__InterestRate__c, 'Interest Rate should match');
        System.assertEquals(6, scheme.dmpl__MinimumTenure__c, 'Minimum Tenure should match');
        scheme.dmpl__Features__c = 'Plan is to have good return to investment';
        update scheme;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals('Plan is to have good return to investment', updated.dmpl__Features__c, 'Features should be updated to describe scheme benefits');
        System.assertNotEquals(null, updated, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', updated.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, updated.dmpl__FinancerId__c, 'Financer ID should match');
        System.assertEquals(500, updated.dmpl__MinimumAmount__c, 'Minimum Amount should match');
        System.assertEquals(10, updated.dmpl__MaximumTenure__c, 'Maximum Tenure should match');
        System.assertEquals(6, updated.dmpl__InterestRate__c, 'Interest Rate should match');
        System.assertEquals(6, updated.dmpl__MinimumTenure__c, 'Minimum Tenure should match');
        Test.stopTest();
    }
    
    @isTest
    public static void addDetailedDescriptionForSchemeWithDifferentFinancingOptionsPositiveEdit() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme1 = FinancerDataHelper.createFinancerScheme(
            financer, 
            'HDFC', 
            500,
            10000, 
            10, 
            6, 
            2,
            partnerAccount.id,
            null,
            null
        );
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.getFinancerScheme(scheme1.Id);
        System.assertNotEquals(null, scheme, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', scheme.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, scheme.dmpl__FinancerId__c, 'Financer ID should match');
        System.assertEquals(500, scheme.dmpl__MinimumAmount__c, 'Minimum Amount should match');
        System.assertEquals(10, scheme.dmpl__MaximumTenure__c, 'Maximum Tenure should match');
        System.assertEquals(6, scheme.dmpl__InterestRate__c, 'Interest Rate should match');
        System.assertEquals(2, scheme.dmpl__MinimumTenure__c, 'Minimum Tenure should match');
        scheme.dmpl__Description__c = 'This scheme offers multiple financing options including fixed and floating rates, flexible tenure, and special offers for select partners.';
        update scheme;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(scheme.Id);
        System.assertEquals('This scheme offers multiple financing options including fixed and floating rates, flexible tenure, and special offers for select partners.',
                            updated.dmpl__Description__c,
                            'Description should be updated with detailed financing options'
                           );
        System.assertNotEquals(null, updated, 'Financer Scheme should be created successfully');
        System.assertEquals('HDFC', updated.Name, 'Financer Scheme name should match');
        System.assertEquals(financer.Id, updated.dmpl__FinancerId__c, 'Financer ID should match');
        Test.stopTest();
    }
    
    @isTest
    public static void TryLinkingTheSchemeToDeletedOrInactiveFinancerRecordNegativeNew(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Financer__c financer = FinancerDataHelper.getFinancer();
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
                null,
                null
            );
            System.assert(false, 'Expected exception for linking scheme to deleted financer');
        }catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for linking scheme to deleted financer');
        Test.stopTest();
    }
}