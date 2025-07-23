@isTest
public with sharing class CreditLimitHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 10');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(partnerAccount, customerAccount);
    }
    
    @isTest
    static void createCreditLimitPositive() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        System.assertNotEquals(creditLimit, null, 'Expected Credit Limit to be created.');
        System.assertEquals(100000, creditLimit.dmpl__CreditLimitAmount__c, 'Expected credit limit to match default.');
    }
    
    @isTest
    static void updateCreditLimitPositive() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        System.assertNotEquals(creditLimit, null, 'Expected Credit Limit to be created.');
        creditLimit.dmpl__CreditDays__c = 45;
        update creditLimit;
        dmpl__CreditLimit__c updated = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(updated, null, 'Expected Credit Limit to be created.');
        System.assertEquals(45, updated.dmpl__CreditDays__c, 'Expected updated credit days.');
    }
    
    @isTest
    static void deleteCreditLimit() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        System.assertNotEquals(creditLimit, null, 'CreditLimit should exist before delete.');
        delete creditLimit;
        dmpl__CreditLimit__c deletedLimit = null;
        try {
            deletedLimit = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        } catch (Exception e) {
            deletedLimit = null;
        }
        System.assertEquals(null, deletedLimit, 'CreditLimit should be deleted and not found after deletion.');
    }
    
    @isTest
    static void createNewCreditLimitRecordLinkedToAValidPartnerAndAccountPositiveNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            100,
            50000,
            0
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(100, inserted.dmpl__CreditDays__c, 'Credit Days should match');
        System.assertEquals(50000, inserted.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should match');
        System.assertEquals(0, inserted.dmpl__UtilizedLimit__c, 'Utilized Limit should be 0');
        System.assertEquals(50000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should match Credit Limit Amount');
    }
    
    @isTest
    static void createCreditLimitWithValidAmountDaysAndTotalCreditLimitNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            100,
            50000,
            0
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(100, inserted.dmpl__CreditDays__c, 'Credit Days should match');
        System.assertEquals(50000, inserted.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should match');
        System.assertEquals(0, inserted.dmpl__UtilizedLimit__c, 'Utilized Limit should be 0');
        System.assertEquals(50000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should match Credit Limit Amount');
    }
    
    @isTest
    public static void autoCalculateAvailableLimitAsTotalCreditLimitMinusUtilizedLimitPositiveEdit(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            100,
            50000,
            0
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(50000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should match Credit Limit Amount initially');
        inserted.dmpl__UtilizedLimit__c = 6000;
        update inserted;
        dmpl__CreditLimit__c updated = CreditLimitDataHelper.getCreditLimit(inserted.Id);
        System.assertEquals(50000, updated.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should remain same');
        System.assertEquals(6000, updated.dmpl__UtilizedLimit__c, 'Utilized Limit should be updated');
        System.assertEquals(44000, updated.dmpl__AvaliableLimit__c, 'Available Limit should be Credit Limit Amount minus Utilized Limit after update');
    }
    
  	@isTest
    public static void assignCreditLimitWithoutLinkingPartnerAccountPositiveNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            null,
            customerAccount,
            100,
            50000,
            6000
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(100, inserted.dmpl__CreditDays__c, 'Credit Days should match');
        System.assertEquals(50000, inserted.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should match');
        System.assertEquals(6000, inserted.dmpl__UtilizedLimit__c, 'Utilized Limit should match');
        System.assertEquals(44000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should be Credit Limit Amount minus Utilized Limit');
    }
    
    @isTest
    public static void creditLimitAmountLowerThanCurrentOutstandingAmountPositiveNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            100,
            4000,
            6000
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(4000, inserted.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should match');
        System.assertEquals(6000, inserted.dmpl__UtilizedLimit__c, 'Utilized Limit should match');
        System.assertEquals(-2000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should be Credit Limit Amount minus Utilized Limit');
    }
        
    @isTest
    public static void creditLimitWithExcessiveCreditDaysPositiveNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            99999,
            4000,
            6000
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(99999, inserted.dmpl__CreditDays__c, 'Credit Days should match');
        System.assertEquals(4000, inserted.dmpl__CreditLimitAmount__c, 'Credit Limit Amount should match');
        System.assertEquals(6000, inserted.dmpl__UtilizedLimit__c, 'Utilized Limit should match');
        System.assertEquals(-2000, inserted.dmpl__AvaliableLimit__c, 'Available Limit should be Credit Limit Amount minus Utilized Limit');
    }
    
    @isTest
    public static void autoBlockOrdersIfAvailableLimitIsZeroOrNegative_PositiveEdit() {
        test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.createCreditLimit(
            partnerAccount,
            customerAccount,
            30,
            10000,
            2000
        );
        dmpl__CreditLimit__c inserted = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertNotEquals(null, inserted.Id, 'Credit Limit should be inserted');
        System.assertEquals(partnerAccount.Id, inserted.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, inserted.dmpl__AccountId__c, 'Customer Account should match');
        inserted.dmpl__CreditLimitAmount__c = -9999;
        inserted.dmpl__CreditDays__c = 99999;
        update inserted;
        dmpl__CreditLimit__c updated = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertEquals(-11999, updated.dmpl__AvaliableLimit__c, 'Available Limit should be negative after update');
        test.stopTest();
    }
}