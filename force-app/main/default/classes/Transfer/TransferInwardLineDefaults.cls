@isTest
public with sharing class TransferInwardLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> {
            'dmpl__Quantity__c' => 1      
        };
    }
}