@isTest
public with sharing class DiscountGroupRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__DiscountGroupId__c' => null,
            'dmpl__ItemId__c' => null,
            'dmpl__SKUId__c' => null,
            'dmpl__ItemGroupId__c' => null,
            'dmpl__PriceListId__c' => null,
            'dmpl__DiscountPercent__c' => 4,
            'dmpl__DateEffectiveFrom__c' => Date.newInstance(2025, 1, 5),
            'dmpl__DateEffectiveTill__c' => Date.newInstance(2025, 7, 30)
        };
    }
}