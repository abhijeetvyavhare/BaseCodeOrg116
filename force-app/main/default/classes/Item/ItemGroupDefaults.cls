@isTest
public with sharing class ItemGroupDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Item Group 1',
            'dmpl__ItemGroupType__c' => 'Tax'
        };
    }
}