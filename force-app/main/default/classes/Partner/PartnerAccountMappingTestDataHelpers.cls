@isTest
public class PartnerAccountMappingTestDataHelpers {
    public static dmpl__PartnerAccountMapping__c createPartnerAccountMapping(
        String name
    ) {
        return (dmpl__PartnerAccountMapping__c) TestFactory.createSObject(
            new dmpl__PartnerAccountMapping__c(
                Name = name
            ),
            'PartnerAccountMappingDefaults',
            true
        );
    }

    public static dmpl__PartnerAccountMapping__c createPartnerAccountMapping(
        String name,
        Id partnerAccountId
    ) {
        return (dmpl__PartnerAccountMapping__c) TestFactory.createSObject(
            new dmpl__PartnerAccountMapping__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            'PartnerAccountMappingDefaults',
            true
        );
    }

    public static dmpl__PartnerAccountMapping__c createPartnerAccountMapping(
        String name,
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__ItemGroup__c itemGroup,
        dmpl__Item__c item,
        Account partnerAccount,
        Date toDate
    ) {
        return (dmpl__PartnerAccountMapping__c) TestFactory.createSObject(
            new dmpl__PartnerAccountMapping__c(
                Name = name,
                dmpl__AccountId__c = customerAccount != null ? customerAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__ItemGroupId__c = itemGroup != null ? itemGroup.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__ToDate__c = toDate
            ),
            'PartnerAccountMappingDefaults',
            true
        );
    }
    
    public static dmpl__PartnerAccountMapping__c getPartnerAccountMappingById(
        Id mappingId
    ) {
        return [
            SELECT
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ItemGroupId__c,
                dmpl__ItemId__c,
                dmpl__FromDate__c,
                dmpl__ToDate__c
            FROM dmpl__PartnerAccountMapping__c
            WHERE Id = :mappingId
            LIMIT 1
        ];
    }
    
    public static dmpl__PartnerAccountMapping__c getPartnerAccountMapping() {
        return [
            SELECT  
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ItemGroupId__c,
                dmpl__ItemId__c,
                dmpl__FromDate__c,
                dmpl__ToDate__c
            FROM dmpl__PartnerAccountMapping__c
            LIMIT 1
        ];
    }
    
    public static dmpl__PartnerAccountMapping__c getPartnerAccountMapping(
        Id id
    ) {
        return [
            SELECT 
                Id, 
                dmpl__FromDate__c, 
                dmpl__ToDate__c,
                Name
            FROM dmpl__PartnerAccountMapping__c
            WHERE Id = : id
            LIMIT 1
        ];
    }
}