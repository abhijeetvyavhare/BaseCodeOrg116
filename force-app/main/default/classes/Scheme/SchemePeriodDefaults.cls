@isTest
public with sharing class SchemePeriodDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Scheme Period',
            'dmpl__DateFrom__c' => Date.newInstance(2025, 6, 1),
            'dmpl__DateTo__c' => Date.newInstance(2025, 6, 30),
            'dmpl__Status__c' => 'Approved'
        };
    }
}