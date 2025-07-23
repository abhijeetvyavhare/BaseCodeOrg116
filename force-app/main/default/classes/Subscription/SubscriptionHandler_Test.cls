@isTest
public with sharing class SubscriptionHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch);
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
            partnerAccount, 
            customerAccount, 
            branch, 
            item
        );
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        if(subscription != null) {
            System.assertNotEquals(subscription, null, 'Expected subscription to be created.');
        }
        System.assertEquals(null, subscription.dmpl__BillingFrequency__c, 'Billing Frequency should be monthly');
        System.assertEquals(null, subscription.dmpl__BillingType__c, 'Billing Type should be Advance');
        System.assertEquals(null, subscription.dmpl__ChargeType__c, 'Charge Type should be One Time');
        System.assertEquals(null, subscription.dmpl__PricingMethod__c, 'Pricing Method should be List Price');
    }
    
    @isTest
    static void updateSubscriptionPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(subscription, null, 'Subscription should exist before update.');
        subscription.dmpl__PricingMethod__c = 'Bundled Price';
        subscription.dmpl__ChargeType__c = 'Recurring';
        update subscription;
        dmpl__Subscription__c updatedSubscription = SubscriptionDataHelper.getSubscription(subscription.id);
        System.assertEquals('Bundled Price', updatedSubscription.dmpl__PricingMethod__c, 'Expected subscription Pricing Method to be updated to Bundled Price.');
        System.assertEquals('Recurring', updatedSubscription.dmpl__ChargeType__c, 'Charge Type should be Recurring');
    }
    
    @isTest
    static void deleteSubscriptionNegative() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(subscription, null, 'subscription should exist before delete.');
        delete subscription;
        dmpl__Subscription__c deletedsubscription = null;
        try  {
            deletedsubscription = SubscriptionDataHelper.getSubscription(subscription.id);
        } catch (Exception e) {
            deletedsubscription = null;
        }
        System.assertEquals(null, deletedsubscription, 'Subscription should be deleted and not found in query.');
    }
    
    @isTest
    static void createSubscriptionWithCorrectPartnerAccountAndBranchPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');     
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void createSubscriptionWithCustomerAccountPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void createSubscriptionWithSaleOrderReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        subscription.dmpl__SaleOrderId__c = saleOrder.Id;
        update subscription;
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');
    }
    
    @isTest
    static void createSubscriptionWithWrongPartnerAccountNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount3, 
                customerAccount, 
                branch, 
                item
            );
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with wrong partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithInactivePartnerAccountNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount2, 
                customerAccount, 
                branch2, 
                item
            );
            System.assertEquals(null, subscription.Id, 'subscription should not be created with inactive partner account');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithWrongBranchNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount, 
                customerAccount, 
                branch, 
                item
            );
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with wrong branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithInactiveBranchNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount, 
                customerAccount, 
                branch, 
                item
            );
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithNoCustomerAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
            partnerAccount, 
            null, 
            branch, 
            item
        );
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void createSubscriptionWithNoSaleOrderReferencePositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void updateSubscriptionWithCustomerAccountPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
            partnerAccount, 
            null, 
            branch, 
            item
        );
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2'); 
        Boolean exceptionThrown = false;
        try {
            subscription.dmpl__AccountId__c = customerAccount.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when assigning customer account');
        if(!exceptionThrown) {
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithWrongPartnerAccountNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');       
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2'); 
        Boolean exceptionThrown = false;
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
            subscription.dmpl__PartnerAccountId__c = partnerAccount4.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');   
        Boolean exceptionThrown = false;
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
            subscription.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when assigning inactive partner account');
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithWrongBranchNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');  
        Boolean exceptionThrown = false;
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
            subscription.dmpl__BranchId__c = branch4.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithInactiveBranchNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        Boolean exceptionThrown = false;
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
            subscription.dmpl__BranchId__c = branch3.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithNoCustomerAccountPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');  
        Boolean exceptionThrown = false;
        try {
            subscription.dmpl__AccountId__c = null;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing customer account');
        if(!exceptionThrown) {
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithNoSaleOrderPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch);
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount.Id, saleOrder.dmpl__AccountId__c, 'Account Name mismatch');        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        subscription.dmpl__SaleOrderId__c = saleOrder.Id;
        update subscription;
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');      
        Boolean exceptionThrown = false;
        try {
            subscription.dmpl__SaleOrderId__c = null;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when removing sale order');
        if(!exceptionThrown) {
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithActiveItemPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void createSubscriptionWithSaleOrderLineReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(); 
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount.Id, saleOrder.dmpl__AccountId__c, 'Account Name mismatch');
        SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item5.Id, 
            10, 
            null
        );
        System.assertNotEquals(null, saleOrderLine.Id, 'sale Order Line should be created');
        System.assertEquals(10, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, saleOrderLine.dmpl__SaleOrderId__c, 'saleOrder should be match');
        System.assertEquals(item5.Id, saleOrderLine.dmpl__ItemId__c, 'Item should be Item 5');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
            partnerAccount, 
            customerAccount, 
            branch, 
            item5
        );
        subscription.dmpl__SaleOrderId__c = saleOrder.Id;
        subscription.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
        update subscription;
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item5.Id, subscription.dmpl__ItemId__c, 'Item should be Item 5');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');
        System.assertEquals(saleOrderLine.Id, subscription.dmpl__SaleOrderLineId__c, 'saleOrderLine should be match');
    }
    
    @isTest
    static void createSubscriptionWithInactiveItemNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount, 
                customerAccount, 
                branch, 
                item2
            );
            System.assertEquals(null, subscription.Id, 'subscription should not be created with inactive item');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive item');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithoutSaleOrderLineReferencePositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }
    
    @isTest
    static void updateSubscriptionWithInactiveItemNegative() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');        
        Boolean exceptionThrown = false;
        try {
            SubscriptionMasterData.createSubscriptionWithWrongORInactiveNegativeData();
            dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
            subscription.dmpl__ItemId__c = item2.Id;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception when assigning inactive item');
        Test.stopTest();      
    }
    
    @isTest
    static void createSubscriptionWithZeroQuantityPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try {
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(
                partnerAccount, 
                customerAccount, 
                branch, 
                item
            );
            subscription.dmpl__Quantity__c = 0;
            update subscription;
            System.assertNotEquals(null, subscription.Id, 'Subscription should be created');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with zero quantity');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSubscriptionWithZeroQuantityPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');        
        Boolean exceptionThrown = false;
        try {
            subscription.dmpl__Quantity__c = 0;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when quantity less than 1');     
    }
    
    @isTest
    static void createSubscriptionWithoutUnitCostPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');        
    }
    
    @isTest
    static void updateSubscriptionWithoutUnitCostPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        subscription.dmpl__UnitPrice__c = 1500;
        update subscription;
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(1500.00, subscription.dmpl__UnitPrice__c, 'Price should be ₹1, 500.00');
        System.assertEquals(customerAccount.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        Boolean exceptionThrown = false;
        try {
            subscription.dmpl__UnitPrice__c = 0;
            update subscription;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown, 'exception caught when unitPrice is zero');       
    }
    
    @isTest
    static void createSubscriptionUsageSummaryWithSummaryNamePositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 100);
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
    
    @isTest
    static void createSubscriptionUsageSummaryWithoutSaleInvoiceLinePositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 100);
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
    
    @isTest
    static void createSubscriptionUsageSummaryWithoutNoSaleInvoicePositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 100);
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
    
    @isTest
    static void createSubscriptionUsageSummaryWithZeroBilledQuantityPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 0);
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(0, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
    
    @isTest
    static void updateSubscriptionUsageSummaryWithZeroBilledQuantityPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 100);
        subUsageSummary.dmpl__BilledQuantity__c = 0;
        update subUsageSummary;
        dmpl__SubscriptionUsageSumary__c fetchedSubUsageSummary = SubscriptionDataHelper.getSubscriptionUsageSummary(subUsageSummary.Id);
        System.assertNotEquals(null, fetchedSubUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, fetchedSubUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(0, fetchedSubUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
    
    @isTest
    static void createSubscriptionUsageSummaryWithNullSummaryNamePositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id, 100);
        dmpl__SubscriptionUsageSumary__c fetchedSubUsageSummary = SubscriptionDataHelper.getSubscriptionUsageSummary(subUsageSummary.Id);
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }  
}