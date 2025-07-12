@isTest
public with sharing class ServiceCampaignMemberDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__MobilePhone__c'=>'9876543210',
            'dmpl__Email__c'=>'dmpl@dealermatix.com'
        };
    }
}