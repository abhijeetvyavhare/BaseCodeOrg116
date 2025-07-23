public with sharing class TaxMasterData {
    public static void createGST18TaxGroup(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst18TaxGroup = TestDataHelpers.createTaxGroup('GST 18', partnerAccount.Id, branch.Id);
        gst18TaxGroup.dmpl__IsActive__c = true;
        gst18TaxGroup.dmpl__TaxGroupType__c = 'Line Level';
        update gst18TaxGroup;
        dmpl__Tax__c cgst = TestDataHelpers.createTax('CGST 9', gst18TaxGroup.Id, 9);
        dmpl__Tax__c sgst = TestDataHelpers.createSGSTTax('SGST 9', gst18TaxGroup.Id, 9);
    }

    public static void createGST12TaxGroup(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        gst12TaxGroup.dmpl__IsActive__c = true;
        gst12TaxGroup.dmpl__TaxGroupType__c = 'Line Level';
        update gst12TaxGroup;
    }

    public static void createIGST18TaxGroup(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c igst18TaxGroup = TestDataHelpers.createTaxGroup('IGST 18', partnerAccount.Id, branch.Id);
        igst18TaxGroup.dmpl__IsActive__c = true;
        igst18TaxGroup.dmpl__TaxGroupType__c = 'Line Level';
        update igst18TaxGroup;
        dmpl__Tax__c igst = TestDataHelpers.createTax('IGST', igst18TaxGroup.Id, 18);
        igst.dmpl__Type__c = 'IGST';
        update igst;
    }

    public static void createUTGST18TaxGroup(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c utgst18TaxGroup = TestDataHelpers.createTaxGroup('UT GST 18', partnerAccount.Id, branch.Id);
        utgst18TaxGroup.dmpl__IsActive__c = true;
        utgst18TaxGroup.dmpl__TaxGroupType__c = 'Line Level';
        update utgst18TaxGroup;
        dmpl__Tax__c utgst = TestDataHelpers.createTax('UTGST', utgst18TaxGroup.Id, 9);
        utgst.dmpl__Type__c = 'UTGST';
        update utgst;
        dmpl__Tax__c cgst = TestDataHelpers.createTax('CGST 9', utgst18TaxGroup.Id, 9);
        cgst.dmpl__Type__c = 'CGST';
        update cgst;
    }
}