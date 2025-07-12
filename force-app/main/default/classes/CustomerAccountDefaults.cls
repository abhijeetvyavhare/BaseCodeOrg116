@isTest
public with sharing class CustomerAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'Name' => 'Customer 1',
            'Phone' => '9876543210',
            'dmpl__Status__c' => 'Created',
            'dmpl__IsCustomerAccount__c' => true,
            'dmpl__IsPartnerAccount__c' => false,
            'dmpl__IsSupplierAccount__c' => false,
            'dmpl__IsActive__c' => true,
            'dmpl__BillingStreet__c' => 'Ring Rd',
            'dmpl__BillingCity__c' => 'Nagpur',
            'dmpl__BillingState__c' => 'Maharashtra',
            'dmpl__BillingCountry__c' => 'India',
            'dmpl__BillingPostalCode__c' => '440001',
            'dmpl__ShippingStreet__c' => 'MG Road',
            'dmpl__ShippingCity__c' => 'Pune',
            'dmpl__ShippingState__c' => 'Maharashtra',
            'dmpl__ShippingCountry__c' => 'India',
            'dmpl__ShippingPostalCode__c' => '411001'
        };
    }
}