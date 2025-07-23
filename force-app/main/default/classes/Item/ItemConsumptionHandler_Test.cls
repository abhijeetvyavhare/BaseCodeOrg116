@isTest
private class ItemConsumptionHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
        dmpl__ResourceGroup__c resourceGroup = ResourceGroupDataHelper.createResourceGroup();
        dmpl__ResourceGroupRule__c resourceGroupRule = ResourceGroupDataHelper.createResourceGroupRule(resourceGroup);
        dmpl__ResourceGroupMember__c resourceGroupMember = ResourceGroupDataHelper.createResourceGroupMember(resource, resourceGroup);
        dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.createItemConsumptionSchedule('Schedule-1', item.Id);
    }

    @isTest
    static void createItemConsumptionRateWithNamePositive() {
        Test.startTest();
        dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
        dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.createItemConsumptionRate('Rate-1', schedule);
        System.assertEquals('Rate-1', rate.Name, 'Rate name should be Rate-1');
        System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule link should be correct');
        Test.stopTest();
    }

    @isTest
    static void createItemConsumptionRateWithConsumptionSchedulePositive() {
        Test.startTest();
        dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
        dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.createItemConsumptionRate('Rate-1', schedule);
        System.assertNotEquals(null, rate.Id, 'Item Consumption Rate should be inserted');
        System.assertEquals('Rate-1', rate.Name, 'Rate Name should match');
        System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
        Test.stopTest();
    }

    @isTest
    static void createItemConsumptionRateWithPricingMethodPositive() {
        Test.startTest();
        dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
        dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.createItemConsumptionRate('Rate-1', schedule);
        rate.dmpl__PricingMethod__c = 'Per Unit';
        update rate;
        System.assertNotEquals(null, rate.Id, 'Item Consumption Rate should be created');
        System.assertEquals('Rate-1', rate.Name, 'Rate Name should match');
        System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
        System.assertEquals('Per Unit', rate.dmpl__PricingMethod__c, 'Pricing Method should be set correctly');
        Test.stopTest();
    }

    @isTest
    static void createItemConsumptionRateWithoutPricingMethodPositive() {
        Test.startTest();
        dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
        dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.createItemConsumptionRate('Rate-1', schedule);
        System.assertNotEquals(null, rate.Id, 'Item Consumption Rate should be created');
        System.assertEquals('Rate-1', rate.Name, 'Rate Name should match');
        System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
        System.assertEquals(null, rate.dmpl__PricingMethod__c, 'Pricing Method should be blank');
        Test.stopTest();
    }
}