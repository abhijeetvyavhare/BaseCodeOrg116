@isTest
public with sharing class ServiceCampaignDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'dmpl__IsActive__c' => true,
            'dmpl__ReportId__c' => 'Sample Report',
            'dmpl__ApexJobId__c' => 'Job1',
            'dmpl__CronExpression__c' => 'Cron Expression',
            'dmpl__Type__c' => 'Marketing',                           
            'dmpl__DynamicMemberType__c' => 'Field Filter',           
            'dmpl__RuleSuccessCriteria__c' => 'All Rules Are Met',    
            'Name' => 'Service - Campaign',
            'dmpl__ReminderDaysOffset1__c' => 3,
            'dmpl__EndDate__c' => Date.newInstance(2025, 7, 30),
            'dmpl__StartDate__c' => Date.newInstance(2025, 6, 10)
        };
    }
}