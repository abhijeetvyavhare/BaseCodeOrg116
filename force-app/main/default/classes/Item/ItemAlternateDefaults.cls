@isTest
public with sharing class ItemAlternateDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__QuantityAvailable__c' => null,
            'dmpl__QuantityInHand__c' => null
        };
    }
}