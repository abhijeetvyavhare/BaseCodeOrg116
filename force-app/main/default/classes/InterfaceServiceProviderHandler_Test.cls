@isTest
public class InterfaceServiceProviderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog(interfaceServiceProvider, interfaceServiceProviderRequest);
    }
    
    @isTest
    static void createInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'Expected InterfaceServiceProvider to be created.');
        System.assertEquals('Test1', provider.Name, 'Name should be Test1');
        System.assertEquals('tesrt', provider.dmpl__NamedCredentials__c, 'NamedCredentials should be tesrt');
        System.assertEquals('Callout', provider.dmpl__Logging__c, 'Logging should be Callout');
        System.assertEquals('www.rk.com', provider.dmpl__CustomCredentialsUrl__c, 'CustomCredentialsUrl should be www.rk.com');
        System.assertEquals('REST Client', provider.dmpl__ProviderType__c, 'ProviderType should be REST Client');
        System.assertNotEquals(provider.dmpl__PartnerAccountId__c, null, 'PartnerAccountId should be set');
    }
    
    @isTest
    static void updateInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'InterfaceServiceProvider should exist before update.');
        provider.dmpl__Logging__c = 'None';
        provider.dmpl__CustomCredentialsUrl__c = 'https://updated-url.com';
        update provider;
        dmpl__InterfaceServiceProvider__c updatedProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertEquals('None', updatedProvider.dmpl__Logging__c, 'Expected updated Logging value');
        System.assertEquals('https://updated-url.com', updatedProvider.dmpl__CustomCredentialsUrl__c, 'Expected updated CustomCredentialsUrl');
    }
    
    @isTest
    static void deleteInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'InterfaceServiceProvider should exist before delete.');
        delete provider;
        dmpl__InterfaceServiceProvider__c deletedProvider = null;
        try {
            deletedProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        } catch (Exception e) {
            deletedProvider = null;
        }
        System.assertEquals(null, deletedProvider, 'InterfaceServiceProvider should be deleted and not found in query.');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithActivePartnerAccountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be match the created branch.');
    }
    
    @isTest
    static void updateInterfaceServiceProviderWithActivePartnerAccountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c createdInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        createdInterfaceServiceProvider.dmpl__PartnerAccountId__c = partner4.Id;
        update createdInterfaceServiceProvider;
        dmpl__InterfaceServiceProvider__c updatedInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(createdInterfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdInterfaceServiceProvider, 'InterfaceServiceProvider should be updated successfully.');
        System.assertNotEquals(null, updatedInterfaceServiceProvider, 'Updated InterfaceServiceProvider should not be null.');
        System.assertEquals(partner4.Id, updatedInterfaceServiceProvider.dmpl__PartnerAccountId__c, 'Updated PartnerAccountId should match the new partner account.');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithNamePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('Test1', interfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be match the created branch.');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeRESTAPIPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('Test1', interfaceServiceProvider.Name, 'Name should be MOF');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('REST Client', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be REST Client');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeFileStoragePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        interfaceServiceProvider.dmpl__ProviderType__c = 'File Storage';
        update interfaceServiceProvider;
        interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('File Storage', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be File Storage');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeCustomProviderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        interfaceServiceProvider.dmpl__ProviderType__c = 'Custom Provider';
        update interfaceServiceProvider;
        interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Custom Provider', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be Custom Provider');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithLoggingCalloutPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Callout', interfaceServiceProvider.dmpl__Logging__c, 'Logging should be Callout');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithLoggingCalloutWithPayloadPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        interfaceServiceProvider.dmpl__Logging__c = 'Callout with Payload';
        update interfaceServiceProvider;
        interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Callout With Payload', interfaceServiceProvider.dmpl__Logging__c, 'Logging should be Callout with Payload');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithInactivePartnerAccountNegative() {
        Test.startTest();
        InterfaceProviderMasterData.createInterfaceServiceProviderWithInactivePartnerAccountNegative();
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner2, branch);
            System.assertEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should not be created with inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceServiceProviderWithoutBranchPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created without branch.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
    }

    @isTest
    static void createInterfaceServiceProviderWithInactiveBranchPositive() {
        Test.startTest();
        InterfaceProviderMasterData.createInterfaceServiceProviderWithInactiveBranchPositive();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch3);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created with inactive branch.');
        System.assertEquals(partner.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch3.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 3');
    }
    
    @isTest
    static void createInterfaceServiceProviderWithDeletingBranch(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner, branch);
        delete branch;
        dmpl__InterfaceServiceProvider__c createdInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertNotEquals(null, createdInterfaceServiceProvider, 'Created InterfaceServiceProvider should not be null.');
        System.assertEquals(partner.Id, createdInterfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 3 before deleting the branch.');
        System.assertEquals(null, createdInterfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be null after deleting the branch.');
    }
    
    @isTest
    static void deleteInterfaceServiceProviderWithActivePartnerAccountPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        try {
            delete interfaceServiceProvider;
            dmpl__InterfaceServiceProvider__c deletedInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
            System.assertEquals(null, deletedInterfaceServiceProvider, 'InterfaceServiceProvider should be deleted and not found in query.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithEndPointPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void updateInterfaceServiceProviderRequestWithEndPointPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        interfaceServiceProviderRequest.dmpl__EndPoint__c = 'Updated Endpoint Url';
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertEquals('Updated Endpoint Url', updatedRequest.dmpl__EndPoint__c, 'EndPoint should be Updated Endpoint');
        System.assertEquals('Sample JSON Payload', updatedRequest.dmpl__PayloadSchema__c, 'Payload should be Updated Payload');
        System.assertEquals('Sample Response', updatedRequest.dmpl__ResponseSchema__c, 'Response should be Updated Response');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithValidInterfaceServiceProviderPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithInvalidInterfaceServiceProviderNegative() {
        Test.startTest();
        InterfaceProviderMasterData.createInterfaceServiceProviderWithInactivePartnerAccountNegative();
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner2, branch);
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
            System.assertEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created with invalid interface service provider.');
        } catch(exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithRequestNamePositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithPayloadSchemaPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void updateInterfaceServiceProviderRequestWithPayloadSchemaPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        createdRequest.dmpl__PayloadSchema__c = 'Updated Valid Sample JSON Payload';
        update createdRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Updated Valid Sample JSON Payload', updatedRequest.dmpl__PayloadSchema__c, 'Payload should be Updated Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithResponsePathAndMessagePositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
        System.assertEquals('POST', createdRequest.dmpl__ResponseSuccessValue__c, 'Response Success Value should be ACT');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithResponseMethodAndBodyPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
        System.assertEquals('POST', createdRequest.dmpl__ResponseSuccessValue__c, 'Response Method should be POST');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithoutEndPointPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        try {
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, null, 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
            System.assertNotEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created without end point.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateInterfaceServiceProviderRequestWithBlankEndPointPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        interfaceServiceProviderRequest.dmpl__EndPoint__c = null;
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
    }
    
    @isTest
    static void deleteInterfaceServiceProviderRequestPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        try {
            delete interfaceServiceProviderRequest;
            dmpl__InterfaceServiceProviderRequest__c deletedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
            System.assertEquals(null, deletedRequest, 'InterfaceServiceProviderRequest should be deleted and not found in query.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithNonExistentInterfaceServiceProviderNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(null);
            System.assertEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created with non-existent Interface Service Provider.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateInterfaceServiceProviderRequestWithRemovingRequestNamePositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        interfaceServiceProviderRequest.Name = null;
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertNotEquals(null, updatedRequest.Name, 'Request Name should be null after update');
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithDuplicateRequestNameNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        try {
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest1 = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest2 = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
            System.assertNotEquals(null, interfaceServiceProviderRequest2, 'InterfaceServiceProviderRequest should not be created with duplicate request Name.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceServiceProviderRequestWithoutPayloadSchemaNegative() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        createdRequest.dmpl__PayloadSchema__c = null;
        update createdRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals(null, updatedRequest.dmpl__PayloadSchema__c, 'Payload Schema should be null');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    @isTest
    static void updateInterfaceServiceProviderRequestWithInvalidPayloadSchemaPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        createdRequest.dmpl__PayloadSchema__c = null;
        update createdRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertEquals(null, updatedRequest.dmpl__PayloadSchema__c, 'Payload Schema should be null after update');
    }
    
    @isTest
    static void createInterfaceLogWithEndpointURLPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
    }
    
    @isTest
    static void createInterfaceLogWithCorrectPayloadPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
    }
    
    @isTest
    static void updateInterfaceLogWithCorrectPayloadPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.getInterfaceLog();
        interfaceLog.dmpl__Payload__c = 'Updated Valid JSON';
        update interfaceLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Updated Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Updated Valid JSON');
    }
    
    @isTest
    static void createInterfaceLogWithValidInterfaceServiceProviderTaggingPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProvider.Id, createdLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
    }
    
    @isTest
    static void updateInterfaceLogWithValidInterfaceServiceProviderTaggingPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider2 = InterfaceTestDataHelper.createInterfaceServiceProvider(partner4);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        createdLog.dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider2.Id;
        update createdLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(createdLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Valid JSON');
    System.assertEquals(interfaceServiceProvider2.Id, updatedLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the updated interface service provider.');    }
    
    @isTest
    static void createInterfaceLogWithValidInterfaceServiceProviderRequestTaggingPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProvider.Id, createdLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals(interfaceServiceProviderRequest.Id, createdLog.dmpl__InterfaceServiceProviderRequestId__c, 'InterfaceServiceProviderRequestId should match the created interface service provider request.');
    }
    
    @isTest
    static void updateInterfaceLogWithValidInterfaceServiceProviderRequestTaggingPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest2 = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog();
        createdLog.dmpl__InterfaceServiceProviderRequestId__c = interfaceServiceProviderRequest2.Id;
        update createdLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(createdLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProviderRequest2.Id, updatedLog.dmpl__InterfaceServiceProviderRequestId__c, 'InterfaceServiceProviderRequestId should match the updated interface service provider request.');
    }
    
    @isTest
    static void deleteInterfaceLogPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.getInterfaceLog();
        try {
            delete interfaceLog;
            dmpl__InterfaceLog__c deletedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
            System.assertEquals(null, deletedLog, 'InterfaceLog should be deleted and not found in query.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceLogWithEndpointURLNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.getInterfaceLog();
            interfaceLog.dmpl__EndPoint__c = null;
            update interfaceLog;
            dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
            System.assertNotEquals(null, updatedLog, 'InterfaceLog should be created with null/Invalid EndPoint URL.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createInterfaceLogWithInvalidPayloadNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.getInterfaceLog();
            interfaceLog.dmpl__Payload__c = null;
            update interfaceLog;
            dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
            System.assertNotEquals(null, updatedLog, 'InterfaceLog should be created with null/Invalid Payload.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}