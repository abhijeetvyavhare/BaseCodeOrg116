@isTest
public with sharing class SchemeBenefitDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Title__c'               => 'Rate Off',
            'dmpl__RewardType__c'          => 'Discounted Item',
            'dmpl__RewardType__c'          => 'Discounted Item',
            'dmpl__DiscountAmount__c'      => 0,
            'dmpl__DiscountedItemId__c'    => null,
            'dmpl__DiscountedItemQuantity__c' => null,
            'dmpl__DiscountPercent__c'     => 0,
            'dmpl__SchemeLineId__c'        => null,
            'dmpl__SchemeId__c'            => null,
            'dmpl__UOMQuantity__c'         => 0,
            'dmpl__SequenceNumber__c'      => 1,
            'dmpl__ExcludeQualifyingItems__c' => false,
            'dmpl__RepeatReward__c'        => false
        };
    }
}