@isTest
public with sharing class FinancerDataHelper {
    public static dmpl__Financer__c createFinancer(
        Id customerAccountId
    ) {
        return (dmpl__Financer__c) TestFactory.createSObject(
            new dmpl__Financer__c(
                dmpl__AccountId__c = customerAccountId
            ),
            'FinancerDefaults',
            true
        );
    }

    public static dmpl__Financer__c createFinancer(
        Account customerAccount, 
        String name,
        dmpl__Branch__c branch
    ) {
        return (dmpl__Financer__c) TestFactory.createSObject(
            new dmpl__Financer__c(
                Name = name,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__Branch__c = branch!=null?branch.Id:null
            ),
            'FinancerDefaults',
            true
        );
    }

    public static dmpl__Financer__c getFinancer() {
        return [
            SELECT 
                Id, 
                dmpl__Address__c, 
                Name
            FROM dmpl__Financer__c
            LIMIT 1
        ];
    }

    public static dmpl__Financer__c getFinancer(
        Id financerId
    ) {
        return [
            SELECT 
                Id, 
                dmpl__Address__c, 
                Name,
                dmpl__AccountId__c
            FROM dmpl__Financer__c
            WHERE Id = :financerId
            LIMIT 1
        ];
    }

    public static List<dmpl__Financer__c> getFinancers() 
    {
        return [
            SELECT 
                Id, 
                dmpl__Address__c, 
                Name
            FROM dmpl__Financer__c
        ];
    }

    public static dmpl__FinancerScheme__c createFinancerScheme(
        dmpl__Financer__c financer,
        Id applicablePartnerAccountId,
        Id applicableToPartnerAccountGroupId
    ) {
        return (dmpl__FinancerScheme__c) TestFactory.createSObject(
            new dmpl__FinancerScheme__c(
                dmpl__FinancerId__c = financer.Id,
                dmpl__ApplicablePartnerAccountId__c = applicablePartnerAccountId,
                dmpl__ApplicableToPartnerAccountGroupId__c = applicableToPartnerAccountGroupId
            ),
            'FinancerSchemeDefaults',
            true
        );
    }

    public static dmpl__FinancerScheme__c createFinancerScheme(
        dmpl__Financer__c financer,
        String name,
        Decimal miniAmount,
        Integer maxiTenure,
        Decimal interestRate,
        Integer miniTenure,
        Id partner,
        Id applicableToPartnerAccountGroupId,
         String externalId 
    ) {
        return (dmpl__FinancerScheme__c) TestFactory.createSObject(
            new dmpl__FinancerScheme__c(
                dmpl__FinancerId__c = financer.Id,
                Name = name,
                dmpl__MinimumAmount__c = miniAmount,
                dmpl__MaximumTenure__c = maxiTenure,
                dmpl__InterestRate__c = interestRate, 
                dmpl__MinimumTenure__c = miniTenure ,
                dmpl__ApplicablePartnerAccountId__c = partner != null ? partner : null,
                dmpl__ExternalId__c=externalId != null ? externalId : null,
                dmpl__ApplicableToPartnerAccountGroupId__c = applicableToPartnerAccountGroupId
               ),
            'FinancerSchemeDefaults',
            true
        );
    }
   
    public static dmpl__FinancerScheme__c createFinancerScheme(
        dmpl__Financer__c financer,
        String name,
        Decimal miniAmount,
        Decimal maxiAmount,
        Integer maxiTenure,
        Decimal interestRate,
        Integer miniTenure,
        Id partner,
        Id applicableToPartnerAccountGroupId,
        String externalId 
    ) {
        return (dmpl__FinancerScheme__c) TestFactory.createSObject(
            new dmpl__FinancerScheme__c(
                dmpl__FinancerId__c = financer.Id,
                Name = name,
                dmpl__MinimumAmount__c = miniAmount,
                dmpl__MaximumTenure__c = maxiTenure,
				dmpl__MaximumAmount__c = maxiAmount,
                dmpl__InterestRate__c = interestRate, 
                dmpl__MinimumTenure__c = miniTenure ,
                dmpl__ApplicablePartnerAccountId__c = partner != null ? partner : null,
                dmpl__ExternalId__c=externalId != null ? externalId : null,
                dmpl__ApplicableToPartnerAccountGroupId__c = applicableToPartnerAccountGroupId!= null ? applicableToPartnerAccountGroupId : null
               ),
            'FinancerSchemeDefaults',
            true
        );
    }

    public static dmpl__FinancerScheme__c getFinancerScheme() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FinancerId__c, 
                dmpl__ApplicablePartnerAccountId__c, 
                dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
            LIMIT 1
        ];
    }

    public static dmpl__FinancerScheme__c getFinancerScheme(
        Id schemeId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FinancerId__c, 
                dmpl__ApplicablePartnerAccountId__c, 
                dmpl__ApplicableToPartnerAccountGroupId__c,
                dmpl__MinimumAmount__c,
                dmpl__MaximumTenure__c, 
                dmpl__InterestRate__c, 
                dmpl__MinimumTenure__c,
                dmpl__ExternalId__c,
                dmpl__Description__c,
                dmpl__Features__c
            FROM dmpl__FinancerScheme__c
            WHERE Id = :schemeId
            LIMIT 1
        ];
    }

    public static List<dmpl__FinancerScheme__c> getFinancerSchemes() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FinancerId__c, 
                dmpl__ApplicablePartnerAccountId__c, 
                dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
        ];
    }
}