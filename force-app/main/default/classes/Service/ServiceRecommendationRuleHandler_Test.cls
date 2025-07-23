@isTest
public with sharing class ServiceRecommendationRuleHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 1',partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine =  ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(checkListTemplate);
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(checklistTemplateLine, item);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product');
    }

    @isTest
    static void createServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Expected Service Recommendation Rule to be created.');
    }

    @isTest
    static void updateServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before update.');
        serviceRecommendationRule.dmpl__Quantity__c = 4;
        serviceRecommendationRule.dmpl__ValueGreaterThan__c = 6;
        serviceRecommendationRule.dmpl__ValueLessThan__c = 3;
        serviceRecommendationRule.dmpl__RAGValue__c = 'Amber';
        serviceRecommendationRule.dmpl__RecommendationType__c = 'Optional';
        update serviceRecommendationRule;
        dmpl__ServiceRecommendationRule__c updatedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertEquals(updatedServiceRecommendationRule.dmpl__Quantity__c, 4, 'Quantity should be 4 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueGreaterThan__c, 6, 'Value greater than should be 6 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueLessThan__c, 3, 'Value less than should be 3 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RAGValue__c, 'Amber', 'RAG Value should be Amber after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RecommendationType__c, 'Optional', 'Recommendation Type should be Optional after update.');
    }

    @isTest
    static void deleteServiceRecommendationRule() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before delete.');
        Id serviceRecommendationRuleId = serviceRecommendationRule.Id;
        delete serviceRecommendationRule;
        dmpl__ServiceRecommendationRule__c deletedServiceRecommendationRule = null;
        try {
            deletedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(serviceRecommendationRuleId);
        } catch (Exception e) {
            deletedServiceRecommendationRule = null;
        }
        System.assertEquals(deletedServiceRecommendationRule, null, 'Service Recommendation Rule should be deleted and not found in query.');
    }
    
    @isTest
    static void createServiceRecommendationRuleWithChecklistLineTemplatePositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            checklistTemplateLine,
            item
        );
        rule.dmpl__Quantity__c=1;
        update rule;
        dmpl__ServiceRecommendationRule__c fetched = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);
        System.assertNotEquals(null, fetched.Id, 'Service Recommendation Rule should be inserted');
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(checklistTemplateLine.Id, fetched.dmpl__ChecklistTemplateLineId__c,
            'Checklist Template Line should be "Was the delivery received on time and in good condition?"');
        System.assertEquals(1, fetched.dmpl__Quantity__c, 'Quantity should be 1');
    }

    @isTest
    static void updateServiceRecommendationRuleWithChecklistLineTemplatePositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__CheckListTemplateLine__c checklistTemplateLine2 = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'How satisfied are you with the delivery service?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            checklistTemplateLine,
            item
        );
        rule.dmpl__Quantity__c=1;
        update rule;
        dmpl__ServiceRecommendationRule__c fetched = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);
        fetched.dmpl__CheckListTemplateLineId__c=checklistTemplateLine2.Id;
        update fetched;
        System.assertNotEquals(null, fetched.Id, 'Service Recommendation Rule should be inserted');
        System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(checklistTemplateLine2.Id, fetched.dmpl__ChecklistTemplateLineId__c,
            'Checklist Template Line should be "Was the delivery received on time and in good condition?"');
        System.assertEquals(1, fetched.dmpl__Quantity__c, 'Quantity should be 1');
    }

    @isTest
    static void createServiceRecommendationRuleWithoutChecklistLinePositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            null,
            item
        );
        rule.dmpl__Quantity__c=1;
        update rule;
        System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted without checklist line ');
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(1, rule.dmpl__Quantity__c, 'Quantity should be 1');
    }

    @isTest
    static void createServiceRecommendationRuleWithActiveItem() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            checklistTemplateLine,
            item
        );
        rule.dmpl__Quantity__c=1;
        System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted');
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 1');
    }

    @isTest
    static void updateServiceRecommendationRuleWithActiveItemPositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Product');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            checklistTemplateLine,
            item
        );
        rule.dmpl__Quantity__c=1;
        update rule;
        dmpl__ServiceRecommendationRule__c fetchedrule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);
        fetchedrule.dmpl__ItemId__c=item3.Id;
        fetchedrule.dmpl__Quantity__c=8;
        update rule;
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(8, fetchedrule.dmpl__Quantity__c, 'Quantity should be 1');
    }

    @isTest
    static void createServiceRecommendationRuleWithInActiveItemNegative(){
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2','Product'); 
        inactiveItem.dmpl__IsActive__c = false;
        update inactiveItem;
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item2);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        Boolean exceptionThrown=false;
        Test.startTest();
        try {
            dmpl__ServiceRecommendationRule__c recommendationRule = 
                ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
                    checklistTemplateLine,item2
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for inactive item');
    }

    @isTest
    static void createServiceRecommendationRuleWithZeroQuantityPositive() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(item);
        dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
            checklistTemplate,
            'Was the delivery received on time and in good condition?'
        );
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            checklistTemplateLine,
            item
        );
        rule.dmpl__Quantity__c=0;
        update rule;
        System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted');
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(0, rule.dmpl__Quantity__c, 'Item should be Item 8');
    }
}