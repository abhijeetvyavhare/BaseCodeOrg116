@isTest
public class GLAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__IsActive__c' => true
        };
    }    
}