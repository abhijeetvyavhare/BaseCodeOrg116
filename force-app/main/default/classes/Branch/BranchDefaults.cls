@isTest
public with sharing class BranchDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'Name' => 'Branch 1',
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__IsActive__c' => true,
            'dmpl__AllowSales__c' => false,
            'dmpl__AllowPurchase__c' => true,
            'dmpl__AllowInventory__c' => true
        };
    }
}