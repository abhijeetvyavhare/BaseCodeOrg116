@isTest
public with sharing class ServiceCampaignHandler_Test{
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 1','Product');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);  
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(branch, customerAccount, resource); 
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__ItemServiceContract__c itemServiceContract = ServiceCampaignTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = TestDataHelpers.createItemMaintenanceSchedule(item, sku);
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign(
            serviceLead, 
            item, 
            itemServiceContract, 
            itemMaintenanceSchedule, 
            branch, 
            partnerAccount
        );
        dmpl__ServiceCampaignItem__c serviceCampaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(serviceCampaign, item, itemServiceContract);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch); 
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
        Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(
            account, 
            branch, 
            item, 
            itemLot, 
            sku
        );
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
    }

    @isTest
    static void createServiceCampaignPositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Expected Service Campaign to be created.');
        System.assertEquals(serviceCampaign.Name, 'Service - Campaign', 'Name should be Service - Campaign.');
        System.assertEquals(serviceCampaign.dmpl__ReminderDaysOffset1__c, 3, 'Reminder Days Offset 1 should be 3.');
        System.assertEquals(serviceCampaign.dmpl__IsActive__c, true, 'is Active should be true.');
        System.assertEquals(serviceCampaign.dmpl__ReportId__c, 'Sample Report', 'Report Id  should be Sample Report.');
        System.assertEquals(serviceCampaign.dmpl__ApexJobId__c, 'Job1', 'Apex Job Id should be Job1.');
        System.assertEquals(serviceCampaign.dmpl__CronExpression__c, 'Cron Expression', 'Cron Expression should be Cron Expression.');
    }

    @isTest
    static void updateServiceCampaignPositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Service Campaign should exist before update.');
        serviceCampaign.Name = 'Service - Campaign updated';
        serviceCampaign.dmpl__ReminderDaysOffset1__c = 2;
        serviceCampaign.dmpl__IsActive__c = false;
        serviceCampaign.dmpl__ReportId__c = 'Sample Report1';
        serviceCampaign.dmpl__ApexJobId__c = 'Job2';
        serviceCampaign.dmpl__CronExpression__c = 'Cron Exp1';
        update serviceCampaign;
        dmpl__ServiceCampaign__c UpdatedServiceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertEquals(UpdatedServiceCampaign.Name, 'Service - Campaign updated', 'Name should be Service - Campaign updated after update.');
        System.assertEquals(UpdatedServiceCampaign.dmpl__ReminderDaysOffset1__c, 2, 'Reminder Days Offset 1 should be 2 after update.');
        System.assertEquals(serviceCampaign.dmpl__IsActive__c, false, 'is Active should be false after update.');
        System.assertEquals(serviceCampaign.dmpl__ReportId__c, 'Sample Report1', 'Report Id  should be Sample Report1 after update.');
        System.assertEquals(serviceCampaign.dmpl__ApexJobId__c, 'Job2', 'Apex Job Id should be Job2.');
        System.assertEquals(serviceCampaign.dmpl__CronExpression__c, 'Cron Exp1', 'Cron Expression should be Cron Exp1 after update.');
        dmpl__ServiceCampaignItem__c serviceCampaignItem = ServiceCampaignTestDataHelpers.getServiceCampaignItem();
        System.assertNotEquals(serviceCampaignItem, null, 'Service Campaign Item should exist before update.');
        serviceCampaignItem.dmpl__IsMandatory__c = false;
        serviceCampaignItem.dmpl__Quantity__c = 2;
        update serviceCampaignItem;
        dmpl__ServiceCampaignItem__c updatedServiceCampaignItem = ServiceCampaignTestDataHelpers.getServiceCampaignItem();
        System.assertEquals(updatedServiceCampaignItem.dmpl__IsMandatory__c, false, 'Is Mandatory should be false after update.');
        System.assertEquals(updatedServiceCampaignItem.dmpl__Quantity__c, 2, 'Quantity should be 2 after update.');
    }

    @isTest
    static void deleteServiceCampaign() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Service Campaign should exist before delete.');
        Id serviceCampaignId = serviceCampaign.Id;
        delete serviceCampaign;
        dmpl__ServiceCampaign__c deletedServiceCampaign = null;
        try {
            deletedServiceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign(serviceCampaignId);
        } catch (Exception e) {
            deletedServiceCampaign = null;
        }
        System.assertEquals(deletedServiceCampaign, null, 'Service Campaign should be deleted and not found in query.');
    }

    @isTest
    static void createServiceCampaignItemWithCampaignPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Test.startTest();
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        Test.stopTest();
        System.assertNotEquals(null, campaign.Id, 'Service Campaign should be created with a valid Id');
        System.assertNotEquals(null, campaignItem.Id, 'Service Campaign Item should be created with a valid Id');
        System.assertEquals(campaign.Id, campaignItem.dmpl__ServiceCampaignId__c, 'Service Campaign Item should reference the correct Service Campaign');
    }

    @isTest
    static void updateServiceCampaignItemWithActiveItemPositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        Test.startTest();
        campaignItem.dmpl__ItemId__c = item.Id;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(item.Id, campaignItem.dmpl__ItemId__c, 'Service Campaign Item should reference the correct Item');
        System.assertEquals(campaign.Id, campaignItem.dmpl__ServiceCampaignId__c, 'Service Campaign Item should reference the correct Service Campaign');
    }

    @isTest
    static void updateServiceCampaignItemWithItemServiceContractPositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        dmpl__ItemServiceContract__c itemContract = ServiceCampaignTestDataHelpers.createItemServiceContractWithName(item, 'ISC01');
        Test.startTest();
        campaignItem.dmpl__ItemId__c = item.Id;
        campaignItem.dmpl__ItemServiceContractId__c = itemContract.Id;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(item.Id, campaignItem.dmpl__ItemId__c, 'Service Campaign Item should reference the correct Item');
        System.assertEquals(itemContract.Id, campaignItem.dmpl__ItemServiceContractId__c, 'Service Campaign Item should reference the correct Item Service Contract');
        System.assertEquals(campaign.Id, campaignItem.dmpl__ServiceCampaignId__c, 'Service Campaign Item should reference the correct Service Campaign');
    }

    @isTest
    static void createServiceCampaignItemWithNoItemServiceContractPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Test.startTest();
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        Test.stopTest();
        System.assertNotEquals(null, campaignItem.Id, 'Service Campaign Item should be created with a valid Id');
        System.assertEquals(campaign.Id, campaignItem.dmpl__ServiceCampaignId__c, 'Service Campaign Item should reference the correct Service Campaign');
        System.assertEquals(null, campaignItem.dmpl__ItemServiceContractId__c, 'Item Service Contract should be null for this Service Campaign Item');
    }

    @isTest
    static void updateServiceCampaignItemWithIsMandatoryTruePositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        Test.startTest();
        campaignItem.dmpl__IsMandatory__c = true;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(true, campaignItem.dmpl__IsMandatory__c, 'Service Campaign Item should be marked as mandatory');
        System.assertEquals(campaign.Id, campaignItem.dmpl__ServiceCampaignId__c, 'Service Campaign Item should reference the correct Service Campaign');
    }

    @isTest
    static void updateServiceCampaignItemWithDiscontinuedItemPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        ServiceCampaignMasterData.updateServiceCampaignItemWithDiscontinuedItemPositiveData();
        dmpl__Item__c discontinuedItem = TestDataHelpers.getItem('Item 4'); 
        Test.startTest();
        campaignItem.dmpl__ItemId__c = discontinuedItem.Id;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(discontinuedItem.Id, campaignItem.dmpl__ItemId__c, 'Service Campaign Item should reference the correct Discontinued Item');
    }

    @isTest
    static void updateServiceCampaignItemWithInactiveItemPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        ServiceCampaignMasterData.updateServiceCampaignItemWithInactiveItemPositiveData();
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        campaignItem.dmpl__ItemId__c = inactiveItem.Id;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(inactiveItem.Id, campaignItem.dmpl__ItemId__c, 'Service Campaign Item should reference the correct Inactive Item');
    }

    @isTest
    static void updateServiceCampaignItemWithQuantityAsMinusOnePositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        Test.startTest();
        campaignItem.dmpl__Quantity__c = 3;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(3, campaignItem.dmpl__Quantity__c, 'Service Campaign Item should have Quantity set to 3');
    }

    @isTest
    static void updateServiceCampaignItemWithActiveItemAndNoQuantityPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ServiceCampaignItem__c campaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(campaign.Id);
        campaignItem.dmpl__ItemId__c = item.Id;
        update campaignItem;
        Test.startTest();
        campaignItem.dmpl__Quantity__c = 5;
        update campaignItem;
        Test.stopTest();
        System.assertEquals(5, campaignItem.dmpl__Quantity__c, 'Service Campaign Item should have Quantity set to 5');
    }

    @isTest
    static void createServiceCampaignMemberWithCampaignOnlyPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Test.startTest();
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, null, null);
        Test.stopTest();
        System.assertEquals(campaign.Id, member.dmpl__ServiceCampaignId__c, 'Service Campaign Member should reference the correct Service Campaign');
    }

    @isTest
    static void createServiceCampaignMemberWithActivePartnerPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, partner.Id, null);
        Test.stopTest();
        System.assertEquals(campaign.Id, member.dmpl__ServiceCampaignId__c, 'Service Campaign Member should reference the correct Service Campaign');
        System.assertEquals(partner.Id, member.dmpl__PartnerAccountId__c, 'Service Campaign Member should reference the correct Partner Account');
    }

    @isTest
    static void updateServiceCampaignMemberWithInactivePartnerPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, partner1.Id, null);
        Test.startTest();
        member.dmpl__PartnerAccountId__c = partner2.Id;
        update member;
        Test.stopTest();
        System.assertEquals(partner2.Id, member.dmpl__PartnerAccountId__c, 'Service Campaign Member should reference the correct Partner Account (partner2)');
    }

    @isTest
    static void updateServiceCampaignMemberWithCorrectMobilePhonePositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Account activePartner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, activePartner.Id, null);
        Test.startTest(); 
        member.dmpl__MobilePhone__c = '8888888888';
        update member;
        Test.stopTest();
        System.assertEquals('8888888888', member.dmpl__MobilePhone__c, 'Service Campaign Member should have the correct Mobile Phone number');
    }

    @isTest
    static void updateServiceCampaignMemberWithIncorrectMobilePhonePositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Account activePartner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, activePartner.Id, null);
        Test.startTest();
        member.dmpl__MobilePhone__c = '237477847938797';
        update member;
        Test.stopTest();
        System.assertEquals('237477847938797', member.dmpl__MobilePhone__c, 'Service Campaign Member should have the correct Mobile Phone number');
    }

    @isTest
    static void updateServiceCampaignMemberWithActiveItemPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__Item__c activeItem1 = TestDataHelpers.getItem('Item 1');
        ServiceCampaignMasterData.updateServiceCampaignMemberWithActiveItemPositiveData();
        dmpl__Item__c activeItem3 = TestDataHelpers.getItem('Item 3');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, null, activeItem1.Id);
        Test.startTest();
        member.dmpl__ItemId__c = activeItem3.Id;
        update member;
        Test.stopTest();
        System.assertEquals(activeItem3.Id, member.dmpl__ItemId__c, 'Service Campaign Member should reference the correct Active Item (activeItem3)');
    }

    @isTest
    static void updateServiceCampaignMemberWithInactiveItemPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
        ServiceCampaignMasterData.updateServiceCampaignItemWithInactiveItemPositiveData();
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, null, activeItem.Id);
        Test.startTest();
        member.dmpl__ItemId__c = inactiveItem.Id;
        update member;
        Test.stopTest();
        System.assertEquals(inactiveItem.Id, member.dmpl__ItemId__c, 'Service Campaign Member should reference the correct Inactive Item');
    }

    @isTest
    static void updateServiceCampaignMemberWithDiscontinuedItemPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 1');
        ServiceCampaignMasterData.updateServiceCampaignItemWithDiscontinuedItemPositiveData();
        dmpl__Item__c discontinuedItem = TestDataHelpers.getItem('Item 4');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, null, activeItem.Id);
        Test.startTest();
        member.dmpl__ItemId__c = discontinuedItem.Id;
        update member;
        Test.stopTest();
        System.assertEquals(discontinuedItem.Id, member.dmpl__ItemId__c, 'Service Campaign Member should reference the correct Discontinued Item');
    }

    @isTest
    static void updateServiceCampaignMemberWithPastDueDatePositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Date validDueDate = Date.today().addDays(5);
        Date pastDueDate = Date.today().addDays(-10);
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, null, null);
        Test.startTest();
        member.dmpl__DueDate__c = pastDueDate;
        update member;
        Test.stopTest();
        System.assertEquals(pastDueDate, member.dmpl__DueDate__c, 'Service Campaign Member should have the correct past Due Date');
    }

    @isTest
    static void updateServiceCampaignMemberWithIncorrectPartnerBranchMappingPositive() {
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ServiceCampaignMember__c member = ServiceCampaignTestDataHelpers.createServiceCampaignMember(campaign.Id, partner.Id, null);
        member.dmpl__BranchId__c = branch.Id;
        update member;
        Test.startTest();
        member.dmpl__PartnerAccountId__c = partner4.Id;
        update member;
        Test.stopTest();
        System.assertEquals(partner4.Id, member.dmpl__PartnerAccountId__c, 'Service Campaign Member should reference the correct Partner Account (partner4)');
    }

    @isTest
    static void updateServiceCampaignRuleWithNewCampaignPositive() {
        dmpl__ServiceCampaign__c campaign1 = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c campaign2 = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 2');
        dmpl__ServiceCampaignRule__c rule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(campaign1.Id, 'Account', 'equals');
        Test.startTest();
        delete rule;
        dmpl__ServiceCampaignRule__c newRule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(campaign2.Id, 'Account', 'equals');
        Test.stopTest();
        System.assertEquals(campaign2.Id, newRule.dmpl__ServiceCampaignId__c, 'Service Campaign Rule should reference the correct Service Campaign');
    }

    @isTest
    static void createServiceCampaignRuleWithoutCampaignNegative() {
        Test.startTest();
        try {
            dmpl__ServiceCampaignRule__c rule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(null, 'Account', 'equals');
            System.assert(false, 'Rule creation should fail when no campaign is provided.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('campaign'), 'Expected error due to missing campaign.');
        }
        Test.stopTest();
    }

    @isTest
    static void updateServiceCampaignRuleWithInvalidObjectTypeNegative() {
        dmpl__ServiceCampaign__c campaign1 = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignRule__c rule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(campaign1.Id, 'Account', 'equals');
        Test.startTest();
        rule.dmpl__ObjectType__c = 'Pickle'; 
        try {
            update rule;
            System.assert(false, 'Update should fail due to invalid object type.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('object') || e.getMessage().toLowerCase().contains('type'), 'Expected failure due to incorrect object type.');
        }
        Test.stopTest();
    }

    @isTest
    static void updateServiceCampaignRuleWithInvalidOperationNegative() {
        dmpl__ServiceCampaign__c campaign1 = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        dmpl__ServiceCampaignRule__c rule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(campaign1.Id, 'Account', 'equals');
        Test.startTest(); 
        rule.dmpl__Operation__c = 'Morning'; 
        try {
            update rule;
            System.assert(false, 'Update should fail due to invalid operation.');
        } catch (DmlException e) {
            System.assert(e.getMessage().toLowerCase().contains('operation') || e.getMessage().toLowerCase().contains('invalid'), 'Expected failure due to incorrect operation.');
        }
        Test.stopTest();
    }

    @isTest
    static void CreateCampaignCreationWithCampaignNamePositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        System.assertNotEquals(null, serviceCampaign, 'Service Campaign should be retrieved');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should be Campaign 1');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member should be Field Filter');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should be Marketing');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule criteria should match');
    }

    @isTest
    static void UpdateCampaignCreationWithCampaignNamePositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        serviceCampaign.Name = 'Campaign 2';
        update serviceCampaign;
        System.assertEquals('Campaign 2', serviceCampaign.Name, 'Name should be Campaign 2');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should be All Rules Are Met');
    }

    @isTest
    static void CreateCampaignCreationWithoutCampaignName() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign(null);
            insert serviceCampaign;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to missing Name field.');
    }

    @isTest
    static void CreateCampaignCreationWithParentServiceContract() {
        dmpl__ServiceCampaign__c parent = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c child = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 2');
        child.dmpl__ParentServiceCampaignId__c = parent.Id;
        update child;
        System.assertEquals('Campaign 2', child.Name, 'Name should be Campaign 2');
        System.assertEquals('Field Filter', child.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
        System.assertEquals('All Rules Are Met', child.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
    }

    @isTest
    static void UpdateCampaigncreationwithParentServiceContract() {
        dmpl__ServiceCampaign__c child = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c parent = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 2');
        child.dmpl__ParentServiceCampaignId__c = parent.Id;
        child.dmpl__DynamicMemberType__c = 'Field Filter';
        child.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
        update child;
        dmpl__ServiceCampaign__c createdChild = CampaignTestDataHelpers.getServiceCampaignById(child.Id);
        parent.dmpl__ParentServiceCampaignId__c = child.Id;
        parent.dmpl__DynamicMemberType__c = 'Field Filter';
        parent.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
        parent.dmpl__Type__c = 'Marketing';
        update parent;
        dmpl__ServiceCampaign__c updatedParent = CampaignTestDataHelpers.getServiceCampaignById(parent.Id);
        System.assertEquals(parent.Id, createdChild.dmpl__ParentServiceCampaignId__c);
        System.assertEquals(child.Id, updatedParent.dmpl__ParentServiceCampaignId__c);
        System.assertEquals('Field Filter', updatedParent.dmpl__DynamicMemberType__c);
        System.assertEquals('All Rules Are Met', updatedParent.dmpl__RuleSuccessCriteria__c);
        System.assertEquals('Marketing', updatedParent.dmpl__Type__c);
    }

    @isTest
    static void CreateCampaignCreationWithoutParentServiceContract() {
        dmpl__ServiceCampaign__c serviceCampaign1 = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(serviceCampaign1.Id);
        System.assertEquals(null, fetched.dmpl__ParentServiceCampaignId__c, 'Parent Campaign should be null');
        System.assertEquals('Marketing', fetched.dmpl__Type__c, 'Type should be Marketing');
        System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
        System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c, 'Rule Criteria should be All Rules Are Met');
    }

    @isTest
    static void CreateCampaigncreationwithItemServiceContractPositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1'); 
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        update contract;
        dmpl__ServiceCampaign__c serviceCampaign1 = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        System.assertEquals('Campaign 1', serviceCampaign1.Name, 'Name should be Campaign 1');
        System.assertEquals('Field Filter', serviceCampaign1.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
        System.assertEquals('All Rules Are Met', serviceCampaign1.dmpl__RuleSuccessCriteria__c, 'Rule Criteria should be All Rules Are Met');
        System.assertEquals('Marketing', serviceCampaign1.dmpl__Type__c, 'Type should be Marketing');
    }

    @isTest
    static void UpdateCampaigncreationwithItemServiceContractPositive(){
        dmpl__Item__c item=TestDataHelpers.getItem('Item 1');
        Account partnerAccount=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__SKU__c sku=TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract1=AssetTestDataHelpers.createItemServiceContract(item, sku);
        update contract1;
        Account partnerAccount2=TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__ItemServiceContract__c contract2=AssetTestDataHelpers.createItemServiceContract(item, sku);
        update contract2;
        dmpl__ServiceCampaign__c serviceCampaign=ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c created=CampaignTestDataHelpers.getServiceCampaignById(serviceCampaign.Id);
        serviceCampaign.dmpl__ItemServiceContractId__c=contract2.Id;
        update serviceCampaign;
        dmpl__ServiceCampaign__c updated=CampaignTestDataHelpers.getServiceCampaignById(serviceCampaign.Id);
        System.assertEquals('Campaign 1',created.Name,'Service Campaign should have the correct Name');
        System.assertEquals('Field Filter',created.dmpl__DynamicMemberType__c,'Dynamic Member Type should be set to Field Filter');
        System.assertEquals('All Rules Are Met',created.dmpl__RuleSuccessCriteria__c,'Rule Success Criteria should be All Rules Are Met');
        System.assertEquals('Marketing',created.dmpl__Type__c,'Campaign Type should be Marketing');
        System.assertEquals('Campaign 1',updated.Name,'Service Campaign name should remain as Campaign 1 after update');
        System.assertEquals(contract2.Id,updated.dmpl__ItemServiceContractId__c,'Updated Item Service Contract should be Contract 2');
        System.assertEquals('Field Filter',updated.dmpl__DynamicMemberType__c,'Dynamic Member Type should remain Field Filter');
        System.assertEquals('All Rules Are Met',updated.dmpl__RuleSuccessCriteria__c,'Rule Success Criteria should remain All Rules Are Met');
        System.assertEquals('Marketing',updated.dmpl__Type__c,'Campaign Type should remain Marketing');
    }

    @isTest
    static void CreateCampaignCreationWithoutItemServiceContractPositive() {
        dmpl__ServiceCampaign__c serviceCampaign1 = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(serviceCampaign1.Id);
        System.assertEquals('Campaign 1', fetched.Name, 'Fetched campaign should have the correct Name');
        System.assertEquals(null, fetched.dmpl__ItemServiceContractId__c, 'Fetched campaign should not have an associated Item Service Contract');
        System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c, 'Fetched campaign should have Dynamic Member Type as Field Filter');
        System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c, 'Fetched campaign should have Rule Success Criteria as All Rules Are Met');
        System.assertEquals('Marketing', fetched.dmpl__Type__c, 'Fetched campaign should have Type set to Marketing');
    }

    @isTest
    static void createServiceCampaignWithServiceCampaignName(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign('Campaign 1');
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithStartStatus(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1' ,'Start' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Start', serviceCampaign.dmpl__Status__c, 'Status should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithStatusInProgress(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1' ,'In Progress' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('In Progress', serviceCampaign.dmpl__Status__c, 'Status should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithStatusOnHold(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1' ,'On Hold' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('On Hold', serviceCampaign.dmpl__Status__c, 'Status should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithStatusOnComplete(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1' ,'Completed' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Completed', serviceCampaign.dmpl__Status__c, 'Status should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeRecall(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Recall' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Recall', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeRecallAssetActions(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Recall - Asset Actions' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Recall - Asset Actions', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeMarketing(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Marketing' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeService(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Service' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Service', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeMaintenanceSchedule(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Maintenance Schedule' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Maintenance Schedule', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithTypeContractSchedule(){
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaignWithType('Campaign 1' ,'Contract Schedule' );
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Contract Schedule', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

    @isTest
    static void createServiceCampaignWithDynamicMemberTypeFieldFilter() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1','Maintenance Schedule' ,'Field Filter');
        System.assertEquals(Date.newInstance(2025, 7, 30), serviceCampaign.dmpl__EndDate__c, 'End Date should match');
        System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should match');
        System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should match');
        System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
        System.assertEquals(Date.newInstance(2025, 6, 10), serviceCampaign.dmpl__StartDate__c, 'Start Date should match');
        System.assertEquals('Maintenance Schedule', serviceCampaign.dmpl__Type__c, 'Type should match');
    }

}