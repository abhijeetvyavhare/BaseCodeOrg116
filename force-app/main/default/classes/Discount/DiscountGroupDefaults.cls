@isTest
public with sharing class DiscountGroupDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Discount 1',
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__BranchId__c' => null,
            'dmpl__CustomerAccountGroupId__c' => null,
            'dmpl__IsActive__c' => true,
            'dmpl__DiscountType__c' => 'Sale Price'
        };
    }
}