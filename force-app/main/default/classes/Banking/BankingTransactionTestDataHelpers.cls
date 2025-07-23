public with sharing class BankingTransactionTestDataHelpers {
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
                dmpl__Date__c,
                dmpl__Narration__c,
                dmpl__PartnerAccountId__c
            FROM dmpl__BankingTransaction__c 
            LIMIT 1
        ];
    }

    public static dmpl__BankingTransaction__c getBankingTransaction(
        Id id
    ){
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__Withdrawal__c, 
                dmpl__Payee__c, 
                dmpl__Deposit__c, 
                dmpl__GLAccountId__c, 
                dmpl__Date__c,
                dmpl__Narration__c,
                dmpl__PartnerAccountId__c
            FROM dmpl__BankingTransaction__c 
            WHERE Id = :id 
            LIMIT 1
        ];
    }
}