@isTest
public with sharing class ShipmentLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1, 
            'dmpl__SKUId__c' => null,
            'dmpl__ItemId__c' => null,
            'dmpl__ShipmentId__c' => null
        };
    }
}