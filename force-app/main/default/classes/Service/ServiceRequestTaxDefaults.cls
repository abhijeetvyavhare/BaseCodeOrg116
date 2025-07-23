@isTest
public with sharing class ServiceRequestTaxDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__TaxOnAmount__c' => 100,
            'dmpl__TaxAmount__c' => 1000
        };
    }
}