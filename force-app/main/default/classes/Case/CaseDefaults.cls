@isTest
public with sharing class CaseDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Case1',
            'dmpl__CaseReason__c' => 'Performance',
            'dmpl__CaseSource__c' => 'Phone',
            'dmpl__ClosedWhenCreated__c' => false,
            'dmpl__ContactEmail__c' => 'ContactEmail@Test.com',
            'dmpl__ContactName__c' => 'ContactName1',
            'dmpl__AccountPhone__c' => '9733387909',
            'dmpl__Priority__c' => 'Medium',
            'dmpl__Status__c' => 'New',
            'dmpl__DateTimeOpened__c' => System.now(),
            'dmpl__Mobile__c' => '9733387909',
            'dmpl__AccountName__c' => 'Test-Account',
            'dmpl__Remarks__c' => 'Test Remarks'     
        };
    }
}