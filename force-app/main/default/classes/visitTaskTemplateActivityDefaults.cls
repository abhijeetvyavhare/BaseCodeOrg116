@isTest
public with sharing class VisitTaskTemplateActivityDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'VisitTaskTemplateActivity',
            'dmpl__ActivityType__c' => 'Create Object',
            'dmpl__Description__c' => 'Description1',
            'dmpl__Duration__c' => 5,
            'dmpl__FieldName__c' => 'VisitTaskTemplateActivity1',
            'dmpl__FieldValue__c' => '1',
            'dmpl__IsHidden__c' => true,
            'dmpl__IsMandatory__c' => true,
            'dmpl__ObjectName__c' => 'dmpl__SaleOrder__c',
            'dmpl__PerformAutomatically__c' => true,
            'dmpl__PicklistValues__c' => 'Values1',
            'dmpl__RelatedActivityAction__c' => 'Repeat By Value',
            'dmpl__ReportURL__c' => 'http://www.example.com',
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__ObjectApiName__c' => 'dmpl__SaleOrder__c'
        };
    }
}