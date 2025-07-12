@isTest
public with sharing class SchemeSlabDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Title__c'                      => 'FREE OF COST',
            'dmpl__SequenceNumber__c'             => 1,
            'dmpl__DefinitionFilterCriteria__c'   => 'All Conditions Are Met',
            'dmpl__RewardApplicability__c'        => 'All Rewards'
        };
    }
}