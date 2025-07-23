public with sharing class BankingTransactionTestDataHelpers {
    public static dmpl__BankingTransaction__c createBankingTransaction(
        Id glAccountId
    ) {
        return (dmpl__BankingTransaction__c)TestFactory.createSObject(
            new dmpl__BankingTransaction__c(
                dmpl__GLAccountId__c = glAccountId
            ),
            'BankingTransactionDefaults',
            true
        );
    }

    public static dmpl__BankingTransaction__c createCustomBankingTransaction(
        String name,
        Date transactionDate,
        Decimal depositAmount,
        String payee,
        Decimal withdrawalAmount,
        Id glAccountId
        ) {
        return (dmpl__BankingTransaction__c)TestFactory.createSObject(
            new dmpl__BankingTransaction__c(
                Name = name != null ? name : 'Transaction1',
                dmpl__Date__c = transactionDate != null ? transactionDate :  null,
                dmpl__Deposit__c = depositAmount != null ? depositAmount : 2000,
                dmpl__Payee__c = payee != null ? payee : 'Test Payee',
                dmpl__Withdrawal__c = withdrawalAmount != null ? withdrawalAmount : 1000,
                dmpl__Status__c = 'Categorized',
                dmpl__GLAccountId__c = glAccountId
            ),
            'BankingTransactionDefaults',
            true
        );
    }

    public static dmpl__BankingTransaction__c createBankingTransaction(
        Id glAccountId,
        String payeeName,
        String narration,
        Decimal withdrawalAmount,
        Id partnerAccountId
    ) {
        return (dmpl__BankingTransaction__c)TestFactory.createSObject(
            new dmpl__BankingTransaction__c(
                dmpl__GLAccountId__c = glAccountId,
                dmpl__Payee__c = payeeName,
                dmpl__Narration__c = narration,
                dmpl__Withdrawal__c = withdrawalAmount,
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            'BankingTransactionDefaults',
            true
        );
    }

    public static dmpl__BankingTransaction__c getBankingTransaction(){
        return [
            SELECT     	
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__Withdrawal__c, 
                dmpl__Payee__c, 
                dmpl__Deposit__c, 
                dmpl__GLAccountId__c, 
                dmpl__Date__c 
            FROM dmpl__BankingTransaction__c 
            LIMIT 1
        ];
    }

    public static dmpl__BankingTransaction__c getBankingTransaction(Id id){
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__Withdrawal__c, 
                dmpl__Payee__c, 
                dmpl__Deposit__c, 
                dmpl__GLAccountId__c, 
                dmpl__Date__c 
            FROM dmpl__BankingTransaction__c 
            WHERE Id = :id 
            LIMIT 1
        ];
    }
}