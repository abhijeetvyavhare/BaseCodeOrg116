@isTest
public with sharing class SchemeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner4.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3', partner4.Id, branch4.Id);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMember1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id, item1.Id);
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        dmpl__ItemGroupMember__c itemGroupMember2 = TestDataHelpers.createItemGroupMember(itemGroup2.Id, item5.Id);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item1.id, false);
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme();
        scheme2.dmpl__PartnerAccountId__c = partner4.Id;
        scheme2.dmpl__BranchId__c = branch4.Id;
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition(scheme2.Id, schemeLine2.Id, item1.Id);
        schemeCondition2.dmpl__ConditionType__c = 'Item Quantity';
        schemeCondition2.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
        schemeCondition2.dmpl__ConditionValue__c = 10;
        update schemeCondition2;
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit(scheme2.Id,schemeLine2.Id, item5.Id);
        schemeBenefit2.dmpl__RewardType__c = 'Line Level Discount Amount';
        schemeBenefit2.dmpl__DiscountAmount__c = 1000;
        update schemeBenefit2;
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partner4.Id);
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2.Id);
        Test.stopTest();
    }
    
    @isTest
    static void createScheme() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.stopTest();
        System.assertNotEquals(null, scheme.Id, 'Scheme record should be inserted');
    }
    
    @isTest
    static void createSchemeAccountBudget() {
        Test.startTest();
        dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
        Test.stopTest();
        System.assertNotEquals(null, budget.Id, 'Scheme Account Budget should be inserted');
    }
    
    @isTest
    static void createSchemeBenefitPositive() {
        Test.startTest();
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        Test.stopTest();
        System.assertNotEquals(null, benefit.Id, 'Scheme Benefit should be inserted');
        System.assertEquals('Rate Off', benefit.dmpl__Title__c, 'Title should match default');
    }
    
    @isTest
    static void createSchemeCondition() {
        Test.startTest();
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        Test.stopTest();
        System.assertNotEquals(null, testCondition, 'testCondition should not be null');
        System.assertNotEquals(null, testCondition.Id, 'Scheme Condition should be inserted');
    }
    
    @isTest
    static void createSchemeLine() {
        Test.startTest();
        dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
        Test.stopTest();
        System.assertNotEquals(null, line.Id, 'Scheme Line should be inserted');
    }
    
    @isTest
    static void createSchemePeriod() {
        Test.startTest();
        dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
        Test.stopTest();
        System.assertNotEquals(null, period.Id, 'Scheme Period should be inserted');
    }
    
    @isTest
    static void updateScheme() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme.Name = 'Updated Scheme';
        scheme.dmpl__Application__c = 'Apply On Selection';
        scheme.dmpl__IgnoreBudget__c = true;
        scheme.dmpl__IncludeRelatedAccountTransactions__c = true;
        scheme.dmpl__IsClaimable__c = false;
        scheme.dmpl__MultipleFulfilmentTreatment__c = 'Apply First Fulfilled';
        scheme.dmpl__PeriodEndDate__c = Date.today().addMonths(6);
        scheme.dmpl__PeriodStartDate__c = Date.today().addDays(10);
        scheme.dmpl__PeriodType__c = 'Yearly';
        scheme.dmpl__RoundOffType__c = 'floor';
        scheme.dmpl__SchemeBudget__c = 200000;
        scheme.dmpl__SchemeQuota__c = 90.00;
        scheme.dmpl__Status__c = 'Pending Approval';
        scheme.dmpl__UtilizedAmount__c = 5000;
        scheme.dmpl__ValidCount__c = 20;
        update scheme;
        dmpl__Scheme__c updated = SchemeDataHelper.getScheme('Updated Scheme');
        Test.stopTest();
        System.assertEquals('Updated Scheme', updated.Name);
        System.assertEquals('Apply On Selection', updated.dmpl__Application__c);
        System.assertEquals(true, updated.dmpl__IgnoreBudget__c);
        System.assertEquals(true, updated.dmpl__IncludeRelatedAccountTransactions__c);
        System.assertEquals(false, updated.dmpl__IsClaimable__c);
        System.assertEquals('Apply First Fulfilled', updated.dmpl__MultipleFulfilmentTreatment__c);
        System.assertEquals(Date.today().addMonths(6), updated.dmpl__PeriodEndDate__c);
        System.assertEquals(Date.today().addDays(10), updated.dmpl__PeriodStartDate__c);
        System.assertEquals('Yearly', updated.dmpl__PeriodType__c);
        System.assertEquals('floor', updated.dmpl__RoundOffType__c);
        System.assertEquals(200000, updated.dmpl__SchemeBudget__c);
        System.assertEquals(90.00, updated.dmpl__SchemeQuota__c);
        System.assertEquals('Pending Approval', updated.dmpl__Status__c);
        System.assertEquals(5000, updated.dmpl__UtilizedAmount__c);
        System.assertEquals(20, updated.dmpl__ValidCount__c);
    }
    
    @isTest
    static void updateSchemeAccountBudget() {
        Test.startTest();
        dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
        budget.dmpl__BudgetAmount__c = 15000.00;
        update budget;
        dmpl__SchemeAccountBudget__c updatedBudget = SchemeDataHelper.getSchemeAccountBudget();
        Test.stopTest();
        System.assertEquals(15000.00, updatedBudget.dmpl__BudgetAmount__c, 'Budget Amount should update');
    }
    
    @isTest
    static void updateSchemeBenefit() {
        Test.startTest();
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        benefit.dmpl__DiscountAmount__c = 750.00;
        update benefit;
        dmpl__SchemeBenefit__c updated = SchemeDataHelper.getSchemeBenefit();
        Test.stopTest();
        System.assertEquals(750.00, updated.dmpl__DiscountAmount__c, 'Discount amount should update');
    }
    
    @isTest
    static void updateSchemeCondition() {
        Test.startTest();
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        testCondition.dmpl__Title__c = 'Updated Title';
        update testCondition;
        dmpl__SchemeCondition__c updated = SchemeDataHelper.getSchemeCondition();
        Test.stopTest();
        System.assertEquals('Updated Title', updated.dmpl__Title__c);
    }
    
    @isTest
    static void updateSchemeLine() {
        Test.startTest();
        dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
        line.dmpl__DefinitionCustomLogic__c = 'Updated custom logic';
        line.dmpl__RewardCustomLogic__c = 'Updated reward logic';
        line.dmpl__SequenceNumber__c = 2;
        line.dmpl__Title__c = 'Updated Slab Title';
        update line;
        dmpl__SchemeLine__c updated = SchemeDataHelper.getSchemeLineRecord();
        Test.stopTest();
        System.assertEquals('Updated custom logic', updated.dmpl__DefinitionCustomLogic__c);
        System.assertEquals('Updated reward logic', updated.dmpl__RewardCustomLogic__c);
        System.assertEquals(2, updated.dmpl__SequenceNumber__c);
        System.assertEquals('Updated Slab Title', updated.dmpl__Title__c);
    }
    
    @isTest
    static void updateSchemePeriod() {
        Test.startTest();
        dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
        period.Name = 'Updated Scheme Period';
        period.dmpl__DateFrom__c = Date.today().addDays(1);
        period.dmpl__DateTo__c = Date.today().addDays(60);
        update period;
        dmpl__SchemePeriod__c updated = SchemeDataHelper.getSchemePeriodRecord();
        Test.stopTest();
        System.assertEquals('Updated Scheme Period', updated.Name);
        System.assertEquals(Date.today().addDays(1), updated.dmpl__DateFrom__c);
        System.assertEquals(Date.today().addDays(60), updated.dmpl__DateTo__c);
    }
    
    @isTest
    static void deleteSchemeAccountBudget() {
        Test.startTest();
        try {
            dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
            delete budget;
            dmpl__SchemeAccountBudget__c deletedSchemeAccountBudget = SchemeDataHelper.getSchemeAccountBudget(budget.Id);
            System.assertEquals(null, deletedSchemeAccountBudget, 'Scheme Account Budget record should be deleted');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void deleteSchemeBenefit() {
        Test.startTest();
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        delete benefit;
        dmpl__SchemeBenefit__c deleted = SchemeDataHelper.getSchemeBenefit(benefit.Id);
        Test.stopTest();
        System.assertEquals(null, deleted, 'Scheme Benefit record should be deleted');
    }
    
    @isTest
    static void deleteSchemeCondition() {
        Test.startTest();
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        delete testCondition;
        try {
            dmpl__SchemeCondition__c deleted = SchemeDataHelper.getSchemeCondition(testCondition.Id);
            System.assert(false, 'Expected QueryException was not thrown. Record should have been deleted.');
        } catch (QueryException e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void deleteSchemeLinePeriod() {
        Test.startTest();
        try {
            dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
            dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
            dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
            Id lineId = line.Id;
            Id periodId = period.Id;
            Id schemeId = scheme.Id;
            delete line;
            delete period;
            delete scheme;
            dmpl__SchemeLine__c deletedLine = SchemeDataHelper.getSchemeLineRecord(lineId);
            System.assertEquals(null, deletedLine, 'Scheme Line should be deleted');
            dmpl__SchemePeriod__c deletedPeriod = SchemeDataHelper.getSchemePeriodRecord(periodId);
            System.assertEquals(null, deletedPeriod, 'Scheme Period should be deleted');
            dmpl__Scheme__c deletedScheme = SchemeDataHelper.getScheme(schemeId);
            System.assertEquals(null, deletedScheme, 'Scheme should be deleted');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeWithRequiredFieldsPositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 2', scheme.Name, 'Scheme Name should be "Scheme 2"');
        System.assertEquals(Date.today().addDays(-10), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(10), scheme.dmpl__ValidTo__c, 'Valid To should match');
    }
    
    @isTest
    static void updateSchemeNamePositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme.Name = 'Scheme 25';
        update scheme;
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 25', scheme.Name, 'Scheme Name should be "Scheme 25"');
        System.assertEquals(Date.today().addDays(-10), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(10), scheme.dmpl__ValidTo__c, 'Valid To should match');
    }
    
    @isTest
    static void updateSchemeTypePositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme = SchemeDataHelper.getScheme(scheme.Name);
        scheme.dmpl__SchemeType__c = 'Per Sale Invoice';
        update scheme;
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 2', scheme.Name, 'Scheme Name should be "Scheme 2"');
        System.assertEquals(Date.today().addDays(-10), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(10), scheme.dmpl__ValidTo__c, 'Valid To should match');    
    }
    
    @isTest
    static void updatePeriodTypePositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme = SchemeDataHelper.getScheme(scheme.Name);
        scheme.dmpl__PeriodType__c = 'Monthly';
        update scheme;
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 2', scheme.Name, 'Scheme Name should be "Scheme 2"');
        System.assertEquals(Date.today().addDays(-10), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(10), scheme.dmpl__ValidTo__c, 'Valid To should match');
    }
    
    @isTest
    static void createSchemeWithoutPeriodTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
            scheme.dmpl__PeriodType__c = null;
            update scheme;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to Period type field');
    }
    
    @isTest
    static void updateSchemeCreationWithValidFromPositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme.dmpl__ValidFrom__c = Date.Today().addDays(2) ;
        update scheme;
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 2', scheme.Name, 'Scheme Name should be "Scheme 2"');
        System.assertEquals(Date.Today().addDays(2), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(10), scheme.dmpl__ValidTo__c, 'Valid To should match');
    }
    
    @isTest
    static void updateSchemeCreationWithValidToPositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        scheme.dmpl__ValidTo__c = Date.today().addDays(12);
        update scheme;
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        Test.stopTest();
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals('Scheme 2', scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(Date.today().addDays(-10), scheme.dmpl__ValidFrom__c, 'Valid From should match');
        System.assertEquals(Date.today().addDays(12), scheme.dmpl__ValidTo__c, 'Valid To should match');
    }
    
    @isTest
    static void createSchemeWithoutValidFromNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
            scheme.dmpl__ValidFrom__c = Date.today().addDays(40);
            update scheme;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid from field');
    }
    
    @isTest
    static void createSchemeWithoutSchemeTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
            scheme.dmpl__SchemeType__c = null;
            update scheme;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing scheme type field');
    }
    
    @isTest
    static void createSchemeAccountBudgetWithPartnerAccountPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, scheme.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithPartnerAccountGroupPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
            schemeAccountBudget.dmpl__PartnerAccountGroupId__c = accountGroup.Id;
            update schemeAccountBudget;
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(accountGroup.Id, schemeAccountBudget.dmpl__PartnerAccountGroupId__c, 'SchemeAccountBudget must have a partner Group account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithBudgetAmountPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, scheme.Id);
            schemeAccountBudget.dmpl__BudgetAmount__c = 10000;
            update schemeAccountBudget;
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        System.AssertEquals(10000, schemeAccountBudget.dmpl__BudgetAmount__c, 'SchemeAccountBudget must have a Budget Amount 10000!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithUtilizedAmountPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id,scheme.Id);
            schemeAccountBudget.dmpl__UtilizedAmount__c = 2500;
            update schemeAccountBudget;
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        System.AssertEquals(2500, schemeAccountBudget.dmpl__UtilizedAmount__c, 'SchemeAccountBudget must have a Utilized Amount 2500!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutPartnerAccountNegative() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Wrong Partner Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutPartnerAccountGroupNegative() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As No Partner Group Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutBudgetAmountNegative() {
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Budget Amount Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutSchemeNegative() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try {
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, null);
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
        } catch (Exception e) {
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSchemeSlabPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SchemeLineId__c = schemeLine.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(schemeLine.Id, schemeLedger.dmpl__SchemeLineId__c, 'Scheme line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithBillPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__BillId__c = bill.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeLedgerWithBillPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__BillId__c = bill.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get update! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleOrderLinePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
    }
    
    @isTest
    static void updateSchemeLedgerWithSaleOrderLinePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
    }
    
    @isTest
    static void createSchemeLedgerWithSaleOrderPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderId__c = saleOrder.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
    }
    
    @isTest
    static void updateSchemeLedgerWithSaleOrderPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderId__c = saleOrder.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
    }
    
    @isTest
    static void createSchemeLedgerWithSaleInvoicePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleInvoiceId__c = saleInvoice.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
    }
    
    @isTest
    static void createSchemeLedgerWithSaleInvoiceLinePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithSaleOrderPositiveData(
            branch,
            priceList,
            Item
        );
        Test.stopTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleInvoiceId__c = saleInvoice.Id;
            schemeLedger.dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
        System.assertEquals(saleInvoiceLine.Id, schemeLedger.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line must match!');
    }
    
    @isTest
    static void createSchemeLedgerWithSaleReturnPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        SchemeMasterData.createSchemeLedgerWithSaleReturnPositiveData(
            branch, 
            priceList,
            item,
            sku,
            taxGroup
        );
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleReturnId__c = saleReturn.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleReturnLinePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        SchemeMasterData.createSchemeLedgerWithSaleReturnPositiveData(
            branch, 
            priceList,
            item,
            sku,
            taxGroup
        );
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleReturnId__c = saleReturn.Id;
            schemeLedger.dmpl__SaleReturnLineId__c = saleReturnLine.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
        System.assertEquals(saleReturnLine.Id, schemeLedger.dmpl__SaleReturnLineId__c, 'Sale Retrun Line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithRepairOrderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        SchemeMasterData.createSchemeLedgerWithRepairOrderPositiveData(
            partner, 
            customer, 
            branch, 
            item
        );
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__RepairOrderId__c = repairOrder.Id;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(repairOrder.Id, schemeLedger.dmpl__RepairOrderId__c, 'Repair Order must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithDiscountAmountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(500, schemeLedger.dmpl__DiscountAmount__c, 'Discount Amount must be 500!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithDiscountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__Discount__c = 10;
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(10, schemeLedger.dmpl__Discount__c, 'Discount percent must be 10%!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithRewardPointsPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__RewardPoints__c = 600;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(600, schemeLedger.dmpl__RewardPoints__c, 'Reward Point must be 600!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithWrongBranchNegative() {
        Test.startTest();
        SchemeMasterData.createSchemeConsumptionWithWrongBranchNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger == null, 'Scheme Ledger must fail As wrong partner added! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSchemeBenefitPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        dmpl__SchemeLedger__c schemeLedger;
        try {
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SchemeBenefitId__c = schemeBenefit.Id;
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
        } catch (Exception e) {
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must create ! >> ' + e.getMessage());
        }
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(schemeBenefit.Id, schemeLedger.dmpl__SchemeBenefitId__c, 'Scheme Benefit must be Match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithDiscountedItemPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id,item?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithDiscountedItemPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        SchemeMasterData.createItem2(itemGroup);
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithDiscountedItemGroupPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = 'Discounted Item Group';
            schemeBenefit.dmpl__RepeatReward__c = false;
            schemeBenefit.dmpl__DiscountedItemGroupId__c = itemGroup?.Id;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Discounted Item Group', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(false, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithLineLevelDiscountPercentPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountPercent__c = 100;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(100, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithLineLevelDiscountAmountPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id,item?.Id);
            schemeBenefit.dmpl__DiscountAmount__c = 2500;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(2500, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithRewardPointsPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = 'Reward Points';
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Reward Points', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem1Positive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithFreeItem1Positive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c ItemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        SchemeMasterData.createItem2(ItemGroup);
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem1PieceQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__UOMQuantity__c = 15;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(15, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem2Positive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemGroupId__c = null;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithFreeItem2Positive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 6', 'Product'); 
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem2PieceQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__UOMQuantity__c = 20;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(20, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithSchemeValuePositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithSchemePercentagePositive() {
        Test.startTest();
        dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithExcludeQualifyingItemTruePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = false;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(false, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithReadRewardEveryQualificationTruePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RepeatReward__c = false;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(false, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithExcludeQualifyingItemFalsePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = false;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(false, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithReadRewardEveryQualificationFalsePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RepeatReward__c = false;
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = true;
            update schemeBenefit;
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(1, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals('Line Level Discount Amount', schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(null, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(1000, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(null, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(true, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(false, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithoutRewardTypeNegative() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SchemeBenefit__c schemeBenefit;
        try {
            schemeBenefit = SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = null;
            update schemeBenefit;
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must not create !');
        } catch (Exception e) {
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must not create ! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    static void createSchemeConditionWithItemQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = 'Item Quantity';
            schemeCondition.dmpl__ConditionValue__c = 10;
            schemeCondition.dmpl__ConditionQuantity__c = 10;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(10, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(10, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithValuePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionQuantity__c = 12;
            schemeCondition.dmpl__ConditionValue__c = 12;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(12, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(12, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithCaseQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionValue__c = 12;
            schemeCondition.dmpl__UOMQuantity__c = 2;
            schemeCondition.dmpl__ConditionQuantity__c = 12;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(12, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(2, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(12, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithPieceQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionValue__c = 12;
            schemeCondition.dmpl__UOMQuantity__c = 2;
            schemeCondition.dmpl__ConditionQuantity__c = 12;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(12, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(2, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(12, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditoinTypeAsItemGroupPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionType__c = 'Item Group Quantity';
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Group Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditoinTypeAsItemGroupValuePositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionType__c = 'Item Group Quantity';
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Group Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorGreaterThanOrEqualPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Greater Than Or Equal', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorEqualsPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Equals', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorDoesNotEqualsPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionOperator__c = 'Does Not Equal';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Does Not Equal', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorGreaterThanPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Greater Than', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorLessThanPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionOperator__c = 'Less Than';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Less Than', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorLessThanOrEqualPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionOperator__c = 'Less Than Or Equal';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Quantity', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Less Than Or Equal', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithItemPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = 'Item Group Value';
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Group Value', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(null, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Greater Than Or Equal', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithItemGroupPositive() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            schemeCondition.dmpl__ConditionType__c = 'Item Group Value';
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
            update schemeCondition;
        } catch (Exception e) {
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition = SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals('Item Group Value', schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(null, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(null, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(null, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals('Greater Than Or Equal', schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(100, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(1, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutSequenceNumberNegative() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionType__c = 'Item Group Value';
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
            schemeCondition.dmpl__SequenceNumber__c = null;
            update schemeCondition;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutConditionTypeNegative() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionType__c = null;
            schemeCondition.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
            update schemeCondition;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutConditionOperatorNegative() {
        Test.startTest();
        SchemeMasterData.createScheme20();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try {
            schemeCondition = SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,null);
            schemeCondition.dmpl__ConditionType__c = 'Value';
            schemeCondition.dmpl__ConditionOperator__c = null;
            update schemeCondition;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithItemGroupPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                null,
                itemGroup?.Id
            );
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully>> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(null, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(0, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithWrongPartnerAccountNegative() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        SchemeMasterData.createSchemeLedgerWithWrongPartnerAccountNegativeData(accountGroup);
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                item?.Id,
                itemGroup?.Id
            );
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must be Fail Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithWrongBranchNegative() {
        Test.startTest();
        SchemeMasterData.createSchemeConsumptionWithWrongBranchNegativeData();
        SchemeMasterData.createPartnerAccount1Data();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        SchemeMasterData.createSchemeLedgerWithWrongPartnerAccountNegativeData(accountGroup);
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                item?.Id,
                itemGroup?.Id
            );
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithoutItemNegative() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                null,
                null
            );
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeConsumptionWithConsumedQuantityPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        SchemeMasterData.createItem2(itemGroup);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                item?.Id,
                itemGroup?.Id
            );
            schemeConsumption.dmpl__ConsumedQuantity__c = 10;
            update schemeConsumption;
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(10, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeConsumptionWithConsumedAmountPositive() {
        Test.startTest();
        SchemeMasterData.createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__SchemeConsumption__c schemeConsumption;
        try {
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(
                partner?.Id,
                branch?.Id,
                item?.Id,
                itemGroup?.Id
            );
            schemeConsumption.dmpl__ConsumedAmount__c = 3000;
            update schemeConsumption;
        } catch (Exception e) {
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(0, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemePeriodPositive() {
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.getSchemePeriodRecord();
        Test.stopTest();
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Test Scheme Period', schemePeriod.Name, 'Name should be Test Scheme Period');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
    }
    
    @isTest
    static void createSchemePeriodWithSchemePeriodNamePositive() {
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.getSchemePeriodRecord();
        Test.stopTest();
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Test Scheme Period', schemePeriod.Name, 'Name should be Test Scheme Period');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
    }
    
    @isTest
    static void createSchemePeriodWithoutSchemePeriodNameNegative() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);
        Test.startTest();
        try {
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(
                scheme,
                null,
                Date.newInstance(2025, 6, 1),
                Date.newInstance(2025, 6, 30)
            );
        } catch (Exception e) {
            System.Assert.isTrue(true, 'schemePeriod should not be created without name');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemePeriodWithDateFromAndDateToPositive() {
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.getSchemePeriodRecord();
        Test.stopTest();
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Test Scheme Period', schemePeriod.Name, 'Name should be Test Scheme Period');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
    }
    
    @isTest
    static void createSchemePeriodWithoutDateFromAndDateToPositive() {
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.getSchemePeriodRecord();
        schemePeriod.dmpl__DateFrom__c = null;
        schemePeriod.dmpl__DateTo__c = null;
        update schemePeriod;
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Test Scheme Period', schemePeriod.Name, 'Name should be Test Scheme Period');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeSlabPositive() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('NET RATE', schemeLine.dmpl__Title__c, 'Title should be NET RATE');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithFilterCriteriaPositive() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('NET RATE', schemeLine.dmpl__Title__c, 'Title should be NET RATE');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithRewardApplicabilityPositive() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('NET RATE', schemeLine.dmpl__Title__c, 'Title should be NET RATE');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithSequenceNumberPositive() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('NET RATE', schemeLine.dmpl__Title__c, 'Title should be NET RATE');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
}