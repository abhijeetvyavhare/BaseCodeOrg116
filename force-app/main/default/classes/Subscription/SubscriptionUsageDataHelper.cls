@isTest
public with sharing class SubscriptionUsageDataHelper {
    public static dmpl__SubscriptionUsage__c createSubscriptionUsage(
        Account acc, 
        dmpl__SaleInvoiceLine__c saleInvoiceLine
    ) {
        return (dmpl__SubscriptionUsage__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsage__c(
                dmpl__AccountId__c = acc.Id, 
                dmpl__AssetId__c = saleInvoiceLine.dmpl__AssetId__c
            ), 
            'SubscriptionUsageDefault', 
            true
        );
    }

    public static dmpl__SubscriptionUsage__c createSubscriptionUsage(
        Account customerAccount, 
        Asset asset, 
        dmpl__Item__c item, 
        dmpl__Subscription__c subscription
    ) {
        return (dmpl__SubscriptionUsage__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsage__c(
                dmpl__AccountId__c = customerAccount !=  null ? customerAccount.Id : null, 
                dmpl__AssetId__c = asset !=  null ? asset.Id : null, 
                dmpl__ItemId__c = item !=  null ? item.Id : null, 
                dmpl__Quantity__c = 2, 
                dmpl__SubscriptionId__c = subscription !=  null ? subscription.Id : null
            ), 
            'SubscriptionUsageDefault', 
            true
        );
    }

    public static dmpl__SubscriptionUsage__c updateSubscriptionUsage(
        Account acc, 
        dmpl__SaleInvoiceLine__c saleInvoiceLine
    ) {
        return (dmpl__SubscriptionUsage__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsage__c(
                dmpl__AccountId__c = acc.Id, 
                dmpl__AssetId__c = saleInvoiceLine.dmpl__AssetId__c
            ), 
            'SubscriptionUsageDefault', 
            false
        );
    }

    public static dmpl__SubscriptionUsage__c getSubscriptionUsage() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__SubscriptionId__c, 
                dmpl__AssetId__c, 
                dmpl__AccountId__c, 
                dmpl__ItemId__c, 
                dmpl__Quantity__c
            FROM dmpl__SubscriptionUsage__c
            LIMIT 1
        ];
    }

    public static dmpl__SubscriptionUsage__c getSubscriptionUsage(
        dmpl__SubscriptionUsage__c subsUsage
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__Quantity__c
            FROM dmpl__SubscriptionUsage__c
            WHERE Id = :subsUsage.Id
            LIMIT 1
        ];
    }
}