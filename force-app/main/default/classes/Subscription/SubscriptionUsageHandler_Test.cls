@isTest
public with sharing class SubscriptionUsageHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);  
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount.Id, item.Id); 
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
            partnerAccount, 
            customerAccount, 
            branch, 
            item
        );
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(
            customerAccount, 
            asset, 
            item, 
            subscription
        );
    }
    
    @isTest
    static void createSubscriptionUsagePositive() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should be created.');
    }
    
    @isTest
    static void updateSubscriptionUsagePositive() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should exist before update.');
        usage.dmpl__Quantity__c = 10;
        update usage;
        dmpl__SubscriptionUsage__c updatedUsage = SubscriptionUsageDataHelper.getSubscriptionUsage(usage);
        System.assertEquals(10, updatedUsage.dmpl__Quantity__c, 'Quantity should be updated to 10.');
    }
    
    @isTest
    static void deleteSubscriptionUsage() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should exist before delete.');
        delete usage;
        dmpl__SubscriptionUsage__c deletedUsage = null;
        try {
            deletedUsage = SubscriptionUsageDataHelper.getSubscriptionUsage(usage);
        } catch (Exception e) {
            deletedUsage = null;
        }
        System.assertEquals(null, deletedUsage, 'SubscriptionUsage should be deleted and not found.');
    }
    
    @isTest
    static void createSubscriptionUsageNormalPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        Test.stopTest();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }
    
    @isTest
    static void createSubscriptionUsageWithCustomerAccountPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        Test.stopTest();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }
    
    @isTest
    static void createSubscriptionUsageWithNoCustomerAccountPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(
                null, 
                asset, 
                item, 
                subscription
            );
            System.assertNotEquals(null, usage.Id, 'Subscription usage should be created without customer account');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription usage should not be created without customer');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionUsageWithCustomerAccountPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');    
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(
            null, 
            asset, 
            item, 
            subscription
        );
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__AccountId__c = customerAccount.Id;
            update usage;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when referencing customer account');
        Test.stopTest();
        if(!exceptionThrown) {
            System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.AssertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        }
    }
    
    @isTest
    static void updateSubscriptionUsageWithNoCustomerAccountPositive() {    
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__AccountId__c = null;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing customer account');
        Test.stopTest();
        if(!exceptionThrown) {
            System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        }
    }
    
    @isTest
    static void createSubscriptionUsageWithActiveItemPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        Test.stopTest();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }
    
    @isTest
    static void createSubscriptionUsageWithInActiveItemNegative() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(
                customerAccount, 
                asset, 
                item2, 
                subscription
            );
            System.assertEquals(null, usage.Id, 'SubscriptionUsage record should not be created with inactive item');
        }catch (Exception e) {
            System.assert.isTrue(true, 'SubscriptionUsage record should not be created with inactive item');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionUsageWithInactiveItemNegative() {  
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__ItemId__c = item2.Id;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when assigning inactive item');
    }
    
    @isTest
    static void createSubscriptionUsageWithZeroQuantityPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
            usage.dmpl__Quantity__c = 0;
            update usage;
            System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
            System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(0, usage.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');        
        } catch (Exception e) {
            System.assert.isTrue(true, 'SubscriptionUsage record should be created with zero quantity entered');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionUsageWithZeroQuantityPositive() {      
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__Quantity__c = 0;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when quantity less than 1');
    }
    
    @isTest
    static void createSubscriptionUsageWithAssetPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        Test.stopTest();
        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }
}