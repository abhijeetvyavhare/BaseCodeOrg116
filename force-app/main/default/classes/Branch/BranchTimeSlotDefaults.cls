@isTest
public with sharing class BranchTimeSlotDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> {
            'dmpl__IsActive__c' => true,
            'Name' => 'T3',
            'dmpl__TransactionType__c' => 'Delivery',
            'dmpl__MaximumCapacity__c' => 12,
            'dmpl__MondayCapacity__c' => 12,
            'dmpl__TuesdayCapacity__c' => 12,
            'dmpl__WednesdayCapacity__c' => 12,
            'dmpl__ThursdayCapacity__c' => 12,
            'dmpl__FridayCapacity__c' => 12,
            'dmpl__SaturdayCapacity__c' => 12,
            'dmpl__SundayCapacity__c' => 12,
            'dmpl__StartTime__c' => Time.newInstance(7, 15, 0, 0),
            'dmpl__EndTime__c' => Time.newInstance(10, 15, 0, 0)
        };
    }
}