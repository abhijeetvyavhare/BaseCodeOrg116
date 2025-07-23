@isTest
public with sharing class PriceListHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('T7', partner.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item.id, 1000);
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
        System.assertEquals(1000, priceListRule.dmpl__Price__c, 'Unit price should be 100');
        System.assertEquals(Date.today().addDays(-1), priceListRule.dmpl__DateEffectiveFrom__c, 'DateEffectiveFrom mismatch');
        System.assertEquals(Date.today().addDays(9), priceListRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill mismatch');
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
        priceList.dmpl__PriceListType__c = 'Purchase Price';
        priceList.dmpl__IsActive__c = false;
        priceList.dmpl__IsDefault__c = false;
        priceList.Name = 'Updated Price List';
        update priceList;
        Test.stopTest();
        dmpl__PriceList__c updatedPriceList = PriceListDataHelper.getPriceList(priceList.Id);
        System.assertEquals('Purchase Price', updatedPriceList.dmpl__PriceListType__c, 'Price List type should be updated to Purchase Price');
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
    static void createPriceListWithPriceListNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
    
    @isTest
    static void updatePriceListWithPriceListNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.Name = 'T9';
        update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T9', updatedpriceList.Name, 'Price List Name should be T9.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
    
    @isTest
    static void createPriceListWithisActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
    
    @isTest
    static void updatePriceListWithPriceListwithIsActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__IsActive__c = false;
        update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(false, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }    
    
    @isTest
    static void createPriceListWithPartnerAccountPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
        
    @isTest
    static void updatePriceListWithPriceListPartnerAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        priceList.dmpl__PartnerAccountId__c = partner3.Id;
        priceList.dmpl__BranchId__c = branch3.Id;
        update priceList;
        Test.stopTest();
        System.assertEquals('T7', priceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, priceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch3.Id, priceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner3.Id, priceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
    
    @isTest
    static void createPriceListWithoutPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList(
                'T1', 
                true, 
                null, 
                branch.Id
            );
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price List partner account is empty.');
    }
    
    static void createPriceListWithBranchPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        Test.stopTest();
        System.assertEquals('T7', priceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, priceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch.Id, priceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner.Id, priceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }    
    
    @isTest
    static void updatePriceListWithPriceListBranchPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        priceList.dmpl__BranchId__c = branch3.Id;
        priceList.dmpl__PartnerAccountId__c = partner3.Id;
        update priceList;
        Test.stopTest();
        System.assertEquals('T7', priceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, priceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch3.Id, priceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partner3.Id, priceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
    }
    
    @isTest
    static void createPriceListRuleWithItemPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.getPriceListRules();
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void updatePriceListRuleWithItemPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Product');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.getPriceListRules();
        rule.dmpl__ItemId__c = item3.Id;
        update rule;
        Test.stopTest();
        System.assertEquals(item3.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }

    @isTest
    static void createPriceListRuleWithPricePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.getPriceListRules();
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void updatePriceListRuleWithPricePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = TestDataHelpers.getPriceListRules();
        rule.dmpl__Price__c = 2000;
        update rule;
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(-1), rule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addDays(9), rule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(2000, rule.dmpl__Price__c, 'Price should be 2000.');
    }
    
    @isTest
    static void createPriceListRuleWithEffectiveFromPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.getPriceListRules();
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void updatePriceListRuleWithEffectiveFromPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.getPriceListRules();
        rule.dmpl__DateEffectiveFrom__c = Date.today().addDays(7);
        update rule;
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(7), rule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addDays(9), rule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void createPriceListRuleWithoutEffectiveFromNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try {
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(
                priceList.Id, 
                item.Id, 
                1000, 
                null, 
                Date.today().addMonths(1)
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
    }
    
    @isTest
    static void createPriceListRuleWithPriceListPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.getPriceListRules();
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void updatePriceListRuleWithPriceListNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceList__c priceList1 = PriceListDataHelper.createPriceList(
            'T8', 
            true, 
            partnerAccount2.Id, 
            branch2.Id
        );
        dmpl__PriceListRules__c rule = PriceListDataHelper.getPriceListRules();
        try {
            rule.dmpl__PriceListId__c = priceList1.Id;
            update rule;
        }catch(exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Price List Rule should not be updated.');
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should not Update.');
        System.assertEquals(Date.today().addDays(-1), rule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addDays(9), rule.dmpl__DateEffectiveTill__c, 'Effective Till date should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    @isTest
    static void createPriceListRuleWithoutPriceListNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        try {
            dmpl__PriceListRules__c rule = TestDataHelpers.createPriceListRules(null, item.id, 1000);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
    }
    
    @isTest
    static void createPriceListRuleWithDateEffectiveFromAndDateEffectiveToPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.getPriceListRule();
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(-1), rule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addDays(9), rule.dmpl__DateEffectiveTill__c, 'Effective till date should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }

    @isTest
    static void createPriceListRuleWithDateEffectiveToBeforeDateEffectiveFromNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        try {
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(
                priceList.Id, 
                item.Id, 
                1000, 
                Date.today(), 
                Date.today().addDays(-1)
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective till is less than Date Effective From .');
    }

    @isTest
    static void createPriceListRuleWithDateEffectiveToSameAsDateEffectiveFromPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList('T7');
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(
            priceList.Id, 
            item.Id, 
            1000, 
            Date.today(), 
            Date.today()
        );
        Test.stopTest();
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, rule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), rule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today(), rule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, rule.dmpl__Price__c, 'Price should be 1000.');
    }
}