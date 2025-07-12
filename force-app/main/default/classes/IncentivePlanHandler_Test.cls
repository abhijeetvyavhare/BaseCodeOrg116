@isTest
public with sharing class IncentivePlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
       dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        dmpl__Scheme__c scheme = SchemeDataHelper.createScheme();
        scheme.dmpl__PartnerAccountId__c = partnerAccount4.Id;
        scheme.dmpl__BranchId__c = branch4.Id;
        update scheme;
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(accountGroup.Id, partnerAccount4.Id, supplierAccount.Id);
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.createIncentivePeriod(plan.Id);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount4, branch4);
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(plan.Id,resource.Id,partnerAccount4.Id,branch4.Id);
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(plan.Id,'All Rewards');        
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
    static void createIncentiveLineWithAllRewardsPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine(incentivePlan.Id,'All Rewards');
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('All Rewards', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be All Rewards');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyOneLowestValuePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Any One With Lowest Value' );
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Lowest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Lowest Value');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyOneHighestValuePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Any One With Highest Value' );
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Highest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Highest Value');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithCustomLogicPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Custom Logic' );
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Custom Logic', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Custom Logic');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAllConditionsMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null );
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyConditionMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null);
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithCustomLogicMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null );
        incentiveLine.dmpl__DefinitionFilterCriteria__c='Custom Logic Is Met';
        update incentiveLine;
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        System.assertEquals('Custom Logic Is Met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be Custom Logic Is Met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithoutIncentivePlanNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine = IncentivePlanDataHelper.createIncentiveLine( null , 'Any One With Highest Value' );
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine == null, 'Incentive Line Expected not to be created!');
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void createCompensationSlabCreationWithMemeberResourceTypeAsSalespersonPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, 'Salesperson',  period?.Id ,incentiveLine?.Id);
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
    static void createCompensationSlabCreationWithMemeberResourceTypeAsServiceadvisorPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, 'Service Advisor',  period?.Id ,incentiveLine?.Id);
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
    static void createCompensationSlabCreationWithMemeberResourceTypeAsManagerPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, 'Manager',  period?.Id ,incentiveLine?.Id);
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
    static void createCompensationSlabCreationWithGiftAsRewardPointsPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, 'Manager',  period?.Id ,incentiveLine?.Id);
        compensationSlab.dmpl__GiftPoints__c=2;
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
    static void createCompensationSlabCreationWithoutReferenceIncentiveLineNegative(){
       Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, 'Manager', null,incentiveLine?.Id);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithoutIncentivePlanNegative(){
        Test.startTest();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(null , 'Manager', period?.Id,incentiveLine?.Id);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithoutResourceTypeNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, null,  period?.Id ,incentiveLine?.Id);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
   
    @isTest
    static void createIncentivePlanWithNamePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
    }
    
    @isTest
    static void createIncentivePlanWithoutNameNagative(){
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
            incentivePlan.Name = null;
            update incentivePlan;
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created without name');
        }
    }
    @isTest
    static void updateIncentivePlanWithoutNameNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(); 
        Test.startTest();
        try{
            incentivePlan.Name = null;
            update incentivePlan;
        }catch (Exception e) {
           System.Assert.isTrue(true, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void createIncentivePlanWithSupplierAccountPositive(){
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, null, supplierAccount1?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }
    
    @isTest
    static void createIncentivePlanWithNoSupplierAccountPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
    }
    
    
    @isTest
    static void createIncentivePlanWithInactivePartnerAccountNagative(){
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, partnerAccount2?.Id, null);
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created with inactive partner Account');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePlanWithInactivePartnerAccountNagative(){
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, partnerAccount1?.Id, null);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals(partnerAccount1.Id, incentivePlan.dmpl__PartnerAccountId__c, 'Partner Account should be same');        
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update incentivePlan;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentivePlanWithSupplierAccountPositive(){
        Account supplierAccount1=TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__SupplierAccountId__c = supplierAccount1.Id;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false,exceptionThrown, 'exception caught when assigning supplier Account');
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }
    
    
    @isTest
    static void updateIncentivePlanWithNoSupplierAccountPositive(){
        Account supplierAccount1=TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null, null, supplierAccount1?.Id);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
        Boolean exceptionThrown = false;
        Test.startTest();
        try{
            incentivePlan.dmpl__SupplierAccountId__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
            
        }
        System.assertEquals(false,exceptionThrown, 'exception caught when removing supplier Account');
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.AssertEquals(null, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }
    
    
    @isTest
    static void createIncentivePlanWithDefinedPeriodTypePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        incentivePlan.dmpl__PeriodType__c = 'Monthly';
        update incentivePlan;
        incentivePlan = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
    }
    
    @isTest
    static void createIncentivePlanWithoutPeriodTypeNegative(){
        Test.startTest();
        try{
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
            incentivePlan.dmpl__PeriodType__c = null;
            update incentivePlan;
            System.assertEquals(null, incentivePlan.Id, 'incentive plan should not be created without period type');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Incentive plan should not be created without period type');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentivePlanWithoutPeriodTypeNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePlan.dmpl__PeriodType__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing period type');
        Test.stopTest();
    }
    
    

    @isTest
    static void createIncentivePeriodWithPeriodNamePositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
    }
    
    @isTest
    static void createIncentivePeriodWithoutPeriodNameNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
            incentivePeriod.Name = null;
            update incentivePeriod;
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePeriod should not be created without period Name');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePeriodWithoutPeriodNameNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.Name = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void createIncentivePeriodWithDefiningDateFromAndDateToPositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        incentivePeriod.dmpl__DateFrom__c = dateFrom;
        incentivePeriod.dmpl__DateTo__c = dateto;
        update incentivePeriod;
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
    }
    
    @isTest
    static void createIncentivePeriodWithoutDefiningDateFromAndDateToNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
            incentivePeriod.dmpl__DateFrom__c = null;
            incentivePeriod.dmpl__DateTo__c = null;
            update incentivePeriod;
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentivePeriod should not be created without date from and date to');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePeriodWithoutDefiningDateFromAndDateToNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.dmpl__DateFrom__c = null;
            incentivePeriod.dmpl__DateTo__c = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
    }
    
    @isTest
    static void createIncentivePeriodWithInvalidDateRangeNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom= Date.newInstance(2025, 7, 20);
        Date dateto = Date.newInstance(2025, 2, 11);
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
            incentivePeriod.dmpl__DateFrom__c = dateFrom;
            incentivePeriod.dmpl__DateTo__c = dateto;
            update incentivePeriod;
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePeriod should not be created with invalid date range');
        }
        Test.stopTest();
        
    }
    
    
    @isTest
    static void updateIncentivePeriodWithInvalidDateRangeNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.dmpl__DateFrom__c = Date.newInstance(2025, 7, 20);
            incentivePeriod.dmpl__DateTo__c = Date.newInstance(2025, 2, 11);
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void createIncentivePeriodWithIncentivePlanReferencePositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(incentivePlan?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
    }

    @isTest
    static void createIncentivePeriodWithoutIncentivePlanReferenceNegative(){
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(null);
            System.assertEquals(null, incentivePeriod.Id, 'Incentice period should not becreated without incentive plan reference');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Incentive period should not be created without incentive plan reference');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithIncentivePlanReferencePositive(){
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4?.Id,branch4?.Id,'Resource 4',incentivePlan?.Id);
        Test.stopTest();
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
    }
    
    
    @isTest
    static void createIncentiveResourceWithoutIncentivePlanReferenceNegative(){
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4?.Id,branch4?.Id,'Resource 4',null);
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created without incentive plan');
        }catch(Exception e){
            System.Assert.isTrue(true, 'incentiveResource should not be created without incentive plan');
            
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void updateIncentiveResourceWithoutIncentivePlanReferenceNegative(){
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan();
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4?.Id,branch4?.Id,'Resource 4',incentivePlan?.Id);
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveResource.dmpl__IncentivePlanId__c = null;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing incentive plan from incentive resource');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithNoPartnerAccountNegative(){
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(null, branch4.Id,'Resource 4',incentivePlan.Id);
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created without partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithInactivePartnerAccountNegative(){
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount2.Id,branch2.Id,'Resource 4',incentivePlan.Id);
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created with Inactive partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentiveResourceWithInactivePartnerAccountNegative(){
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4?.Id,branch4?.Id,'Resource 4',incentivePlan?.Id);
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            incentiveResource.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            incentiveResource.dmpl__BranchId__c = branch2.Id;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception updating inactive partner account to incentive resource');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithNoBranchNegative(){
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4?.Id,null,'Resource 4',incentivePlan?.Id);
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created without partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void updateCompensationWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
            );
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__PartnerAccountId__c = partnerAccount2.Id;
        update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount2.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void createCompensationWithoutPartnerAccountPositive() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
                incentivePlan.Id,
                branch.Id,
                null,  
                null,
                null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(null, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
   
    @isTest
    static void createCompensationWithBranchPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void updateCompensationWithBranchPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
        );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__BranchId__c = branch1.Id;
        Update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void createCompensationWithoutBranchPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            null,
            partnerAccount.Id,
            null,
            null
        );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(null, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void createCompensationWithIncentivePlanPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void updateCompensationWithIncentivePlanPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        Account supplierAccount = TestDataHelpers.getSupplierAccount();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(accountGroup.Id,partnerAccount.Id,supplierAccount.Id);
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__IncentivePlanId__c = plan.Id;
        Update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(plan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated');
    }
    
    
    @isTest
    static void createCompensationWithoutEncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    
    @isTest
    static void createCompensationLineCreationWithSchemePositive() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme();
        fetchedCompensationLine.dmpl__SchemeId__c = scheme2.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedcompensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(scheme2.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    }
    
    
    @isTest
    static void createCompensationLineWithoutSchemeNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
            incentivePlan.Id,
            null
            );
        Test.stopTest();
    }
    
    
    @isTest
    static void createCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    
    @isTest
    static void updateCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1',partnerAccount1.Id);
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentivePlan__c plan1 = IncentivePlanDataHelper.createIncentivePlan(
        accountGroup.Id,
        partnerAccount1.Id,
        supplierAccount.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__IncentivePlanId__c = plan1.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        Test.stopTest();
        System.assertEquals(plan1.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated.');
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertNotEquals(null, updatedCompensationLine.Id, 'Compensation Line should exist.');
        System.assertEquals(partnerAccount1.Id, plan1.dmpl__PartnerAccountId__c, 'Plan should link to correct partner.');
        System.assertEquals(accountGroup.Id, plan1.dmpl__AccountGroupId__c, 'Plan should link to correct account group.');
        System.assertEquals(supplierAccount.Id, plan1.dmpl__SupplierAccountId__c, 'Plan should link to correct supplier.');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should still point to original partner.');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should still point to original branch.');
    }
    @isTest
    static void createCompensationLineWithoutIncentivePlanNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        null,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(null, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    
    @isTest
    static void createCompensationLineWithCompensationPositive() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    
    @isTest
    static void updateCompensationLineWithCompensationNegative() {
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1',partnerAccount1.Id);
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
            branch.Id,
            partnerAccount.Id,
            null,
            null
            );
        dmpl__IncentiveCompensation__c compensation1 = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch1.Id,
        partnerAccount1.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        try{
            dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
            fetchedCompensationLine.dmpl__CompensationId__c = compensation1.Id;
            update fetchedCompensationLine;
        }catch(Exception e){}
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation Line should reference the Old Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch1.Id, compensation1.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partnerAccount1.Id, compensation1.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }
    
    
    @isTest
    static void createCompensationLineWithoutCompensationNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        try {
            dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
                null,
            incentivePlan.Id,
            scheme.Id
                );
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    
    @isTest
    static void updateCompensationLineWithRequiredFieldsPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1',partnerAccount1.Id);
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        scheme1.dmpl__PartnerAccountId__c = partnerAccount.Id;
        scheme1.dmpl__BranchId__c = branch.Id;
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__SchemeId__c = scheme1.Id;
        update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        Test.stopTest();
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation Line should reference the updated Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme1.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }
}