@isTest
public with sharing class PaymentDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{  
             'dmpl__Amount__c'=>100,
             'dmpl__PaymentMode__c'=>'Cash',
             'dmpl__SaleOrderId__c'=>null,
             'dmpl__SaleInvoiceId__c'=>null,
             'dmpl__PaymentDate__c'=>Date.today(),
             'dmpl__PaymentType__c'=>'PaymentGiven',
             'dmpl__Status__c'=>'Draft',
             'dmpl__IsGLPosted__c'=>false,
             'dmpl__IsGLPostingApproved__c'=>false,
             'dmpl__IsRelatedGLPosted__c'=>false,
             'dmpl__AdjustedAmount__c' =>100
        };
    }
}