public with sharing class TaxIGSTDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'IGST',
            'dmpl__Type__c' => 'IGST',
            'dmpl__Rate__c' => 18,
            'dmpl__TaxGroupId__c' => null,
            'dmpl__PostingFieldName__c' => 'Tax3'
        };
    }
}