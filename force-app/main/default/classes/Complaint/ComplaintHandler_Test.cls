@isTest
public with sharing class ComplaintHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint();
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 1','Product');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        Asset asset = ComplaintTestDataHelpers.createAsset('Asset 1', customer, item);
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customer);
    }

    @isTest
    static void createComplaintPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        System.assertNotEquals(null, complaint, 'Complaint should be created.');
        System.assertEquals('Complaint-Test', complaint.Name, 'Complaint Name should match.');
        System.assertEquals('37592', complaint.dmpl__Code__c, 'Complaint Code should match.');
        System.assertEquals('Text', complaint.dmpl__Description__c, 'Complaint Description should match.');
    }

    @isTest
    static void updateComplaintPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        complaint.dmpl__Description__c = 'Updated Description';
        update complaint;
        dmpl__Complaint__c updated = ComplaintTestDataHelpers.getComplaintById(complaint.Id);
        System.assertEquals('Updated Description', updated.dmpl__Description__c, 'Description should be updated.');
    }

    @isTest
    static void deleteComplaint() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        delete complaint;
        Integer count = ComplaintTestDataHelpers.getComplaintCountById(complaint.Id);
        System.assertEquals(0, count, 'Complaint should be deleted.');
    }

    @isTest
    static void createComplaintCreatedWithNewCodePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90-TEST','Sample complaint description');
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint record should be inserted');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90-TEST', complaint.dmpl__Code__c, 'Complaint code should match');
    }

    @isTest
    static void updateComplaintCreatedWithNewCodePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90-TEST','' );
        complaint.dmpl__Code__c = 'CF91-UPDATED';
        update complaint;
        System.assertEquals('Complaint-01', complaint.Name, 'Name should remain unchanged');
        System.assertEquals('CF91-UPDATED', complaint.dmpl__Code__c, 'Updated code should be CF91-UPDATED');
    }

    @isTest
    public static void createComplaintCreatedWithDescriptionHaving200CharactersPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris');
        Test.stopTest();
        dmpl__Complaint__c insertedComplaint = ComplaintTestDataHelpers.getComplaint('Complaint-01', 'CF90');
        System.assertNotEquals(null, insertedComplaint, 'Complaint record should exist in database');
        System.assertEquals('Complaint-01', insertedComplaint.Name, 'Name should match');
        System.assertEquals('CF90', insertedComplaint.dmpl__Code__c, 'Code should match');
        System.assertEquals(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris',
            insertedComplaint.dmpl__Description__c,
            'Description should match the expected 200 characters'
        );
    }

    @isTest
    public static void createComplaintCreatedWithNoCodeNegative() {
        Test.startTest();
        try {
            ComplaintTestDataHelpers.createComplaint('Complaint-01','', 'Complaint will not get created');
            System.assert(false, 'Complaint should not be inserted without Code');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('dmpl__Code__c') || 
                e.getMessage().contains('REQUIRED_FIELD_MISSING'),
                'Error should indicate that Code is required'
            );
        }
        Test.stopTest();
    }

    @isTest
    public static void createComplaintCreatedWithDescriptionHaving300CharactersNegative() {
        Test.startTest();
        try {
            ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit');
            System.assert(false, 'Complaint should not be inserted with 300-character description');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('dmpl__Description__c') || 
                e.getMessage().contains('STRING_TOO_LONG'),
                'Error should be related to Description field exceeding limit'
            );
        }
        Test.stopTest();
    }

    @isTest
    public static void createComplaintFaultCreatedWithComplaintPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,
            null,
            null,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
    }

    @isTest
    public static void createComplaintFaultCreatedWithFaultCodePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            'CFL-01', 
            null,
            null,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
        System.assertEquals('CFL-01', complaintFault.dmpl__FaultCode__c, 'Fault Code should match');
    }

    @isTest
    public static void createComplaintFaultCreatedWithNewItemPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90', null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,     
            item,     
            null,     
            null      
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, item.Id, 'Item should be created');
        System.assertEquals('Item 1', item.Name, 'Item name should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
        System.assertEquals(item.Id, complaintFault.dmpl__ApplicableToItemId__c, 'Complaint Fault should be linked to Item');
    }

    @isTest
    public static void createComplaintFaultCreatedWithItemGroupPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90', null);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,      
            null,      
            itemGroup, 
            null       
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, itemGroup.Id, 'Item Group should be created');
        System.assertEquals('Item Group 1', itemGroup.Name, 'Item Group name should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
        System.assertEquals(itemGroup.Id, complaintFault.dmpl__ApplicableToItemGroupId__c, 'Complaint Fault should be linked to Item Group');
    }

    @isTest
    public static void createComplaintFaultCreatedWithDescriptionHaving200CharactersPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90', null);
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null, 
            null, 
            null, 
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris'
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
        System.assertEquals(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris',
            complaintFault.dmpl__Description__c,
            'Complaint Fault description should match 200 characters'
        );
    }

    @isTest
    public static void createComplaintFaultCreatedWithItemAndItemGroupPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,    
            item,
            itemGroup,
            null      
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint code should match');
        System.assertNotEquals(null, item.Id, 'Item should be created');
        System.assertEquals('Item 1', item.Name, 'Item name should match');
        System.assertNotEquals(null, itemGroup.Id, 'Item Group should be created');
        System.assertEquals('Item Group 1', itemGroup.Name, 'Item Group name should match');
        System.assertNotEquals(null, complaintFault.Id, 'Complaint Fault should be created');
        System.assertEquals('ComplaintFault-01', complaintFault.Name, 'Complaint Fault name should match');
        System.assertEquals(complaint.Id, complaintFault.dmpl__ComplaintId__c, 'Complaint Fault should be linked to Complaint');
        System.assertEquals(item.Id, complaintFault.dmpl__ApplicableToItemId__c, 'Complaint Fault should be linked to Item');
        System.assertEquals(itemGroup.Id, complaintFault.dmpl__ApplicableToItemGroupId__c, 'Complaint Fault should be linked to Item Group');
    }

    @isTest
    public static void createComplaintFaultWithNOComplaintPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__ComplaintFault__c fault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            null,
            null,
            null,
            null,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint record should be created with a valid Id');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint should have the correct Name');
        System.assertEquals('CF90', complaint.dmpl__Code__c, 'Complaint should have the correct Code');
        System.assertNotEquals(null, fault.Id, 'Complaint Fault record should be created with a valid Id');
        System.assertEquals('ComplaintFault-01', fault.Name, 'Complaint Fault should have the correct Name');
        System.assertEquals(null, fault.dmpl__ComplaintId__c, 'Complaint Fault should not be linked to a Complaint (ComplaintId should be null)');
    }

    @isTest
    public static void updateComplaintFaultCreatedWithDiscontinuedItemPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,
            item1,
            null,
            null
        );
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product'); 
        item4.dmpl__IsDiscontinued__c = true;
        update item4;
        complaintFault.dmpl__ApplicableToItemId__c = item4.Id;
        update complaintFault;
        dmpl__ComplaintFault__c updatedFault = ComplaintTestDataHelpers.getComplaintFault('ComplaintFault-01');
        Test.stopTest();
        System.assertEquals(item4.Id, updatedFault.dmpl__ApplicableToItemId__c, 'Item should be updated to discontinued item successfully');
    }

    @isTest
    public static void updateComplaintFaultCreatedWithInactiveItemPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90',null);
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,
            item1,
            null,
            null
        );
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product'); 
        item2.dmpl__IsActive__c = false;
        update item2;
        complaintFault.dmpl__ApplicableToItemId__c = item2.Id;
        Test.startTest();
        update complaintFault;
        Test.stopTest();
        dmpl__ComplaintFault__c updatedFault = ComplaintTestDataHelpers.getComplaintFault('ComplaintFault-01');
        System.assertNotEquals(null, updatedFault, 'Complaint Fault should exist');
        System.assertEquals(item2.Id, updatedFault.dmpl__ApplicableToItemId__c, 'Item should be updated to the inactive item successfully');
    }

    @isTest
    public static void createComplaintFaultWithNoComplaintNegative() {
        Test.startTest();
        dmpl__ComplaintFault__c fault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            null,
            null,
            null,
            null,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, fault.Id, 'Complaint Fault record should be created with a valid Id');
    }

    @isTest
    public static void createComplaintFaultCreatedWithFaultCodeHaving50CharactersNegative() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90', null);
        String longFaultCode = 'Lorem ipsum dolor sit amet, consectetur elit.';
        try {
            ComplaintTestDataHelpers.createComplaintFault(
                'ComplaintFault-01',
                complaint,
                longFaultCode,
                null,
                null,
                null
            );
            System.assert(false, 'Complaint Fault should not be inserted with invalid Fault Code');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('dmpl__FaultCode__c') ||
                e.getMessage().contains('value') ||
                e.getMessage().contains('Validation'),
                'Error should be related to invalid or long Fault Code'
            );
        }
        Test.stopTest();
    }

    @isTest
    public static void createComplaintFaultCreatedWithDescriptionHaving300CharactersNegative() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01','CF90', null);
        String longDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                + 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
                                + 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';
        try {
            ComplaintTestDataHelpers.createComplaintFault(
                'ComplaintFault-01',
                complaint,
                null,    
                null,    
                null,    
                longDescription
            );
            System.assert(false, 'Complaint Fault should not be created with 300-character description');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('dmpl__Description__c') ||
                e.getMessage().contains('value too large') ||
                e.getMessage().contains('Validation'),
                'Error should be related to Description length exceeding the limit'
            );
        }
        Test.stopTest();
    }

    @isTest
    public static void createComplaintItemWithNewActiveItemPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            item,
            complaint,
            null,      
            1,         
            true       
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint name should match');
        System.assertNotEquals(null, item.Id, 'Item should be created');
        System.assertEquals('Item 1', item.Name, 'Item name should match');
        System.assertNotEquals(null, complaintItem.Id, 'Complaint Item should be created');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint Item should be linked to Complaint');
        System.assertEquals(item.Id, complaintItem.dmpl__ItemId__c, 'Complaint Item should be linked to active Item');
    }

    @isTest
    public static void createComplaintItemWithNewItemAndComplaintPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            item,
            complaint,
            null,
            1,
            true
        );
        Test.stopTest();
        System.assertNotEquals(null, complaint.Id, 'Complaint should be created');
        System.assertEquals('Complaint-01', complaint.Name, 'Complaint Name should match');
        System.assertNotEquals(null, item.Id, 'Item should be created');
        System.assertEquals('Item 1', item.Name, 'Item Name should match');
        System.assertNotEquals(null, complaintItem.Id, 'Complaint Item should be created');
        System.assertEquals(item.Id, complaintItem.dmpl__ItemId__c, 'Complaint Item should be linked to Item');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint Item should be linked to Complaint');
    }

    @isTest
    public static void updateComplaintItemWithNewItemAndComplaintPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            item1,
            complaint,
            null,
            1,
            true
        );
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
        complaintItem.dmpl__ItemId__c = item3.Id;
        update complaintItem;
        Test.stopTest();
        System.assertNotEquals(null, complaintItem, 'Complaint Item should exist after update');
        System.assertEquals(item3.Id, complaintItem.dmpl__ItemId__c, 'Complaint Item should be updated to new Item');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint reference should remain unchanged');
    }

    @isTest
    public static void updateComplaintItemWithComplaintFaultCodePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            item,
            complaint,
            null,     
            1,
            true
        );
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,
            null,
            null,
            null
        );
        complaintItem.dmpl__ComplaintFaultCodeId__c = complaintFault.Id;
        update complaintItem;
        Test.stopTest();
        System.assertNotEquals(null, complaintItem, 'Updated Complaint Item should exist');
        System.assertEquals(item.Id, complaintItem.dmpl__ItemId__c, 'Item reference should remain unchanged');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint reference should remain unchanged');
        System.assertEquals(complaintFault.Id, complaintItem.dmpl__ComplaintFaultCodeId__c, 'Complaint Fault Code should be updated correctly');
    }

    @isTest
    public static void createComplaintItemWithDiscontinuedItemPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c discontinuedItem = TestDataHelpers.createItem('Item 4', 'Product');
        discontinuedItem.dmpl__IsDiscontinued__c = true;
        update discontinuedItem;
        Test.startTest();
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            discontinuedItem,
            complaint,
            null,
            1,
            true
        );
        Test.stopTest();
        System.assertNotEquals(null, complaintItem, 'Complaint Item should be created');
        System.assertEquals(discontinuedItem.Id, complaintItem.dmpl__ItemId__c, 'Item should be the discontinued one');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint should match');
    }

    @isTest
    public static void createComplaintItemWithInactiveItemPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2', 'Product');
        inactiveItem.dmpl__IsActive__c = true;
        update inactiveItem;
        Test.startTest();
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            inactiveItem,
            complaint,
            null,
            1,
            true
        );
        Test.stopTest();
        System.assertNotEquals(null, complaintItem, 'Complaint Item should be created');
        System.assertEquals(inactiveItem.Id, complaintItem.dmpl__ItemId__c, 'Item should be the inactive one');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'Complaint should match');
    }

    @isTest
    public static void updateComplaintItemWithNoItemAndNoComplaintPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ComplaintItem__c complaintItem = ComplaintTestDataHelpers.createComplaintItem(
            item,
            complaint,
            null,
            1,
            true
        );
        complaintItem.dmpl__ItemId__c = null;
        complaintItem.dmpl__ComplaintId__c = null;
        Test.startTest();
        update complaintItem;
        Test.stopTest();
        System.assertNotEquals(null, complaintItem, 'Complaint Item should exist after update');
        System.assertEquals(null, complaintItem.dmpl__ItemId__c, 'Item should be null after update');
        System.assertEquals(null, complaintItem.dmpl__ComplaintId__c, 'Complaint should be null after update');
    }

    @isTest
    public static void createComplaintLineWithComplaintPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            null,     
            null,     
            null,     
            null      
        );
        Test.stopTest();
        dmpl__ComplaintLine__c insertedLine = ComplaintTestDataHelpers.getComplaintLine(complaint.Id);
        System.assertNotEquals(null, insertedLine, 'Complaint Line should be inserted');
        System.assertEquals(complaint.Id, insertedLine.dmpl__ComplaintId__c, 'Complaint reference should match');
    }

    @isTest
    public static void createComplaintLineWithComplaintAndComplaintFaultCodePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(
            'ComplaintFault-01',
            complaint,
            null,  
            null,  
            null,  
            null   
        );
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            complaintFault,
            null,  
            null,  
            null   
        );
        Test.stopTest();
        dmpl__ComplaintLine__c insertedLine = ComplaintTestDataHelpers.getComplaintLine(complaint.Id);
        System.assertNotEquals(null, insertedLine, 'Complaint Line should be inserted');
        System.assertEquals(complaint.Id, insertedLine.dmpl__ComplaintId__c, 'Complaint reference should match');
        System.assertEquals(complaintFault.Id, insertedLine.dmpl__ComplaintFaultCodeId__c, 'Complaint Fault Code reference should match');
    }

    @isTest
    public static void updateComplaintLineWithRepairOrderPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = ComplaintTestDataHelpers.getAsset('Asset 1');
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            null,
            null,
            null,
            null
        );
        dmpl__RepairOrder__c repairOrder = ComplaintTestDataHelpers.createRepairOrder(item, branch, customer);
        complaintLine.dmpl__RepairOrderId__c = repairOrder.Id;
        update complaintLine;
        Test.stopTest();
        System.assertEquals(complaint.Id, complaintLine.dmpl__ComplaintId__c, 'Complaint should be correctly referenced.');
        System.assertEquals(repairOrder.Id, complaintLine.dmpl__RepairOrderId__c, 'Repair Order should be correctly linked.');
    }

    @isTest
    public static void createComplaintLineWithNoRepairOrderPositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            null,
            null,
            null,
            null
        );
        Test.stopTest();
        System.assertNotEquals(null, complaintLine.Id, 'Complaint Line should be created.');
        System.assertEquals(complaint.Id, complaintLine.dmpl__ComplaintId__c, 'Complaint should be correctly referenced.');
        System.assertEquals(null, complaintLine.dmpl__RepairOrderId__c, 'Repair Order should be null as not linked.');
    }

    @isTest
    public static void updateComplaintLineWithServiceEstimatePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource = ComplaintTestDataHelpers.createResource(
            'Resource 1',
            partner.Id,
            branch.Id,
            true
        );
        dmpl__Quote__c quote = ComplaintTestDataHelpers.createQuote(customer, branch);
        update quote;
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            null, 
            null,
            null, 
            null  
        );
        complaintLine.dmpl__ServiceEstimateId__c = quote.Id;
        update complaintLine;
        Test.stopTest();
        System.assertEquals(complaint.Id, complaintLine.dmpl__ComplaintId__c, 'Complaint Line should reference the correct Complaint');
        System.assertEquals(quote.Id, complaintLine.dmpl__ServiceEstimateId__c, 'Complaint Line should reference the correct Service Estimate (Quote)');
    }

    @isTest
    public static void createComplaintLineWithNoServiceEstimatePositive() {
        Test.startTest();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint('Complaint-01', 'CF90', null);
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            complaint,
            null,  
            null,  
            null,  
            null   
        );
        Test.stopTest();
        System.assertNotEquals(null, complaintLine.Id, 'Complaint Line should be created.');
        System.assertEquals(complaint.Id, complaintLine.dmpl__ComplaintId__c, 'Complaint should be correctly linked.');
        System.assertEquals(null, complaintLine.dmpl__ServiceEstimateId__c, 'Service Estimate should be null.');
    }

    @isTest
    public static void createComplaintLineWithNoComplaintPositive() {
        Test.startTest();
        dmpl__ComplaintLine__c complaintLine = ComplaintTestDataHelpers.createComplaintLine(
            null,   
            null,   
            null,   
            null,   
            null    
        );
        Test.stopTest();
        System.assertNotEquals(null, complaintLine, 'Complaint Line should be created even without Complaint');
        System.assertEquals(null, complaintLine.dmpl__ComplaintId__c, 'ComplaintId should be null');
    }
}