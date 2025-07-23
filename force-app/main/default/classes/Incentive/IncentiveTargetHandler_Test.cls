@isTest
public with sharing class IncentiveTargetHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__IncentivePlan__c incentivePlan = IncentiveTargetDataHelper.createIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentiveTargetDataHelper.createIncentivePeriod(incentivePlan.Id);
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1', 'Resource', 'dmpl__DocumentDate__c');
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, kpiConfig, item);
        dmpl__IncentiveResource__c incentiveResource = IncentiveTargetDataHelper.createIncentiveResource(incentivePlan.Id);
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(target, kpiConfig, incentiveResource);
    }

    @isTest
    static void createIncentiveTargetPositive() {
        Test.startTest();
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(target, null, 'Expected Incentive Target to be created.');
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentiveTargetPositive() {
        Test.startTest();
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        target.dmpl__Value__c = 150;
        update target;
        System.assertEquals(150, target.dmpl__Value__c, 'Value should be updated.');
        Test.stopTest();
    }
    
    @isTest
    static void deleteIncentiveTargetNegative() {
        Test.startTest();
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        delete target;
        System.assertNotEquals(null, target, 'IncentiveTarget Should not be deleted');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceTargetPositive() {
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        System.assertNotEquals(incentiveResourceTarget, null, 'Expected Incentive Resource Target to be created.');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should match');
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentiveResourceTargetPositive() {
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        incentiveResourceTarget.dmpl__Value__c = 150;
        update incentiveResourceTarget;
        System.assertEquals(150, incentiveResourceTarget.dmpl__Value__c, 'Value should be updated.');
        Test.stopTest();
    }
    
    @isTest
    static void deleteIncentiveResourceTarget() {
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        delete incentiveResourceTarget;
        System.assertNotEquals(null, incentiveResourceTarget.Id, 'IncentiveTarget Should not be deleted');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveTargetNormalPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createIncentiveTargetWithValuePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(4000, incentiveTarget.dmpl__Value__c, 'value should be 4000');
    }
    
    @isTest
    static void createIncentiveTargetWithoutValuePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__Value__c = null;
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(null, incentiveTarget.dmpl__Value__c, 'value should be null');
    }
    
    @isTest
    static void updateIncentiveTargetWithoutValuePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(4000, incentiveTarget.dmpl__Value__c, 'value should be 4000');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveTarget.dmpl__Value__c = null;
            update incentiveTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing value from incentiveTarget');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveTargetWithActiveItemPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createIncentiveTargetWithInactiveItemNegative() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        Test.startTest();
        try {      
            dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, kpiConfig, item2);
            System.assertEquals(null, incentiveTarget, 'IncentiveTarget should not be created with inactive item');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveTarget should not be created with inactive item');
        }
        Test.stopTest();        
    }

    @isTest
    static void createIncentiveTargetWithoutItemPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, kpiConfig, null);
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(null, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createIncentiveTargetWithRequiredSKUPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item8 = TestDataHelpers.createItem('Item 8', 'Product');
        item8.dmpl__IsSKURequired__c = true;
        update item8;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.Id, false);
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(
            incentivePlan, 
            kpiConfig, 
            item8, 
            null, 
            sku2
        );
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item8.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku2.Id, incentiveTarget.dmpl__SKUId__c, 'sku ID should match');
    }
    
    @isTest
    static void createIncentiveTargetWithNoRequiredSKUPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void createIncentiveTargetWithoutSKUPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void updateIncentiveTargetWithNoRequiredSKUPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8', 'Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.Id, false);
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(
            incentivePlan, 
            kpiConfig, 
            item, 
            null, 
            sku2
        );
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku2.Id, incentiveTarget.dmpl__SKUId__c, 'sku ID should match');
        Boolean exceptionThrown = false;
        try {
            incentiveTarget.dmpl__ItemId__c = item.Id;
            incentiveTarget.dmpl__SKUId__c = null;
            update incentiveTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing no required sku');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveTargetWithDiscontinuedItemPositive() {
       dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4', 'Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, kpiConfig, item);
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');  
    }
    
    @isTest
    static void createIncentiveTargetWithActiveKPIConfigurationPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createIncentiveTargetWithInactiveKPIConfigurationPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        kpiConfig.dmpl__IsActive__c = false;
        update kpiConfig;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {      
            dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, kpiConfig, item);
            System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveTarget should be created with inactive kpi');
        }
        Test.stopTest(); 
    }

    @isTest
    static void createIncentiveTargetWithoutKPIConfigurationPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan, null, item);
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void updateIncentiveTargetWithInactiveKPIConfigurationNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig11 = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__KPIConfiguration__c kpiConfig12 = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        kpiConfig12.dmpl__IsActive__c = false;
        update kpiConfig12;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');   
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig11.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveTarget.dmpl__KPIConfigurationId__c = kpiConfig12.Id;
            update incentiveTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentiveTargetWithoutIncentivePlanNegative() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {
            dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
            incentiveTarget.dmpl__IncentivePlanId__c = null;
            update incentiveTarget;
        } catch(Exception e) {
            System.Assert.isTrue(true, 'IncentiveTarget should not be created without IncentivePlan');  
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentiveTargetWithoutIncentivePlanNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');   
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveTarget.dmpl__IncentivePlanId__c = null;
            update incentiveTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert.isTrue(true, 'IncentiveTarget should not be updated without IncentivePlan');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveTargetWithDefiningTargettypePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__IncentiveTargetType__c = 'No Of Purchase Orders';
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('No Of Purchase Orders', incentiveTarget.dmpl__IncentiveTargetType__c, 'Incentive Target Type should match');
    }

    @isTest
    static void createIncentiveTargetWithoutDefiningTargettypePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__IncentiveTargetType__c = null;
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(null, incentiveTarget.dmpl__IncentiveTargetType__c, 'Incentive Target Type should match');
    }

    @isTest
    static void createIncentiveTargetWithoutItemGroupPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__ItemGroupId__c = null;
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(null, incentiveTarget.dmpl__ItemGroupId__c, 'ItemGroupID should match');
    }

    @isTest
    static void createIncentiveTargetWithAccountPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__AccountId__c = customer.Id;
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(customer.Id, incentiveTarget.dmpl__AccountId__c, 'Account ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void createIncentiveTargetWithoutAccountPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        incentiveTarget.dmpl__AccountId__c = null;
        update incentiveTarget;
        Test.stopTest();
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveTarget.dmpl__AccountId__c, 'Account ID should match');
        System.assertEquals(item.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }
    
    @isTest
    static void createIncentiveResouceTargetWithIncentiveTargetPositive() {
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    }
    
    @isTest
    static void createIncentiveResouceTargetWithoutIncentiveTargetNegative() {
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');      
        Test.startTest();
        try {      
            dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(null, kpiConfig, null);
            System.assertEquals(null, incentiveResourceTarget.Id, 'incentiveResourceTarget should not be created without incentiveTarget ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResourceTarget should not be created without incentiveTarget');
        }
        Test.stopTest(); 
    } 

    @isTest
    static void updateIncentiveResouceTargetWithoutIncentiveTargetNegative() {  
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveResourceTarget.dmpl__IncentiveTargetId__c = null;
            update incentiveResourceTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when Incentive Target is not attached');
        Test.stopTest();
    } 

    @isTest
    static void createIncentiveResouceTargetWithDefiningValuePositive() {
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    } 

    @isTest
    static void createIncentiveResouceTargetWithoutDefiningValueNegative() {
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.startTest();
        try {      
            dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(
                incentiveTarget.Id, 
                null, 
                null, 
                kpiConfig.Id, 
                null
            );
            System.assertEquals(null, incentiveResourceTarget.Id, 'IncentiveResourceTarget should not be created without value');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveResourceTarget should not be created without value');
        }
        Test.stopTest(); 
    } 

    @isTest
    static void updateIncentiveResouceTargetWithoutDefiningValueNegative() {    
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');  
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveResourceTarget.dmpl__Value__c = null;
            update incentiveResourceTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResouceTargetWithIncentiveResourceNamePositive() {
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentiveResource__c incentiveResource = IncentiveTargetDataHelper.getIncentiveResource();
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        Test.stopTest();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(incentiveResource.Id, incentiveResourceTarget.dmpl__IncentiveResourceId__c, 'IncentiveResource ID should match');
    } 
    
    @isTest
    static void createIncentiveResouceTargetWithoutIncentiveResourceNamePositive() {
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget, kpiConfig, null);
        Test.stopTest();
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    }
    
    @isTest
    static void updateIncentiveResouceTargetWithoutIncentiveResourceNamePositive() { 
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveResource__c incentiveResource = IncentiveTargetDataHelper.createIncentiveResource(incentivePlan.Id);
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget, kpiConfig, incentiveResource);     
        System.assertNotEquals(null, incentiveResourceTarget, 'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(incentiveResource.Id, incentiveResourceTarget.dmpl__IncentiveResourceId__c, 'IncentiveResource ID should match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveResourceTarget.dmpl__IncentiveResourceId__c = null;
            update incentiveResourceTarget;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when Incentive Resource Name is removed');
        Test.stopTest();
    }
}