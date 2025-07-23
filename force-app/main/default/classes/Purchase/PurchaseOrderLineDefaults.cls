@isTest
public with sharing class PurchaseOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PurchaseOrderId__c' => null,
            'dmpl__ItemId__c'          => null,
            'dmpl__TaxGroupId__c'      => null,
            'dmpl__Quantity__c'        => 1
        };
    }
}