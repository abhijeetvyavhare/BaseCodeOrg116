@isTest
public with sharing class StorageLocationMasterData {
    public static void createStorageLocationWithWrongBranchNegativeData(Id partnerAccountId) {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccountId);
    }

    public static void createStorageLocationWithInactiveBranchNegativeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
    }
}