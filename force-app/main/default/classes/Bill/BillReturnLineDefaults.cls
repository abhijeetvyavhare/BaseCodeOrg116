@isTest
public with sharing class BillReturnLineDefaults  implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsApproved__c' => true,
            'dmpl__IsClaimed__c' => true,
            'dmpl__IsGLPosted__c' => true,
            'dmpl__IsGLPostingApproved__c' => true,
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true
        };
    }
}