@isTest
public with sharing class SubscriptionMasterData {
    public static void createSubscriptionWithWrongORInactiveNegativeData(){
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
    }
}