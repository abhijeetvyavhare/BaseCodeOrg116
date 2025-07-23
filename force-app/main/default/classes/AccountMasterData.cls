public with sharing class AccountMasterData {
    public static void createPartner2Data(
        dmpl__AccountGroup__c accountGroup
    ) {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup.id,partner.id); 
    }

    public static void createAccountGroup2AndPartner4Data() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 2');
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup.id,partner.id); 
    }

      public static void generateGST(
        Id itemId, 
        Id partnerId, 
        Id branchId, 
        Integer percentage
    ) {
        dmpl__TaxGroup__c taxGroupGST = TestDataHelpers.createTaxGroup('GST ' + percentage, partnerId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroupGST.Id, percentage/2);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroupGST.Id, percentage/2);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(itemId, taxGroupGST.Id);
    }

    public static void generateItemWithPriceList(
        String name, 
        Id partnerId, 
        Id branchId, 
        Decimal price
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem(name, 'Product');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List ' + name.substringAfter(' '), partnerId, branchId);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, price);
    }
}