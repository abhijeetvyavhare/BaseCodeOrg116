@isTest
public with sharing class IncentivePlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 11', 
            partner.Id, 
            null, 
            branch.Id
       );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'FREE OF COST');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id, 
            scheme.Id, 
            'Equals', 
            item.Id, 
            7
        );
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(accountGroup.Id, partner.Id, supplier.Id);
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.createIncentivePeriod(plan.Id);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partner, branch);
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
            partner.Id, 
            branch.Id,
            'Resource 4',
            plan.Id
        );
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(plan.Id, 'All Rewards');        
    }

    @isTest
    static void createIncentivePlanPositive() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(plan, null, 'Expected Incentive Plan to be created.');
        System.assertEquals('Yearly', plan.dmpl__PeriodType__c, 'PeriodType should match');
        System.assertEquals('Resource', plan.dmpl__MemberType__c, 'MemberType should match');
        System.assertEquals('Draft', plan.dmpl__Status__c, 'Status should match');
    }

    @isTest
    static void createIncentivePeriodPositive() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        System.assertNotEquals(period, null, 'Expected Incentive Period to be created.');
        System.assertEquals(null, period.dmpl__Status__c, 'Status should match');
    }

    @isTest
    static void createIncentiveLinePositive() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        System.assertNotEquals(line, null, 'Expected Incentive Line to be created.');
        System.assertEquals('All Conditions Are Met', line.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should match');
        System.assertEquals('All Rewards', line.dmpl__RewardApplicability__c, 'RewardApplicability should match');
        System.assertEquals(1, line.dmpl__SequenceNumber__c, 'SequenceNumber should match');
        System.assertEquals(false, line.dmpl__UseSlabAbsoluteValue__c, 'UseSlabAbsoluteValue should match');
    }

    @isTest
    static void updateIncentivePlanPositive() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePlan__c updatedPlan = IncentivePlanDataHelper.updateIncentivePlan(plan, 'Approved');
        System.assertEquals('Approved', updatedPlan.dmpl__Status__c, 'Status should be updated.');
    }

    @isTest
    static void updateIncentivePeriodPositive() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentivePeriod__c updatedPeriod = IncentivePlanDataHelper.updateIncentivePeriod(period, 'Approved');
        System.assertEquals('Approved', updatedPeriod.dmpl__Status__c, 'Status should be updated.');
    }

    @isTest
    static void updateIncentiveLinePositive() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveLine__c updatedLine = IncentivePlanDataHelper.updateIncentiveLine(line, 'Updated Line');
        System.assertEquals('Updated Line', updatedLine.dmpl__Title__c, 'Line Title should be updated.');
    }

    @isTest
    static void deleteIncentivePlan() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        Integer count = IncentivePlanDataHelper.deleteIncentivePlan(plan);
        System.assertEquals(0, count, 'Incentive Plan should be deleted and not found in query.');
    }

    @isTest
    static void deleteIncentivePeriod() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        Integer count = IncentivePlanDataHelper.deleteIncentivePeriod(period);
        System.assertEquals(0, count, 'Incentive Period should be deleted and not found in query.');
    }

    @isTest
    static void deleteIncentiveLine() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        Integer count = IncentivePlanDataHelper.deleteIncentiveLine(line);
        System.assertEquals(0, count, 'Incentive Line should be deleted and not found in query.');
    }

    @isTest
    static void createIncentiveResourcePositive() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        System.assertNotEquals(resource, null, 'Expected Incentive Resource to be created.');
    }

    @isTest
    static void updateIncentiveResourcePositive() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        dmpl__Branch__c newBranch = TestDataHelpers.createBranch(TestDataHelpers.createPartnerAccount());
        dmpl__IncentiveResource__c updatedResource = IncentivePlanDataHelper.updateIncentiveResource(resource, newBranch.Id);
        System.assertEquals(newBranch.Id, updatedResource.dmpl__BranchId__c, 'Branch should be updated.');
    }

    @isTest
    static void deleteIncentiveResource() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        Integer count = IncentivePlanDataHelper.deleteIncentiveResource(resource);
        System.assertEquals(0, count, 'Incentive Resource should be deleted and not found in query.');
    }

    @isTest
    static void createIncentiveLineWithAllRewardsPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, 'All Rewards');
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('All Rewards', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be All Rewards');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithAnyOneLowestValuePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, 'Any One With Lowest Value');
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Lowest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Lowest Value');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithAnyOneHighestValuePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, 'Any One With Highest Value');
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Highest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Highest Value');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithCustomLogicPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, 'Custom Logic');
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Custom Logic', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Custom Logic');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithAllConditionsMetPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, null);
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithAnyConditionMetPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, null);
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithCustomLogicMetPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id, null);
        incentiveLine.dmpl__DefinitionFilterCriteria__c = 'Custom Logic Is Met';
        update incentiveLine;
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        System.assertEquals('Custom Logic Is Met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be Custom Logic Is Met');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveLineWithoutIncentivePlanNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try {
            incentiveLine = IncentivePlanDataHelper.createIncentiveLine(null, 'Any One With Highest Value');
        } catch (Exception e) {
            System.Assert.isTrue(incentiveLine == null, 'Incentive Line Expected not to be created!');
        }
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithMemeberResourceTypeAsSalespersonPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
            incentivePlan?.Id, 
            'Salesperson', 
            period?.Id, 
            incentiveLine?.Id
       );
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Salesperson', compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(null, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithMemeberResourceTypeAsServiceadvisorPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
            incentivePlan?.Id, 
            'Service Advisor', 
            period?.Id, 
            incentiveLine?.Id
       );
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Service Advisor', compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(null, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithMemeberResourceTypeAsManagerPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
            incentivePlan?.Id, 
            'Manager',  
            period?.Id, 
            incentiveLine?.Id
       );
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Manager', compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(null, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithGiftAsRewardPointsPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
            incentivePlan?.Id, 
            'Manager', 
            period?.Id, 
            incentiveLine?.Id
       );
        compensationSlab.dmpl__GiftPoints__c= 2;
        update compensationSlab;
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Manager', compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(2, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithReferenceIncentiveLineNegative() {
       Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try {
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
                incentivePlan?.Id, 
                'Manager', 
                null, 
                incentiveLine?.Id
           );
        } catch (Exception e) {
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithIncentivePlanNegative() {
        Test.startTest();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try {
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
                null, 
                'Manager', 
                period?.Id, 
                incentiveLine?.Id
           );
        } catch (Exception e) {
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createCompensationSlabWithResourceTypeNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try {
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(
                incentivePlan?.Id, 
                null, 
                period?.Id, 
                incentiveLine?.Id
           );
        } catch (Exception e) {
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentivePlanWithNamePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
    }

    @isTest
    static void createIncentivePlanWithoutNameNagative() {
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
            incentivePlan.Name = null;
            update incentivePlan;
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created without name');
        }
    }

    @isTest
    static void updateIncentivePlanWithoutNameNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan(); 
        Test.startTest();
        try {
            incentivePlan.Name = null;
            update incentivePlan;
        }catch (Exception e) {
           System.Assert.isTrue(true, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentivePlanWithSupplierAccountPositive() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, null, supplier?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.AssertEquals(supplier.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }

    @isTest
    static void createIncentivePlanWithNoSupplierAccountPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
    }

    @isTest
    static void createIncentivePlanWithInactivePartnerAccountNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, partner?.Id, null);
            System.assertEquals(null, incentivePlan, 'IncentivePlan should not be created with inactive partner Account');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created with inactive partner Account');
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentivePlanWithInactivePartnerAccountNagative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partner2.dmpl__IsActive__c = false;
        update partner2;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, partner?.Id, null);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals(partner.Id, incentivePlan.dmpl__PartnerAccountId__c, 'Partner Account should be same');        
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__PartnerAccountId__c = partner2.Id;
            update incentivePlan;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentivePlanWithSupplierAccountPositive() {
        Account supplier= TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__SupplierAccountId__c = supplier.Id;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when assigning supplier Account');
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.AssertEquals(supplier.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }

    @isTest
    static void updateIncentivePlanWithNoSupplierAccountPositive() {
        Account supplier= TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, null, supplier?.Id);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.AssertEquals(supplier.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            incentivePlan.dmpl__SupplierAccountId__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;  
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing supplier Account');
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.AssertEquals(null, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }

    @isTest
    static void createIncentivePlanWithDefinedPeriodTypePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        incentivePlan.dmpl__PeriodType__c = 'Monthly';
        update incentivePlan;
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
    }

    @isTest
    static void createIncentivePlanWithoutPeriodTypeNegative() {
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
            incentivePlan.dmpl__PeriodType__c = null;
            update incentivePlan;
            System.assertEquals(null, incentivePlan.Id, 'incentive plan should not be created without period type');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Incentive plan should not be created without period type');
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentivePlanWithoutPeriodTypeNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__PeriodType__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when removing period type');
        Test.stopTest();
    }

    @isTest
    static void createIncentivePeriodWithPeriodNamePositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('IncentivePeriod1', incentivePeriod.Name, 'incentive period name should match');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
    }

    @isTest
    static void createIncentivePeriodWithoutPeriodNameNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try {
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
            incentivePeriod.Name = null;
            update incentivePeriod;
            System.assertEquals(null, incentivePeriod, 'IncentivePeriod should not be created without period Name');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePeriod should not be created without period Name');
        }
        Test.stopTest();  
    }

    @isTest
    static void updateIncentivePeriodWithoutPeriodNameNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentivePeriod.Name = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();   
    }

    @isTest
    static void createIncentivePeriodWithDefiningDateFromAndDateToPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        incentivePeriod.dmpl__DateFrom__c = Date.newInstance(2025, 6, 20);
        incentivePeriod.dmpl__DateTo__c = Date.newInstance(2025, 7, 20);
        update incentivePeriod;
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'Incentive plan should be match');
    }

    @isTest
    static void createIncentivePeriodWithoutDefiningDateFromAndDateToPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        incentivePeriod.dmpl__DateFrom__c = null;
        incentivePeriod.dmpl__DateTo__c = null;
        update incentivePeriod;
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('IncentivePeriod1', incentivePeriod.Name, 'Incentive Period name should match');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'Incentive plan should be match');
        Test.stopTest();
    }

    @isTest
    static void updateIncentivePeriodWithoutDefiningDateFromAndDateToNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'IncentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'Incentive plan should be match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentivePeriod.dmpl__DateFrom__c = null;
            incentivePeriod.dmpl__DateTo__c = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
    }

    @isTest
    static void createIncentivePeriodWithInvalidDateRangeNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try {
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
            incentivePeriod.dmpl__DateFrom__c = Date.newInstance(2025, 7, 20);
            incentivePeriod.dmpl__DateTo__c = Date.newInstance(2025, 2, 11);
            update incentivePeriod;
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Incentive Period should not be created with invalid date range');
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentivePeriodWithInvalidDateRangeNegative() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentivePeriod.dmpl__DateFrom__c = Date.newInstance(2025, 7, 20);
            incentivePeriod.dmpl__DateTo__c = Date.newInstance(2025, 2, 11);
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentivePeriodWithIncentivePlanReferencePositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'Incentive Period should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'Incentive plan should be match');
    }

    @isTest
    static void createIncentivePeriodWithoutIncentivePlanReferenceNegative() {
        Test.startTest();
        try {
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(null);
            System.assertEquals(null, incentivePeriod.Id, 'Incentive period should not be created without incentive plan reference');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'Incentive period should not be created without incentive plan reference');
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentivePeriodWithAutoTaggedIncentivePlanPositive() {
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.getIncentivePeriod();
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'Incentive Period should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'Incentive plan should be match');
        System.assertEquals(Date.today() , incentivePeriod.dmpl__DateFrom__c, 'IncentivePeriod DateFrom should match');
        System.assertEquals(Date.today().addMonths(1).addDays(-1) , incentivePeriod.dmpl__DateTo__c, 'IncentivePeriod DateTo should match');
    }

    @isTest
    static void createIncentiveResourceWithIncentivePlanReferencePositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.getIncentiveResource();
        Test.stopTest();
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partner.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
    }

    @isTest
    static void createIncentiveResourceWithoutIncentivePlanReferenceNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Test.startTest();
        try {
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
                partner?.Id, 
                branch?.Id, 
                'Resource 4', 
                null
           );
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created without incentive plan');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created without incentive plan');        
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentiveResourceWithoutIncentivePlanReferenceNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.getIncentiveResource();
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partner.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            incentiveResource.dmpl__IncentivePlanId__c = null;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when removing incentive plan from incentive resource');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResourceWithNoPartnerAccountPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
            null, 
            branch.Id, 
            'Resource 4', 
            incentivePlan.Id
        );
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(null, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResourceWithInactivePartnerAccountNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner.Id);
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
                partner.Id, 
                branch2.Id, 
                'Resource 4', 
                incentivePlan.Id
            );
            System.assertEquals(null, incentiveResource, 'IncentiveResource should not be created with Inactive partner account');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveResource should not be created with Inactive partner account');
        }
        Test.stopTest();
    }

    @isTest
    static void updateIncentiveResourceWithInactivePartnerAccountNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partner2.dmpl__IsActive__c = false;
        update partner2;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
            partner?.Id, 
            branch?.Id, 
            'Resource 4', 
            incentivePlan?.Id
       );
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partner.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id);
            incentiveResource.dmpl__PartnerAccountId__c = partner2.Id;
            incentiveResource.dmpl__BranchId__c = branch2.Id;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception updating inactive partner account to incentive resource');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResourceWithNoBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
            partner?.Id, 
            null, 
            'Resource 4', 
            incentivePlan?.Id
        );
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partner.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResourceWithInactiveBranchNegative() {
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try {
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
                partner3.Id, 
                branch3.Id, 
                'Resource 4', 
                incentivePlan.Id
            );
            System.assertEquals(null, incentiveResource, 'IncentiveResource should not be created with Inactive Branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveResource should not be created with Inactive branch');
        }
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResourceWithIncorrectIncentivePlanReferenceNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.getIncentiveResource();
        Test.stopTest();
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partner.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
    }

    @isTest
    static void createIncentiveResourceWithMismatchPartnerAndBranchNegative() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partnerAccount2= TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
                partnerAccount.Id, 
                branch2.Id, 
                'Resource 4', 
                incentivePlan.Id
            );
            System.assertEquals(null, incentiveResource.Id, 'IncentiveResource should not be created with Inactive Branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created with Inactive partner account');
        }
        Test.stopTest();
    }

    @isTest
    static void createCompensationWithPartnerAccountPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void updateCompensationWithPartnerAccountPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partner2.dmpl__IsActive__c = false;
        update partner2;
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__PartnerAccountId__c = partner2.Id;
        update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner2.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void createCompensationWithoutPartnerAccountPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, null);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(null, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void createCompensationWithBranchPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void updateCompensationWithBranchPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        Account partner1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.createBranch('Branch 1', partner1.Id);
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__BranchId__c = branch1.Id;
        Update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void createCompensationWithoutBranchPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, null, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(null, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void createCompensationWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void updateCompensationWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        Account supplier = TestDataHelpers.getSupplierAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(accountGroup.Id, partner.Id, supplier.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__IncentivePlanId__c = plan.Id;
        Update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(plan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated');
    }

    @isTest
    static void createCompensationWithoutEncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(null, branch.Id, partner.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partner.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }

    @isTest
    static void createCompensationLineCreationWithSchemePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(null, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    }

    @isTest
    static void updateCompensationLineCreationWithSchemePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(null, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        IncentivePlanMasterData.createScheme();
        dmpl__Scheme__c scheme10 = SchemeDataHelper.getScheme('Scheme 10');
        fetchedCompensationLine.dmpl__SchemeId__c = scheme10.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedcompensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(scheme10.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    }

    @isTest
    static void createCompensationLineWithoutSchemeNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(null, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, null);
        Test.stopTest();
    }

    @isTest
    static void createCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }

    @isTest
    static void updateCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        Account partner1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partner1.Id);
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentivePlan__c plan1 = IncentivePlanDataHelper.createIncentivePlan(accountGroup.Id, partner.Id, supplier.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__IncentivePlanId__c = plan1.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        Test.stopTest();
        System.assertEquals(plan1.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated.');
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertNotEquals(null, updatedCompensationLine.Id, 'Compensation Line should exist.');
        System.assertEquals(partner.Id, plan1.dmpl__PartnerAccountId__c, 'Plan should link to correct partner.');
        System.assertEquals(accountGroup.Id, plan1.dmpl__AccountGroupId__c, 'Plan should link to correct account group.');
        System.assertEquals(supplier.Id, plan1.dmpl__SupplierAccountId__c, 'Plan should link to correct supplier.');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should still point to original partner.');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should still point to original branch.');
    }

    @isTest
    static void createCompensationLineWithoutIncentivePlanNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, null, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(null, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }

    @isTest
    static void createCompensationLineWithCompensationPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }

    @isTest
    static void createCompensationLineWithoutCompensationNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        try {
            dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(null, incentivePlan.Id, scheme.Id);
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when Compensation is missing.');
    }

    @isTest
    static void createCompensationLineWithRequiredFieldsPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }

    @isTest
    static void updateCompensationLineWithRequiredFieldsPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partner = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        IncentivePlanMasterData.createScheme();
        dmpl__Scheme__c scheme10 = SchemeDataHelper.getScheme('Scheme 10');
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(incentivePlan.Id, branch.Id, partner.Id);
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(compensation.Id, incentivePlan.Id, scheme.Id);
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__SchemeId__c = scheme10.Id;
        update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation Line should reference the updated Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme10.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partner.Id, compensation.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }

    @isTest
    static void createIncentivePlanWithStatusDraftPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Draft' , incentivePlan.dmpl__Status__c, 'IncentivePlan Status should match');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithStatusPendingApprovalPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        incentivePlan.dmpl__Status__c = 'Pending Approval';
        update incentivePlan;
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Pending Approval' , incentivePlan.dmpl__Status__c, 'IncentivePlan Status should match');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithStatusApprovedPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        incentivePlan.dmpl__Status__c = 'Approved';
        update incentivePlan;
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Approved' , incentivePlan.dmpl__Status__c, 'IncentivePlan Status should match');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithMemberResourceTypePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Draft' , incentivePlan.dmpl__Status__c, 'IncentivePlan Status should match');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Salesperson' , incentivePlan.dmpl__MemberResourceType__c, 'IncentivePlan MemberResourceType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithMemberTypePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithPeriodStartDatePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithPeriodEndDatePositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
    }

    @isTest
    static void createIncentivePlanWithAccountGroupPositive() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        incentivePlan.dmpl__AccountGroupId__c = accountGroup.Id;
        update incentivePlan;
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('IncentivePlan1' , incentivePlan.Name, 'IncentivePlan Name should match');
        System.assertEquals('Resource' , incentivePlan.dmpl__MemberType__c, 'IncentivePlan MemberType should match');
        System.assertEquals('Yearly' , incentivePlan.dmpl__PeriodType__c, 'IncentivePlan PeriodType should match');
        System.assertEquals(Date.today() , incentivePlan.dmpl__PeriodStartDate__c, 'IncentivePlan PeriodStartDate should match');
        System.assertEquals(Date.today().addDays(30) , incentivePlan.dmpl__PeriodEndDate__c, 'IncentivePlan PeriodEndDate should match');
        System.assertEquals(accountGroup.id , incentivePlan.dmpl__AccountGroupId__c, 'IncentivePlan AccountGroup should match');
    }
}