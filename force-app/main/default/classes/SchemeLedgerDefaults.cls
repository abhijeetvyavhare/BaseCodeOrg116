@isTest
public with sharing class SchemeLedgerDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DiscountAmount__c' => 0,
            'dmpl__Discount__c' => 0,
            'dmpl__RewardPoints__c' => 0
        };
    }
}