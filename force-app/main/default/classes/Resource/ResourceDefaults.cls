@isTest
public with sharing class ResourceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Resource 2',
            'dmpl__DefaultPartnerAccountId__c' => null,
            'dmpl__DefaultBranchId__c' => null,
            'dmpl__IsActive__c' => false
        };
    }
}