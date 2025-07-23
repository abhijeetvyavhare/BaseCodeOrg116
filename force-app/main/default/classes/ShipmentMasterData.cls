public with sharing class ShipmentMasterData {
    public static void generateGST(Id itemId, Id partnerId, Id branchId, Integer percentage){
        dmpl__TaxGroup__c taxGroupGST = TestDataHelpers.createTaxGroup('GST '+percentage, partnerId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroupGST.Id, percentage/2);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroupGST.Id, percentage/2);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(itemId, taxGroupGST.Id);
    }
}