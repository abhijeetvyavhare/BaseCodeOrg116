@isTest
public with sharing class SchemeConsumptionDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'                      => 'Scheme 1',
            'dmpl__ConsumedQuantity__c' => 0,
            'dmpl__ConsumedAmount__c'   => 0
        };
    }
}