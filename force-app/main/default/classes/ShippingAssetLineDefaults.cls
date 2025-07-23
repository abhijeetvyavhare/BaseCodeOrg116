@isTest
public with sharing class ShippingAssetLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__SerialNumber__c' => '1234567890', 
            'dmpl__EngineNumber__c' => 'Engine Number', 
            'dmpl__AssetNumber__c' => 'Asset Number', 
            'dmpl__DeliveryDate__c' => Date.today()
        };
    }
}