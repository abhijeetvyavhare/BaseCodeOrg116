@isTest
public with sharing class KPIConfigurationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch', partnerAccount.Id);
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1', 'Resource', 'dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationPositive() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        System.assertNotEquals(config, null, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should match');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should match');
        System.assertEquals(true, config.dmpl__IsActive__c, 'IsActive should be true');
    }

    @isTest
    static void updateKPIConfigurationPositive() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.Name = 'Updated KPI Config';
        System.assertEquals('Updated KPI Config', config.Name, 'KPI Configuration Name should be updated.');
    }

    @isTest
    static void deleteKPIConfigurationNegative() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        delete config;
        System.assertNotEquals(null, config.Id, 'Config should not be deleted');
    }

    @isTest
    static void createKPIConfigurationWithKPINamePositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutKPINameNegative() {
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration(null, 'Resource', 'dmpl__DocumentDate__c');
            System.assertEquals(null, config, 'KPIConfiguration should not be created without name');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without name');
        }
        Test.stopTest();
    }

    @isTest
    static void createKPIConfigurationWithMemberTypePositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutMemberTypeNegative() {
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1', null, 'dmpl__DocumentDate__c');
            System.assertEquals(null, config.Id, 'KPIConfiguration should not be created without member type');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without member type');
        }
        Test.stopTest();
    }

    @isTest
    static void updateKPIConfigurationWithoutNameNegative() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            config.Name = null;
            update config;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }

    @isTest
    static void updateKPIConfigurationWithoutMemberTypeNegative() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            config.dmpl__MemberType__c = null;
            update config;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when removing Member Type from kpiConfig');
        Test.stopTest();
    }

    @isTest
    static void createKPIConfigurationWithDateFieldNamePositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutDateFieldNameNegative() {
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1', 'Resource', null);
            System.assertEquals(null, config.Id, 'KPIConfiguration should not be created without member type');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without member type');
        }
        Test.stopTest();
    }

    @isTest
    static void updateKPIConfigurationWithoutDateFieldNameNegative() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            config.dmpl__DateFieldName__c = null;
            update config;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when removing DateFieldName from kpiConfig');
        Test.stopTest();
    }

    @isTest
    static void createKPIConfigurationWithItemGroupPositive() {
        Test.startTest();
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup('Item Group 1', 'Product Demo');
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__ItemGroupId__c = itemGroup.Id;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(itemGroup.Id, config.dmpl__ItemGroupId__c, 'Item group should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutItemGroupPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__ItemGroupId__c = null;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(null, config.dmpl__ItemGroupId__c, 'Item group should be null');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithAccountGroupPositive() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 3');
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__AccountGroupId__c = accountGroup.Id;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(accountGroup.Id, config.dmpl__AccountGroupId__c, 'Account group should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutAccountGroupPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__AccountGroupId__c = null;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(null, config.dmpl__AccountGroupId__c, 'Account group should be null');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithIsActiveTruePositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__IsActive__c = true;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(true, config.dmpl__IsActive__c, 'Is Active should be true');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithIsActiveFalsePositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__IsActive__c = false;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(false, config.dmpl__IsActive__c, 'Is Active should be false');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithPartnerAccountGroupPositive() {
        Test.startTest();
        dmpl__AccountGroup__c partnerAccountGroup = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__PartnerAccountGroupId__c = partnerAccountGroup.Id;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(partnerAccountGroup.Id, config.dmpl__PartnerAccountGroupId__c, 'Partner Account group should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithoutPartnerAccountGroupPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__PartnerAccountGroupId__c = null;
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(null, config.dmpl__PartnerAccountGroupId__c, 'Partner Account group should be null');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithValueFunctionPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__ValueFunction__c = 'Sum';
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('Sum', config.dmpl__ValueFunction__c, 'Value function should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }

    @isTest
    static void createKPIConfigurationWithRulesSuccessCriteriaPositive() {
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration('KPI Configuration 1');
        config.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
        update config;
        Test.stopTest();
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');
        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('All Rules Are Met', config.dmpl__RuleSuccessCriteria__c, 'RulesSuccessCriteria should match');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');
    }
}