@isTest
public with sharing class PartnerAccountMappingDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__FromDate__c' => Date.newInstance(2024, 8, 21),
            'dmpl__ToDate__c' => Date.newInstance(2025, 5, 21)
        };
    }
}