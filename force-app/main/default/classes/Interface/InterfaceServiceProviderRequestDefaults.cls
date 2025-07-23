@isTest
public with sharing class InterfaceServiceProviderRequestDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'Name' => 'Testing Request',
            'dmpl__FileName__c' => 'File1',
            'dmpl__EndPoint__c' => 'Test Url',
            'dmpl__SourceDataType__c' => 'Record Id',
            'dmpl__PayloadSchema__c' => 'Sample JSON Payload',
            'dmpl__ResponseSchema__c' => 'Sample Response',
            'dmpl__ResponseSuccessValue__c' => 'POST'
        };
    }
}