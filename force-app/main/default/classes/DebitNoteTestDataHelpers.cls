public with sharing class DebitNoteTestDataHelpers {
    public static dmpl__DebitNote__c createDebitNote(
        Date dateToday
    ) {
        return (dmpl__DebitNote__c) TestFactory.createSObject(
            new dmpl__DebitNote__c(
                dmpl__DocumentDate__c = dateToday
            ),
            'DebitNoteDefaults',
            true
        );
    }

    public static dmpl__DebitNote__c createDebitNote(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Date documentedDate
    ) {
        return (dmpl__DebitNote__c) TestFactory.createSObject(
            new dmpl__DebitNote__c(
                dmpl__DocumentDate__c = documentedDate,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null
            ),
            'DebitNoteDefaults',
            true
        );
    }
    
    public static dmpl__DebitNote__c getDebitNote() {
        return [
            SELECT Id, Name, dmpl__DocumentDate__c, dmpl__AdjustedAmount__c
            FROM dmpl__DebitNote__c
            LIMIT 1
        ];
    }
    
    public static dmpl__DebitNoteLines__c createDebitNoteLines(
        Id debitNoteId
    ) {
        return (dmpl__DebitNoteLines__c) TestFactory.createSObject(
            new dmpl__DebitNoteLines__c(
                dmpl__DebitNoteId__c = debitNoteId
            ),
            'DebitNoteLinesDefaults',
            true
        );
    }

    public static dmpl__DebitNoteLines__c createDebitNoteLine(
        dmpl__DebitNote__c debitNote,
        dmpl__GLAccount__c glAccountId,
        Account partnerAccount,
        Decimal amount,
        String description
    ) {
        return (dmpl__DebitNoteLines__c) TestFactory.createSObject(
            new dmpl__DebitNoteLines__c(
                dmpl__DebitNoteId__c = debitNote != null ? debitNote.Id : null,
                dmpl__GLAccountId__c = glAccountId != null ? glAccountId.Id : null,
                dmpl__AccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__Amount__c = amount,
                dmpl__Description__c = description
            ),
            'DebitNoteLinesDefaults',
            true
        );
    }
    
    public static dmpl__DebitNoteLines__c getDebitNoteLines() {
        return [
            Select Id 
            FROM dmpl__DebitNoteLines__c
            LIMIT 1
        ];
    }
    
    public static List<dmpl__DebitNoteLines__c> getDebitNoteLines(Id id) {
        return [
            Select Id 
            FROM dmpl__DebitNoteLines__c
            WHERE Id = :id
        ];
    }
}