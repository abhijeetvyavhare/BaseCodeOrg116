@isTest
public with sharing class ItemDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> { 
            'Name' => 'Item 1',
            'dmpl__ItemType__c' => 'Product',
            'dmpl__IsActive__c' => true,
            'dmpl__IsPackage__c' => false,
            'dmpl__IsSKURequired__c' => false,
            'dmpl__ItemCode__c' => '675654',
            'dmpl__IsDiscontinued__c' => false,
            'dmpl__TrackInventory__c' => false
        };
    }
}