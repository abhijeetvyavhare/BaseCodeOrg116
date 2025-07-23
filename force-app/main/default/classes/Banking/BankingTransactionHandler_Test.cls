@isTest
public with sharing class BankingTransactionHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.createGLAccount(partnerAccount, branch, accGroup);
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(glAccount.Id);

        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042','9123456698');
    }

    @isTest
    static void createBankingTransactionPositive(){
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        System.assertNotEquals(bankingTransaction, null, 'BankingTransaction should be created.');
        System.assertEquals('Transaction1', bankingTransaction.Name, 'Name mismatch');
        System.assertEquals(Date.today(), bankingTransaction.dmpl__Date__c, 'Date mismatch');
        System.assertEquals(2000, bankingTransaction.dmpl__Deposit__c, 'Deposit mismatch');
        System.assertEquals('Shubham', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals(1000, bankingTransaction.dmpl__Withdrawal__c, 'Withdrawal mismatch');
        System.assertEquals('Categorized', bankingTransaction.dmpl__Status__c, 'Status mismatch');
    }
        
    @isTest
    static void updateBankingTransactionPositive() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        bankingTransaction.Name = 'Transaction';
        bankingTransaction.dmpl__Date__c = Date.today().addDays(1);
        bankingTransaction.dmpl__Deposit__c = 3000;
        bankingTransaction.dmpl__Payee__c = 'Shubham Singh';
        bankingTransaction.dmpl__Status__c = 'Pending';
        bankingTransaction.dmpl__Withdrawal__c = 1000;
    
        update bankingTransaction;
    
        dmpl__BankingTransaction__c updatedBankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction(bankingTransaction.Id);
        System.assertEquals('Transaction', updatedBankingTransaction.Name, 'Name should be updated.');
        System.assertEquals(Date.today().addDays(1), updatedBankingTransaction.dmpl__Date__c, 'Date should be updated.');
        System.assertEquals(3000, updatedBankingTransaction.dmpl__Deposit__c, 'Deposit should be updated.');
        System.assertEquals('Shubham Singh', updatedBankingTransaction.dmpl__Payee__c, 'Payee should be updated.');
        System.assertEquals('Pending', updatedBankingTransaction.dmpl__Status__c, 'Status should be updated.');
        System.assertEquals(1000, updatedBankingTransaction.dmpl__Withdrawal__c, 'Withdrawal should be updated.');
    }

    @isTest
    static void deleteBankingTransaction() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        System.assertNotEquals(bankingTransaction, null, 'BankingTransaction should exist before delete.');

        delete bankingTransaction;

        dmpl__BankingTransaction__c deletedBankingTransaction = null;
        try {
            deletedBankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction(bankingTransaction.Id);
        } catch (Exception e) {
            deletedBankingTransaction = null;
        }
        System.assertEquals(null, deletedBankingTransaction, 'BankingTransaction should be deleted and not found in query.');
    }

    @isTest
    static void createBankingTransactionWithValidGLAccountAndNullPartnerAccountPositive(){
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(sbiGLAccount.Id, 'Rohan Kumar', 'Payroll Deposit - Hotel', 50000, null);
        Test.stopTest();
        System.assertNotEquals(null, bankingTransaction, 'BankingTransaction should be created.');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals('Payroll Deposit - Hotel', bankingTransaction.dmpl__Narration__c, 'Narration mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Deposit mismatch');
        System.assertEquals(sbiGLAccount.Id, bankingTransaction.dmpl__GLAccountId__c, 'GL Account mismatch');
    }

    @isTest
    static void createBankingTransactionWithValidPartnerAccountPositive(){
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(sbiGLAccount.Id, 'Rohan Kumar', 'Payroll Deposit - Hotel', 50000, partnerAccount3.Id);
        Test.stopTest();
        System.assertNotEquals(null, bankingTransaction, 'BankingTransaction should be created.');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals('Payroll Deposit - Hotel', bankingTransaction.dmpl__Narration__c, 'Narration mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Deposit mismatch');
        System.assertEquals(sbiGLAccount.Id, bankingTransaction.dmpl__GLAccountId__c, 'GL Account mismatch');
        System.assertEquals(partnerAccount3.Id, bankingTransaction.dmpl__PartnerAccountId__c, 'Partner Accounts mismatch');
    }

    @isTest
    static void updateBankDateToFutureDatePositive(){
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Date futureDate = System.today().addDays(30);
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(sbiGLAccount.Id, 'Rohan Kumar', 'Payroll Deposit - Hotel', 50000, partnerAccount3.Id);
        bankingTransaction.dmpl__Date__c = futureDate;
        update bankingTransaction;
        Test.stopTest();
        System.AssertEquals(futureDate, bankingTransaction.dmpl__Date__c, 'Bank Date should not be updated.');
        System.assertNotEquals(null, bankingTransaction, 'BankingTransaction should be created.');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals('Payroll Deposit - Hotel', bankingTransaction.dmpl__Narration__c, 'Narration mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Deposit mismatch');
        System.assertEquals(sbiGLAccount.Id, bankingTransaction.dmpl__GLAccountId__c, 'GL Account mismatch');
        System.assertEquals(partnerAccount3.Id, bankingTransaction.dmpl__PartnerAccountId__c, 'Partner Accounts mismatch');
    }

    @isTest
    static void createBankingTransactionWithoutDateNegative(){
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Boolean exceptionThrown = false;
        dmpl__BankingTransaction__c bankingTransaction;
        Test.startTest();
        try {
            bankingTransaction = BankingTransactionTestDataHelpers.createCustomBankingTransaction(
                'Transaction No Date',
                null,
                2000,
                'Test Payee',
                1000,
                sbiGLAccount.Id
            );
            insert bankingTransaction;
            System.assert(false, 'Exception should have been thrown when Date is null.');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Date'), 'Exception should mention missing Date.');
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when creating BankingTransaction without Date.');
    }
}