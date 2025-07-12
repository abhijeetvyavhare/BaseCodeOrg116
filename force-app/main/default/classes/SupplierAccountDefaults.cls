@isTest
public with sharing class SupplierAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name'                         => 'Supplier 1',
            'dmpl__IsCustomerAccount__c'   => false,
            'dmpl__IsPartnerAccount__c'    => false,
            'dmpl__IsSupplierAccount__c'   => true,
            'dmpl__IsActive__c'            => true,
            'dmpl__BillingStreet__c'       => '55 Industrial Park Road',
            'dmpl__BillingCity__c'         => 'Ahmedabad',
            'dmpl__BillingState__c'        => 'Gujarat',
            'dmpl__BillingCountry__c'      => 'India',
            'dmpl__BillingPostalCode__c'   => '380015',
            'dmpl__ShippingStreet__c'      => '55 Industrial Park Road',
            'dmpl__ShippingCity__c'        => 'Ahmedabad',
            'dmpl__ShippingState__c'       => 'Gujarat',
            'dmpl__ShippingCountry__c'     => 'India',
            'dmpl__ShippingPostalCode__c'  => '380015',
            'Phone'                        => '9988776564'
        };
    }
}