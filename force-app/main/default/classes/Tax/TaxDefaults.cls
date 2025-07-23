@isTest
public with sharing class TaxDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'CGST',
            'dmpl__Type__c' => 'CGST',
            'dmpl__Rate__c' => 14,
            'dmpl__TaxGroupId__c' => null,
            'dmpl__PostingFieldName__c' => 'Tax1'
        };
    }
}