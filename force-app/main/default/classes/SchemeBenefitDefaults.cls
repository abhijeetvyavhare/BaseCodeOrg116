@isTest
public with sharing class SchemeBenefitDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Title__c' => 'Rate Off',
            'dmpl__RewardType__c' => 'Line Level Discount Amount',
            'dmpl__DiscountAmount__c' => 1000,
            'dmpl__DiscountedItemId__c' => null,
            'dmpl__DiscountedItemQuantity__c' => null,
            'dmpl__DiscountPercent__c' => null,
            'dmpl__SchemeLineId__c' => null,
            'dmpl__SchemeId__c' => null,
            'dmpl__SequenceNumber__c' => 1
        };
    }
}