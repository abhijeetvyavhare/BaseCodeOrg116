public with sharing class KPIDataHelper {
    public static dmpl__KPIData__c createKPIData(
        dmpl__KPIConfiguration__c kpiConfig,
        Account account,
        dmpl__Branch__c branch,
        Account partnerAccount,
        dmpl__Resource__c resource
    ) {
        return (dmpl__KPIData__c) TestFactory.createSObject(
            new dmpl__KPIData__c(
                dmpl__KPIConfigurationId__c = kpiConfig != null ? kpiConfig.Id : null,
                dmpl__AccountId__c = account != null ? account.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__ResourceId__c = resource != null ? resource.Id : null
            ),
            'KPIDataDefaults',
            true
        );
    }

    
    public static dmpl__KPIData__c createKPIData(
        String name,
        Id kpiConfig
    ) {
        return (dmpl__KPIData__c) TestFactory.createSObject(
            new dmpl__KPIData__c(
                Name = name,
                dmpl__KPIConfigurationId__c = kpiConfig
            ),
            'KPIDataDefaults',
            true
        );
    }
    
    public static dmpl__KPIData__c getKPIData() {
        return [ 
            SELECT 
                Id, 
                Name, 
                dmpl__KPIConfigurationId__c, 
                dmpl__AccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__IncentivePeriodId__c,
                dmpl__IncentivePlanId__c,
                dmpl__ResourceId__c, 
                dmpl__KPIValue__c, 
                dmpl__RewardValue__c
            FROM dmpl__KPIData__c
            WHERE Name = 'Test-KPI-Data'
            LIMIT 1
        ];
    }
    
    public static dmpl__KPIData__c getKPIData(
        Id kpiDataId
    ) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__KPIConfigurationId__c, 
                dmpl__AccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__ResourceId__c, 
                dmpl__KPIValue__c, 
                dmpl__RewardValue__c
            FROM dmpl__KPIData__c
            WHERE Id = :kpiDataId
            LIMIT 1
        ];
    }
    
    public static dmpl__KPIConfiguration__c  createKPIConfiguration(
        String name, 
        String memberType, 
        String dateFieldName
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = name, 
                dmpl__MemberType__c = memberType, 
                dmpl__DateFieldName__c = dateFieldName
            ),
            'KPIConfigurationDefaults',
            true
        );
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__MemberType__c,
                dmpl__DateFieldName__c
            FROM dmpl__KPIConfiguration__c
            WHERE Name = 'Test KPI Config'
        ];
    }
}