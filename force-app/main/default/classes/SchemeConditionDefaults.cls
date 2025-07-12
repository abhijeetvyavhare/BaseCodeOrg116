@isTest
public with sharing class SchemeConditionDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ConditionType__c'         => 'Value',
            'dmpl__ConditionOperator__c'     => 'Equals',
            'dmpl__ItemId__c'                => null,
            'dmpl__ConditionQuantity__c'     => 0.00,
            'dmpl__SchemeLineId__c'          => null,
            'dmpl__SchemeId__c'              => null,
            'dmpl__SequenceNumber__c'        => 1,
            'dmpl__UOMQuantity__c'           => 0,
            'dmpl__UOMQuantity1__c'          => 0,
            'dmpl__ConditionValue__c'        => 0
        };
    }
}