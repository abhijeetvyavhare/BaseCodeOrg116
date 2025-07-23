@isTest
public class IncentiveLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DefinitionCustomLogic__c' => 'none', 
            'dmpl__DefinitionFilterCriteria__c' => 'All conditions are met', 
            'dmpl__IncentivePlanId__c'=> null, 
            'dmpl__SequenceNumber__c' => 1, 
            'dmpl__UseSlabAbsoluteValue__c' => false
        };
    }
}