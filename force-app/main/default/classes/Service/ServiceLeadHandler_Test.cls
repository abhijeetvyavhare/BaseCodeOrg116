@isTest
    public with sharing class ServiceLeadHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);  
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(branch, customerAccount, resource);
        Account partner1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partner1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        ServiceContract serviceContract = ServiceCampaignTestDataHelpers.createServiceContract(partner1 ,'Service Contract 1');
        dmpl__ServiceCampaign__c campaign = ServiceCampaignTestDataHelpers.createServiceCampaign('Campaign 1');
        // dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
    }

    @isTest
    static void createServiceLeadPositive() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Expected Service Lead to be created.');
        System.assertEquals(serviceLead.dmpl__ContactName__c, 'Contact1', 'Contact Name should be Contact1.');
        System.assertEquals(serviceLead.dmpl__LeadRating__c, 'Hot', 'Lead Rating should be Hot.');
        System.assertEquals(serviceLead.dmpl__ReminderOffsetNumber__c, 2, 'Reminder Off Set Number should be 2.');
        System.assertEquals(serviceLead.dmpl__Status__c, 'Draft', 'Lead Status should be Draft.');
        System.assertEquals(serviceLead.dmpl__LeadSource__c, 'None', 'Lead Source should be None.');
        System.assertEquals(serviceLead.dmpl__LeadType__c, 'Recall', 'Lead Type should be Recall.');
    }

    @isTest
    static void updateServiceLeadPositive() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Service Lead should exist before update.');
        serviceLead.dmpl__LeadRating__c = 'Warm';
        serviceLead.dmpl__ReminderOffsetNumber__c = 1;
        serviceLead.dmpl__Status__c = 'Qualified';
        serviceLead.dmpl__ContactName__c = 'Contact2';
        serviceLead.dmpl__LeadSource__c = 'None';
        serviceLead.dmpl__LeadType__c = 'Manual';
        update serviceLead;
        dmpl__ServiceLead__c UpdatedServiceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertEquals(UpdatedServiceLead.dmpl__LeadRating__c, 'Warm', 'Lead Rating should be Warm after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__ReminderOffsetNumber__c, 1, 'Reminder Off Set Number should be 1 after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__Status__c, 'Qualified', 'Lead Status should be Qualified after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__ContactName__c, 'Contact2', 'Contact Name should be updated to Contact2');
        System.assertEquals(UpdatedServiceLead.dmpl__LeadSource__c, 'None', 'Lead Source should be updated to None');
        System.assertEquals(UpdatedServiceLead.dmpl__LeadType__c, 'Manual', 'Lead Type should be updated to Manual');
    }

    @isTest
    static void deleteServiceLead() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Service Lead should exist before delete.');
        Id serviceLeadId = serviceLead.Id;
        delete serviceLead;
        dmpl__ServiceLead__c deletedserviceLead = null;
        try {
            deletedserviceLead = ServiceLeadTestDataHelpers.getServiceLead(serviceLeadId);
        } catch (Exception e) {
            deletedserviceLead = null;
        }
        System.assertEquals(deletedserviceLead, null, 'Service Lead should be deleted and not found in query.');
    }

    @isTest
    static void CreateServiceLeadWithCorrectPartnerAndBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void CreateServiceLeadWithWrongPartnerNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }

    @isTest
    static void UpdateServiceLeadWithWrongPartnerNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            fetched.dmpl__PartnerAccountId__c = partner3.Id;
            update fetched;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to wrong partner ');
    }

    @isTest
    static void CreateServiceLeadWithinactivePartnerNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c=false;
        update partner;
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ServiceLeadTestDataHelpers.createServiceLead(partner2,null,customer);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }

    @isTest
    static void UpdateServiceLeadWithInactivePartnerNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        partner.dmpl__IsActive__c=false;
        update partner;
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLead(partner1,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);
        System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            fetched.dmpl__PartnerAccountId__c = partner2.Id;
            fetched.dmpl__BranchId__c=null;
            update fetched;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to inactive partner ');
    }

    @isTest
    static void CreateServiceLeadWithWrongBranchNegative() {
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 4', partner4.Id);
        Date documentDate = Date.newInstance(2025, 6, 20);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ServiceLeadTestDataHelpers.createServiceLead(Partner,branch,customer);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }

    @isTest
    static void UpdateServiceLeadWithWrongBranchNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Date documentDate = Date.newInstance(2025, 6, 20);
        dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLead(partner1,branch1,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);
        System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            fetched.dmpl__BranchId__c=branch.Id;
            update fetched;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    } 

    @isTest
    static void CreateServiceLeadWithInactiveBranchNegative() {
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        dmpl__Branch__c wrongbranch = TestDataHelpers.getBranch('Branch 3');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ServiceLeadTestDataHelpers.createServiceLead(partner3,wrongbranch,customer);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to Inactive branch ');
    }

    @isTest
    static void UpdateServiceLeadWithInactiveBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Date documentDate = Date.newInstance(2025, 6, 20);
        dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch1,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            fetched.dmpl__BranchId__c=branch3.Id;
            update fetched;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to inactive branch ');
    }

    @isTest
    static void CreateServiceLeadWithActiveCustomerAccountPositive() {   
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void updateServiceLeadWithActiveCustomerAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer1);
        dmpl__ServiceLead__c fetchedBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(partner.Id, fetchedBefore.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedBefore.dmpl__BranchId__c);
        System.assertEquals(customer1.Id, fetchedBefore.dmpl__AccountId__c);
        System.assertEquals(status, fetchedBefore.dmpl__Status__c);
        System.assertEquals(documentDate, fetchedBefore.dmpl__DocumentDate__c);
        fetchedBefore.dmpl__AccountId__c = customer2.Id;
        update fetchedBefore;
        dmpl__ServiceLead__c fetchedAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedBefore.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedAfter.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedAfter.dmpl__BranchId__c);
        System.assertEquals(customer2.Id, fetchedAfter.dmpl__AccountId__c);
        System.assertEquals(status, fetchedAfter.dmpl__Status__c);
        System.assertEquals(documentDate, fetchedAfter.dmpl__DocumentDate__c);
    }

    @isTest
    static void CreateServiceLeadWithInactiveCustomerNegative() {
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer7 = TestDataHelpers.createCustomerAccount('Customer 7');
        customer7.dmpl__IsActive__c=false;
        update customer7;
        Account customer = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to Inactive customer account ');
    }

    @isTest
    static void UpdateServiceLeadWithInactiveCustomerAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 7');
        customer.dmpl__IsActive__c=false;
        update customer;
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer1);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            fetched.dmpl__AccountId__c=customer7.Id;
            update fetched;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'expected exception due to inactive customer account ');
    }
        
    @isTest
    static void CreateServiceLeadWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, item1.Id);
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        serviceLead.dmpl__AssetId__c=asset1.Id;
        update serviceLead;
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset1.id,fetched.dmpl__AssetId__c,'asset should match');
        System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void updateServiceLeadWithAssetNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        Account customer3 = TestDataHelpers.createCustomerAccount('Customer 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5','Product');
        Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);
        Asset asset3 = AssetTestDataHelpers.createAsset('Asset 3', customer3.Id, item5.Id);
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer1);
        serviceLead.dmpl__AssetId__c=asset1.Id;
        update serviceLead;
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c);
        System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c,'asset should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c);
        Boolean exceptionThrown=false;
        try{
            fetched.dmpl__AssetId__c = asset3.Id;
            update fetched;
        }catch(Exception e){
            exceptionThrown=true;
        }
        System.assertEquals(true,exceptionThrown,'exception should be thrown de to wrong asset on edit');
        Test.stopTest();
    }

    @isTest
    static void CreateServiceLeadWithoutAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createServiceLeadWithCaseReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Test.startTest();
        dmpl__Case__c createdCase = CaseTestDataHelper.CreateCaseById(
            partner, 
            customer, 
            branch, 
            null
        );
        dmpl__Case__c fetchedCase = CaseTestDataHelper.getCaseById(createdCase.Id);
        System.assertEquals(partner.Id, fetchedCase.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedCase.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedCase.dmpl__AccountId__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedCase.dmpl__DocumentDate__c);
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        serviceLead.dmpl__CaseId__c = fetchedCase.Id;
        update serviceLead;
        Test.stopTest();
        dmpl__ServiceLead__c fetchedLead = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(partner.Id, fetchedLead.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLead.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLead.dmpl__AccountId__c);
        System.assertEquals(fetchedCase.Id, fetchedLead.dmpl__CaseId__c);
        System.assertEquals('Draft', fetchedLead.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLead.dmpl__DocumentDate__c);
    }

    @isTest
    static void updateServiceLeadWithCaseReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        Test.startTest();
        dmpl__Case__c case1 = CaseTestDataHelper.CreateCaseById(
            partner, 
            customer, 
            branch, 
            null
            );
        dmpl__Case__c case2 = CaseTestDataHelper.CreateCaseById(
            partner, 
            customer, 
            branch, 
            null
            );
        dmpl__Case__c fetchedCase1 = CaseTestDataHelper.getCaseById(case1.Id);
        dmpl__Case__c fetchedCase2 = CaseTestDataHelper.getCaseById(case2.Id);
        System.assertEquals(partner.Id, fetchedCase1.dmpl__PartnerAccountId__c);
        System.assertEquals(customer.Id, fetchedCase1.dmpl__AccountId__c);
        System.assertEquals(branch.Id, fetchedCase1.dmpl__BranchId__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedCase1.dmpl__DocumentDate__c);
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        serviceLead.dmpl__CaseId__c = fetchedCase1.Id;
        update serviceLead;
        dmpl__ServiceLead__c fetchedLeadBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(fetchedCase1.Id, fetchedLeadBefore.dmpl__CaseId__c);
        System.assertEquals(partner.Id, fetchedLeadBefore.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLeadBefore.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLeadBefore.dmpl__AccountId__c);
        System.assertEquals('Draft', fetchedLeadBefore.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLeadBefore.dmpl__DocumentDate__c);
        fetchedLeadBefore.dmpl__CaseId__c = fetchedCase2.Id;
        update fetchedLeadBefore;
        Test.stopTest();
        dmpl__ServiceLead__c fetchedLeadAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedLeadBefore.Id);
        System.assertEquals(fetchedCase2.Id, fetchedLeadAfter.dmpl__CaseId__c);
        System.assertEquals(partner.Id, fetchedLeadAfter.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLeadAfter.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLeadAfter.dmpl__AccountId__c);
        System.assertEquals('Draft', fetchedLeadAfter.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLeadAfter.dmpl__DocumentDate__c);
    }

    @isTest
    static void CreateServiceLeadWithoutCaseReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(
            partner,
            branch,
            customer
        );
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createServiceLeadWithCampaignReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date startDate = Date.newInstance(2025, 6, 10);
        Date endDate = Date.newInstance(2025, 7, 30);
        Test.startTest();
        dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
            'Campaign 1',
            'Field Filter',
            null,
            null,
            'All Rules Are Met',
            'Marketing',
            startDate,
            endDate
        );
        dmpl__ServiceCampaign__c fetchedCampaign = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);
        System.assertEquals('Campaign 1', fetchedCampaign.Name);
        System.assertEquals('Field Filter', fetchedCampaign.dmpl__DynamicMemberType__c);
        System.assertEquals('Marketing', fetchedCampaign.dmpl__Type__c);
        System.assertEquals('All Rules Are Met', fetchedCampaign.dmpl__RuleSuccessCriteria__c);
        System.assertEquals(startDate, fetchedCampaign.dmpl__StartDate__c);
        System.assertEquals(endDate, fetchedCampaign.dmpl__EndDate__c);
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        serviceLead.dmpl__ServiceCampaignId__c = fetchedCampaign.Id;
        update serviceLead;
        Test.stopTest();
        dmpl__ServiceLead__c fetchedLead = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(partner.Id, fetchedLead.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLead.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLead.dmpl__AccountId__c);
        System.assertEquals(fetchedCampaign.Id, fetchedLead.dmpl__ServiceCampaignId__c);
        System.assertEquals('Draft', fetchedLead.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLead.dmpl__DocumentDate__c);
    }

    @isTest
    static void updateServiceLeadWithCampaignReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date startDate = Date.newInstance(2025, 6, 10);
        Date endDate = Date.newInstance(2025, 7, 30);
        Test.startTest();
        dmpl__ServiceCampaign__c campaign1 = CampaignTestDataHelpers.createServiceCampaign(
            'Campaign 1',
            'Field Filter',
            null,
            null,
            'All Rules Are Met',
            'Marketing',
            startDate,
            endDate
        );
        dmpl__ServiceCampaign__c campaign2 = CampaignTestDataHelpers.createServiceCampaign(
            'Campaign 2',
            'Field Filter',
            null,
            null,
            'All Rules Are Met',
            'Marketing',
            startDate,
            endDate
        );
        dmpl__ServiceCampaign__c fetchedCampaign1 = CampaignTestDataHelpers.getServiceCampaignById(campaign1.Id);
        dmpl__ServiceCampaign__c fetchedCampaign2 = CampaignTestDataHelpers.getServiceCampaignById(campaign2.Id);
        System.assertEquals('Campaign 1', fetchedCampaign1.Name);
        System.assertEquals('Campaign 2', fetchedCampaign2.Name);
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        serviceLead.dmpl__ServiceCampaignId__c = fetchedCampaign1.Id;
        update serviceLead;
        dmpl__ServiceLead__c fetchedLeadBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        System.assertEquals(fetchedCampaign1.Id, fetchedLeadBefore.dmpl__ServiceCampaignId__c);
        System.assertEquals(partner.Id, fetchedLeadBefore.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLeadBefore.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLeadBefore.dmpl__AccountId__c);
        System.assertEquals('Draft', fetchedLeadBefore.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLeadBefore.dmpl__DocumentDate__c);
        fetchedLeadBefore.dmpl__ServiceCampaignId__c = fetchedCampaign2.Id;
        update fetchedLeadBefore;
        Test.stopTest();
        dmpl__ServiceLead__c fetchedLeadAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedLeadBefore.Id);
        System.assertEquals(fetchedCampaign2.Id, fetchedLeadAfter.dmpl__ServiceCampaignId__c);
        System.assertEquals(partner.Id, fetchedLeadAfter.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetchedLeadAfter.dmpl__BranchId__c);
        System.assertEquals(customer.Id, fetchedLeadAfter.dmpl__AccountId__c);
        System.assertEquals('Draft', fetchedLeadAfter.dmpl__Status__c);
        System.assertEquals(Date.newInstance(2025, 6, 20), fetchedLeadAfter.dmpl__DocumentDate__c);
    }

    @isTest
    static void CreateServiceLeadwithoutCampaignReferencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 20);
        String status = 'Draft';
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createServiceLeadWithActiveCustomerPartnerBranchResources(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(Date.newInstance(2025, 6, 20) , fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    @isTest
    static void createServiceLeadWithItemServiceContract(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        serviceContract serviceContract = ServiceCampaignTestDataHelpers.getServiceContract();
        system.debug(serviceContract);
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(partner,branch,customer, serviceContract.Id);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals('Patner 1', serviceLead.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', serviceLead.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', serviceLead.dmpl__AccountId__r.Name, 'Customer Account should match');
        System.assertEquals('Service Contract 1', serviceLead.dmpl__ItemServiceContractId__r.Name, 'Item Service Contract should match');
        System.assertEquals(Date.newInstance(2025, 6, 20), serviceLead.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', serviceLead.dmpl__Status__c, 'Status should match');
    }

    @isTest
    static void createServiceLeadWithServiceCampaign(){
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadWithCampaign(partner,branch,customer, serviceCampaign);
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
        Test.stopTest();
        System.assertEquals('Partner 1', fetched.dmpl__PartnerAccountId__r.Name, 'Partner Account should match');
        System.assertEquals('Branch 1', fetched.dmpl__BranchId__r.Name, 'Branch should match');
        System.assertEquals('Customer 1', fetched.dmpl__AccountId__r.Name, 'Customer Account should match');
        System.assertEquals(Date.newInstance(2025, 6, 20), fetched.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c, 'Status should match');
        System.assertEquals('Campaign 1', fetched.dmpl__ServiceCampaignId__r.Name, 'Service Campaign should match');
    }

    @isTest
    static void CreateServiceLeadWithInactivePartnerCustomerBranchNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner.Id);
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        System.debug('Partner Active: ' + partner.IsActive__c);
        System.debug('Partner ID: ' + partner.Id);
        Boolean correctException = false;
        Test.startTest();
        try {
            partner.dmpl__IsActive__c=false;
            update partner;
            ServiceLeadTestDataHelpers.createServiceLead(partner2, branch, customer);
            System.debug('Service Lead created without exception - this should not happen');
        } catch (DmlException e) {
            System.debug('Full exception message: ' + e.getMessage());
            System.debug('Exception type: ' + e.getTypeName());
            
            if (e.getMessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION') &&
                e.getMessage().contains('dmpl__PartnerAccountId__c')) {
                correctException = true;
            } else {
                System.debug('Unexpected error: ' + e.getMessage());
            }
        } catch (Exception e) {
            System.debug('Non-DML exception: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(true, correctException, 'Expected FIELD_FILTER_VALIDATION_EXCEPTION for inactive Partner');
    }
}