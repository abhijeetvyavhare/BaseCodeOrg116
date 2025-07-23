@isTest
public with sharing class PurchaseRequisitionDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PartnerAccountId__c'     => null,
            'dmpl__BranchId__c'             => null,
            'dmpl__SupplierAccountId__c'    => null,
            'dmpl__PurchaseOrderId__c'      => null,
            'dmpl__Status__c'               => 'Draft'
        };
    }
}