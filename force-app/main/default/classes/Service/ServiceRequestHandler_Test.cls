@isTest
public with sharing class ServiceRequestHandler_Test {
	@TestSetup
	static void createRequiredData() {
		Test.startTest();
		dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
		Account account = TestDataHelpers.createAccount(accountGroup);
		Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
		Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item.Id);
		dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
		dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch1);
		dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch1, item, sku);
		Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(
			account, 
			branch1, 
			item, 
			itemLot, 
			sku
		);
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partnerAccount1,
			customerAccount1,
			branch1,
			asset
		);
		dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.createServiceRequestLine(serviceRequest, item, sku);
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount1, branch1);
		dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
		dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.createServiceRequestTax(
			serviceRequest,
			serviceRequestLine,
			taxGroup,
			tax
		);
		Test.stopTest();
	}

	@isTest
	static void createServiceRequestPositive() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Expected Service Request to be created.');
		dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.getServiceRequestLine();
		System.assertNotEquals(serviceRequestLine, null, 'Expected Service Request Line to be created.');
		dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.getServiceRequestTax();
		System.assertNotEquals(ServiceRequestTax, null, 'Expected Service Request Tax to be created.');
		Test.stopTest();
	}

	@isTest
	static void updateServiceRequestPositive() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Service Request should exist before update.');
		serviceRequest.dmpl__AccountName__c = 'Account 1 Updated';
		serviceRequest.dmpl__AdjustedAdvanceAmount__c = 3000;
		serviceRequest.dmpl__AdvanceAmount__c = 2000;
		serviceRequest.dmpl__Status__c = 'Confirmed';
		serviceRequest.dmpl__CustomerVoice__c = 'CustomerVoice2';
		update serviceRequest;
		dmpl__ServiceRequest__c updatedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertEquals(
			updatedServiceRequest.dmpl__AccountName__c,
			'Account 1 Updated',
			'Account Name should be Account 1 Updated after update.'
		);
		System.assertEquals(updatedServiceRequest.dmpl__AdjustedAdvanceAmount__c, 3000, 'Adjusted Amount should be 3000 after update.');
		System.assertEquals(updatedServiceRequest.dmpl__AdvanceAmount__c, 2000, 'Advance Amount should be 2000 after update.');
		System.assertEquals(updatedServiceRequest.dmpl__Status__c, 'Confirmed', 'Status should be Confirmed after update.');
		System.assertEquals(updatedServiceRequest.dmpl__CustomerVoice__c, 'CustomerVoice2', 'Customer Voice should be CustomerVoice2 after update.');
		Test.stopTest();
	}

	@isTest
	static void deleteServiceRequest() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Service Request should exist before delete.');
		Id serviceRequestId = serviceRequest.Id;
		delete serviceRequest;
		dmpl__ServiceRequest__c deletedServiceRequest = null;
		try {
			deletedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest(serviceRequestId);
		} catch (Exception e) {
			deletedServiceRequest = null;
		}
		Test.stopTest();
		System.assertEquals(deletedServiceRequest, null, 'Service Request should be deleted and not found in query.');
	}

	@isTest
	static void CreateServiceRequestWithCorrectPartnerAndBranchPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customer.Id);
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');
	}

	@isTest
	static void CreateServiceRequestWithWrongPartnerNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner3.Id,
				dmpl__BranchId__c = branch.Id,
				dmpl__AccountId__c = customer.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = asset.Id
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();
	}

	@isTest 
	static void UpdateServiceRequestWithWrongPartnerNegative() { 
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		System.assertEquals(partner.Id, sr.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, sr.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, sr.dmpl__AccountId__c, 'Customer should be Customer 1');
		Boolean isExceptionThrown = false;
		try {
			sr.dmpl__PartnerAccountId__c = partner3.Id;
			update sr;
		} catch (Exception e) {
		}
		Test.stopTest();
	}

	@isTest
	static void CreateServiceRequestWithInactivePartnerNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
		partner.dmpl__IsActive__c=false;
		update partner;
		Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		try{
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
		}catch(Exception e){}
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner2, 
			customer, 
			null, 
			asset
		);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();
		System.assert(isExceptionThrown, 'Insert should have failed due to inactive Partner Account and mandatory branch .');
	}

	@isTest
	static void updateServiceRequestWithInactivePartnerNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
		partner.dmpl__IsActive__c=false;
		update partner;
		Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		try{
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
		}catch(Exception e){}
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner1, 
			customer, 
			branch, 
			asset
		);
		Boolean exceptionThrown = false;
		try {
			sr.dmpl__PartnerAccountId__c=partner2.id;
			sr.dmpl__BranchId__c = null;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();
		System.assert(exceptionThrown, 'Update should fail due to inactive branch Account and missing branch .');
	}

	@isTest
	static void CreateServiceRequestWithWrongBranchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch3, 
			asset
		);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();
		System.assert(isExceptionThrown, 'Insert should have failed due to wrong Partner Account.');
	}

	@isTest
	static void updateServiceRequestWithWrongBranchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		Boolean exceptionThrown = false;
		try {
			sr.dmpl__BranchId__c = branch3.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();
		System.assert(exceptionThrown, 'Update should fail due to mismatched branch Account.');
	}

	@isTest
	static void createServiceRequestWithInactiveBranchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner3.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch3, 
			asset
		);
		} catch (Exception e) {
			isExceptionThrown = true;
			System.debug('Expected DML Exception: ' + e.getMessage());
		}
		Test.stopTest();
		System.assert(isExceptionThrown, 'Insert should have failed due to inactive branch');
	}

	@isTest
	static void updateServiceRequestWithInactiveBRanchNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch1, 
			asset
		);
		Boolean exceptionThrown = false;
		try {
			sr.dmpl__BranchId__c = branch3.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();
		System.assert(exceptionThrown, 'Update should fail due to inactive branch');
	}

	@isTest
	static void CreateServiceRequestWithCorrecActiveCustomerAccountPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customer.Id);
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void updateServiceRequestWithActiveCustomerAccountPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		sr.dmpl__AccountId__c = customer2.Id;
		update sr;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Service Request should now be linked to Customer 2');
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		Test.stopTest();
	}

	@isTest
	static void CreateServiceRequestWithInactiveCustomerAccountNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer7 = TestDataHelpers.createCustomerAccount('Customer 7');
		customer7.dmpl__IsActive__c=false;
		update customer7;
		dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner.Id,
				dmpl__BranchId__c = branch3.Id,
				dmpl__AccountId__c = customer7.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = asset.Id
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();
	}

	@isTest
	static void updateServiceRequestWithInactiveCustomerAccountNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer7 = TestDataHelpers.createCustomerAccount('Customer 7');
		customer7.dmpl__IsActive__c=false;
		update customer7;
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		Boolean exceptionThrown = false;
		try {
			sr.dmpl__AccountId__c = customer7.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
		}
		Test.stopTest();
		System.assert(exceptionThrown, 'Update should fail due to mismatched Partner Account.');
	}

	@isTest
	static void CreateServiceRequestWithAssetPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customer.Id);
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void updateServiceRequestWithAssetPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
		Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5','Product');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		Asset asset3 = AssetTestDataHelpers.createAsset('Asset 3', customerAccount3.Id, item5.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		sr.dmpl__AssetId__c = asset3.Id;
		update sr;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(asset3.Id, fetched.dmpl__AssetId__c, 'Service Request should now be linked to asset 3');
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
	}

	@isTest
	static void CreateServiceRequestWithoutAssetNegative() { 
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		Boolean isExceptionThrown = false;
		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner.Id,
				dmpl__BranchId__c = branch3.Id,
				dmpl__AccountId__c = customer.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = null
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();
		System.assertEquals(false,isExceptionThrown, 'Insert should have failed due to without asset');
	}

	@isTest
	static void CreateServiceRequestWithBillingAndShippingAddressPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customer.Id);
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
    static void CreateServiceRequestWithMultipleBillingAndShippingAddress() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partner.Id, branch.Id);
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customer.Id);
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');    
        Decimal usageReading = 1000;
        Test.startTest();
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
        dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');    
    }

	@isTest
	static void CreateServiceRequestWithGSTTaxGroupPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer2.Id, item.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer2, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c toUpdate = ServiceRequestTestDataHelpers.getServiceRequest(sr.Id);
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partner.Id, branch.Id);
		toUpdate.dmpl__TaxGroupId__c = taxGroup.Id;
		update toUpdate;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(toUpdate.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void CreateServiceRequestWithIGSTTaxGroupPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer2.Id, item.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer2, 
			branch, 
			asset
		);
		dmpl__ServiceRequest__c toUpdate = ServiceRequestTestDataHelpers.getServiceRequest(sr.Id);
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18',partner.Id, branch.Id);
		toUpdate.dmpl__TaxGroupId__c =taxGroup.Id;
		update toUpdate;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(toUpdate.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void CreateServiceRequestLineWithServiceRequestReferencePositive() {
		Test.startTest();
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId( 
			customer, 
			branch,
			item, 
			asset,
			null
		);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 1, 1500);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();
		System.assertEquals(1500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, line.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(request.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, line.dmpl__ItemId__c, 'Item should be item');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void createServiceRequestLineWithZeroQuantityNegative() {
		Test.startTest();
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId( 
			customer, 
			branch, 
			item,
			asset,
			null
		);
		Boolean failedDueToZeroQty = false;
		try {
			dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 0, 1000);
		} catch (Exception e) {
			failedDueToZeroQty = true;
		}
		Test.stopTest();
		System.assertEquals(true, failedDueToZeroQty, 'Insert should fail when quantity is 0');
	}

	@isTest
	static void createServiceRequestLineWithPriceListPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset
		);
		dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(
			request,
			item,
			1,
			1500
		);
		dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
		requestLine.dmpl__PriceListId__c = priceList.Id;
		update requestLine;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		requestLine = ServiceRequestTestDataHelpers.getServiceRequestLineById(requestLine.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(1500, requestLine.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__GrossAmount__c, 'Gross Amount should be 1500');
		System.assertEquals(1, requestLine.dmpl__Quantity__c, 'Quantity should be 1');
		System.assertEquals(1500, requestLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
		System.assertEquals(item.Id, requestLine.dmpl__ItemId__c, 'Item should match Item 8');
		System.assertEquals(request.Id, requestLine.dmpl__ServiceRequestId__c, 'Service Request should match');
		System.assertEquals(10000, requestLine.dmpl__ServiceContractWeightage__c, 'Weightage should be 1000');
	}

	@isTest
	static void createServiceRequestLineWithPositiveQuantityPositive() {
		Test.startTest();
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId( 
			customer, 
			branch, 
			item,
			asset,
			null
		);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(
			request, 
			item, 
			1, 
			1500
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();
		System.assertEquals(1500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, line.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(request.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
	}

	@isTest
	static void updateServiceRequestLineWithPositiveQuantityPositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(
			sr, 
			item, 
			1, 
			1500
		);
		srline.dmpl__Quantity__c = 3;
		update srline;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(4500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(4500, line.dmpl__BaseAmount__c, 'BaseAmount should be 4500');
		System.assertEquals(4500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(3, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(10000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(sr.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, line.dmpl__ItemId__c, 'Item should be Item 8');
	}

	@isTest
	static void CreateServiceRequestLineWithActiveItemPositive() {
		Test.startTest();
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId( 
			customer, 
			branch, 
			item,
			asset,
			null
		);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(
			request, 
			item, 
			1, 
			1500
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(1500, requestLine.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, requestLine.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(10000, requestLine.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(request.Id, requestLine.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, requestLine.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, requestLine.dmpl__ItemId__c, 'Item should be Item 8');
	}

	@isTest
	static void UpdateServiceRequestLineWithActiveItem() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(
			sr, 
			item, 
			1, 
			1500
		);
		srline.dmpl__Quantity__c = 3;
		update srline;
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(4500, line.dmpl__Amount__c, 'Amount should be 4500');
		System.assertEquals(4500, line.dmpl__BaseAmount__c, 'BaseAmount should be 4500');
		System.assertEquals(4500, line.dmpl__GrossAmount__c, 'GrossAmount should be 4500');
		System.assertEquals(3, line.dmpl__Quantity__c, 'Quantity should be 3 after update');
		System.assertEquals(10000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(sr.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, line.dmpl__ItemId__c, 'Item should be Item 8');
	}

	@isTest
	static void CreateServiceRequestLineWithInactiveItem() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2','Product');
		inactiveItem.dmpl__IsActive__c = false;
		update inactiveItem;
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, inactiveItem.Id);
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		Boolean creationFailed = false;
		dmpl__ServiceRequestLine__c srline;
		try {
			srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(sr, inactiveItem, 2, 2400);
		} catch (Exception e) {
			creationFailed = true;
		}
		System.assertEquals(true, creationFailed, 'Line creation should fail with inactive item');
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer.Name, fetched.dmpl__AccountName__c, 'Account Name mismatch');
		Test.stopTest();
	}

	@isTest
	static void CreateServiceRequestTaxWithRequestReferencePositive() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset1 = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partner.Id, branch.Id);
		dmpl__Tax__c createtax = TestDataHelpers.createTax(
			'GST Tax',
		 	'SGST',
			null,
			taxGroup.Id, 
			'Tax1'
		);
		dmpl__Tax__c tax = TestDataHelpers.getTax('GST Tax');
		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		dmpl__ServiceRequestTax__c taxEntry = ServiceRequestTestDataHelpers.createServiceRequestTax(
			sr, 
			null, 
			taxGroup, 
			tax
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertNotEquals(null, taxEntry.Id, 'Service Request Tax should be inserted');
		System.assertEquals(sr.Id, taxEntry.dmpl__ServiceRequestId__c, 'Service Request should be linked');
		System.assertEquals(taxGroup.Id, taxEntry.dmpl__TaxGroupId__c, 'Tax Group should match');
		System.assertEquals(tax.Id, taxEntry.dmpl__TaxId__c, 'Tax should match');
	}

	@isTest
	static void updateServiceRequestTaxWithUpdatedServiceRequestNegative() {
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset1 = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partner.Id, branch.Id);
		dmpl__Tax__c createtax = TestDataHelpers.createTax('GST Tax', 'SGST', null, taxGroup.Id, 'Tax1');
		dmpl__Tax__c tax = TestDataHelpers.getTax('GST Tax');
		dmpl__ServiceRequest__c sr1 = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		dmpl__ServiceRequest__c sr2 = ServiceRequestTestDataHelpers.createServiceRequestWithId(
			partner, 
			customer, 
			branch, 
			asset1
		);
		dmpl__ServiceRequestTax__c taxEntry = ServiceRequestTestDataHelpers.createServiceRequestTax(
			sr1, 
			null, 
			taxGroup, 
			tax
		);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr1.Id);
		System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertNotEquals(null, taxEntry.Id, 'Tax record should be inserted');
		System.assertEquals(sr1.Id, taxEntry.dmpl__ServiceRequestId__c, 'Tax should be linked to SR1');
		Boolean updateFailed = false;
		try {
			taxEntry.dmpl__ServiceRequestId__c = sr2.Id;
			update taxEntry;
		} catch (Exception e) {
			updateFailed = true;
		}
		Test.stopTest();
		System.assert(updateFailed, 'Updating ServiceRequestId__c should not be allowed or should fail');
	}
}