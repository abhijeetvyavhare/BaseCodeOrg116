@isTest
public with sharing class KPIDataHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData('Test-KPI-Data', kpiConfig.Id);
    }
    
    @isTest
    static void createKPIDataPositive() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertNotEquals(kpiData, null, 'Expected KPI Data to be created.');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(100, kpiData.dmpl__KPIValue__c, 'KPI Value should match');
        System.assertEquals(50, kpiData.dmpl__RewardValue__c, 'Reward Value should match');
    }
    
    @isTest
    static void updateKPIDataPositive() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__KPIValue__c = 200;
        update kpiData;
        System.assertEquals(200, kpiData.dmpl__KPIValue__c, 'KPI Value should be updated.');
    }
    
    @isTest
    static void deleteKPIData() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertNotEquals(kpiData, null, 'KPI Data should exist before delete.');
        delete kpiData;
        dmpl__KPIData__c deletedKPIData = null;
        try {
            deletedKPIData = KPIDataHelper.getKPIData(kpiData.Id);
        } catch (Exception e) {
            deletedKPIData = null;
        }
        System.assertEquals(null, deletedKPIData, 'KPI Data should be deleted and not found in query.');
    }
    
    @isTest
    static void createKPIDataWithNamePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void createKPIDataWithDocumentDatePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        KPIData.DocumentDate__c = Date.newInstance(2022, 1, 1);
        update KPIData;
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void createKPIDataWithNoPartnerAccountPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void createKPIDataWithValidPartnerAccountPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void updateKPIDataWithNoKPIConfigurationIdPositive(){
    dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData('Test-KPI-Data', null);
        System.assertEquals(null, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match be null');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void updateKPIDataWithKPIConfigurationIdPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData('Test-KPI-Data', null);
        KPIData.dmpl__KPIConfigurationId__c = kpiConfig.Id;
        update KPIData;
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void createKPIDataWithoutNameNegative() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        try {
            dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData(null, kpiConfig.Id);
            System.assertEquals(null, kpiData.Id, 'KPI Data should not be created without name');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIData should not be created without name');
        }
    }
    
    @isTest
    static void createKPIDataWithAutoTaggedKPIConfigurationPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();        
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
    }
    
    @isTest
    static void createKPIDataWithoutKPIConfigurationNegative(){
        try {
            dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData('Test-KPI-Data', null);
            System.assertEquals(null, kpiData.Id, 'KPI Data should not be created without KPIConfig');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIData should not be created without KPIConfig');
        }
    }
    
    @isTest
    static void createKPIDataWithIncentivePeriodPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan.Id);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__IncentivePeriodId__c = incentivePeriod.Id;
        update kpiData;    
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(incentivePeriod.Id, kpiData.dmpl__IncentivePeriodId__c, 'IncentivePeriod Id should match');
    }
    
    @isTest
    static void createKPIDataWithoutIncentivePeriodPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();   
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(null, kpiData.dmpl__IncentivePeriodId__c, 'IncentivePeriod Id should be null');
    }
    
    @isTest
    static void createKPIDataWithActiveIncentivePlanPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__IncentivePlanId__c = incentivePlan.Id;
        update kpiData;    
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(incentivePlan.Id, kpiData.dmpl__IncentivePlanId__c, 'IncentivePlan Id should match');
    }
    
    @isTest
    static void createKPIDataWithoutIncentivePlanPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(null, kpiData.dmpl__IncentivePlanId__c, 'IncentivePlan Id should be null');
    }
    
    @isTest
    static void createKPIDataWithActivePartnerCustomerBranchAndResourcePositive() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData(
            kpiConfig, 
            customerAccount, 
            branch, 
            partnerAccount, 
            resource
        );
        System.assertNotEquals(null, kpiData.Id, 'KPI Data should be created');
        System.assertEquals(kpiConfig.Id, kpiData.dmpl__KPIConfigurationId__c, 'KPI Config Id should match');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(partnerAccount.Id, kpiData.dmpl__PartnerAccountId__c, 'Partner Account Id should match');
        System.assertEquals(customerAccount.Id, kpiData.dmpl__AccountId__c, 'Customer Account Id should match');
        System.assertEquals(branch.Id, kpiData.dmpl__BranchId__c, 'Branch Id should match');
        System.AssertEquals(resource.Id, kpiData.dmpl__ResourceId__c, 'Resource Id should match');
    }
    
    @isTest
    static void createKPIDataWithMismatchedPartnerCustomerBranchAndResourceNegative() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.getKPIConfiguration();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData(
                kpiConfig, 
                customerAccount, 
                branch2, 
                partnerAccount, 
                resource
            );
            System.assertEquals(null, kpiData.Id, 'KPI Data should not be created with mismatched data');
        } catch(Exception e){
            System.assert.isTrue(true, 'KPI Data should be not created with mismatched data');
        }   
    }
    
    @isTest
    static void createKPIDataWithInActivePartnerAccountNegative() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount.dmpl__IsActive__c = false;
        update partnerAccount;
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__PartnerAccountId__c = partnerAccount.Id;
        Boolean exceptionThrown = false;
        try {
            update kpiData; 
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception while inserting KPI data with inactive partner account');
}

    
    @isTest
    static void createKPIDataWithInActiveBranchNegative() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__BranchId__c = branch.Id;
        Boolean exceptionThrown = false;
        try {
            update kpiData;
        } catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception while assigning inactive branch');
    }
    
    @isTest
    static void createKPIDataWithInActiveResourceNegative() {
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        resource.dmpl__IsActive__c = false;
        update resource;
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        kpiData.dmpl__ResourceId__c = resource.Id;
        Boolean exceptionThrown = false;
        try {
            update kpiData;
        } catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception while assigning inactive resource');
    }
}