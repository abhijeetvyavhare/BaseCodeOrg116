@isTest
public with sharing class ServiceCampaignRuleDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__FieldValue__c'=>'Value',
            'dmpl__SequenceNumber__c'=>322
        };
    }
}