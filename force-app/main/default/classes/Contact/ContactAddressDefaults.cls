@isTest
public class ContactAddressDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Address 1',
            'dmpl__Street__c' => 'Ring Rd',
            'dmpl__City__c' => 'Pune',
            'dmpl__State__c' => 'Maharashtra',
            'dmpl__AccountId__c' => null,          
            'dmpl__AddressType__c' => 'Billing Address',
            'dmpl__PostalCode__c' => '440001',
            'dmpl__IsDefault__c' => false,   
            'dmpl__Country__c' => 'India'
        };
    }
}