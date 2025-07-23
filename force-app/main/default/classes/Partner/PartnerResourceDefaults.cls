@isTest
public with sharing class PartnerResourceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AssignmentSequenceNumber__c' => 1,
            'dmpl__BranchId__c' => null,
            'dmpl__FromDate__c' => Date.today(),
            'dmpl__ManagerId__c' => null,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__ResourceId__c' => null,
            'dmpl__RuleSuccessCriteria__c' => 'All Rules Are Met',
            'dmpl__ToDate__c' => Date.today().addDays(30)
        };
    }
}