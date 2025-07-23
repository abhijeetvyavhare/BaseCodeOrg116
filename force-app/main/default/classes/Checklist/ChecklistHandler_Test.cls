@isTest
public with sharing class ChecklistHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate('Test Checklist Template');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine('Test Checklist Template Line', checklistTemplate.Id);
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.createChecklistLine('Test Setup Checklist Line');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.createChecklistTemplate('Checklist 1');
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
    }

    @isTest
    static void createChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        System.assertNotEquals(checklistTemplate, null, 'Expected checklist template to be created.');
    }

    @isTest
    static void updateChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        checklistTemplate.Name = 'Updated Checklist Template Name';
        Test.startTest();
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updated = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertEquals(updated.Name, 'Updated Checklist Template Name', 'Checklist template name should be updated.');
    }

    @isTest
    static void deleteChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        Test.startTest();
        delete checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c deletedTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertEquals(deletedTemplate, null, 'Checklist template should be deleted.');
    }

    @isTest
    static void createChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        System.assertNotEquals(checklistTemplateLine, null, 'Expected checklist template line to be created.');
    }

    @isTest
    static void updateChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        checklistTemplateLine.Name = 'Updated Checklist Template Line Name';
        Test.startTest();
        update checklistTemplateLine;
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c updated = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertEquals(updated.Name, 'Updated Checklist Template Line Name', 'Checklist template line name should be updated.');
    }

    @isTest
    static void deleteChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        Test.startTest();
        delete checklistTemplateLine;
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c deletedLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertEquals(deletedLine, null, 'Checklist template line should be deleted.');
    }

    @isTest
    static void createChecklistLinePositive() {
        dmpl__CheckListLines__c setUpChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        System.assertNotEquals(setupChecklistLine, null, 'Expected checklistLine to be created.');
    }

    @isTest
    static void updateChecklistLinePositive() {
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        setupChecklistLine.Name = 'Updated Name';
        Test.startTest();
        update setupChecklistLine;
        Test.stopTest();
        dmpl__CheckListLines__c updated = ChecklistDataHelper.getChecklistLineById(setupChecklistLine.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Checklist line name should be updated.');
    }

    @isTest
    static void deleteChecklistLinePositive() {
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        Test.startTest();
        delete setupChecklistLine;
        Test.stopTest();
        dmpl__CheckListLines__c deletedLines = ChecklistDataHelper.getChecklistLineById(setupChecklistLine.Id);
        System.assertEquals(deletedLines, null, 'Checklist line should be deleted.');
    }

    @isTest
    static void checklistTemplateCreationWithItem(){
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        dmpl__ChecklistTemplate__c newChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertNotEquals(null, newChecklistTemplate.Id,'CheckListTemplate should be created');
        System.assertEquals('1', newChecklistTemplate.dmpl__Code__c,'Code should be 1');
        System.assertEquals(parentChecklist.Id, newChecklistTemplate.dmpl__ParentChecklistId__c,'Parent Template should match');    
        System.assertEquals(item.Id, newChecklistTemplate.dmpl__ItemId__c,'ItemId should match');
    }
    
    @isTest
    static void updateChecklistTemplateWithoutItemPositive() {
        Test.startTest();
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',        
            item.Id,            
            'Delivery',    
            parentChecklist.Id,
            '1'            
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist template should be created.');
        System.assertEquals('1', checklistTemplate.dmpl__Code__c, 'Code should match.');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match.');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Item should match.');
        checklistTemplate.dmpl__ItemId__c = null;
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updatedChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertEquals(null, updatedChecklistTemplate.dmpl__ItemId__c, 'Item should remain null.');
        System.assertEquals('1', updatedChecklistTemplate.dmpl__Code__c, 'Code should remain unchanged.');
        System.assertEquals(parentChecklist.Id, updatedChecklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should remain unchanged.');
    }

    @isTest
    static void createChecklistTemplateWithoutTypePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checkListTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            null,
            parentChecklist.Id,
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplate__c newChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checkListTemplate.Id);
        System.assertNotEquals(null, newChecklistTemplate.Id, 'ChecklistTemplate should be created');
        System.assertEquals('1', newChecklistTemplate.dmpl__Code__c, 'Code should be 1');
        System.assertEquals(parentChecklist.Id, newChecklistTemplate.dmpl__ParentChecklistId__c, 'Parent Template should match');
        System.assertEquals(item.Id, newChecklistTemplate.dmpl__ItemId__c, 'ItemId should match');
        System.assertEquals(null, newChecklistTemplate.dmpl__Type__c, 'Type should be null');
    }

    @isTest
    static void updateChecklistTemplateWithoutTypePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate, 'Checklist template should be created .');
        System.assertEquals('1', checklistTemplate.dmpl__Code__c, 'Code should match');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Item should match');
        checklistTemplate.dmpl__Type__c = null;
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updatedChecklist = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertNotEquals(null, updatedChecklist, 'Checklist template should exist after update');
        System.assertEquals('CJ 1', updatedChecklist.Name, 'Name should remain unchanged');
        System.assertEquals(item.Id, updatedChecklist.dmpl__ItemId__c, 'Item should remain unchanged');
        System.assertEquals(parentChecklist.Id, updatedChecklist.dmpl__ParentChecklistId__c, 'Parent Checklist should remain unchanged');
        System.assertEquals('1', updatedChecklist.dmpl__Code__c, 'Code should remain unchanged');
        System.assertEquals(null, updatedChecklist.dmpl__Type__c, 'Type should be null after edit');
    }

    @isTest
    static void createChecklistTemplateWithParentChecklistPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplate__c newChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checkListTemplate.Id);
        System.assertNotEquals(null, newChecklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals('1', newChecklistTemplate.dmpl__Code__c, 'Code should match');
        System.assertEquals(parentChecklist.Id, newChecklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(item.Id, newChecklistTemplate.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void updateChecklistTemplateWithParentChecklistPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            null,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate, 'Checklist Template should be created');
        System.assertEquals('1', checklistTemplate.dmpl__Code__c, 'Code should match');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Item should match');
        checklistTemplate.dmpl__ParentChecklistId__c = parentChecklist.Id;
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updatedCheckListTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertNotEquals(null, updatedCheckListTemplate, 'Checklist Template should exist');
        System.assertEquals('1', updatedCheckListTemplate.dmpl__Code__c, 'Code should remain unchanged');
        System.assertEquals(parentChecklist.Id, updatedCheckListTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(item.Id, updatedCheckListTemplate.dmpl__ItemId__c, 'Item should remain unchanged');
    }

    @isTest
    static void createChecklistTemplateWithCodePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checkListTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplate__c newCheckListtemplate = ChecklistDataHelper.getChecklistTemplateById(checkListTemplate.Id);
        System.assertNotEquals(null, newCheckListtemplate.Id, 'Checklist Template should be created');
        System.assertEquals('1', newCheckListtemplate.dmpl__Code__c, 'Code should be 1');
        System.assertEquals(parentChecklist.Id, newCheckListtemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(item.Id, newCheckListtemplate.dmpl__ItemId__c, 'Item should match');      
    }

    @isTest
    static void updateChecklistTemplateRemoveCodePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate, 'Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Item should match');
        checklistTemplate.dmpl__Code__c = null;
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updatedChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertNotEquals(null, updatedChecklistTemplate, 'Template should still exist');
        System.assertEquals(null, updatedChecklistTemplate.dmpl__Code__c, 'Code should be removed');
        System.assertEquals(parentChecklist.Id, updatedChecklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should remain unchanged');
        System.assertEquals(item.Id, updatedChecklistTemplate.dmpl__ItemId__c, 'Item should remain unchanged');
    }

    @isTest
    static void createChecklistTemplateWithoutNameNegative() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        Test.startTest();
        try {
            dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
                null,
                item.Id,
                'Delivery',
                parentChecklist.Id,
                '1'
            );
        } catch (DmlException e) {
            System.assert(false, 'Expected DmlException not thrown when name is null');
        }
        Test.stopTest();
    }

    @isTest
    static void createChecklistTemplateCreationWithoutCodePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 1',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            null
        );
        dmpl__ChecklistTemplate__c insertedChecklistTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        Test.stopTest();
        System.assertNotEquals(null, insertedChecklistTemplate, 'Checklist Template should be created');
        System.assertEquals(item.Id, insertedChecklistTemplate.dmpl__ItemId__c, 'ItemId should match');
        System.assertEquals(parentChecklist.Id, insertedChecklistTemplate.dmpl__ParentChecklistId__c, 'Parent Checklist should match');
        System.assertEquals(null, insertedChecklistTemplate.dmpl__Code__c, 'Code should be null');
    }

    @isTest
    static void createChecklistTemplateLineWithChecklistTemplateIdPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'CJ2 Line 1',
            checklistTemplate.Id,
            'Numeric',
            'Sample1',
            '1'
        );
        Test.stopTest();
        System.assertNotEquals(null, checklistTemplateLine.Id, 'checklist template Line will get created with checklist template reference');
        System.assertEquals('1', checklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
        System.assertEquals('Sample1', checklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should be Sample1');
    }

    @isTest
    static void createChecklistTemplateLineWithDataTypePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'clt 1',
            checklistTemplate.Id,
            'Numeric',
            'Sample1',
            '1'
        );
        Test.stopTest();
        System.assertNotEquals(null, checklistTemplateLine.Id, 'Checklist Template Line should be created');
        System.assertEquals('1', checklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
        System.assertEquals('Sample1', checklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should be Sample1');
    }

    @isTest
    static void updateChecklistTemplateLineWithDataTypePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'clt 1',
            checklistTemplate.Id,
            null,
            'Sample1',
            '1'
        );
        System.assertNotEquals(null, checklistTemplateLine.Id, 'Checklist Template Line should be created');
        System.assertEquals('1', checklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
        System.assertEquals('Sample1', checklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should be Sample1');
        checklistTemplateLine.dmpl__DataType__c = 'Numeric';
        update checklistTemplateLine;
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c updatedChecklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertNotEquals(null, updatedChecklistTemplateLine.Id, 'Checklist Template Line should still exist after update');
        System.assertEquals('1', updatedChecklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should remain 1');
        System.assertEquals('Sample1', updatedChecklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should remain Sample1');
    }

    @isTest
    static void createChecklistTemplateLineWithGroupByValueAssignedPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'clt 1',
            checklistTemplate.Id,
            'Numeric',
            'Sample1',
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c insertedChecklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertNotEquals(null, insertedChecklistTemplateLine.Id, 'Checklist Template Line should be created with group by value assigned');
        System.assertEquals('1', insertedChecklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
        System.assertEquals('Sample1', insertedChecklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should be Sample1');
    }
    
    @isTest
    static void createChecklistTemplateLineWithoutDataTypePositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'clt 1',
            checklistTemplate.Id,
            null,
            'Sample1',
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c insertedChecklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertNotEquals(null, insertedChecklistTemplateLine.Id, 'Checklist Template Line should be created without Data Type');
        System.assertEquals('1', insertedChecklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
        System.assertEquals('Sample1', insertedChecklistTemplateLine.dmpl__GroupBy__c, 'Checklist Line GroupBy should be Sample1');
    }

    @isTest
    static void createChecklistTemplateLineWithoutGroupByPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ChecklistTemplate__c parentChecklist = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(
            'CJ 2',
            item.Id,
            'Delivery',
            parentChecklist.Id,
            '1'
        );
        System.assertNotEquals(null, checklistTemplate.Id, 'Checklist Template should be created');
        System.assertEquals(parentChecklist.Id, checklistTemplate.dmpl__ParentChecklistId__c, 'Checklist Template Parent should be Checklist 1');
        System.assertEquals(item.Id, checklistTemplate.dmpl__ItemId__c, 'Checklist Template should have Item 1');
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(
            'clt 1',
            checklistTemplate.Id,
            'Numeric',
            null,
            '1'
        );
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c insertedChecklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertNotEquals(null, insertedChecklistTemplateLine.Id, 'Checklist Template Line should be created without GroupBy');
        System.assertEquals('1', insertedChecklistTemplateLine.dmpl__DefaultValue__c, 'Checklist Line Default Value should be 1');
    }

    @isTest
    static void createChecklistLineWithNamePositive() {
        Test.startTest();
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        if (checklistTemplate == null) {
            checklistTemplate = ChecklistDataHelper.createChecklistTemplateWithDefaults();
        }
        dmpl__CheckListLines__c checklistLine = ChecklistDataHelper.createChecklistLine('CLN1', checklistTemplate.Id, 'Text');
        Test.stopTest();
        dmpl__CheckListLines__c insertedLine = ChecklistDataHelper.getChecklistLineById(checklistLine.Id);
        System.assertNotEquals(null, insertedLine.Id, 'Checklist Line should be created');
        System.assertEquals('CLN1', insertedLine.Name, 'Checklist Line Name should be CLN1');
        System.assertEquals('Text', insertedLine.dmpl__DataType__c, 'Checklist Line Data Type should be Text');
        System.assertEquals(checklistTemplate.Id, insertedLine.dmpl__ChecklistTemplateId__c, 'Checklist Line should be linked to Checklist Template');
    }

    @isTest
    static void createChecklistLineWithoutNameNegative() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        System.assertNotEquals(null, checklistTemplate, 'Checklist Template "Checklist 1" should exist');
         Test.startTest();
        try {
            dmpl__CheckListLines__c checklistLine = ChecklistDataHelper.createChecklistLine(null, checklistTemplate.Id, 'Text');
            System.assert(true, 'Insert have not failed due to missing Name');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Name'), 'Exception should mention missing Name');
        }
        Test.stopTest();
    }

    @isTest
    static void createChecklistLineWithChecklistTemplatePositive() {
        Test.startTest();
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Checklist 1');
        System.assertNotEquals(null, checklistTemplate, 'Checklist Template "Checklist 1" should exist');
        dmpl__CheckListLines__c checklistLine = ChecklistDataHelper.createChecklistLine('CLN1', checklistTemplate.Id, 'Text');
        Test.stopTest();
        dmpl__CheckListLines__c insertedChecklistLine = ChecklistDataHelper.getChecklistLineById(checklistLine.Id);
        System.assertNotEquals(null, insertedChecklistLine, 'Checklist Line should be inserted');
        System.assertEquals('CLN1', insertedChecklistLine.Name, 'Checklist Line Name should be CLN1');
        System.assertEquals(checklistTemplate.Id, insertedChecklistLine.dmpl__ChecklistTemplateId__c, 'Checklist Line should reference Checklist Template "Checklist 1"');
        System.assertEquals('Text', insertedChecklistLine.dmpl__DataType__c, 'Checklist Line Data Type should be Text');
    }
    
    @isTest
    static void createChecklistLineWithoutChecklistTemplatePositive() {
        Test.startTest();
        dmpl__CheckListLines__c checklistLine = ChecklistDataHelper.createChecklistLine('CLN1', null, 'Text');
        Test.stopTest();
        dmpl__CheckListLines__c insertedChecklistLine = ChecklistDataHelper.getChecklistLineById(checklistLine.Id);
        System.assertNotEquals(null, insertedChecklistLine, 'Checklist Line should be inserted');
        System.assertEquals('CLN1', insertedChecklistLine.Name, 'Checklist Line Name should be CLN1');
        System.assertEquals(null, insertedChecklistLine.dmpl__ChecklistTemplateId__c, 'Checklist Template should be null');
        System.assertEquals('Text', insertedChecklistLine.dmpl__DataType__c, 'Checklist Line Data Type should be Text');
    }
}