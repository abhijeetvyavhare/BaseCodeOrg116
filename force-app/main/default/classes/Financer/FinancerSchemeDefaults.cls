@isTest
public with sharing class FinancerSchemeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'dmpl__Description__c' => 'Test scheme insert',
            'dmpl__Features__c' => 'Some features here',
            'dmpl__InterestRate__c' => 5.25
        };
    }
}