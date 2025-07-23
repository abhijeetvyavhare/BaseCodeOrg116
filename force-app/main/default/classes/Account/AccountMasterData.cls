@isTest 
public with sharing class AccountMasterData {
    public static void createAccountGroup3(){
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.createAccountGroup('Account Group 3');
    }

    public static void createAccountGroup2(){
        dmpl__AccountGroup__c accountGroup2 = AccountDataHelper.createAccountGroup('Account Group 2');
    }

    public static void createPartnerAccount3(){
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
    }

    public static void createPartnerAccount4(){
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
    }

    public static void createPartnerAccount2(){
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 2');
    }

    public static void createCustomerAccount3(){
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3');
    }

    public static void createBranch2(){
        AccountMasterData.createPartnerAccount2();
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
        branch2.dmpl__AllowSales__c = false;
        branch2.dmpl__AllowPurchase__c = true;
        update branch2;
    }
}