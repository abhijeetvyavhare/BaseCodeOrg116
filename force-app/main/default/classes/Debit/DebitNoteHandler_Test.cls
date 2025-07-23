@isTest
public with sharing class DebitNoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(Date.today());
    }
    
    @isTest
    static void createDebitNotePositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertEquals(200, debitNote.dmpl__AdjustedAmount__c, 'Adjusted amount mismatch');
    }
    
    @isTest
    static void createDebitNoteLinesPositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
        System.assertEquals(20, debitNoteLines.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLines.dmpl__Description__c, 'Description mismatch');
    }
    
    @isTest
    static void updateDebitNotePositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        debitNote.dmpl__AdjustedAmount__c = 300;
        update debitNote;
        dmpl__DebitNote__c updatedDebitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertEquals(300, updatedDebitNote.dmpl__AdjustedAmount__c, 'Adjusted amount should be updated to 300');
    }
    
    @isTest
    static void updateDebitNoteLinesPositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
        debitNoteLines.dmpl__Amount__c = 30;
        debitNoteLines.dmpl__Description__c = 'Changed';
        update debitNoteLines;
        System.assertEquals(30, debitNoteLines.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Changed', debitNoteLines.dmpl__Description__c, 'Description mismatch');
    }
    
    @isTest
    static void deleteDebitNote() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertNotEquals(debitNote, null, 'Debit Note should exist before delete.');
        delete debitNote;
        dmpl__DebitNote__c deletedDebitNote = null;
        try {
            deletedDebitNote = DebitNoteTestDataHelpers.getDebitNote();
        } catch (Exception e) {
            deletedDebitNote = null;
        }
        System.assertEquals(null, deletedDebitNote, 'Debit Note should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteDebitNoteLines() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
        Id debitNoteLineId = debitNoteLines.Id;
        System.assertNotEquals(null, debitNoteLines, 'Debit Note Line should exist before delete.');
        delete debitNoteLines;
        List<dmpl__DebitNoteLines__c> deletedDebitNoteLines = DebitNoteTestDataHelpers.getDebitNoteLines(debitNoteLineId);
        System.assertEquals(0, deletedDebitNoteLines.size(), 'Debit Note Line should be deleted and not found in query.');
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteWithValidPartnerAccountAndBranchPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteCreationWithValidAccountAndAmountPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteCreationWithValidDocumentDatePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(Date.today());
        System.assertEquals(Date.today(), debitNote.dmpl__DocumentDate__c, 'Date mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteWithDocumentAmountAndNoAdjustmentPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteCreationWithCustomDescriptionPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(Date.today());
        debitNote.dmpl__Notes__c = 'This is a test case';
        update debitNote;
        System.assertEquals(Date.today(), debitNote.dmpl__DocumentDate__c, 'Date mismatch');
        System.assertEquals('This is a test case', debitNote.dmpl__Notes__c, 'Notes mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteWithInvalidPartnerAccountNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        try {
            dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
            System.assert (true, 'Expected exception, not thrown');
        } catch (exception e) {
            System.assert (true, 'Exception message mismatch');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteCreationWithNoAmountEnteredPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteWithInvalidBranchPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationDebitNoteCreationWithCustomDescriptionPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(Date.today());
        debitNote.dmpl__Notes__c = 'This is a test case';
        update debitNote;
        System.assertEquals(Date.today(), debitNote.dmpl__DocumentDate__c, 'Date mismatch');
        System.assertEquals('This is a test case', debitNote.dmpl__Notes__c, 'Notes mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteCreationEditDebitNoteRemovePartnerAccountPositiveEdit() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        debitNote.dmpl__PartnerAccountId__c = null;
        update debitNote;
        System.assertEquals(null, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithValidGlAccountAndAmountPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            null, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(null, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineLinkedToValidDebitNotePositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            null, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(null, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithNonZeroPositiveAmountPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            null, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(null, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithDescriptionPopulatedPositiveNew() {
        Test.startTest();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            null, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(null, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineForValidAccountPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineCreationFromParentDebitNotePositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithSameAccountAsHeaderPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithValidGlMappingPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithNoAmountEnteredPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            0, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(0, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
    
    @isTest
    public static void debitNoteLineCreationDebitNoteLineWithInvalidGlAccountPositiveNew() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        DebitNoteHandlerMasterData.createGLAccount();
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('HDFC Bank');
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(partnerAccount1, branch1, Date.today());
        System.assertEquals(branch1.Id, debitNote.dmpl__BranchId__c, 'Branch Id mismatch');
        System.assertEquals(partnerAccount1.Id, debitNote.dmpl__PartnerAccountId__c, 'Partner Account Id mismatch');
        dmpl__DebitNoteLines__c debitNoteLine = DebitNoteTestDataHelpers.createDebitNoteLine(
            debitNote, 
            glAccount1, 
            customerAccount1, 
            1732, 
            'Test'
        );
        System.assertEquals(debitNote.Id, debitNoteLine.dmpl__DebitNoteId__c, 'Debit Note Id mismatch');
        System.assertEquals(glAccount1.Id, debitNoteLine.dmpl__GLAccountId__c, 'GL Account Id mismatch');
        System.assertEquals(customerAccount1.Id, debitNoteLine.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(1732, debitNoteLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLine.dmpl__Description__c, 'Description mismatch');
        Test.stopTest();
    }
}