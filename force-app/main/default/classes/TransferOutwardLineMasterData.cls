@isTest
public with sharing class TransferOutwardLineMasterData {
    public static void createTransferOutwardLineData() {
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account partnerAccount5 = TestDataHelpers.createPartnerAccount('Partner 5');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        dmpl__Branch__c branch5 = TestDataHelpers.createBranch('Branch 5', partnerAccount5.Id);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Item__c  item2 = TestDataHelpers.createItem('Item 2', 'Product');
        item2.dmpl__IsActive__c = false;
        update item2;
    } 
}