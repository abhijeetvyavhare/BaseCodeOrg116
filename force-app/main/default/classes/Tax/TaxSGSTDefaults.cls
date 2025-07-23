@isTest
public with sharing class TaxSGSTDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'SGST',
            'dmpl__Type__c' => 'SGST',
            'dmpl__Rate__c' => 14,
            'dmpl__TaxGroupId__c' => null,
            'dmpl__PostingFieldName__c' => 'Tax2'
        };
    }
}