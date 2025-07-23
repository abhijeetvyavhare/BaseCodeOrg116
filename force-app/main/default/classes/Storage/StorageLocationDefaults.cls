public with sharing class StorageLocationDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Storage Location 1',
            'dmpl__BranchId__c' => null,
            'dmpl__IsActive__c' => true,
            'dmpl__LocationType__c' => 'Warehouse'
        };
    }
}