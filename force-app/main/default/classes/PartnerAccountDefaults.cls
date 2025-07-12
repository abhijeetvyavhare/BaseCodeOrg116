@isTest
public with sharing class PartnerAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Partner 1',
            'dmpl__IsCustomerAccount__c' => false,
            'dmpl__IsPartnerAccount__c' => true,
            'dmpl__IsSupplierAccount__c' => false,
            'dmpl__IsActive__c' => true,
            'dmpl__BillingStreet__c' => '56 Industrial Layout',
            'dmpl__BillingCity__c' => 'Bengaluru',
            'dmpl__BillingState__c' => 'Karnataka',
            'dmpl__BillingCountry__c' => 'India',
            'dmpl__BillingPostalCode__c' => '560095',
            'dmpl__ShippingStreet__c' => 'MG Road',
            'dmpl__ShippingCity__c' => 'Bengaluru',
            'dmpl__ShippingState__c' => 'Karnataka',
            'dmpl__ShippingCountry__c' => 'India',
            'dmpl__ShippingPostalCode__c' => '560001',
            'Phone' => '9876543210'
        };
    }
}