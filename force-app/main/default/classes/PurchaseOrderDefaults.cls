@isTest
public with sharing class PurchaseOrderDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PerformKPICalculation__c'       => false,
            'dmpl__PerformReceive__c'              => false,
            'dmpl__PerformReleaseInvoice__c'       => false,
            'dmpl__PerformReleaseReceipt__c'       => false,
            'dmpl__PerformReleaseSaleOrder__c'     => false,
            'dmpl__Status__c'                      => 'Draft',
            'dmpl__IsInvoiceReleased__c'           => false,
            'dmpl__IsKPICalculated__c'             => false,
            'dmpl__IsOrderReceived__c'             => false,
            'dmpl__IsReceiptReleased__c'           => false,
            'dmpl__DiscountGroupId__c'             => null,
            'dmpl__SupplierAccountId__c'           => null,
            'dmpl__PartnerAccountId__c'            => null,
            'dmpl__BranchId__c'                    => null
        };
    }
}