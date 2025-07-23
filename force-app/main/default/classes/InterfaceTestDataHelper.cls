@isTest
public with sharing class InterfaceTestDataHelper {
    public static dmpl__InterfaceLog__c createInterfaceLog() {
        return (dmpl__InterfaceLog__c) TestFactory.createSObject(
            new dmpl__InterfaceLog__c(
                dmpl__EndPoint__c = 'InterfaceLog EndPoint',
                dmpl__Method__c = 'Demo1',
                dmpl__HttpResponseCode__c = 'Log Response Code'
            ),
            'InterfaceLogDefaults',
            true
        );
    }
    
    public static dmpl__InterfaceLog__c createInterfaceLog(
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider,
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest
    ) {
        return (dmpl__InterfaceLog__c) TestFactory.createSObject(
            new dmpl__InterfaceLog__c(
                dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider?.Id,
                dmpl__InterfaceServiceProviderRequestId__c = interfaceServiceProviderRequest?.Id
            ),
            'InterfaceLogDefaults',
            true
        );
    }
    
    public static dmpl__InterfaceLog__c createInterfaceLog(
        String endpoint,
        String method,
        String payload,
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider,
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest
    ) {
        return (dmpl__InterfaceLog__c) TestFactory.createSObject(
            new dmpl__InterfaceLog__c(
                dmpl__EndPoint__c = endpoint,
                dmpl__Method__c = method,
                dmpl__Payload__c = payload,
                dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider?.Id,
                dmpl__InterfaceServiceProviderRequestId__c = interfaceServiceProviderRequest?.Id
            ),
            true
        );
    }
    
    public static dmpl__InterfaceLog__c getInterfaceLog() {
        return [
            SELECT 
                dmpl__EndPoint__c,
                dmpl__Method__c,
                dmpl__Payload__c,
                dmpl__InterfaceServiceProviderId__c,
                dmpl__InterfaceServiceProviderRequestId__c,
                dmpl__HttpResponseCode__c
            FROM dmpl__InterfaceLog__c 
            LIMIT 1
        ];  
    }
    
    public static dmpl__InterfaceLog__c getInterfaceLog(Id interfaceLogId) {
        return [
            SELECT
                Id,
                Name,
                dmpl__EndPoint__c,
                dmpl__Method__c,
                dmpl__Payload__c,
                dmpl__InterfaceServiceProviderId__c,
                dmpl__InterfaceServiceProviderRequestId__c,
                dmpl__HttpResponseCode__c
            FROM dmpl__InterfaceLog__c 
            WHERE Id=:interfaceLogId 
            LIMIT 1
        ]; 
    }
    
    public static dmpl__InterfaceServiceProvider__c createInterfaceServiceProvider(Account partnerAccount){
        return (dmpl__InterfaceServiceProvider__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProvider__c(
                dmpl__PartnerAccountId__c = partnerAccount?.Id,
                Name = 'Test1',
                dmpl__NamedCredentials__c='tesrt',
                dmpl__Logging__c='Callout',
                dmpl__CustomCredentialsUrl__c='www.rk.com',
                dmpl__ProviderType__c='REST Client'
            ),
            'InterfaceServiceProviderDefaults',
            true
        );
    }
    
    public static dmpl__InterfaceServiceProvider__c createInterfaceServiceProvider(
        Account partnerAccount,
        dmpl__Branch__c branch
    ){
        return (dmpl__InterfaceServiceProvider__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProvider__c(
                dmpl__PartnerAccountId__c = partnerAccount?.Id,
                dmpl__branchId__c = branch?.Id
            ),
            'InterfaceServiceProviderDefaults',
            true
        );
    }
    
    public static dmpl__InterfaceServiceProvider__c getInterfaceServiceProvider() {
        return [
            SELECT 
                dmpl__PartnerAccountId__c,
                dmpl__branchId__c,
                Name,
                dmpl__NamedCredentials__c,
                dmpl__Logging__c,
                dmpl__CustomCredentialsUrl__c,
                dmpl__ProviderType__c
            FROM dmpl__InterfaceServiceProvider__c 
            LIMIT 1
        ]; 
    }
    
    public static dmpl__InterfaceServiceProvider__c getInterfaceServiceProvider(Id interfaceServiceProviderId) {
        return [
            SELECT
                Id,
                dmpl__PartnerAccountId__c,
                dmpl__branchId__c,
                Name,
                dmpl__NamedCredentials__c,
                dmpl__Logging__c,
                dmpl__CustomCredentialsUrl__c,
                dmpl__ProviderType__c
            FROM dmpl__InterfaceServiceProvider__c 
            WHERE Id =: interfaceServiceProviderId
            LIMIT 1
        ];   
    }
    
    public static dmpl__InterfaceServiceProviderRequest__c createInterfaceServiceProviderRequest(dmpl__InterfaceServiceProvider__c interfaceServiceProvider){
        return (dmpl__InterfaceServiceProviderRequest__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProviderRequest__c(
                dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider?.Id
            ),
            'InterfaceServiceProviderRequestDefaults',
            true
        );
    }
    
    public static dmpl__InterfaceServiceProviderRequest__c createInterfaceServiceProviderRequest(
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider,
        String endpoint,
        String  Name,
        String sourceDataType,
        String payload,
        String response,
        String responseSuccessValue
    ){
        return (dmpl__InterfaceServiceProviderRequest__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProviderRequest__c(
                dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider?.Id,
                dmpl__EndPoint__c = endpoint,
                dmpl__FileName__c = 'File1',
                Name = name,
                dmpl__SourceDataType__c = sourceDataType,
                dmpl__PayloadSchema__c = payload,
                dmpl__ResponseSchema__c = response,
                dmpl__ResponseSuccessValue__c = responseSuccessValue
            ),
            true
        );
    }
    
    public static dmpl__InterfaceServiceProviderRequest__c getInterfaceServiceProviderRequest() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__InterfaceServiceProviderId__c,
                dmpl__FileName__c,
                dmpl__SourceDataType__c,
                dmpl__PayloadSchema__c,
                dmpl__ResponseSchema__c,
                dmpl__EndPoint__c,
                dmpl__ResponseSuccessValue__c
            FROM dmpl__InterfaceServiceProviderRequest__c 
            LIMIT 1
        ];
    }
    
    public static dmpl__InterfaceServiceProviderRequest__c getInterfaceServiceProviderRequest(Id interfaceServiceProviderId) {
        return [
            SELECT
                Id,
                Name,
                dmpl__InterfaceServiceProviderId__c,
                dmpl__FileName__c,
                dmpl__SourceDataType__c,
                dmpl__PayloadSchema__c,
                dmpl__ResponseSchema__c,
                dmpl__EndPoint__c,
                dmpl__ResponseSuccessValue__c
            FROM dmpl__InterfaceServiceProviderRequest__c 
            WHERE dmpl__InterfaceServiceProviderId__c =: interfaceServiceProviderId 
            LIMIT 1
        ];
    }
}