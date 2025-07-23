@isTest
public with sharing class SchemeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Scheme 2',
            'dmpl__Application__c' => 'Auto Apply',
            'dmpl__Status__c' => 'Draft',
            'dmpl__SchemeType__c' => 'Per Sale order and Invoice',
            'dmpl__PeriodType__c' => 'Per Order',
            'dmpl__ValidFrom__c' => Date.today().addDays(-10),
            'dmpl__ValidTo__c' => Date.today().addDays(10),
            'dmpl__ValidCount__c' => 10,
            'dmpl__MultipleFulfilmentTreatment__c' => 'Apply all Fulfilled',
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__IgnoreBudget__c' => false,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__PartnerAccountGroupId__c' => null,
            'dmpl__AccountGroupId__c' => null,
            'dmpl__AccountId__c' => null,
            'dmpl__BranchId__c' => null,
            'dmpl__SchemeBudget__c' => 100000
        };
    }
}