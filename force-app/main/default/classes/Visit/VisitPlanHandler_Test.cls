@isTest
private class VisitPlanHandler_Test {
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
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop('Visit Route Stop 1',customerAccount1,route);
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Capturing the Order');
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.CreateVisitPlan(
            'Visit Plan 1',
            partnerAccount1,
            route,
            taskTemplate
        );
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate,'Order Capturing');
        dmpl__Visit__c visits = VisitPlanTestDataHelpers.CreateVisit(customerAccount1,plans,taskTemplate);
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity('Order Capturing',entry);
    }

    @isTest
    static void createVisitPlanPositive() {
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.getVisitPlan();
        if (plans != null) {
            System.assertNotEquals(plans, null, 'Expected Visit Plan to be created.');
        }
        System.assertEquals('Draft', plans.dmpl__Status__c, 'Expected Status to be Task.');
        System.assertEquals('Order Capture', plans.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void createVisitPositive() {
        dmpl__Visit__c visits = VisitPlanTestDataHelpers.getVisit();
        if (visits != null) {
            System.assertNotEquals(visits, null, 'Expected Visit to be created.');
        }
        System.assertEquals(1, visits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 1.');
        System.assertEquals(15,visits.dmpl__GeofencingTolerance__c, 'GeofencingTolerance__c should match');
    }
    
    @isTest
    static void createVisitTaskPositive() {
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        if (task != null) {
            System.assertNotEquals(task, null, 'Expected Visit Task to be created.');
        }
        System.assertEquals(1, task.dmpl__SequenceNumber__c, 'Expected Sequence no. to be .');
    }
    
    @isTest
    static void createVisitTaskActivityPositive() {
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.getVisitTaskActivity();
        if (taskActivity != null) {
            System.assertNotEquals(taskActivity, null, 'Expected Visit Task Activity to be created.');
        }
        System.assertEquals(1, taskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. here also to be 1.');
        System.assertEquals(true, taskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be false.');
        System.assertEquals('http://www.example.com', taskActivity.dmpl__URL__c, 'URL mismatch');
    }
    
    @isTest
    static void updateVisitPlanPositive() {
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.getVisitPlan();
        System.assertNotEquals(plans, null, 'Visit Plan should exist before update.');
        plans.dmpl__Status__c = 'Completed';
        plans.dmpl__VisitPurpose__c = 'Order Delivery';
        update plans;
        dmpl__VisitPlan__c updatedPlans = VisitPlanTestDataHelpers.getVisitPlan();
        System.assertEquals( 'Completed',updatedPlans.dmpl__Status__c, 'Expected Status to be Completed.');  
        System.assertEquals( 'Order Delivery',updatedPlans.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Delivery.');
    }
    
    @isTest
    static void updateVisitPositive() {
        dmpl__Visit__c visits = VisitPlanTestDataHelpers.getVisit();
        System.assertNotEquals(visits, null, 'Visit should exist before update.');
        visits.dmpl__SequenceNumber__c = 2;
        visits.dmpl__VisitStatus__c = 'Assigned';
        update visits;
        System.assertEquals(2, visits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 2.');
        System.assertEquals('Assigned', visits.dmpl__VisitStatus__c, 'Expected Visit Status to be Assigned.');
    }
    
    @isTest
    static void updateVisitTaskPositive() {
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        System.assertNotEquals(task, null, 'Visit Task should exist before update.');
        task.dmpl__SequenceNumber__c = 6;
        task.dmpl__Status__c = 'Started';
        update task;    
        dmpl__VisitTask__c updatedTask = VisitPlanTestDataHelpers.getVisitTask();
        System.assertEquals(6, updatedTask.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 6.');
        System.assertEquals('Started', updatedTask.dmpl__Status__c, 'Expected Status to be Started.');
    }
    
    @isTest
    static void updateVisitTaskActivityPositive() {
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertNotEquals(taskActivity, null, 'Visit Task Activity should exist before update.');
        taskActivity.dmpl__SequenceNumber__c = 11;
        taskActivity.dmpl__PerformAutomatically__c = true;
        update taskActivity;
        dmpl__VisitTaskActivity__c updatedTaskActivity = VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertEquals(11, updatedTaskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 11.');
        System.assertEquals(true, updatedTaskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be true.');
    }
    
    @isTest
    static void deleteVisitPlanPositive() {
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.getVisitPlan();
        System.assertNotEquals(plans, null, 'Visit Plan should exist before delete.');
        Id planId = plans.Id;
        Test.startTest();
        delete plans;
        Test.stopTest();
        dmpl__VisitPlan__c deletedPlans = null;
        try {
            deletedPlans = VisitPlanTestDataHelpers.getVisitPlan(planId);
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedPlans);
        } catch (Exception e) {
            deletedPlans = null;
        }
        System.assertEquals(null, deletedPlans, 'Visit Plan Activity should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitPositive() {
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visits = VisitPlanTestDataHelpers.getVisit();
        System.assertNotEquals(visits, null, 'Visit should exist before delete.');
        Test.startTest();
        delete plans;
        Test.stopTest();
        dmpl__Visit__c deletedVisits = null;
        try {
            deletedVisits = VisitPlanTestDataHelpers.getVisit();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedVisits);
        } catch (Exception e) {
            deletedVisits = null;
        }
        System.assertEquals(null, deletedVisits, 'Visit should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitTaskPositive() {
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        System.assertNotEquals(task, null, 'Task should exist before delete.');
        Test.startTest();
        delete task;
        Test.stopTest();
        dmpl__VisitTask__c deletedVisitTask = null;
        try {
            deletedVisitTask = VisitPlanTestDataHelpers.getVisitTask();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedVisitTask);
        } catch (Exception e) {
            deletedVisitTask = null;
        }
        System.assertEquals(null, deletedVisitTask, 'Visit should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitTaskActivityPositive() {
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertNotEquals(taskActivity, null, 'Task Activity should exist before delete.');
        Test.startTest();
        delete taskActivity;
        Test.stopTest();
        dmpl__VisitTaskActivity__c deletedTaskActivity = null;
        try {
            deletedTaskActivity = VisitPlanTestDataHelpers.getVisitTaskActivity();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedTaskActivity);
        } catch (Exception e) {
            deletedTaskActivity = null;
        }
        System.assertEquals(null, deletedTaskActivity, 'Task Activity should be deleted and not found in query.');
    } 

    @isTest
    static void VisitCreationWithValidPartnerAccountBranch(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        System.assertNotEquals(null, visit, 'Visit should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitCreationWithInactivePartnerAccount(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2',partnerAccount.Id);
        test.startTest();
        try{
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, null);
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void VisitCreationWithInactiveBranch(){
         Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        dmpl__VisitPlan__c visitPlan2 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        try{
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan2.Id);
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void VisitCreationWithMissingVisitPlan(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        test.startTest();
        try{
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, null);
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        Test.stopTest();
    }

    @isTest
    static void VisitCreationWithVisitTaskTemplate(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        System.assertNotEquals(null, visit, 'Visit should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitWithValidAccountTagAndVisitPurpose(){
       Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        System.assertNotEquals(null, visit, 'Visit should be created successfully.');
        test.stopTest();  
    }

     @isTest
    static void VisitCreationWithVisitRouteAndVisitRouteStop(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        System.assertNotEquals(null, visit, 'Visit should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitWithPlannedDateAndPlannedEndTime(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        System.assertNotEquals(null, visit, 'Visit should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitWithWithoutBranchAccount(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        try{
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, null, visitPlan1.Id);
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void VisitCreationWithoutVisitTaskTemplate(){

        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        test.startTest();
        try{
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, null);
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void VisitTaskCreationWithTaskTypeAndStatusPlanned(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        test.startTest();
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            null,
            'Perform Visit Activities',
            'Planned'
        );
        System.assertNotEquals(null, visitTask, 'Visit Task should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskCreationWithoutVisit(){
        test.startTest();
        try{
            dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(
                null,
                null,
                null,
                'Perform Visit Activities',
                'Planned'
            );
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void VistTaskCreationWithReferenceVistTaskTemplateEntry(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            null,
            'Perform Visit Activities',
            'Planned'
        );
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(visitTaskTemplate);
        test.startTest();
        dmpl__VisitTask__c visitTaskWithEntry = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            visitTaskTemplateEntry.Id,
            'Perform Visit Activities',
            'Planned'
        );
        System.assertNotEquals(null, visitTaskWithEntry, 'Visit Task with Template Entry should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskCreationWithVisitReference(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            null,
            'Perform Visit Activities',
            'Planned'
        );
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(visitTaskTemplate);
        test.startTest();
        dmpl__VisitTask__c visitTaskWithEntry = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            visitTaskTemplateEntry.Id,
            null,
            null
        );
        System.assertNotEquals(null, visitTaskWithEntry, 'Visit Task with Template Entry should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskActivityCreationWithOutVisitTask(){
        test.startTest();
        try {
            dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity(
                'Activity Name 1',
                null,
                null,
                null
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
    }

    @isTest
    static void VisitTaskActivityCreationWithVisitTask(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(visitTaskTemplate);
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(
            null,
            visit.Id,
            visitTaskTemplateEntry.Id,
            'Perform Visit Activities',
            'Planned'
        );
        test.startTest();
        dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity(
            'Activity Name 1',
            visitTask.Id,
            null,
            null
        );
        System.assertNotEquals(null, visitTaskActivity, 'Visit Task with Template Entry should be created successfully.');

    }

    @isTest
    static void ActivityWithOnlyPlannedStartTimeAndEndTime(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        test.startTest();
        try {
            dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity(
                'Activity Name 1',
                visit.Id,
                Time.newInstance(1, 0, 0, 0),
                Time.newInstance(0, 15, 0, 0)
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
    }

    @isTest
    static void VisitTaskTemplateCreationWithTemplateNameAndDuration(){
        test.startTest();
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate('Order Capture',30);
        System.assertNotEquals(null, visitTaskTemplate, 'Visit Task Template should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void TemplateCreationWithoutTemplateName(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate(null, 30);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void CreationWithValidEntryNameAndVisitTaskTemplate(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate(null, 30);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void CreationWithoutEntryName(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(null, 'Order Capturing',null);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest 
    static void CreationWithoutVisitTaskTemplate(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry('Order Capturing', null,null);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void CreationWithTaskTypePerformVisitActivities (){
        test.startTest();
        try {
            dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate(null, 30);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void CreationWithEntryNameAndValidVisitTaskTemplateEntry(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate(null, 30);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }
    
    @isTest
    static void CreationWithoutVisitTaskTemplateEntry(){
        test.startTest();
        try {
            dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry('Order Capturing', 'Order Capturing', null);
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Resource Skill.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }
    
    @isTest
    static void createVisitTaskWithValidDataPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.createVisitTask(visit, entry);
        Test.stopTest();
        System.AssertEquals(visit.Id, task.dmpl__VisitId__c, 'Expected Visit ID to match.');
        System.AssertEquals('Planned', task.dmpl__Status__c, 'Expected Status to be Planned.');
        System.AssertEquals('Perform Visit Activities', task.dmpl__TaskType__c, 'Expected Task Type to be Perform Visit Activities.');
        System.AssertEquals(1, task.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }
    
    @isTest
    static void createVisitTaskWithoutVisitNegative() {
        Test.startTest();
        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        try {
            dmpl__VisitTask__c task = VisitPlanTestDataHelpers.createVisitTask(null, entry);
            System.Assert(false, 'Expected exception when creating Visit Task without Visit.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Attempt to de-reference a null object'), 
                'Expected exception message not found but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void visitNamePopulatedWhenVisitTaskCreatedPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        Test.stopTest();
        System.AssertEquals(visit.Id, task.dmpl__VisitId__c, 'Expected Visit ID to match.');
    }
    
    @isTest
    static void createVisitTaskActivityWithValidDataPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        taskActivity.dmpl__VisitId__c = visit.id;
        update taskActivity;
        Test.stopTest();
        System.AssertEquals(task.Id, taskActivity.dmpl__VisitTaskId__c, 'Expected Visit Task ID to match.');
        System.AssertEquals(visit.id, taskActivity.dmpl__VisitId__c, 'Expected Visit ID to match.');
        System.AssertEquals('Create Object', taskActivity.dmpl__ActivityType__c, 'Expected Activity Type to be Create Object.');
        System.AssertEquals(1, taskActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }
    
    @isTest
    static void visitTaskActivityAutoPopulatedPositive() {
        Test.startTest();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        taskActivity.dmpl__VisitId__c = visit.id;
        update taskActivity;
        Test.stopTest();
        System.AssertEquals(task.Id, taskActivity.dmpl__VisitTaskId__c, 'Expected Visit Task ID to match.');
        System.AssertEquals(visit.id, taskActivity.dmpl__VisitId__c, 'Expected Visit ID to match.');
    }
    
    @isTest
    static void visitTaskTemplateAutoPopulatedInVisitTaskActivityPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        taskActivity.dmpl__VisitId__c = visit.id;
        taskActivity.dmpl__VisitTaskTemplateActivityId__c = taskTempActivity.Id;
        update taskActivity;
        Test.stopTest();
        System.AssertEquals(taskTempActivity.Id, taskActivity.dmpl__VisitTaskTemplateActivityId__c, 'Expected Visit Task Template Activity ID to match.');
        System.AssertEquals(task.Id, taskActivity.dmpl__VisitTaskId__c, 'Expected Visit Task ID to match.');
        System.AssertEquals(visit.id, taskActivity.dmpl__VisitId__c, 'Expected Visit ID to match.');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithValidActivityTypeNegative() {
        Test.startTest();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        taskActivity.dmpl__VisitId__c = visit.id;
        taskActivity.dmpl__VisitTaskTemplateActivityId__c = taskTempActivity.Id;
        update taskActivity;
        Test.stopTest();
        System.AssertEquals(taskTempActivity.Id, taskActivity.dmpl__VisitTaskTemplateActivityId__c, 'Expected Visit Task Template Activity ID to match.');
        System.AssertEquals(task.Id, taskActivity.dmpl__VisitTaskId__c, 'Expected Visit Task ID to match.');
        System.AssertEquals(visit.id, taskActivity.dmpl__VisitId__c, 'Expected Visit ID to match.');
        System.AssertEquals('Create Object', taskTempActivity.dmpl__ActivityType__c, 'Expected Activity Type to be Checklist.');
    }
    
    @isTest
    static void createVisitTaskTemplateActivityWithSequenceNumberPositive() {
        Test.startTest();
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        dmpl__VisitTask__c task = VisitPlanTestDataHelpers.getVisitTask();
        dmpl__VisitTaskActivity__c taskActivity = VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        taskActivity.dmpl__VisitId__c = visit.id;
        taskActivity.dmpl__VisitTaskTemplateActivityId__c = taskTempActivity.Id;
        update taskActivity;
        Test.stopTest();
        System.AssertEquals(taskTempActivity.Id, taskActivity.dmpl__VisitTaskTemplateActivityId__c, 'Expected Visit Task Template Activity ID to match.');
        System.AssertEquals(task.Id, taskActivity.dmpl__VisitTaskId__c, 'Expected Visit Task ID to match.');
        System.AssertEquals(visit.id, taskActivity.dmpl__VisitId__c, 'Expected Visit ID to match.');
        System.AssertEquals('Create Object', taskTempActivity.dmpl__ActivityType__c, 'Expected Activity Type to be Checklist.');
        System.AssertEquals(1, taskTempActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }
    
    @isTest
    static void createVisitPlanWithValidDataPositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void tagVisitPlanWithValidVisitTaskTemplatePositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(
            'Visit Route 1',
            accountGroup1,
            partnerAccount1,
            resource
        );
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Order Capturing');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.CreateVisitPlan(
            'Visit Plan 1',
            partnerAccount1,
            route,
            taskTemplate
        );
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(taskTemplate.Id, visitPlan.dmpl__VisitTaskTemplateId__c, 'Expected Visit Task Template ID to match.');
    }
    
    @isTest
    static void createVisitPlanWithoutVisitPurposeNegative() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        visitPlan.dmpl__VisitPurpose__c = null;
        try {
            update visitPlan;
            System.Assert(false, 'Expected exception when updating Visit Plan without Visit Purpose.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Required fields are missing'), 
                'Expected exception message not found but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createVisitPlanWithActiveResourcePositive() {
        Test.startTest();
        dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        visitPlan.dmpl__AssignedResourceId__c = resource.Id;
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(resource.Id, visitPlan.dmpl__AssignedResourceId__c, 'Expected Resource ID to match.');
    }
    
    @isTest
    static void createVisitPlanWithValidVisitPurposePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void tagVisitPlanWithValidVisitRoutePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(route.Id, visitPlan.dmpl__VisitRouteId__c, 'Expected Visit Route ID to match.');
    }
    
    @isTest
    static void createVisitPlanWithValidStartAndEndDatePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        visitPlan.dmpl__PlanStartDate__c = Date.newInstance(2025, 10, 24);
        visitPlan.dmpl__PlanEndDate__c = Date.newInstance(2025, 11, 30);
        update visitPlan;
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(Date.newInstance(2025, 10, 24), visitPlan.dmpl__PlanStartDate__c, 'Expected Start Date to match.');
        System.AssertEquals(Date.newInstance(2025, 11, 30), visitPlan.dmpl__PlanEndDate__c, 'Expected End Date to match.');
    }
    
    @isTest
    static void tagVisitPlanWithActivePartnerAccountPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(partnerAccount1.Id, visitPlan.dmpl__PartnerAccountId__c, 'Expected Partner Account ID to match.');
    }
    
    @isTest
    static void tagVisitPlanWithActiveBranchPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        visitPlan.dmpl__BranchId__c = branch.Id;
        update visitPlan;
        Test.stopTest();
        System.AssertEquals('Visit Plan 1', visitPlan.Name, 'Expected Name to be Visit Plan 1.');
        System.AssertEquals('Draft', visitPlan.dmpl__Status__c, 'Expected Status to be Draft.');
        System.AssertEquals('Order Capture', visitPlan.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
        System.AssertEquals(branch.Id, visitPlan.dmpl__BranchId__c, 'Expected Branch ID to match.');
    }
    
    @isTest
    static void createVisitWithValidVisitPlanPositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
    }
    
    @isTest
    static void createVisitWithoutVisitPlanNegative() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        try {
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.CreateVisit(customerAccount1,null,taskTemplate);
            System.Assert(false, 'Expected exception when creating Visit without Visit Plan.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Attempt to de-reference a null object'), 
                'Expected exception message not found but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void tagVisitWithActivePartnerAccountPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__PartnerAccountId__c = partnerAccount1.Id;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(partnerAccount1.Id, visit.dmpl__PartnerAccountId__c, 'Expected Partner Account ID to match.');
    }
    
    @isTest
    static void createVisitWithoutVisitTaskTemplateNegative() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        try {
            dmpl__Visit__c visit = VisitPlanTestDataHelpers.CreateVisit(customerAccount1,visitPlan,null);
            System.Assert(false, 'Expected exception when creating Visit without Visit Plan.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Attempt to de-reference a null object'), 
                'Expected exception message not found but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void tagVisitWithActiveBranchPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__BranchId__c = branch.Id;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(branch.Id, visit.dmpl__BranchId__c, 'Expected Branch ID to match.');
    }
    
    @isTest
    static void createVisitWithValidVisitTaskTemplatePositive() {
        Test.startTest();
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitTaskTemplateId__c = visitTaskTemplate.Id;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(visitTaskTemplate.Id, visit.dmpl__VisitTaskTemplateId__c, 'Expected Visit Task Template ID to match.');
    }
    
    @isTest
    static void createVisitWithValidVisitPurposePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals('Order Capture', visit.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void createVisitWithoutVisitPurposePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitPurpose__c = null;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
    }
    
    @isTest
    static void tagVisitWithValidVisitRoutePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitRouteId__c = route.Id;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(route.Id, visit.dmpl__VisitRouteId__c, 'Expected Visit Route ID to match.');
    }
    
    @isTest
    static void tagVisitWithoutVisitRoutePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitRouteId__c = null;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
    }
    
    @isTest
    static void createVisitWithPlannedStatusPositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals('Planned', visit.dmpl__VisitStatus__c, 'Expected Visit Status to be Planned.');
    }
    
    @isTest
    static void tagVisitWithValidVisitRouteStopPositive() {
        Test.startTest();
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitRouteStopId__c = routeStop.Id;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(routeStop.Id, visit.dmpl__VisitRouteStopId__c, 'Expected Visit Route Stop ID to match.');
    }
    
    @isTest
    static void tagVisitWithoutVisitRouteStopPositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__VisitRouteStopId__c = null;
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(null, visit.dmpl__VisitRouteStopId__c, 'Expected Visit Route Stop ID to match.');
    }
    
    @isTest
    static void createVisitWithValidPlannedDateAndTimePositive() {
        Test.startTest();
        dmpl__VisitPlan__c visitPlan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        visit.dmpl__PlannedStartTime__c = Time.newInstance(12, 0, 0, 0);
        visit.dmpl__PlannedDate__c = Date.newInstance(2025, 7, 9);
        update visit;
        Test.stopTest();
        System.AssertEquals(visitPlan.Id, visit.dmpl__VisitPlanId__c, 'Expected Visit plan ID to match.');
        System.AssertEquals(Time.newInstance(12, 0, 0, 0), visit.dmpl__PlannedStartTime__c, 'Expected Planned Start Time to match.');
        System.AssertEquals(Date.newInstance(2025, 7, 9), visit.dmpl__PlannedDate__c, 'Expected Planned End Time to match.');
    }
}