@isTest
public with sharing class ShipmentDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__SupplierAccountId__c' => null, 
            'dmpl__BranchId__c' => null,
            'dmpl__ShipmentDate__c' => Date.today(),
            'dmpl__Status__c' => 'Draft'
        };
    }
}