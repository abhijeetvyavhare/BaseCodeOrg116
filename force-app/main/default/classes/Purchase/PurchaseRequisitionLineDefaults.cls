@isTest
public class PurchaseRequisitionLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PurchaseRequisitionId__c' => null, 
            'dmpl__ItemId__c' => null, 
            'dmpl__Quantity__c' => 1
        };
    }
}