@isTest
public with sharing class CreditLimitDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__CreditLimitAmount__c' => 100000
        };
    }
}