@isTest
public class GoodReceiptLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__IsApproved__c' => false, 
            'dmpl__IsClaimed__c' => false, 
            'dmpl__IsILPosted__c' => false, 
            'dmpl__IsILPostingApproved__c' => false, 
            'dmpl__IsPosted__c' => false
        };
    }
}