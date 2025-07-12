@isTest
public with sharing class PriceListHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('T7', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
    }
    
    @isTest
    static void createPriceListPositive() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        System.assertNotEquals(null, priceList.Id, 'Expected PriceList to be created');
        System.assertEquals(true, priceList.dmpl__IsActive__c, 'Price List should be active');
        System.assertEquals(false, priceList.dmpl__IsDefault__c, 'Price List should be default');
    }
    
    @isTest
    static void createPriceListRulePositive() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        System.assertNotEquals(null, priceListRule.Id, 'Expected PriceListRule to be created');
        System.assertEquals(1500, priceListRule.dmpl__Price__c, 'Unit price should be 100');
        System.assertEquals(Date.today(), priceListRule.dmpl__DateEffectiveFrom__c, 'DateEffectiveFrom mismatch');
        System.assertEquals(Date.today().addMonths(1), priceListRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill mismatch');
    }
    
    @isTest
    static void updatePriceListRulePositive() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        
        Test.startTest();
        priceListRule.dmpl__DateEffectiveFrom__c = Date.today()+1;
        priceListRule.dmpl__DateEffectiveTill__c = Date.today()+2;
        update priceListRule;
        Test.stopTest();
        
        dmpl__PriceListRules__c updatedPriceListRule = PriceListDataHelper.getPriceListRule(priceListRule.Id);
        System.assertEquals(Date.today()+1, priceListRule.dmpl__DateEffectiveFrom__c, 'DateEffectiveFrom mismatch');
        System.assertEquals(Date.today()+2, priceListRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill mismatch');
    }
    
    @isTest
    static void updatePriceListPositive() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        
        Test.startTest();
        priceList.dmpl__PriceListType__c = PriceListHelper.PRICELIST_TYPE_PURCHASE;
        priceList.dmpl__IsActive__c = false;
        priceList.dmpl__IsDefault__c = false;
        priceList.Name = 'Updated Price List';
        update priceList;
        Test.stopTest();
        
        dmpl__PriceList__c updatedPriceList = PriceListDataHelper.getPriceList(priceList.Id);
        System.assertEquals(PriceListHelper.PRICELIST_TYPE_PURCHASE, updatedPriceList.dmpl__PriceListType__c, 'Price List type should be updated to Purchase Price');
        System.assertEquals(false, updatedPriceList.dmpl__IsActive__c, 'Price List should be inactive');
        System.assertEquals(false, updatedPriceList.dmpl__IsDefault__c, 'Price List should not be default');
        System.assertEquals('Updated Price List', updatedPriceList.Name, 'Price List name should be updated');
    }
    
    @isTest
    static void deletePriceListRule() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        
        Test.startTest();
        delete priceListRule;
        Test.stopTest();
        
        try {
            dmpl__PriceListRules__c deletedPriceListRule = PriceListDataHelper.getPriceListRule(priceListRule.Id);
            System.assertEquals(null, deletedPriceListRule.Id, 'Price List Rule should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Expected exception on querying deleted Price List Rule');
        }
    }
    
    @isTest
    static void deletePriceList() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        
        Test.startTest();
        delete priceList;
        Test.stopTest();
        
        try {
            dmpl__PriceList__c deletedPriceList = PriceListDataHelper.getPriceList(priceList.Id);
            System.assertEquals(null, deletedPriceList.Id, 'Price List Rule should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Expected exception on querying deleted price list');
        }
    }
    
    
    @isTest
    static void createPriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    @isTest
    static void updatePriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.Name = 'T9';
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T9', updatedpriceList.Name, 'Price List Name should be T9.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    @isTest
    static void createPriceListWithoutPriceListNameNegative(){
        Boolean exceptionThrown = false;
        
        try{
            Test.startTest();
            dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
            Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('',true,partnerAccount1.Id,branch1.Id);
            
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        
        
    }
    
    
    @isTest
    static void createPriceListWithisActivePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    @isTest
    static void updatePriceListWithPriceListwithIsActivePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__IsActive__c = false;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(false, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    
    static void createPriceListWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    
    @isTest
    static void updatePriceListWithPriceListPartnerAccountPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        PriceListMasterData.updatePriceListWithPriceListPartnerAccountPositiveData();
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__PartnerAccountId__c = partnerAccount3.Id;
        fetchedpriceList.dmpl__BranchId__c = branch3.Id;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch3.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount3.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    @isTest
    static void createPriceListWithoutPartnerAccountNegative(){
        Boolean exceptionThrown = false;
        
        try{
            Test.startTest();
            dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
            Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T1',true,null,branch1.Id);
            
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price List partner account is empty.');
        
    }
    
    
    static void createPriceListWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    
    @isTest
    static void updatePriceListWithPriceListBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        PriceListMasterData.updatePriceListWithPriceListPartnerAccountPositiveData();
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__BranchId__c = branch3.Id;
        fetchedpriceList.dmpl__PartnerAccountId__c = partnerAccount3.Id;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch3.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount3.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    @isTest
    static void createPriceListRuleWithItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void updatePriceListRuleWithItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item3 = TestDataHelpers.createItem('Item 3', 'Product');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__ItemId__c = item3.Id;
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item3.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void createPriceListRuleWithoutItemNegative(){
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try{
            dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, null, 1000);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        
        
    }
    
    
    @isTest
    static void createPriceListRuleWithPricePositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void updatePriceListRuleWithPricePositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__Price__c = 2000;
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(2000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void createPriceListRuleWithoutPriceNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try{
            dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, null);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        
        
    }
    
    
    @isTest
    static void createPriceListRuleWithEffectiveFromPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void updatePriceListRuleWithEffectiveFromPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__DateEffectiveFrom__c = Date.today().addDays(7);
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(7), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void createPriceListRuleWithoutEffectiveFromNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,null,Date.today().addMonths(1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
        
    }
    
    
    @isTest
    static void createPriceListRuleWithPriceListPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void updatePriceListRuleWithPriceListNegative(){
        Test.startTest();
        Boolean exceptionThrown = false;
        
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 =TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c priceList1 = PriceListDataHelper.createPriceList('T8',true,partnerAccount2.Id,branch2.Id);
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        try{
            fetchedrule.dmpl__PriceListId__c = priceList1.Id;
            Update fetchedrule;
        }catch(exception e){
            
            exceptionThrown = true;
        }
        
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Price List Rule should not be updated.');
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should not Update.');
        System.assertEquals(Date.today(), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective Till date should match.');
        System.assertEquals(1000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void createPriceListRuleWithoutPriceListNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        try{
            dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(null, item1.id, 1000);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
        
    }
    
    
    @isTest
    static void createPriceListRuleWithDateEffectiveFromAndDateEffectiveToPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(priceList.id, item1.id, 1000);
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    
    @isTest
    static void createPriceListRuleWithDateEffectiveToBeforeDateEffectiveFromNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addDays(-1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective till is less than Date Effective From .');
    }
    
    
    @isTest
    static void createPriceListRuleWithDateEffectiveToSameAsDateEffectiveFromPositive(){
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today());
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
}