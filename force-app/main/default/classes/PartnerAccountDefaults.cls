@isTest
public with sharing class PartnerAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Partner 1',
            'dmpl__IsCustomerAccount__c' => false,
            'dmpl__IsPartnerAccount__c' => true,
            'dmpl__IsSupplierAccount__c' => false,
            'dmpl__IsActive__c' => true
        };
    }
}