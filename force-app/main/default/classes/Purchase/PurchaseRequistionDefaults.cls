@isTest
public class PurchaseRequistionDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PartnerAccountId__c' => null, 
            'dmpl__BranchId__c' => null, 
            'dmpl__SupplierAccountId__c' => null,
            'dmpl__Status__c' => 'Draft',
            'dmpl__Remarks__c' => 'Test-Remarks'
        };
    }
}