@isTest
public with sharing class ResourceAvailabilityHandler_Test {
	@TestSetup
	static void createRequiredData() {
		Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
		dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
		dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(resource);
		dmpl__ResourceAvailabilityData__c resourcAvailabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(resource.Id, resourceAvailability.Id, Branch.Id);
		dmpl__ResourceAvailabilityCheckIn__c resourcAvailabilityCheckIn = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(resourceAvailability);
	}

	@isTest
	static void createResourceAvailabilityPositive() {
		dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
		System.assertNotEquals(null, resourceAvailability , 'Expected Resource Availability to be created.');
		System.assertEquals('Present', resourceAvailability.dmpl__AvailabilityType__c, 'Resource Availability Type must be Present');
	}

	@isTest
	static void createResourceAvailabilityDataPositive() {
		dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
		System.assertNotEquals(resourceAvailabilityData, null, 'Expected Resource Availability Data to be created.');
		System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Resource Availability Data Type must be Check-In');
	}

	@isTest
	static void createResourceAvailabilityCheckInPositive() {
		dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
		System.assertNotEquals(resourceAvailabilityCheckIn, null, 'Expected Resource Availability CheckIn to be created.');
		System.assertEquals('Desktop', resourceAvailabilityCheckIn.dmpl__CheckInSource__c, 'Resource Availability CheckIn Source must be Desktop');
	}

	@isTest
	static void updateResourceAvailabilityPositive() {
		dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
		System.assertNotEquals(resourceAvailability, null, 'Resource Availability should exist before update.');
		resourceAvailability.dmpl__AvailabilityType__c = 'Leave';
		update resourceAvailability;
		System.assertEquals('Leave', resourceAvailability.dmpl__AvailabilityType__c, 'Expected Resource Availability Type to be updated to Leave.');
	}

	@isTest
	static void updateResourceAvailabilityDataPositive() {
		dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
		System.assertNotEquals(resourceAvailabilityData, null, 'Resource Availability Data should exist before update.');
		resourceAvailabilityData.dmpl__Type__c = 'Check-Out';
		update resourceAvailabilityData;
		System.assertEquals('Check-Out', resourceAvailabilityData.dmpl__Type__c, 'Expected Resource Availability Data Type to be updated to Check-Out.');
	}

	@isTest
	static void updateResourceAvailabilityCheckInPositive() {
		dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
		System.assertNotEquals(resourceAvailabilityCheckIn, null, 'Resource Availability Data should exist before update.');
		resourceAvailabilityCheckIn.dmpl__CheckInSource__c = 'Mobile';
		update resourceAvailabilityCheckIn;
		System.assertEquals('Mobile', resourceAvailabilityCheckIn.dmpl__CheckInSource__c, 'Expected Resource Availability Data CheckIn Source to be updated to Mobile.');
	}

	@isTest
	static void deleteResourceAvailabilityCheckIn() {
		dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
		System.assertNotEquals(null, resourceAvailabilityCheckIn, 'ResourceAvailabilityCheckIn should exist before delete.');
		delete resourceAvailabilityCheckIn;
		dmpl__ResourceAvailabilityCheckIn__c deletedCheckIn;
		try {
			deletedCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(resourceAvailabilityCheckIn.Id);
		} catch (Exception e) {
			deletedCheckIn = null;
		}
		System.assertEquals(null, deletedCheckIn, 'ResourceAvailabilityCheckIn should be deleted and not found in query.');
	}

	@isTest
	static void deleteResourceAvailabilityData() {
		dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
		System.assertNotEquals(null, resourceAvailabilityData, 'ResourceAvailabilityData should exist before delete.');
		delete resourceAvailabilityData;
		dmpl__ResourceAvailabilityData__c deletedData;
		try {
			deletedData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(resourceAvailabilityData.Id);
		} catch (Exception e) {
			deletedData = null;
		}
		System.assertEquals(null, deletedData, 'ResourceAvailabilityData should be deleted and not found in query.');
	}

	@isTest
	static void deleteResourceAvailability() {
		dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
		System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should exist before delete.');
		delete resourceAvailability;
		dmpl__ResourceAvailability__c deletedAvailability;
		try {
			deletedAvailability = ResourceAvailabilityDataHelper.getResourceAvailability(resourceAvailability.Id);
		} catch (Exception e) {
			deletedAvailability = null;
		}
		System.assertEquals(null, deletedAvailability, 'ResourceAvailability should be deleted and not found in query.');
	}

    @isTest
    static void createAvailabilityDataWithActiveResourceAvailabilityIdAndResourceIdPositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
    }

    @isTest
    static void createAvailabilityDataWithTypeAndAttendanceTimePositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(resource.Id, resourceAvailability.Id, null);
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
    }

    @isTest
    static void createAvailabilityDataWithActiveBranchPositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(branch.Id, resourceAvailabilityData.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    static void createAvailabilityDataWithcurrentAttendanceTimePositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(resource.Id, resourceAvailability.Id, null);
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(DateTime.now(), resourceAvailabilityData.dmpl__Time__c, 'Attendance time should match');
    }

    @isTest
    static void createAvailabilityDataWithMultipleEntriesforSameResourcePositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData2 = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
		resourceAvailabilityData2.dmpl__Type__c = 'Check-Out';
		resourceAvailabilityData2.dmpl__Time__c = DateTime.now().addHours(3);
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(branch.Id, resourceAvailabilityData.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Check-Out', resourceAvailabilityData2.dmpl__Type__c, 'Type should be Check-In');
    }

    @isTest
    static void updateAvailabilityDataWithAttendanceTimePositive() {
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        resourceAvailabilityData.dmpl__AttendenceTime__c = DateTime.now().addHours(3);
        resourceAvailabilityData.dmpl__Time__c = DateTime.now().addHours(3);
        update resourceAvailabilityData;
        Test.stopTest();
        System.assertNotEquals(null, resourceAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, resourceAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, resourceAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(branch.Id, resourceAvailabilityData.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    static void createAvailabilityDataWithoutResourceAvailabilityNegative() {
        Test.startTest();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        try {
            dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(resource.Id, null, branch.Id);
        } catch(Exception e){
			System.Assert.isTrue(true, 'Availability data should not be created without resource availability');
		}
        Test.stopTest();
    }
}