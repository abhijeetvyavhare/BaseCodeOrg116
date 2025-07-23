@isTest
public with sharing class BankingTransactionHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.createGLAccount(partnerAccount1, branch1, accountGroup);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        dmpl__Resource__c resource = TestDataHelpers.createResource('Resource 1');
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(
            glAccount.Id,
            'Rohan Kumar',
            'Payroll Deposit - Hotel',
            50000,
            partnerAccount1.Id
        );
    }

    @isTest
    static void createBankingTransactionPositive() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        System.assertNotEquals(bankingTransaction, null, 'BankingTransaction should be created.');
        System.assertEquals('Transaction1', bankingTransaction.Name, 'Name mismatch');
        System.assertEquals(Date.today(), bankingTransaction.dmpl__Date__c, 'Date mismatch');
        System.assertEquals(2000, bankingTransaction.dmpl__Deposit__c, 'Deposit mismatch');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Withdrawal mismatch');
        System.assertEquals('Categorized', bankingTransaction.dmpl__Status__c, 'Status mismatch');
    }
    
    @isTest
    static void updateBankingTransactionPositive() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        bankingTransaction.Name = 'Transaction';
        bankingTransaction.dmpl__Date__c = Date.today().addDays(1);
        bankingTransaction.dmpl__Deposit__c = 3000;
        bankingTransaction.dmpl__Payee__c = 'Test User 2';
        bankingTransaction.dmpl__Status__c = 'Pending';
        bankingTransaction.dmpl__Withdrawal__c = 1000;
        update bankingTransaction;
        dmpl__BankingTransaction__c updatedBankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction(bankingTransaction.Id);
        System.assertEquals('Transaction', updatedBankingTransaction.Name, 'Name should be updated.');
        System.assertEquals(Date.today().addDays(1), updatedBankingTransaction.dmpl__Date__c, 'Date should be updated.');
        System.assertEquals(3000, updatedBankingTransaction.dmpl__Deposit__c, 'Deposit should be updated.');
        System.assertEquals('Test User 2', updatedBankingTransaction.dmpl__Payee__c, 'Payee should be updated.');
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
    static void createBankingTransactionWithValidGLAccountAndNullPartnerAccountPositive() {
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        Test.stopTest();
        System.assertNotEquals(null, bankingTransaction, 'BankingTransaction should be created.');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals('Payroll Deposit - Hotel', bankingTransaction.dmpl__Narration__c, 'Narration mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Deposit mismatch');
        System.assertEquals(sbiGLAccount.Id, bankingTransaction.dmpl__GLAccountId__c, 'GL Account mismatch');
    }

    @isTest
    static void createBankingTransactionWithValidPartnerAccountPositive() {
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        bankingTransaction.dmpl__PartnerAccountId__c = partnerAccount3.Id;
        update bankingTransaction;
        Test.stopTest();
        System.assertNotEquals(null, bankingTransaction, 'BankingTransaction should be created.');
        System.assertEquals('Rohan Kumar', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals('Payroll Deposit - Hotel', bankingTransaction.dmpl__Narration__c, 'Narration mismatch');
        System.assertEquals(50000, bankingTransaction.dmpl__Withdrawal__c, 'Deposit mismatch');
        System.assertEquals(sbiGLAccount.Id, bankingTransaction.dmpl__GLAccountId__c, 'GL Account mismatch');
        System.assertEquals(partnerAccount3.Id, bankingTransaction.dmpl__PartnerAccountId__c, 'Partner Accounts mismatch');
    }

    @isTest
    static void updateBankDateToFutureDatePositive() {
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Date futureDate = System.today().addDays(30);
        Test.startTest();
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        bankingTransaction.dmpl__PartnerAccountId__c = partnerAccount3.Id;
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
    static void createBankingTransactionWithoutDateNegative() {
        dmpl__GLAccount__c sbiGLAccount = GLAccountDataHelper.getGLAccount();
        Boolean exceptionThrown = false;
        dmpl__BankingTransaction__c bankingTransaction;
        Test.startTest();
        try {
            bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
            bankingTransaction.dmpl__Date__c = null;
            update bankingTransaction;
            System.assert(false, 'Exception should have been thrown when Date is null.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when creating BankingTransaction without Date.');
    }
}