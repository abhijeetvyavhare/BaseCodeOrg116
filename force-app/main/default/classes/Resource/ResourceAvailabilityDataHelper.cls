@isTest
public with sharing class ResourceAvailabilityDataHelper {
	public static dmpl__ResourceAvailability__c createResourceAvailability(
		dmpl__Resource__c resource
	) {
		return (dmpl__ResourceAvailability__c) TestFactory.createSObject(
			new dmpl__ResourceAvailability__c (
				dmpl__ResourceId__c = resource.Id
			), 
			'ResourceAvailabilityDefaults', 
			true
		);
	}

	public static dmpl__ResourceAvailability__c getResourceAvailability(){
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceId__c, 
				dmpl__AvailabilityType__c, 
				dmpl__Date__c 
			FROM dmpl__ResourceAvailability__c 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailability__c getResourceAvailability(
		Id id
	) {
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceId__c, 
				dmpl__CheckIn__c, 
				dmpl__CheckOut__c, 
				dmpl__AvailabilityType__c, 
				dmpl__Date__c 
			FROM dmpl__ResourceAvailability__c 
			WHERE Id = :id 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailabilityData__c createResourceAvailabilityData(
		dmpl__Resource__c resource, 
		dmpl__ResourceAvailability__c resourceAvailability
	) {
		return (dmpl__ResourceAvailabilityData__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityData__c (
                dmpl__ResourceId__c = resource.Id, 
                dmpl__ResourceAvailabilityId__c = resourceAvailability.Id
			), 
			'ResourceAvailabilityDataDefaults', 
			true
		);
	}

	public static dmpl__ResourceAvailabilityData__c createResourceAvailabilityData(
		Id resourceId, 
		Id resourceAvailabilityId,
		Id branchId
	) {
		return (dmpl__ResourceAvailabilityData__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityData__c (
                dmpl__ResourceId__c = resourceId, 
                dmpl__ResourceAvailabilityId__c = resourceAvailabilityId,
				dmpl__BranchId__c = branchId
			), 
			'ResourceAvailabilityDataDefaults', 
			true
		);
	}

	public static dmpl__ResourceAvailabilityData__c getResourceAvailabilityData() {
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceId__c, 
				dmpl__Type__c, 
				dmpl__Time__c,
				dmpl__AttendenceTime__c, 
				dmpl__ResourceAvailabilityId__c,
				dmpl__BranchId__c
			FROM dmpl__ResourceAvailabilityData__c 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailabilityData__c getResourceAvailabilityData(
		Id id
	) {
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceId__c, 
				dmpl__Type__c, 
				dmpl__AttendenceTime__c, 
				dmpl__Time__c, 
				dmpl__ResourceAvailabilityId__c, 
				dmpl__BranchId__c 
			FROM dmpl__ResourceAvailabilityData__c 
			WHERE Id = :id 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailabilityCheckIn__c createResourceAvailabilityCheckIn(
		dmpl__ResourceAvailability__c resourceAvailability
	) {
		return (dmpl__ResourceAvailabilityCheckIn__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityCheckIn__c (
                dmpl__ResourceAvailabilityId__c = resourceAvailability.Id
			), 
			'ResourceAvailabilityCheckInDefaults', 
			true
		);
	}

	public static dmpl__ResourceAvailabilityCheckIn__c getResourceAvailabilityCheckIn() {
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceAvailabilityId__c, 
				dmpl__CheckIn__c, 
				dmpl__CheckOut__c, 
				dmpl__CheckInSource__c, 
				dmpl__CheckOutSource__c 
			FROM dmpl__ResourceAvailabilityCheckIn__c 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailabilityCheckIn__c getResourceAvailabilityCheckIn(
		Id id
	) {
		return [
			SELECT 
				Id, 
				Name, 
				dmpl__ResourceAvailabilityId__c, 
				dmpl__CheckIn__c, 
				dmpl__CheckOut__c, 
				dmpl__CheckInSource__c, 
				dmpl__CheckOutSource__c 
			FROM dmpl__ResourceAvailabilityCheckIn__c 
			WHERE Id = :id 
			LIMIT 1 
		];
	}

	public static dmpl__ResourceAvailabilityData__c createResourceAvailabilityData(
		Id resourceId, 
		Id resourceAvailabilityId, 
		Id branchId, 
		String type, 
		DateTime dateTimevar
	) {
		return (dmpl__ResourceAvailabilityData__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityData__c (
				dmpl__Type__c = type, 
                dmpl__ResourceId__c = resourceId, 
                dmpl__AttendenceTime__c = dateTimevar, 
                dmpl__ResourceAvailabilityId__c = resourceAvailabilityId, 
				dmpl__Time__c = dateTimevar, 
				dmpl__BranchId__c = branchId
			), 
			true
		);
	}

	public static dmpl__ResourceAvailability__c createResourceAvailability(
		Id resourceId, 
		String availability, 
		DateTime checkIn, 
		DateTime checkOut, 
		Date customDate
	) {
		return (dmpl__ResourceAvailability__c) TestFactory.createSObject(
			new dmpl__ResourceAvailability__c(
				dmpl__ResourceId__c = resourceId, 
				dmpl__AvailabilityType__c = availability, 
				dmpl__CheckIn__c = checkIn, 
				dmpl__CheckOut__c = checkOut, 
				dmpl__Date__c = customDate
			), 
			true
		);
	}

	public static dmpl__ResourceAvailabilityCheckIn__c createResourceAvailabilityCheckIn(
		Id resourceAvailabilityId, 
		Datetime checkIn, 
		Datetime checkOut, 
		String checkInSource, 
		String checkOutSource
	) {
		return (dmpl__ResourceAvailabilityCheckIn__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityCheckIn__c (
                dmpl__ResourceAvailabilityId__c = resourceAvailabilityId, 
				dmpl__CheckIn__c = checkIn, 
				dmpl__CheckOut__c = checkOut, 
				dmpl__CheckInSource__c = checkInSource, 
				dmpl__CheckOutSource__c = checkOutSource
			), 
			true
		);
	}
}