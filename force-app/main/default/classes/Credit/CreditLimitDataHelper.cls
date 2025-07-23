@isTest
public with sharing class CreditLimitDataHelper {
    public static dmpl__CreditLimit__c createCreditLimit(
        Account partnerAccount, 
        Account customerAccount
    ) {
        return (dmpl__CreditLimit__c) TestFactory.createSObject(
            new dmpl__CreditLimit__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__AccountId__c = customerAccount.Id
            ),
            'CreditLimitDefaults',
            true
        );
    }

     public static dmpl__CreditLimit__c createCreditLimit(
        Account partnerAccount, 
        Account customerAccount,
        Decimal creditDays,
        Decimal creditLimitAmount,
        Decimal utilizedLimit
     ) {
        return (dmpl__CreditLimit__c) TestFactory.createSObject(
            new dmpl__CreditLimit__c(
                dmpl__PartnerAccountId__c = partnerAccount!=null?partnerAccount.Id:null,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__CreditDays__c = creditDays,
                dmpl__CreditLimitAmount__c = creditLimitAmount,
                dmpl__UtilizedLimit__c = utilizedLimit
            ),
            'CreditLimitDefaults',
            true
        );
    }
    
    public static dmpl__CreditLimit__c getCreditLimit() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PartnerAccountId__c, 
                dmpl__AccountId__c,
                dmpl__CreditLimitAmount__c,
                dmpl__UtilizedLimit__c, 
                dmpl__CreditDays__c,
                dmpl__AvaliableLimit__c
            FROM dmpl__CreditLimit__c
            LIMIT 1
        ];
    }

    public static dmpl__CreditLimit__c getCreditLimit(
        Id creditLimitId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PartnerAccountId__c, 
                dmpl__AccountId__c,
                dmpl__CreditLimitAmount__c, 
                dmpl__UtilizedLimit__c, 
                dmpl__CreditDays__c,
                dmpl__AvaliableLimit__c
            FROM dmpl__CreditLimit__c
            WHERE Id = :creditLimitId
            LIMIT 1
        ];
    }
}