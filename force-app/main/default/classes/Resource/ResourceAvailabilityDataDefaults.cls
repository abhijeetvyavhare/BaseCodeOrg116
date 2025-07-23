@isTest
public with sharing class ResourceAvailabilityDataDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Type__c' => 'Check-In',
			'dmpl__ResourceId__c' => null,
			'dmpl__AttendenceTime__c' => DateTime.valueOf(datetime.now()),
			'dmpl__ResourceAvailabilityId__c' => null,
            'dmpl__Time__c' => DateTime.valueOf(datetime.now())
        };
    }
}