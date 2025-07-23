@isTest
public with sharing class ItemConsumptionScheduleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> {
            'Name' => 'Schedule 1'
        };
    }
}