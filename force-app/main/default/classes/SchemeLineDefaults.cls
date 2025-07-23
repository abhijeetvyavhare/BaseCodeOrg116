@isTest
public with sharing class SchemeLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__Title__c' => 'NET RATE',
            'dmpl__DefinitionFilterCriteria__c' => 'All Conditions Are Met',
            'dmpl__RewardApplicability__c' => 'All Rewards'
        };
    }
}