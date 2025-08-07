@isTest
public class GoodsReceiptDefaults implements TestFactory.FieldDefaults {  
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsAllocated__c' => false, 
            'dmpl__IsBillGenerated__c' => false, 
            'dmpl__IsClaimed__c' => false, 
            'dmpl__Status__c'=>'Draft',
            'dmpl__TransporterName__c' => 'Transporter'
        };
    }
}