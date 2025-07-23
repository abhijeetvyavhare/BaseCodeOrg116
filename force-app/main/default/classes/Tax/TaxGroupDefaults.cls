@isTest
public with sharing class TaxGroupDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'GST 28',
            'dmpl__IsActive__c' => true,
            'dmpl__TaxGroupType__c' => 'Line Level',
            'dmpl__PartnerAccountId__c' => null,  
            'dmpl__BranchId__c' => null,          
            'dmpl__PartnerAccountGroupId__c' => null
        };
    }
}