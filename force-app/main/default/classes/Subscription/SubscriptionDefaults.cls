@isTest
public with sharing class SubscriptionDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> {
            'dmpl__GoodwillDays__c' => 4, 
            'dmpl__IsPriceBundled__c' => true, 
            'dmpl__MarkupAmount__c' => 1000, 
            'dmpl__MarkupRate__c' => 10, 
            'dmpl__Quantity__c' => 100, 
            'dmpl__UnitCost__c' => 100, 
            'dmpl__UnitPrice__c' => 100
        };
    }
}