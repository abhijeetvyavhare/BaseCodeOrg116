@isTest
public with sharing class DeliveryOrderDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountName__c' => 'AccountName1',
            'dmpl__DeliveredDateTime__c' => null,
            'dmpl__DeliveryDate__c' => null,
            'dmpl__DeliveryDoneBy__c' => null,
            'dmpl__DeliveryPostalCode__c' => '140055',
            'dmpl__Discount__c' => 10,
            'dmpl__DocumentDate__c' => null,
            'dmpl__IsCancelled__c' => false,
            'dmpl__IsConfirmed__c' => false,
            'dmpl__IsDelivered__c' => false,
            'dmpl__IsILPosted__c' => false,
            'dmpl__IsILPostingApproved__c' => false,
            'dmpl__IsInJobQueue__c' => false,
            'dmpl__IsShipmentReleased__c' => false,
            'dmpl__PerformPopulateChecklist__c' => false,
            'dmpl__PerformReleaseShipment__c' => false,
            'dmpl__PriceAsOnDate__c' => null,
            'dmpl__Remarks__c' => 'Remarks1',
            'dmpl__RequestedDeliveryDate__c' => Date.newInstance(2025, 01, 01),
            'dmpl__RequestedDeliveryDateTime__c' => Datetime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)),
            'dmpl__RequestedDeliveryTime__c' => null,
            'dmpl__ScheduledDeliveryDate__c' => null,
            'dmpl__ScheduledDeliveryDateTime__c' => null,
            'dmpl__Status__c' => 'Draft',
            'dmpl__TaxSupplyType__c' => 'Within State'
        };
    }
}