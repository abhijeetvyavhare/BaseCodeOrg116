@isTest
public with sharing class SaleInvoiceMasterData {
    public static void SaleInvoiceCreationWithInactiveCustomerAccountData() {
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7');
        customerAccount7.dmpl__IsActive__c = false;
        update customerAccount7;
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id);
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
    
    public static void createSaleInvoiceLineWithSupercedingItemPositive() {
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part');
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part');
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.createItemAlternate(
            item15.Id, 
            item16.Id, 
            'Superseded', 
            Date.today()
        );
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