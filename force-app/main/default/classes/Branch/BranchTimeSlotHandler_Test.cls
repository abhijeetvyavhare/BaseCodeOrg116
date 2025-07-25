@isTest
public with sharing class BranchTimeSlotHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(null, branch);
    }

    @isTest
    static void createBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        if(branchTimeSlot != null) {
            System.assertNotEquals(branchTimeSlot, null, 'Expected branchTimeSlot to be created.');
        }
        System.assertEquals('Delivery', branchTimeSlot.dmpl__TransactionType__c, 'Transaction type must Delivery');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'Name should be Test - branchTimeSlot');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__MondayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__TuesdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__WednesdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__ThursdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__SundayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__FridayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__SaturdayCapacity__c, 'Capacity must be 12');
        System.assertNotEquals(branchTimeSlot.dmpl__BranchId__c, null, 'Expected dmpl__BranchId__c to be created.');
    }
    
    @isTest
    static void updateBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        System.assertNotEquals(branchTimeSlot, null, 'BranchTimeSlot should exist before update.');
        branchTimeSlot.dmpl__TransactionType__c = 'Product Demo';
        branchTimeSlot.Name = 'Updated - branchTimeSlot';
        branchTimeSlot.dmpl__MaximumCapacity__c = 25;
        branchTimeSlot.dmpl__MondayCapacity__c = 15;
        branchTimeSlot.dmpl__TuesdayCapacity__c = 14;
        branchTimeSlot.dmpl__WednesdayCapacity__c = 13;
        branchTimeSlot.dmpl__ThursdayCapacity__c = 12;
        branchTimeSlot.dmpl__FridayCapacity__c = 11;
        branchTimeSlot.dmpl__SaturdayCapacity__c = 10;
        branchTimeSlot.dmpl__SundayCapacity__c = 9;
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c updatedBranchTimeSlot = BranchTestDataHelper.getBranchTimeSlot(branchTimeSlot.Id);
        System.assertEquals('Product Demo', updatedBranchTimeSlot.dmpl__TransactionType__c, 'Expected TransactionType to be updated to Product Demo');
        System.assertEquals('Updated - branchTimeSlot', updatedBranchTimeSlot.Name, 'Expected Name to be updated');
        System.assertEquals(25, updatedBranchTimeSlot.dmpl__MaximumCapacity__c, 'Expected MaximumCapacity to be 25');
        System.assertEquals(15, updatedBranchTimeSlot.dmpl__MondayCapacity__c, 'Expected MondayCapacity to be 15');
        System.assertEquals(14, updatedBranchTimeSlot.dmpl__TuesdayCapacity__c, 'Expected TuesdayCapacity to be 14');
        System.assertEquals(13, updatedBranchTimeSlot.dmpl__WednesdayCapacity__c, 'Expected WednesdayCapacity to be 13');
        System.assertEquals(12, updatedBranchTimeSlot.dmpl__ThursdayCapacity__c, 'Expected ThursdayCapacity to be 12');
        System.assertEquals(11, updatedBranchTimeSlot.dmpl__FridayCapacity__c, 'Expected FridayCapacity to be 11');
        System.assertEquals(10, updatedBranchTimeSlot.dmpl__SaturdayCapacity__c, 'Expected SaturdayCapacity to be 10');
        System.assertEquals(9, updatedBranchTimeSlot.dmpl__SundayCapacity__c, 'Expected SundayCapacity to be 9');
    }
    
    @isTest
    static void deleteBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        System.assertNotEquals(branchTimeSlot, null, 'BranchTimeSlot should exist before delete.');
        delete branchTimeSlot;
        dmpl__BranchTimeSlot__c deletedBranchTimeSlot = null;
        try {
            deletedBranchTimeSlot = BranchTestDataHelper.getBranchTimeSlot(branchTimeSlot.Id);
        } catch (Exception e) {
            deletedBranchTimeSlot = null;
        }
        System.assertEquals(null, deletedBranchTimeSlot, 'BranchTimeSlot should be deleted and not found in query.');
    }
    
    @isTest
    static void createBranchTimeSlotWithTimeSlotNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithTimeSlotNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.name = 'T10';
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('T10', fetchTimeSlot.Name, 'TimeSlot name should be "T10"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }    

    @isTest
    static void updateBranchTimeSlotWithTimeSlotStartTimePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 15, 0, 0);
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(8, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(branchTimeSlot.dmpl__MaximumCapacity__c, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithTimeSlotEndTimePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__EndTime__c = Time.newInstance(11, 15, 0, 0);
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(11, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void createBranchTimeSlotWithStartTimeAfterEndTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__Branch__c branch = TestDataHelpers.getbranch();
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(10, 30, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(10, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithEndTimeBeforeStartTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 30, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(8, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithEndTimeSameAsStartTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 15, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(8, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithoutBranchTagNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(
                null, 
                'T1', 
                Time.newInstance(8, 15, 0, 0), 
                Time.newInstance(8, 15, 0, 0), 
                12
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown for missing Branch');
    }
    
    @isTest
    static void createBranchTimeSlotWithoutMaximumCapacityNegative() {
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(
                branch, 
                'T1', 
                Time.newInstance(8, 15, 0, 0), 
                Time.newInstance(8, 15, 0, 0), 
                null
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown for missing Maximum capacity');
    }
    
    @isTest
    static void createBranchTimeSlotWithMaximumCapacityPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithMaximumCapacityPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__MaximumCapacity__c = 17;
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(17, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void createBranchTimeSlotWithIsActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
        System.assertEquals(true, branchTimeSlot.dmpl__IsActive__c, 'Time Slot should be active');
    }
    
    @isTest
    static void updateBranchTimeSlotWithIsActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__IsActive__c = false;
        Update branchTimeSlot;
        dmpl__BranchTimeSlot__c updatedTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, updatedTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', updatedTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), updatedTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), updatedTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, updatedTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
        System.assertEquals(false, updatedTimeSlot.dmpl__IsActive__c, 'Time Slot should be active');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithNamePositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithCapacityPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void updateBranchTimeSlotBookingWithCapacityPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        fetchedBranchTimeSlotBooking.dmpl__Capacity__c = 120;
        Update fetchedBranchTimeSlotBooking;
        dmpl__BranchTimeSlotBooking__c updatedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(120, updatedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 120');
        System.assertEquals(branchTimeSlot.Id, updatedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithBranchTimeSlotPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutCapacityNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.id, 'T3', null);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when capacity is missing');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutNamePositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, '', 12);
        dmpl__BranchTimeSlotBooking__c updatedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, updatedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, updatedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutbranchTimeSlotNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(null, 'T3', 12);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when Branch Time Slot is missing');
    }
    
    @isTest
    static void createBranchDateSlotResultWithNamePositive() {
        Test.startTest();
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.createBranchDateSlotResult('T4');
        dmpl__BranchDateSlotResult__c fetchedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedbranchDateSlotResult, 'Fetched BranchDateSlotResult should not be null');
        System.assertEquals('T4', fetchedbranchDateSlotResult.Name, 'Name should be "T4"');
        System.assertEquals(branchDateSlotResult.Id, fetchedbranchDateSlotResult.Id, 'Fetched record Id should match original');
    }
    
    @isTest
    static void updateBranchDateSlotResultWithNamePositive() {
        Test.startTest();
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.createBranchDateSlotResult('T4');
        dmpl__BranchDateSlotResult__c fetchedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        fetchedbranchDateSlotResult.Name = 'T5';
        update fetchedbranchDateSlotResult;
        dmpl__BranchDateSlotResult__c updatedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(fetchedbranchDateSlotResult.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedbranchDateSlotResult, 'Fetched BranchDateSlotResult should not be null');
        System.assertEquals('T5', updatedbranchDateSlotResult.Name, 'Name should be "T4"');
        System.assertEquals(branchDateSlotResult.Id, updatedbranchDateSlotResult.Id, 'Fetched record Id should match original');
    }
}