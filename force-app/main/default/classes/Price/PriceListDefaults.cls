@isTest
public with sharing class PriceListDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'Name' => 'Price List 1',
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__BranchId__c' => null,
            'dmpl__PartnerAccountGroupId__c' => null,
            'dmpl__CustomerAccountGroupId__c' => null,
            'dmpl__IsActive__c' => true,
            'dmpl__IsDefault__c' => false,
            'dmpl__PriceListType__c' => 'Sale Price'
        };
    }
}