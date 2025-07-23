@isTest
public with sharing class AssetMasters {
    public static void createAssetAccountHistoryWithDiscontinuedItemNegativeData() {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 4','Product');
        item.dmpl__IsDiscontinued__c = true;
        update item;
    }

    public static void updateAssetAccountHistoryWithInactiveCustomerNegativeData(){
        Account customer7 = TestDataHelpers.createCustomerAccount('Customer 7');
        customer7.dmpl__IsActive__c = false;
        update customer7;
    }

    public static void updateAssetDiagnosticDataWithNewItemPositiveData(){
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
    }
}