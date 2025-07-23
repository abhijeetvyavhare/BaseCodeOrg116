@isTest 
public with sharing class JournalEntryHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Id partnerAccountId = partnerAccount.Id;
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(1, accountGroup1.Id);
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);   
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partnerAccountId);
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.createJournalEntryLines(journal.Id);
    }
     
    @isTest
    static void createJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        System.assertNotEquals(journal, null, 'Expected Journal Entry to be created.');
        System.assertEquals('INR', journal.dmpl__Currency__c, 'Expected currency to be INR.');
    }
     
    @isTest
    static void updateJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        journal.dmpl__Notes__c = 'Updated notes';
        update journal;        
        dmpl__JournalEntry__c updatedJournal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals('Updated notes', updatedJournal.dmpl__Notes__c, 'Expected notes to be updated.');
    }

    @isTest
    static void deleteJournalEntry() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        delete journal;
        Integer count = [SELECT COUNT() FROM dmpl__JournalEntry__c WHERE Id = :journal.Id];
        System.assertEquals(0, count, 'Expected Journal Entry to be deleted.');
    }
    
    @isTest
    static void createJournalEntryLinesPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        System.assert(lines.size() > 0, 'Expected at least one Journal Entry Line.');
    }
     
    @isTest
    static void updateJournalEntryLinePositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            dmpl__JournalEntryLine__c line = lines[0];
            line.dmpl__Credit__c = 500;
            update line;
            dmpl__JournalEntryLine__c updatedLine = JournalEntryDataHelper.getJournalEntryLine(line.Id);
            System.assertEquals(500, updatedLine.dmpl__Credit__c, 'Expected credit amount to be updated.');
        }
    }
     
    @isTest
    static void deleteJournalEntryLine() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            Id lineIdToDelete = lines[0].Id;
            delete lines[0];
            Integer count = [SELECT COUNT() FROM dmpl__JournalEntryLine__c WHERE Id = :lineIdToDelete];
            System.assertEquals(0, count, 'Expected Journal Entry Line to be deleted.');
        }
    }

    @isTest 
    static void createRecordWithValidDocumentDateCurrencyAndPartnerAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals(journal.dmpl__PartnerAccountId__c, partner1.Id, 'Expected journal entry to be linked to the correct partner.');
        System.assertEquals(journal.dmpl__Currency__c, 'INR', 'Expected journal entry to have the correct currency.');
        System.assertEquals(journal.dmpl__DocumentDate__c, Date.today(), 'Expected journal entry to have the correct document date.');
        Test.stopTest();
    }

    @isTest
    static void validateCreationWithOnlyRequiredFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals(journal.dmpl__PartnerAccountId__c, partner1.Id, 'Expected journal entry to be linked to the correct partner.');
        System.assertEquals(journal.dmpl__Currency__c, 'INR', 'Expected journal entry to have the correct currency.');
        System.assertEquals(journal.dmpl__DocumentDate__c, Date.today(), 'Expected journal entry to have the correct document date.');
        Test.stopTest();
    }

    @isTest
    static void skipMandatoryFieldDocumentDateNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try{
            dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',null);
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch(Exception e) {
            System.Assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void useInvalidValueInCurrencyNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try{
            dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'LRDT',System.today());
            System.assert(false, 'Expected an exception to be thrown due to invalid currency.');
        } catch(Exception e) {
            System.assert(true, 'Expected exception due to invalid currency.');
        }
        Test.stopTest();
    }

    @isTest
    static void createRecordWithValidDebitCreditJournalEntryPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(journal.Id,100,200);
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        System.assertEquals(journalEntryLine.dmpl__Credit__c, 200, 'Expected journal entry line to have the correct credit amount.');
        System.assertEquals(journalEntryLine.dmpl__Debit__c, 100, 'Expected journal entry line to have the correct debit amount.');
        Test.stopTest();
    }

    @isTest
    static void validateEntryWithOnlyDebitOrCreditPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(journal.Id,100,null);
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        Test.stopTest();
    }

    @isTest
    static void doNotPopulateMandatoryJournalEntryLineFieldNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        try{
            dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(null,100,200);
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch( Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void inputNegativeValuesInCreditAndDebitPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partner1.Id,'INR',Date.today());
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(journal.Id,-100,-200);
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        System.assertEquals(journalEntryLine.dmpl__Credit__c, -200, 'Expected journal entry line to have the correct credit amount.');
        System.assertEquals(journalEntryLine.dmpl__Debit__c, -100, 'Expected journal entry line to have the correct debit amount.');
        Test.stopTest();
    }
}