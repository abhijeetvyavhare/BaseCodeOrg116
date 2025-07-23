@isTest
public with sharing class GLAccountHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__GLAccount__c glAccount1 = GLAccountDataHelper.createGLAccount(
            partnerAccount1, 
            branch1,
            true,
            'Other Assets',
            'HDFC',
            '12345'
        );
    }
    
    @isTest
    static void testInsertGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        System.assertNotEquals(null, glAccount, 'GL Account should be created successfully');
    }
    
    @isTest
    static void testUpdateGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        glAccount.dmpl__AccountNumber__c ='456';
        glAccount.dmpl__AccountType__c ='Current Assets';
        glAccount.dmpl__Currency__c ='USD';
        glAccount.dmpl__Description__c ='Updated Description';
        glAccount.dmpl__ExternalId__c ='999';
        glAccount.Name ='Updated GL Name';
        glAccount.dmpl__IsActive__c =true;
        glAccount.dmpl__IsSystem__c =true;
        glAccount.dmpl__TaxType__c ='IGST';
        update glAccount;
        dmpl__GLAccount__c updatedGL = GLAccountDataHelper.getGLAccount();
        System.assertEquals('456', updatedGL.dmpl__AccountNumber__c, 'AccountNumber should be updated');
        System.assertEquals('Current Assets', updatedGL.dmpl__AccountType__c, 'AccountType should be updated');
        System.assertEquals('USD', updatedGL.dmpl__Currency__c, 'Currency should be updated');
        System.assertEquals('Updated Description', updatedGL.dmpl__Description__c, 'Description should be updated');
        System.assertEquals('999', updatedGL.dmpl__ExternalId__c, 'ExternalId should be updated');
        System.assertEquals('Updated GL Name', updatedGL.Name, 'Name should be updated');
        System.assertEquals(true, updatedGL.dmpl__IsActive__c, 'IsActive should be updated');
        System.assertEquals(true, updatedGL.dmpl__IsSystem__c, 'IsSystem should be updated');
        System.assertEquals('IGST', updatedGL.dmpl__TaxType__c, 'TaxType should be updated');
    }
    
    @isTest
    static void testDeleteGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        Id glAccId = glAccount.Id;
        delete glAccount;
        try {
            dmpl__GLAccount__c deleted = GLAccountDataHelper.getGLAccount(glAccId);
            System.assert(false, 'Expected GLAccount to be deleted, but record still exists.');
        } catch (QueryException ex) {
            System.assert(true, 'GLAccount successfully deleted.');
        } 
    }
    
    @isTest 
    static void createANewGLAccountWithValidAccountNumberBranchPositiveNew(){
        Account partner  = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        dmpl__GLAccount__c glAccount1 = GLAccountDataHelper.createGLAccount(
            null, 
            branch,
            true,
            'Other Assets',
            'HDFC',
            '12345'
        );
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount(glAccount1.Id);
        System.assertNotEquals(null, glAccount, 'GL Account should be created successfully');
        System.assertEquals('12345', glAccount.dmpl__AccountNumber__c, 'AccountNumber should match');
        System.assertEquals('Other Assets', glAccount.dmpl__AccountType__c, 'AccountType should match');
        System.assertEquals('HDFC', glAccount.Name, 'Name should match');
        System.assertEquals(true, glAccount.dmpl__IsActive__c, 'GL Account Active Status should match');
        System.assertEquals(branch.Id, glAccount.dmpl__BranchId__c, 'Branch should match');
    }
    
    @isTest
    static void createGLAccountLinkedToPartnerAccountPositiveNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__GLAccount__c glAccount1 = GLAccountDataHelper.createGLAccount(
            partner, 
            branch,
            true,
            'Other Assets',
            'ICICI',
            '12345'
        );
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount(glAccount1.Id);
        System.assertNotEquals(null, glAccount, 'GL Account should be created successfully');
        System.assertEquals('Other Assets', glAccount.dmpl__AccountType__c, 'AccountType should match');
        System.assertEquals('ICICI', glAccount.Name, 'Name should match');
        System.assertEquals(true, glAccount.dmpl__IsActive__c, 'IsActive should match');
        System.assertEquals(partner.Id, glAccount.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, glAccount.dmpl__BranchId__c, 'Branch should match');
    }
    
	@isTest
    static void  createGLAccountAndSetIsActiveToTruePositiveNew() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        System.assertNotEquals(null, glAccount, 'GL Account should be created successfully');
        System.assertEquals('12345', glAccount.dmpl__AccountNumber__c, 'AccountNumber should match');
        System.assertEquals('Other Assets', glAccount.dmpl__AccountType__c, 'AccountType should match');
        System.assertEquals('HDFC', glAccount.Name, 'Name should match');
        System.assertEquals(true, glAccount.dmpl__IsActive__c, 'IsActive should match');
        System.assertEquals(partner.Id, glAccount.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, glAccount.dmpl__BranchId__c, 'Branch should match');   
    }
    
    @isTest
    static void editGLAccountAddDescriptionAndUpdateAccountTypePositiveEdit() {
    	Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        System.assertEquals(true, glAccount.dmpl__IsActive__c, 'IsActive should match');
        System.assertEquals(partner.Id, glAccount.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, glAccount.dmpl__BranchId__c, 'Branch should match');
        glAccount.dmpl__Description__c = 'This is a cash account for daily transactions';
        glAccount.dmpl__AccountType__c = 'Cash';
        update glAccount;
        dmpl__GLAccount__c updatedGL = GLAccountDataHelper.getGLAccount(glAccount.Id);
        System.assertEquals('This is a cash account for daily transactions', updatedGL.dmpl__Description__c, 'Description should be updated');
        System.assertEquals('Cash', updatedGL.dmpl__AccountType__c, 'Account Type should be updated to Cash');
        System.assertEquals(true, updatedGL.dmpl__IsActive__c, 'IsActive should match');
        System.assertEquals(partner.Id, updatedGL.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedGL.dmpl__BranchId__c, 'Branch should match');
    }  
}