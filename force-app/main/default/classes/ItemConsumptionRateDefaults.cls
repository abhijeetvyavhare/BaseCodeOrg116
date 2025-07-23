@isTest
public with sharing class ItemConsumptionRateDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object> {
            'Name' => 'Rate 1'
        };
    }
}