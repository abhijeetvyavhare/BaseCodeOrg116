@isTest
public with sharing class InterfaceProviderMasterData {
    public static void updateInterfaceServiceProviderWithActivePartnerAccountPositive(){
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
    }

    public static void createInterfaceServiceProviderWithInactivePartnerAccountNegative(){
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partner2.dmpl__IsActive__c = false;
        update partner2;
    }

    public static void createInterfaceServiceProviderWithInactiveBranchPositive(){
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
    }
}