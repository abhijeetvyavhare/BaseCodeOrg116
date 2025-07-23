@isTest
private class VisitTaskTemplateHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id); 
        dmpl__Resource__c resource = TestDataHelpers.createResource('Resource 1',partnerAccount1,branch1);  
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(
            'Visit Route 1',
            accountGroup1,
            partnerAccount1,
            resource
        );
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Capturing the Order');
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount1,route,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate,'Order Capturing');
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity('Take Order',entry);
        dmpl__Visit__c visits = VisitPlanTestDataHelpers.CreateVisit(customerAccount1,plans,taskTemplate);
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__ChecklistTemplate__c checkListTemplate = ChecklistDataHelper.createChecklistTemplate('SurveyTemplate');
    }

    @isTest
    static void createVisitTaskTemplatePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        Test.stopTest();
        if(taskTemplate != null) {
            System.assertNotEquals(taskTemplate, null, 'Expected Visit Task Template to be created.');
        }
        System.assertEquals(10, taskTemplate.dmpl__Duration__c, 'Expected Duration to be 10.'); 
    }
    
    @isTest
    static void createVisitTaskTemplateEntryPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        Test.stopTest();
        if(entry != null) {
            System.assertNotEquals(entry, null, 'Expected Visit Task Template Entry to be created.');
        }
        System.assertEquals(1, entry.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');          
    }
    
    @isTest
    static void createVisitTaskTemplateActivityPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        Test.stopTest();
        if(taskTempActivity != null) {
            System.assertNotEquals(taskTempActivity, null, 'Expected Visit Task Template Activity to be created.');
        }
        System.assertEquals(false, taskTempActivity.dmpl__PerformAutomatically__c, 'Expected PerformAutomatically field to be false.');
        System.assertEquals(1, taskTempActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.'); 
    }

    @isTest
    static void updateVisitTaskTemplatePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        System.assertNotEquals(taskTemplate, null, 'Visit Task Template should exist before update.');
        taskTemplate.dmpl__Duration__c = 20; 
        update taskTemplate;
        Test.stopTest();
        dmpl__VisitTaskTemplate__c updatedTaskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        System.assertEquals(20, updatedTaskTemplate.dmpl__Duration__c, 'Expected Duration to be updated to 20.');
    }
    
    @isTest
    static void updateVisitTaskTemplateEntryPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        System.assertNotEquals(entry, null, 'Visit Task Template Entry should exist before update.');
        entry.dmpl__SequenceNumber__c = 2;
        update entry;    
        Test.stopTest();
        dmpl__VisitTaskTemplateEntry__c updatedEntry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        System.assertEquals(2, updatedEntry.dmpl__SequenceNumber__c, 'Expected Sequence Number to be updated to 2.');
    }
    
    @isTest
    static void updateVisitTaskTemplateActivityPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        System.assertNotEquals(taskTempActivity, null, 'Visit Task Template Activity should exist before update.');
        taskTempActivity.dmpl__PerformAutomatically__c = true;
        taskTempActivity.dmpl__SequenceNumber__c = 4;
        update taskTempActivity;
        Test.stopTest();
        dmpl__VisitTaskTemplateActivity__c updatedTaskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        System.assertEquals(true, updatedTaskTempActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be true.');
        System.assertEquals(4, updatedTaskTempActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be updated to 4.');
    }
    
    @isTest
    static void deleteVisitTaskTemplatePositive() {
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        System.assertNotEquals(taskTemplate, null, 'Task Template should exist before delete.');
        Test.startTest();
        delete taskTemplate;
        Test.stopTest();
        dmpl__VisitTaskTemplate__c deletedTaskTemplate = null;
        try {
            deletedTaskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedTaskTemplate);
        } catch (Exception e) {
            deletedTaskTemplate = null;
        }
        System.assertEquals(null, deletedTaskTemplate, 'Task Template should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitTaskTemplateEntryPositive() {
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        System.assertNotEquals(entry, null, 'Visit Task Template Entry should exist before delete.');
        Test.startTest();
        delete entry;
        Test.stopTest();
        dmpl__VisitTaskTemplateEntry__c deletedEntry = null;
        try {
            deletedEntry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedEntry);
        } catch (Exception e) {
            deletedEntry = null;
        }
        System.assertEquals(null, deletedEntry, 'Visit Task Template Entry should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitTaskTemplateActivityPositive() {
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        System.assertNotEquals(taskTempActivity, null, 'Task Temp Activity should exist before delete.');
        Test.startTest();
        delete taskTempActivity;
        Test.stopTest();
        dmpl__VisitTaskTemplateActivity__c deletedTaskTempActivity = null;
        try {
            deletedTaskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedTaskTempActivity);
        } catch (Exception e) {
            deletedTaskTempActivity = null;
        }
        System.assertEquals(null, deletedTaskTempActivity, 'Task Temp Activity should be deleted and not found in query.');
    }

    @isTest
    static void createVisitTaskTemplateAutoEntryPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c template = VisitPlanTestDataHelpers.createVisitTaskTemplate('Task Template', 10);
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(template, template.Name);
        System.assertEquals('Task Template', entry.Name, 'Entry Name should match template Name');
        System.assertEquals('Perform Visit Activities', entry.dmpl__TaskType__c, 'Task Type should match');
        System.assertEquals(template.Id, entry.dmpl__VisitTaskTemplateId__c, 'Entry should be linked to correct template');
        Test.stopTest();
    }

    @isTest
    static void createVisitTaskTemplateEntryWithValidEntryNameSeqNoTaskTypePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c template = VisitPlanTestDataHelpers.createVisitTaskTemplate('Capturing the Order', 10);
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(template, 'Order Capturing');
        Test.stopTest();
        System.assertNotEquals(null, entry, 'Visit Task Template Entry should be created');
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals('Perform Visit Activities', entry.dmpl__TaskType__c, 'Task Type should be Perform Visit Activities');
        System.assertEquals(1, entry.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals(template.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
    }

    @isTest
    static void createVisitTaskTemplateEntryWithSequenceEditablePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c template = VisitPlanTestDataHelpers.createVisitTaskTemplate('Capturing the Order', 10);
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(template, 'Order Capturing');
        entry.dmpl__SequenceNumber__c = 5;
        update entry;
        Test.stopTest();
        System.assertNotEquals(null, entry, 'Visit Task Template Entry should be created');
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals('Perform Visit Activities', entry.dmpl__TaskType__c, 'Task Type should be Perform Visit Activities');
        System.assertEquals(5, entry.dmpl__SequenceNumber__c, 'Sequence Number should be updated to 5');
        System.assertEquals(template.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
    }

    @isTest
    static void createVisitTaskWithValidDetailsPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.createVisitTask(visit, entry);
        Test.stopTest();
        System.assertNotEquals(null, task, 'Visit Task should be created');
        System.assertEquals('VisitTask1', task.dmpl__TaskName__c, 'Task Name should be VisitTask1');
        System.assertEquals('Perform Visit Activities', task.dmpl__TaskType__c, 'Task Type should be Perform Visit Activities');
        System.assertEquals(1, task.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('Planned', task.dmpl__Status__c, 'Status should be Planned');
        System.assertEquals(visit.Id, task.dmpl__VisitId__c, 'Visit ID should match');
        System.assertEquals(entry.Id, task.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
    }

    @isTest
    static void createVisitTaskWithVisitNameAutoPopulatedPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.createVisitTask(visit, entry);
        Test.stopTest();
        System.assertNotEquals(null, task, 'Visit Task should be created');
        System.assertEquals('VisitTask1', task.dmpl__TaskName__c, 'Task Name should be VisitTask1');
        System.assertEquals(visit.Id, task.dmpl__VisitId__c, 'Visit should be auto-populated correctly');
    }
    
    @isTest
    static void createVisitTaskTemplateWithValidNameAndDurationPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        Test.stopTest();
        System.assertEquals('Capturing the Order', taskTemplate.Name, 'Template Name should match');
    }

    @isTest
    static void createAutoPopulatedVisitTaskTemplateEntryPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        Test.stopTest();
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals(taskTemplate.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
    }

    @isTest
    static void createVisitTaskTemplateEntryWithValidDataPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        Test.stopTest();
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals('Perform Visit Activities', entry.dmpl__TaskType__c, 'Task Type should be Perform Visit Activities');
        System.assertEquals(1, entry.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals(taskTemplate.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
    }

    @isTest
    static void createVisitTaskTemplateEntryWithIsMandatoryTruePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        Test.stopTest();
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals(taskTemplate.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
        System.assertEquals(true, entry.dmpl__IsMandatory__c, 'Is Mandatory should be true');
    }

    @isTest
    static void createVisitTaskTemplateEntryIfNoVisitTaskTemplateSelectedNegative() {
        Test.startTest();
        try{
            dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(null,'Order Capturing');
            System.assert(false, 'Expected an exception to be thrown when no Visit Task Template is selected');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Attempt to de-reference a null object'), 
            'Expected exception for missing Visit Task Template but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void editVisitTaskTemplateEntrySequencePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        entry.dmpl__SequenceNumber__c = 2;
        update entry;
        Test.stopTest();
        System.assertEquals('Order Capturing', entry.Name, 'Entry Name should be Order Capturing');
        System.assertEquals('Perform Visit Activities', entry.dmpl__TaskType__c, 'Task Type should be Perform Visit Activities');
        System.assertEquals(2, entry.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals(taskTemplate.Id, entry.dmpl__VisitTaskTemplateId__c, 'Template ID should match');
    }

    @isTest
    static void createAutoPopulatedVisitTaskTemplateActivityPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        Test.stopTest();
        System.assertEquals('Take Order', taskTempActivity.Name, 'Activity Name should be Take Order');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithValidDataPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        Test.stopTest();
        System.assertEquals('Take Order', taskTempActivity.Name, 'Activity Name should be Take Order');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
        System.assertEquals(1, taskTempActivity.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals(5, taskTempActivity.dmpl__Duration__c, 'Duration should be 5');
        System.assertEquals('Create Object', taskTempActivity.dmpl__ActivityType__c, 'Activity Type should be Create Object');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithObjectNamePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        Test.stopTest();
        System.assertEquals('Take Order', taskTempActivity.Name, 'Activity Name should be Take Order');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
        System.assertEquals('Create Object', taskTempActivity.dmpl__ActivityType__c, 'Activity Type should be Create Object');
        System.assertEquals('dmpl__SaleOrder__c', taskTempActivity.dmpl__ObjectName__c, 'Object Name should be SaleOrder');
        System.assertEquals('dmpl__SaleOrder__c', taskTempActivity.dmpl__ObjectApiName__c, 'Object API Name should be dmpl__SaleOrder__c');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithValidActivityTypeNegative() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        try {
            dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity('Survey',entry);
            taskTempActivity.dmpl__ActivityType__c = 'Checklist';
            update taskTempActivity;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Invalid Activity Type'), 
            'Expected exception for invalid activity type but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void editVisitTaskTemplateActivitySequencePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        taskTempActivity.dmpl__SequenceNumber__c = 2;
        update taskTempActivity;
        Test.stopTest();
        System.assertEquals('Take Order', taskTempActivity.Name, 'Activity Name should be Take Order');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
        System.assertEquals(2, taskTempActivity.dmpl__SequenceNumber__c, 'Sequence Number should be updated to 2');
        System.assertEquals('Create Object', taskTempActivity.dmpl__ActivityType__c, 'Activity Type should be Create Object');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithIsMandatoryTruePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        Test.stopTest();
        System.assertEquals('Take Order', taskTempActivity.Name, 'Activity Name should be Take Order');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
        System.assertEquals(true, taskTempActivity.dmpl__IsMandatory__c, 'Is Mandatory should be true');
    }
    
    @isTest
    static void tagChecklistTemplateNameInVisitTaskTemplateActivityPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__ChecklistTemplate__c checkListTemplate = ChecklistDataHelper.getChecklistTemplateByName('SurveyTemplate');
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity('Survey',entry);
        taskTempActivity.dmpl__ActivityType__c = 'Checklist';
        taskTempActivity.dmpl__ChecklistTemplateId__c = checkListTemplate.Id;
        update taskTempActivity;
        System.assertEquals('Survey', taskTempActivity.Name, 'Activity Name should be Survey');
        System.assertEquals(entry.Id, taskTempActivity.dmpl__VisitTaskTemplateEntryId__c, 'Entry ID should match');
        System.assertEquals('Checklist', taskTempActivity.dmpl__ActivityType__c, 'Activity Type should be Checklist');
        System.assertEquals(checkListTemplate.Id,taskTempActivity.dmpl__ChecklistTemplateId__c,'Checklist Template name should match');
    }
}