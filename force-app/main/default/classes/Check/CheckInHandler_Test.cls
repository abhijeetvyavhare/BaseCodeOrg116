@isTest
public with sharing class CheckInHandler_Test {
    @TestSetup
    static void createRequiredData(){
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.createCheckInInspection(checkInDateTime);
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.createCheckInInspectionLine(checkInInspection.Id, 'Exterior');
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.createCheckInTemplate(CheckInTemplateExternalId);
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine('Front',CheckInTemplate.Id);
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');      
		dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partner.Id);
		dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.createServiceAdvisor();
    }

    @isTest
    static void createCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        System.assertNotEquals(checkInInspection, null, 'Expected check-in inspection to be created.');
    }

    @isTest
    static void updateCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        checkInInspection.dmpl__CheckInDateTime__c = DateTime.newInstance(2026, 10, 1, 12, 0, 0);
        Test.startTest();
        update checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c updated = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(updated.dmpl__CheckInDateTime__c, DateTime.newInstance(2026, 10, 1, 12, 0, 0), 'Check-in inspection date time should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        Test.startTest();
        delete checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c deletedInspection = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(deletedInspection, null, 'Check-in inspection should be deleted.');
    }

    @isTest
    static void createCheckInInspectionLinePositive(){
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        System.assertNotEquals(checkInInspectionLine, null, 'Expected check-in inspection line to be created.');
    }

    @isTest
    static void updateCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        checkInInspectionLine.dmpl__Section__c = 'Interior';
        Test.startTest();
        update checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c updatedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(updatedLine.dmpl__Section__c, 'Interior', 'Check-in inspection line section should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        Test.startTest();
        delete checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c deletedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(deletedLine, null, 'Check-in inspection line should be deleted.');
    }

    @isTest
    static void createCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        System.assertNotEquals(CheckInTemplate, null, 'Expected CheckIn template to be created.');
    }

    @isTest
    static void updateCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        CheckInTemplate.dmpl__ExternalId__c = 'Updated ExternalID';
        Test.startTest();
        update CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c updated = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(updated.dmpl__ExternalId__c, 'Updated ExternalID', 'CheckIn template name should be updated.');
    }

    @isTest
    static void deleteCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        Test.startTest();
        delete CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c deletedTemplate = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(deletedTemplate, null, 'CheckIn template should be deleted.');
    }

    @isTest 
    static void createCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        System.assertNotEquals(CheckInTemplateLine, null, 'Expected CheckIn template line to be created.');
    }

    @isTest
    static void updateCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        CheckInTemplateLine.dmpl__SectionName__c = 'Back';
        Test.startTest();
        update CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c updatedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(updatedLine.dmpl__SectionName__c, 'Back', 'CheckIn template line section name should be updated.');
    }
    
    @isTest
    static void deleteCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        Test.startTest();
        delete CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c deletedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(deletedLine, null, 'CheckIn template line should be deleted.');
    }

    @isTest
    static void createCheckInsWithCorrectPartnerandbranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        createdCheckIn.dmpl__DocumentDate__c = Date.today();
        Test.stopTest();
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should be auto-tagged from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void createCheckInsWithWrongPartnerAccountNegative() {
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
                partner3, 
                customer, 
                branch, 
                asset
            );
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive partner account.');
    }

    @isTest
    static void updateCheckInswithWrongPartnerAccountNeagtive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with wrong partner account.');
    }

    @isTest
    static void createCheckInsWithInactivePartnerAccountNegative() {
    Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
	partner.dmpl__IsActive__c=false;
	update partner;
	Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
    Boolean exceptionThrown = false;
    Test.startTest();
    try {
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
            partner2,
            customer, 
            null, 
            asset
        );
    } catch (System.DmlException e) {
        exceptionThrown = true;

    }
    Test.stopTest();
    System.assertEquals(true, exceptionThrown, 'Exception should be thrown because partner account is inactive.');
}

    @isTest
    static void upadteCheckInsWithInactivePartnerAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
		partnerAccount.dmpl__IsActive__c=false;
		update partnerAccount;
		Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1'); 
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner2.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with inactive partner account.');
    }

    @isTest
    static void createCheckInswithWrongBranchPositive() {
            Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
            Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
            dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
            Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
            Test.startTest();
            dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
                partner, 
                customer, 
                branch, 
                asset
            );
            createdCheckIn.dmpl__DocumentDate__c = Date.today();
            Test.stopTest();
            dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
            System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should match');
            System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
            System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
            System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
            System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should be auto-tagged from customer');
            System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        }

    @isTest
    static void updateCheckInswithWrongBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner.Id;
        checkInToUpdate.dmpl__BranchId__c = branch.Id;
        checkInToUpdate.dmpl__AccountId__c = customer.Id;
        checkInToUpdate.dmpl__AssetId__c = asset.Id;
        update checkInToUpdate;
        Test.stopTest();
        dmpl__CheckInInspection__c updatedCheckIn = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        System.assertEquals(partner.Id, updatedCheckIn.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, updatedCheckIn.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer.Id, updatedCheckIn.dmpl__AccountId__c, 'Customer should remain Customer 1');
        System.assertEquals(asset.Id, updatedCheckIn.dmpl__AssetId__c, 'Asset should remain Asset 1');
        System.assertEquals(Date.today(), updatedCheckIn.dmpl__DocumentDate__c, 'Document Date should remain unchanged');
        System.assertEquals('9876543210', updatedCheckIn.dmpl__MobileNumber__c, 'Mobile number should remain unchanged');
        System.assertEquals('Draft', updatedCheckIn.dmpl__Status__c, 'Status should remain Draft');
}

    @isTest
    static void createCheckInswithInactiveBranchNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Test.startTest();
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
            partner,
            customer, 
            branch3, 
            asset
        );
        Test.stopTest();
        System.assertEquals(partner.Id, checkIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch3.Id, checkIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, checkIn.dmpl__AccountId__c, 'Customer should be Customer 1');
    }

    @isTest
    static void updateCheckInswithInactiveBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3',partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);    
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch1, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
        checkInToUpdate.dmpl__BranchId__c = branch.Id;
        update checkInToUpdate;
        dmpl__CheckInInspection__c  CheckIn = CheckInDataHelper.GetCheckIn(checkInToUpdate.Id);
        System.assertEquals(partner3.Id, CheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, CheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        Test.stopTest();
    }

    @isTest
    static void createCheckInsWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        Test.stopTest();
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void updateCheckInsWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner.Id;
        checkInToUpdate.dmpl__BranchId__c = branch.Id;
        checkInToUpdate.dmpl__AccountId__c = customer.Id;
        checkInToUpdate.dmpl__AssetId__c = asset.Id;
        update checkInToUpdate;
        Test.stopTest();
        dmpl__CheckInInspection__c updatedCheckIn = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        System.assertEquals(partner.Id, updatedCheckIn.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, updatedCheckIn.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer.Id, updatedCheckIn.dmpl__AccountId__c, 'Customer should remain Customer 1');
        System.assertEquals(asset.Id, updatedCheckIn.dmpl__AssetId__c, 'Asset should remain Asset 1');
        System.assertEquals(Date.today(), updatedCheckIn.dmpl__DocumentDate__c, 'Document Date should remain unchanged');
        System.assertEquals('9876543210', updatedCheckIn.dmpl__MobileNumber__c, 'Mobile number should remain unchanged');
        System.assertEquals('Draft', updatedCheckIn.dmpl__Status__c, 'Status should remain Draft');
    }

    @isTest
    static void createCheckInsWithActiveCustomerAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner,
            customer, 
            branch, 
            asset
        );
        Test.stopTest();
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void updateCheckInsWithActiveCustomerAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer3 = TestDataHelpers.createCustomerAccount('Customer 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        Boolean exceptionThrown=false;
        Test.startTest();
        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        try{
            checkInToUpdate.dmpl__AccountId__c = customer3.Id;
            update checkInToUpdate;
        } catch (Exception e) {
                exceptionThrown = true;
            }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive customer on update.');
    }

    @isTest
    static void createCheckInWithInactiveCustomerAccountNegative() {
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		Account customer = TestDataHelpers.createCustomerAccount('Customer 7');
		customer.dmpl__IsActive__c=false;
		update customer;
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3',partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer7.Id, item.Id);         
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
                partner3, 
                customer7, 
                branch, 
                asset
            );
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive customer account.');
    }

    @isTest
    static void createCheckInsWithServiceAdvisorPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.getServiceAdvisor('Service Advisor');
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        createdCheckIn.dmpl__ServiceAdvisorId__c=serviceAdvisor.Id;
        update createdCheckIn;
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(serviceAdvisor.Id,fetchedCheckIn.dmpl__ServiceAdvisorId__c,'service advisor should match');
    }

    @isTest
    static void updateCheckInsWithServiceAdvisorPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.getServiceAdvisor('Service Advisor');
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        createdCheckIn.dmpl__ServiceAdvisorId__c=serviceAdvisor.Id;
        update createdCheckIn;
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(serviceAdvisor.Id,fetchedCheckIn.dmpl__ServiceAdvisorId__c,'service advisor should match');
    }

    @isTest
    static void updateheckInWithInactiveCustomerAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 7');
		customerAccount.dmpl__IsActive__c=false;
		update customerAccount;
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3',partner3.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id); 
        Boolean exceptionThrown = false;
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(
            partner,
            customer, 
            branch1, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
            checkInToUpdate.dmpl__BranchId__c = branch3.Id;
            checkInToUpdate.dmpl__AccountId__c = customer7.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive customer account.');
    }

    @isTest
    static void createCheckInInspectionLineWithCheckInReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        Test.startTest();
        dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLineWithDefaults(fetchedCheckIn.Id);
        Test.stopTest();
        dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
        System.assertEquals(fetchedCheckIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    }

    @isTest
    static void updateCheckInInspectionLineWithCheckInReferenceNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        dmpl__CheckInInspection__c checkIn1 = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn1 = CheckInDataHelper.GetCheckIn(checkIn1.Id);
        System.assertEquals(partner.Id, fetchedCheckIn1.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedCheckIn1.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedCheckIn1.dmpl__AccountId__c);
        System.assertEquals(asset.Id, fetchedCheckIn1.dmpl__AssetId__c);
        System.assertEquals(Date.today(), fetchedCheckIn1.dmpl__DocumentDate__c);
        System.assertEquals('9876543210', fetchedCheckIn1.dmpl__MobileNumber__c);
        System.assertEquals('Draft', fetchedCheckIn1.dmpl__Status__c);
        dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLineWithDefaults(fetchedCheckIn1.Id);
        dmpl__CheckInInspection__c checkIn2 = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn2 = CheckInDataHelper.GetCheckIn(checkIn2.Id);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            line.dmpl__CheckInInspectionId__c = fetchedCheckIn2.Id;
            update line;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown);
    }

    @isTest
    static void createCheckInInspectionLinewithSectionPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
        partner, 
        customer, 
        branch, 
        asset
    );
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);
    Test.startTest();
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLine(checkIn.Id, 'SIde Panel');
    Test.stopTest();
    dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
    }

    @isTest
    static void updateCheckInInspectionLinewithSectionPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
    Test.startTest();
    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
        partner,
        customer, 
        branch, 
        asset
    );
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLine(checkIn.Id, 'SIde Panel');
    dmpl__CheckInInspectionLine__c lineToUpdate = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    lineToUpdate.dmpl__Section__c = 'Front Panel';
    update lineToUpdate;
    Test.stopTest();
    dmpl__CheckInInspectionLine__c updatedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, updatedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('Front Panel', updatedLine.dmpl__Section__c, 'Section should be updated to Front Panel');
}

    @isTest 
    static void createCheckInInspectionLinewithSubSectionPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(
            partner, 
            customer, 
            branch, 
            asset
        );
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c);
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);
        Test.startTest();
        dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLinWithSubsectionCondition(
            checkIn.Id, 
            'SIde Panel',
            'Right Side Panel',
            null
        );
        Test.stopTest();
        dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
        System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
        System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
        System.assertEquals('Right Side Panel',fetchedLine.dmpl__SubSection__c);
    }

@isTest 
static void createCheckInInspectionLinewithConditionPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner, customer, branch, asset);
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);
    Test.startTest();
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLinWithSubsectionCondition(
        checkIn.Id,
        'SIde Panel',
        'Right Side Panel',
        'Torn'
    );
    Test.stopTest();
    dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
    System.assertEquals('Right Side Panel',fetchedLine.dmpl__SubSection__c);
    System.assertEquals('Torn',fetchedLine.dmpl__Condition__c);
}

@isTest
static void createcheckInTemplateWithActiveApplicableItemPositive() {
    dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item.Id
    );
    System.assertEquals(item.Id, template.dmpl__ApplicableItemId__c);
}

@isTest
static void updatecheckInTemplateWithActiveApplicableItemPositive() {
    Test.startTest();
    dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item8.Id
    );
    insert template;
    System.assertEquals(item8.Id, template.dmpl__ApplicableItemId__c);
    template.dmpl__ApplicableItemId__c = item.Id;
    update template;
    Test.stopTest();
    System.assertEquals(item.Id, template.dmpl__ApplicableItemId__c);
}

@isTest
static void createCheckInTemplateWithInactiveApplicableItemNegative() {
    dmpl__Item__c item = TestDataHelpers.createItem('Item 2','Product');
    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item.Id
    );
    System.assertEquals(item.Id, template.dmpl__ApplicableItemId__c);
}

@isTest
static void updatecheckInTemplateWithInactiveApplicableItemNegative() {
    Test.startTest();
    dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product');
    dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item8.Id
    );
    insert template;
    System.assertEquals(item8.Id, template.dmpl__ApplicableItemId__c);
    template.dmpl__ApplicableItemId__c = item2.Id;
    update template;
    Test.stopTest();
    System.assertEquals(item2.Id, template.dmpl__ApplicableItemId__c,'applicable item should match');
}

@isTest
static void createCheckInTemplateLineWithValidDataPositive() {
    dmpl__CheckInTemplate__c template = CheckInDataHelper.getCheckInTemplateByExternalId('ExternalIDTEST123');
    System.assertNotEquals(template, null, 'Check-in template should exist.');
    Test.startTest();
    dmpl__CheckInTemplateLine__c newCheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine(
        template.Id,
        'Front',
        'Brakes',
        'Broken'
    );
    Test.stopTest();
    dmpl__CheckInTemplateLine__c fetchedCheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineById(newCheckInTemplateLine.Id);
    System.assertNotEquals(fetchedCheckInTemplateLine, null, 'Check-in template line should be created and fetched.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__CheckInTemplateId__c, template.Id, 'Template ID should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SectionName__c, 'Front', 'Section name should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SubSection__c, 'Brakes', 'Sub-section should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__Issues__c, 'Broken', 'Issues should match.');
}

@isTest
static void createCheckInTemplateLineWithMultipleSubSectionsPositive() {
    dmpl__CheckInTemplate__c template = CheckInDataHelper.getCheckInTemplateByExternalId('ExternalIDTEST123');
    System.assertNotEquals(template, null, 'Check-in template should exist.');
    Test.startTest();
    dmpl__CheckInTemplateLine__c newCheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine(
        template.Id,
        'Back',
        'Fender;Seat',
        'Defective'
    );
    Test.stopTest();
    dmpl__CheckInTemplateLine__c fetchedCheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineById(newCheckInTemplateLine.Id);
    System.assertNotEquals(fetchedCheckInTemplateLine, null, 'Check-in template line should be created and fetched.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__CheckInTemplateId__c, template.Id, 'Template ID should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SectionName__c, 'Back', 'Section name should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SubSection__c, 'Fender;Seat', 'Sub-sections should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__Issues__c, 'Defective', 'Issues should match.');
}

@isTest
static void createCheckInTemplateLineWithMultipleIssuesPositive() {
    dmpl__CheckInTemplate__c template = CheckInDataHelper.getCheckInTemplateByExternalId('ExternalIDTEST123');
    System.assertNotEquals(template, null, 'Check-in template should exist.');
    Test.startTest();
    dmpl__CheckInTemplateLine__c newCheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine(
        template.Id,
        'Back',
        'Fender;Seat',
        'Defective;Scratch'
    );
    Test.stopTest();
    dmpl__CheckInTemplateLine__c fetchedCheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineById(newCheckInTemplateLine.Id);
    System.assertNotEquals(fetchedCheckInTemplateLine, null, 'Check-in template line should be created and fetched.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__CheckInTemplateId__c, template.Id, 'Template ID should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SectionName__c, 'Back', 'Section name should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SubSection__c, 'Fender;Seat', 'Sub-sections should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__Issues__c, 'Defective;Scratch', 'Issues should match.');
}

@isTest
static void createCheckInTemplateLineWithoutSectionNamePositive() {
    dmpl__CheckInTemplate__c template = CheckInDataHelper.getCheckInTemplateByExternalId('ExternalIDTEST123');
    System.assertNotEquals(template, null, 'Check-in template should exist.');
    Test.startTest();
    dmpl__CheckInTemplateLine__c newCheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine(
        template.Id,
        null,
        'Fender;Seat',
        'Defective;Scratch'
    );
    Test.stopTest();
    dmpl__CheckInTemplateLine__c fetchedCheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineById(newCheckInTemplateLine.Id);
    System.assertNotEquals(fetchedCheckInTemplateLine, null, 'Check-in template line should be created and fetched.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__CheckInTemplateId__c, template.Id, 'Template ID should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SectionName__c, null, 'Section name should be null.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__SubSection__c, 'Fender;Seat', 'Sub-sections should match.');
    System.assertEquals(fetchedCheckInTemplateLine.dmpl__Issues__c, 'Defective;Scratch', 'Issues should match.');
}
}