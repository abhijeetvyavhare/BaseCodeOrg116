@isTest
public with sharing class InterfaceLogDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Payload__c' => 'Valid JSON',
            'dmpl__EndPoint__c' => 'Test EndPoint Url',
            'dmpl__Method__c' => 'POST'
        };
    }
}