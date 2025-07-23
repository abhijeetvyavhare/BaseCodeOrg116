@isTest
public with sharing class PriceListRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__PriceListId__c' => null, 
            'dmpl__ItemId__c' => null, 
            'dmpl__ItemLotTypeId__c' => null,
            'dmpl__SKUId__c' => null,
            'dmpl__Price__c' => 1500,
            'dmpl__DateEffectiveFrom__c' => System.today().addDays(-1),
            'dmpl__DateEffectiveTill__c' => System.today().addDays(9)
        };
    }
}