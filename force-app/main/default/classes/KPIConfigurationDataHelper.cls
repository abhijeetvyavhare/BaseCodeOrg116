public with sharing class KPIConfigurationDataHelper {
    public static dmpl__KPIConfiguration__c createKPIConfiguration(
        String name, 
        String memberType, 
        String dateFieldName
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = name, 
                dmpl__MemberType__c = memberType, 
                dmpl__DateFieldName__c = dateFieldName, 
                dmpl__IsActive__c = true
            ), 
            true
        );
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration(
        String kpiConfigName
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__MemberType__c, 
                dmpl__DateFieldName__c, 
                dmpl__IsActive__c
            FROM dmpl__KPIConfiguration__c
            WHERE Name = :kpiConfigName
            LIMIT 1
        ];
    }

    public static dmpl__KPIConfiguration__c createKPIConfiguration(
        String kpiName, 
        String memberType, 
        String dateFieldName, 
        Boolean isActive
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = kpiName, 
                dmpl__MemberType__c = memberType, 
                dmpl__DateFieldName__c = dateFieldName, 
                dmpl__IsActive__c = isActive != null ? isActive : false
            ), 
            true
        );
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__MemberType__c, 
                dmpl__DateFieldName__c, 
                dmpl__IsActive__c
            FROM dmpl__KPIConfiguration__c
            LIMIT 1
        ];
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration(
        Id configId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__MemberType__c, 
                dmpl__DateFieldName__c, 
                dmpl__IsActive__c
            FROM dmpl__KPIConfiguration__c
            WHERE Id = :configId
            LIMIT 1
        ];
    }
}