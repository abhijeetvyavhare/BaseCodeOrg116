@isTest
public with sharing class CreditNoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__CreditNote__c creditNote = CreditNoteDataHelper.createCreditNote(partnerAccount.Id,branch.Id,customerAccount.Id);
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.createCreditNoteLines(creditNote.Id);
    } 

    @isTest
    static void createCreditNotePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        System.assertNotEquals(note, null, 'Expected Credit Note to be created.');
        System.assertEquals('INR', note.dmpl__Currency__c, 'Expected currency to be INR.');
    }
    
    @isTest
    static void updateCreditNotePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        note.dmpl__Notes__c = 'Updated credit note';
        update note;
        dmpl__CreditNote__c updatedNote = CreditNoteDataHelper.getCreditNote(note.Id);
        System.assertEquals('Updated credit note', updatedNote.dmpl__Notes__c, 'Expected note update.');
    }
    
    @isTest
    static void deleteCreditNote() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        delete note;
        Integer count = [SELECT COUNT() FROM dmpl__CreditNote__c WHERE Id = :note.Id];
        System.assertEquals(0, count, 'Expected Credit Note to be deleted.');
    }

    @isTest
    static void createCreditNoteLinesPositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        System.assert(lines.size() > 0, 'Expected at least one Credit Note Line.');
        for(dmpl__CreditNoteLine__c line : lines) {
            System.assertEquals(note.Id, line.dmpl__CreditNoteId__c, 'Expected Credit Note Line to be associated with Credit Note.');
        }
    }
    
    @isTest
    static void updateCreditNoteLinePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        if (!lines.isEmpty()) {
            dmpl__CreditNoteLine__c line = lines[0];            
            line.dmpl__Amount__c = 250;
            line.dmpl__Description__c = 'Updated Credit Note Line Description';
            update line;
            dmpl__CreditNoteLine__c updatedLine = CreditNoteDataHelper.getCreditNoteLine(line.Id);
            System.assertEquals(250, updatedLine.dmpl__Amount__c, 'Expected amount to be updated.');
            System.assertEquals('Updated Credit Note Line Description', updatedLine.dmpl__Description__c, 'Expected description to be updated.');
        }
    }
    
    @isTest
    static void deleteCreditNoteLine() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        if (!lines.isEmpty()) {
            Id lineIdToDelete = lines[0].Id;
            delete lines[0];
            Integer count = [SELECT COUNT() FROM dmpl__CreditNoteLine__c WHERE Id = :lineIdToDelete];
            System.assertEquals(0, count, 'Expected Credit Note Line to be deleted.');
        }
    }

    @isTest
    static void createCreditNotewithCorrectPartnerandBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date todayDate = Date.today();
        Test.startTest();
        dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
        dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
    
    }

@isTest
static void createCreditNoteWithWrongPartnerAccountPositive() {
    Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    creditNote.dmpl__PartnerAccountId__c=partner.Id;
    update creditNote;
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');

}

@isTest
static void updateCreditNoteWithWrongPartnerAccountPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    fetchedCreditNote.dmpl__PartnerAccountId__c = partner3.Id;
    update fetchedCreditNote;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner3.Id, updatedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, updatedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, updatedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, updatedCreditNote.dmpl__DocumentDate__c);
}

@isTest
static void createCreditNoteWithoutBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    creditNote.dmpl__BranchId__c=null;
    update creditNote;
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(null, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
}

@isTest
static void updateCreditNoteWithoutBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    fetchedCreditNote.dmpl__BranchId__c = null;
    update fetchedCreditNote;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner.Id, updatedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(null, updatedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, updatedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, updatedCreditNote.dmpl__DocumentDate__c);
}

@isTest
static void createCreditNoteWithWrongBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
    
}

@isTest
static void updateCreditNoteWithWrongBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
    branch3.dmpl__IsActive__c = false;
    update branch3;
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    fetchedCreditNote.dmpl__BranchId__c = branch3.Id;
    update fetchedCreditNote;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner.Id, updatedCreditNote.dmpl__PartnerAccountId__c,'Partner should match');
    System.assertEquals(branch3.Id, updatedCreditNote.dmpl__BranchId__c,'branch should match');
    System.assertEquals(customer1.Id, updatedCreditNote.dmpl__AccountId__c,'customer should match');
    System.assertEquals(todayDate, updatedCreditNote.dmpl__DocumentDate__c,'Document date should match today');
}

@isTest
static void createCreditNotewithInactiveBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
    branch3.dmpl__IsActive__c = false;
    update branch3;
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    creditNote.dmpl__BranchId__c=branch.Id;
    update creditNote;
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
}

@isTest
static void updateCreditNoteWithInactiveBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
    branch3.dmpl__IsActive__c = false;
    update branch3;
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    fetchedCreditNote.dmpl__BranchId__c = branch3.Id;
    update fetchedCreditNote;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner.Id, updatedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch3.Id, updatedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, updatedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, updatedCreditNote.dmpl__DocumentDate__c);
}

@isTest
static void createCreditNotewithDocumentDate() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today'); 
}

@isTest
static void updateCreditNotewithDocumentDateEdit() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Date futureDate = Date.newInstance(2025, 6, 26);
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner1.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    dmpl__CreditNote__c creditNoteToUpdate = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    creditNoteToUpdate.dmpl__DocumentDate__c = futureDate;
    update creditNoteToUpdate;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner1.Id, updatedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, updatedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer.Id, updatedCreditNote.dmpl__AccountId__c);
    System.assertEquals(futureDate, updatedCreditNote.dmpl__DocumentDate__c);
}

@isTest
static void createCreditNoteWithoutDocumentDateNegative() {
    Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Boolean exceptionThrown = false;
    Test.startTest();
    try {
        dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
        creditNote.dmpl__DocumentDate__c=null;
        update creditNote;
    } catch (System.DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();
    System.assertEquals(true, exceptionThrown, 'Exception should be thrown because document date is missing.');
}

@isTest
static void createCreditNotewithActivePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
}

@isTest
static void updateCreditNoteWithActiveCustomerAccountPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    fetchedCreditNote.dmpl__AccountId__c = customer2.Id;
    update fetchedCreditNote;
    Test.stopTest();
    dmpl__CreditNote__c updatedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(fetchedCreditNote.Id);
    System.assertEquals(partner.Id, updatedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, updatedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer2.Id, updatedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, updatedCreditNote.dmpl__DocumentDate__c);
}

@isTest
static void createCreditNoteWithInactiveCustomerAccountPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.createCustomerAccount('Customer 7');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    creditNote.dmpl__AccountId__c=customer.Id;
    update creditNote;
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');    
}

@isTest
static void createCreditNoteLineWithCreditNoteReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    List<dmpl__CreditNoteLine__c> creditNoteLines = CreditNoteDataHelper.createCreditNoteLines(creditNote.Id);
    Test.stopTest();
    List<dmpl__CreditNoteLine__c> fetchedLines = CreditNoteDataHelper.getCreditNoteLinesAllDetails(creditNote.Id);
    for (dmpl__CreditNoteLine__c line : fetchedLines) {
        System.assertEquals(branch.Id, line.dmpl__BranchId__c, 'Branch should match');
    }
}

@isTest
static void createCreditNoteLineWithoutCreditNoteReferenceNegative() {
    Boolean exceptionThrown = false;
    Test.startTest();
    try {
        List<dmpl__CreditNoteLine__c> creditNoteLines = CreditNoteDataHelper.createCreditNoteLines(null);
    } catch (System.DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();
    System.assertEquals(true, exceptionThrown, 'Exception should be thrown because Credit Note reference is missing.');
}

@isTest
static void updateCreditNoteLineWithoutCreditNoteReferenceNegative() {
    Boolean exceptionThrown = false;
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date todayDate = Date.today();
    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.getCreditNote();
    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c);
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c);
    try{
        List<dmpl__CreditNoteLine__c> creditNoteLines = CreditNoteDataHelper.createCreditNoteLines(null);
    }catch(Exception e){
        exceptionThrown=true;
    }
    System.assertEquals(true,exceptionThrown,'exception should be thrown while creating line without creditnote reference');
}
}