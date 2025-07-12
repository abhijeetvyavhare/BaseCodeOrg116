@isTest
public with sharing class SchemeMasterData {
    public static void createSchemeLedgerWithWrongPartnerAccountNegativeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount.Id);
        partnerAccount.dmpl__IsActive__c = false;
        Update partnerAccount;
    }
    
    Public Static Void createSchemeConsumptionWithWrongBranchNegativeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        Update branch;
    }
    
   
}