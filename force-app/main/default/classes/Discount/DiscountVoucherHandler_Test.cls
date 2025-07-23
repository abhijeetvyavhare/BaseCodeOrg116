@isTest
    public with sharing class DiscountVoucherHandler_Test {
        @TestSetup
        static void createRequiredData() {
            Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
            Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);      
            dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
            dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.createDiscountVoucher(customerAccount, branch, partnerAccount);
        }

        @isTest
        static void createDiscountVoucher() {
            dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
            System.assertNotEquals(null, dv, 'Discount Voucher should be created');
            System.assertEquals(100.00, dv.dmpl__Amount__c, 'Discount Voucher amount should be 100');
            System.assertNotEquals(null, dv.dmpl__AccountId__c, 'Account lookup should not be null');
            System.assertNotEquals(null, dv.dmpl__BranchId__c, 'Branch lookup should not be null');
            System.assertNotEquals(null, dv.dmpl__PartnerAccountId__c, 'Partner Account lookup should not be null');
        }

    @isTest
    static void updateDiscountVoucherPositive() {
            dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
            System.assertNotEquals(null, dv, 'Discount Voucher should exist before update');
            dv.dmpl__Amount__c = 150.00;
            update dv;
            dmpl__DiscountVoucher__c updatedDV = DiscountVoucherTestDataHelper.getDiscountVoucher();
            System.assertEquals(150.00, updatedDV.dmpl__Amount__c, 'Discount Voucher amount should be updated to 150');
        }

    @isTest
    static void deleteDiscountVoucher() {
            dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
            System.assertNotEquals(null, dv, 'Discount Voucher should exist before delete');
            delete dv;
            dmpl__DiscountVoucher__c deletedDV;
            try {
                deletedDV = DiscountVoucherTestDataHelper.getDiscountVoucher();
            } catch (Exception e) {
                deletedDV = null;
            }
            System.assertEquals(null, deletedDV, 'Discount Voucher should be deleted and not found in query');
        }
    @isTest
    static void createDiscountVoucherWithCorrectPartnerAndBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }

    @isTest
    static void createDiscountVoucherWithWrongPartnerPositive() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }

    @isTest
    static void updateDiscountVoucherWithWrongPartnerPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');
        fetchedVoucher.dmpl__PartnerAccountId__c = partner3.Id;
        update fetchedVoucher;
        Test.stopTest();
        dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);
        System.assertEquals(partner3.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
        System.assertEquals(branch1.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
    }

    @isTest
        static void createDiscountVoucherWithActivePartnerWithoutBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, null);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(null, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }

    @isTest
    static void updateDiscountVoucherWithActivePartnerWithoutBranchPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');
        fetchedVoucher.dmpl__BranchId__c = null;
        update fetchedVoucher;
        Test.stopTest();
        dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);
        System.assertEquals(partner1.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 1');
        System.assertEquals(null, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
    }

    @isTest
        static void createDiscountVoucherWithWrongBranchPositive() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }

    @isTest
    static void updateDiscountVoucherWithWrongBranchPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');
        fetchedVoucher.dmpl__BranchId__c = branch3.Id;
        update fetchedVoucher;
        Test.stopTest();
        dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);
        System.assertEquals(partner1.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
        System.assertEquals(branch3.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
    }

    @isTest
    static void createDiscountVoucherWithInactiveBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id);
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch3);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch3.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }

    @isTest
    static void updateDiscountVoucherWithInactiveBranchPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');
        fetchedVoucher.dmpl__PartnerAccountId__c = partner3.Id;
        fetchedVoucher.dmpl__BranchId__c=branch3.Id;
        update fetchedVoucher;
        Test.stopTest();
        dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);
        System.assertEquals(partner3.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
        System.assertEquals(branch3.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
    }
}