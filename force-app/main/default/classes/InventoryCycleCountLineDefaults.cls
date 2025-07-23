@isTest
public with sharing class InventoryCycleCountLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'dmpl__UnitCost__c' => 100,
                'dmpl__OnHandQuantity__c' => 10,
                'dmpl__PickedQuantity__c' => 5,
                'dmpl__RecordedQuantity__c' => 10,
                'dmpl__RecordedDamagedQuantity__c' => 1,
                'dmpl__RecordedExpiredQuantity__c' => 2,
                'dmpl__IsApproved__c' => true,
                'dmpl__Remarks__c' => 'Successfully Created',
                'dmpl__ItemId__c' => null,
                'dmpl__CycleCountId__c' => null

        };
    }
}