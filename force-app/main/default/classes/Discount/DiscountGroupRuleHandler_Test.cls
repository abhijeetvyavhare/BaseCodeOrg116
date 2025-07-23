@isTest
public with sharing class DiscountGroupRuleHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup('Discount 1', partnerAccount, branch);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__ItemLotType__c itemLotType = TestDataHelpers.createItemLotType(item);
        DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
                    discountGroup,
                    item,
                    null,
                    itemLotType,
                    sku,
                    priceList
        ); 
    }

    @isTest
    static void createDiscountGroupRulePositive() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should be created');
        System.assertNotEquals(null, rule.dmpl__DiscountGroupId__c, 'Discount Group should not be null');
        System.assertNotEquals(null, rule.dmpl__SKUId__c, 'SKU should not be null');
        System.assertNotEquals(null, rule.dmpl__PriceListId__c, 'Price List should not be null');
        System.assertNotEquals(null, rule.dmpl__ItemLotTypeId__c, 'Item Lot Type should not be null');
        System.assertEquals(null, rule.dmpl__ItemGroupId__c, 'Item Group is optional and should be null here');
    }

    @isTest
    static void updateDiscountGroupRulePositive() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should exist before update');
        rule.dmpl__DiscountPercent__c = 25.5;
        update rule;
        dmpl__DiscountGroupRule__c updatedRule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertEquals(25.5, updatedRule.dmpl__DiscountPercent__c, 'Discount Percentage should be updated to 25.5');
    }

    @isTest
    static void deleteDiscountGroupRule() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should exist before delete');
        Id ruleId = rule.Id;
        delete rule;
        dmpl__DiscountGroupRule__c deletedGroupRule = null;
        try {
            deletedGroupRule =  DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        } catch (Exception e) {
            deletedGroupRule = null;
        }
        System.assertEquals(null, deletedGroupRule, 'DiscountGroup should be deleted and not found.');
    }

    @isTest
    static void createDiscountGroupRuleWithDiscountGroupReferencePositive() {
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');    
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        Date tillDate = Date.newInstance(2025, 7, 30);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            tillDate
        );
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
        System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c, 'Effective Till date should match');
    }

    @isTest
    static void updateDiscountGroupRuleWithDiscountGroupNegative() {
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        Date fromDate = Date.newInstance(2025,1,5);
        Date tillDate = Date.newInstance(2025, 7, 30);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            tillDate
        );
        discountGroup.Name='Discount 2';
        update discountGroup;
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroup__c fetchedGroup2 = DiscountDataHelper.getDiscountGroup('Discount 2');
        System.assertEquals('Discount 2', fetchedGroup2.Name);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__DiscountGroupRule__c ruleToUpdate = rules[0];
            ruleToUpdate.dmpl__DiscountGroupId__c = fetchedGroup2.Id;
            ruleToUpdate.dmpl__DateEffectiveFrom__c = Date.newInstance(2025, 6, 5);
            ruleToUpdate.dmpl__DateEffectiveTill__c = Date.newInstance(2025, 11, 30);
            update ruleToUpdate;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to changing Discount Group reference.');
    }

    @isTest
    static void createDiscountGroupRuleWithDiscountPercentagePositive() {
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        Date tillDate = Date.newInstance(2025, 7, 30);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            tillDate
        );
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
        System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c, 'Effective Till date should match');
    }

    @isTest
    static void updateDiscountGroupRuleWithUpdatedDiscountPercentPositive() {
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');    
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Date tillDate = Date.newInstance(2025, 7, 30);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            7,
            fromDate,
            tillDate
        );
        List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[1];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c);
        System.assertEquals(7, fetchedRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c);
        fetchedRule.dmpl__DiscountPercent__c = 4;
        update fetchedRule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[0];
        System.assertEquals(4, updatedRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(tillDate, updatedRule.dmpl__DateEffectiveTill__c);
        System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
    }

    @isTest
    static void createDiscountGroupRuleWithDateEffectivePositive() {
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    }

    @isTest
    static void updateDiscountGroupRuleWithDateEffectiveFormPositive() {
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account partner1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1',partner1.Id);
        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__DiscountGroup__c discountGroup2 = DiscountDataHelper.createDiscountGroup('Discount 2', partner1, branch1);
        discountGroup2.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup2;
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup1,
            4,
            fromDate,
            null
        );
        List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup1.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[0];
        System.assertEquals(discountGroup1.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Initial Discount Group should match');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);
        Date newFromDate = Date.newInstance(2025, 1, 5);
        fetchedRule.dmpl__DateEffectiveFrom__c = newFromDate;
        update fetchedRule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup1.Id);
        dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[0];
        System.assertEquals(newFromDate, updatedRule.dmpl__DateEffectiveFrom__c, 'Updated From Date should match');
    }

    @isTest
    static void createDiscountGroupRuleWithNoDateEffectiveFromNegative() {
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
                discountGroup,
                4,
                null,
                null
            );
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to missing DateEffectiveFrom.');
    }

    @isTest
    static void createDiscountGroupRuleWithActiveItemPositive() {
        dmpl__Item__c item=TestDataHelpers.createItem('Item 8','Product');
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        Test.stopTest();
        rule.dmpl__ItemId__c=item.Id;
        update rule;
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    }

    @isTest
    static void updateDiscountGroupRuleWithActiveItemPositive() {
        dmpl__Item__c Item8=TestDataHelpers.createItem('Item 8','Product');
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product');
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item1.Id;
        update rule;
        List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);
        fetchedRule.dmpl__ItemId__c = Item8.Id;
        fetchedRule.dmpl__SKUId__c=sku2.Id;
        update fetchedRule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[1];
        System.assertEquals(Item8.Id, fetchedRule.dmpl__ItemId__c = item8.Id);
        System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
    }

    @isTest
    static void createDiscountGroupRuleWithInactiveItemNegative() {
        dmpl__Item__c item2= TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item2.Id;
        update rule;
        Test.stopTest();
        System.assertEquals(item2.Id,rule.dmpl__ItemId__c,'record gets created with inactive item 2');
    }

    @isTest
    static void UpdateDiscountGroupRuleWithInactiveItemPositive() {
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        System.assertEquals('Discount 1', discountGroup.Name);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            Date.newInstance(2025,1,5),
            null
        );
        rule.dmpl__ItemId__c=item8.Id;
        update rule;
        System.assertEquals(discountGroup.Id, rule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, rule.dmpl__DiscountPercent__c);
        System.assertEquals(Date.newInstance(2025,1,5), rule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(item8.Id, rule.dmpl__ItemId__c);
        rule.dmpl__ItemId__c = item2.Id;
        update rule;
        Test.stopTest();
        dmpl__DiscountGroupRule__c updatedRule = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id)[1];
        System.assertEquals(item2.Id, updatedRule.dmpl__ItemId__c);
    }

    @isTest
    static void CreateDiscountGroupRuleWithRequiredSKUPositive() {
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item7.Id;
        rule.dmpl__SKUId__c=sku1.Id;
        update rule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c createdRule = rules[1];
        System.assertEquals(discountGroup.Id, createdRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, createdRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, createdRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(sku1.Id, createdRule.dmpl__SKUId__c);
    }

    @isTest
    static void CreateDiscountGroupRuleWithNoRequiredSKUPositive() {
        dmpl__Item__c Item8=TestDataHelpers.createItem('Item 8','Product');
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item8.Id;
        update rule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    }

    @isTest
    static void updateDiscountGroupRuleWithNoRequiredSKUPositive() {
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product');
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item7.Id;
        rule.dmpl__SKUId__c=sku1.Id;
        update rule;
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c existingRule = rules[1];
        System.assertEquals(discountGroup.Id, existingRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, existingRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, existingRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(item7.Id, existingRule.dmpl__ItemId__c);
        System.assertEquals(sku1.Id, existingRule.dmpl__SKUId__c);
        existingRule.dmpl__ItemId__c = item8.Id;
        existingRule.dmpl__SKUId__c = null;
        update existingRule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> updatedRules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c updatedRule = updatedRules[1];
        System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, updatedRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(item8.Id, updatedRule.dmpl__ItemId__c);
        System.assertEquals(null, updatedRule.dmpl__SKUId__c);
    }

    @isTest
    static void updateDiscountGroupRuleWithRequiredSKUPositive() {
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product');
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemId__c=item8.Id;
        update rule;
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c existingRule = rules[1];
        System.assertEquals(discountGroup.Id, existingRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, existingRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, existingRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(item8.Id, existingRule.dmpl__ItemId__c);
        System.assertEquals(null, existingRule.dmpl__SKUId__c);
        existingRule.dmpl__ItemId__c = item7.Id;
        existingRule.dmpl__SKUId__c = sku1.Id;
        update existingRule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> updatedRules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c updatedRule = updatedRules[1];
        System.assertEquals(item7.Id, updatedRule.dmpl__ItemId__c);
        System.assertEquals(sku1.Id, updatedRule.dmpl__SKUId__c);
        System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
    }

    @isTest
    static void createDiscountGrouprulewithItemGroup() {
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    }

    @isTest
    static void createDiscountGroupRuleWithoutItemGroupPositive() {
        dmpl__Item__c Item8=TestDataHelpers.createItem('Item 8','Product');
        Test.startTest();
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name, 'Name should match');
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Type should match');
        Date fromDate = Date.newInstance(2025,1,5);
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c fetchedRule = rules[0];
        System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
        System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
        System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    }

    @isTest
    static void createDiscountGroupRuleWithItemGroupPositive() {
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        System.assertEquals('Discount 1', discountGroup.Name);
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
        Date fromDate = Date.newInstance(2025,1,5);
        Test.startTest();
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null
        );
        rule.dmpl__ItemGroupId__c=itemgroup2.Id;
        update rule;
        Test.stopTest();
        List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
        dmpl__DiscountGroupRule__c createdRule = rules[1];
        System.assertEquals(discountGroup.Id, createdRule.dmpl__DiscountGroupId__c);
        System.assertEquals(4, createdRule.dmpl__DiscountPercent__c);
        System.assertEquals(fromDate, createdRule.dmpl__DateEffectiveFrom__c);
        System.assertEquals(itemGroup2.Id, createdRule.dmpl__ItemGroupId__c);
    }
}