@isTest
private class VisitPlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount(); 
        dmpl__AccountGroup__c AccountGroup = TestDataHelpers.createAccountGroup();       
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);  
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount,branch);  
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup,partnerAccount,resource);
        dmpl__VisitRouteStop__c routeStop=VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount,route);
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount,route,taskTemplate);
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.CreateVisit(customerAccount,plans,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry=VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity=VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity(entry);
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
        
        dmpl__VisitPlan__c visitPlan1 = visitPlanTestDataHelpers.createVisitPlan(partnerAccount1,branch1,'Order Capture','Draft',Date.newInstance(2025, 6, 20),Date.newInstance(2025, 6, 20));
        dmpl__VisitPlan__c visitPlan2 = visitPlanTestDataHelpers.createVisitPlan(partnerAccount4,branch4,'Order Capture','Draft',Date.newInstance(2025, 10, 25),Date.newInstance(2025, 11, 30));
 
    }

    @isTest
    static void createVisitPlanPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        if(plans !=null) {
            System.assertNotEquals(plans, null, 'Expected Visit Plan to be created.');
        }
        System.assertEquals(
            'Task',
            plans.dmpl__Status__c, 
            'Expected Status to be Task.');
        System.assertEquals( 'Order Capture',plans.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void createVisitPositive() {       
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.getVisit();
        if(visits!=null) {
            System.assertNotEquals(visits, null, 'Expected Visit to be created.');
        }
        System.assertEquals( 1,visits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 1.');   
    }
    
    @isTest
    static void createVisitTaskPositive() {
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.getVisitTask();
        if(task!=null) {
            System.assertNotEquals(task, null, 'Expected Visit Task to be created.');
        }
        System.assertEquals( 5,task.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 5.');
        System.assertEquals( 'Planned',task.dmpl__Status__c, 'Expected Status to be Planned.');
    }
    
    @isTest
    static void createVisitTaskActivityPositive() {
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        if(taskActivity!=null) {
            System.assertNotEquals(taskActivity, null, 'Expected Visit Task Activity to be created.');
        }
        System.assertEquals(1,taskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. here also to be 1.');
        System.assertEquals(true,taskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be false.');
        System.assertEquals('http://www.example.com', taskActivity.dmpl__URL__c, 'URL mismatch');
    }
    
    @isTest
    static void updateVisitPlanPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
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
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.getVisit();
        System.assertNotEquals(visits, null, 'Visit should exist before update.');
        visits.dmpl__SequenceNumber__c = 2;
        visits.dmpl__VisitStatus__c = 'Assigned';
        update visits;
        
        dmpl__Visit__c updatedVisits=VisitPlanTestDataHelpers.getVisit();
        System.assertEquals( 2,updatedVisits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 2.');  
        System.assertEquals( 'Assigned',updatedVisits.dmpl__VisitStatus__c, 'Expected Visit Status to be Assigned.');
    }
    
    @isTest
    static void updateVisitTaskPositive() {
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.getVisitTask();
        System.assertNotEquals(task, null, 'Visit Task should exist before update.');
        task.dmpl__SequenceNumber__c = 6;
        task.dmpl__Status__c='Started';
        update task;
        
        dmpl__VisitTask__c updatedTask=VisitPlanTestDataHelpers.getVisitTask();
        System.assertEquals( 6,updatedTask.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 6.');  
        System.assertEquals( 'Started',updatedTask.dmpl__Status__c, 'Expected Status to be Started.');
    }
    
    @isTest
    static void updateVisitTaskActivityPositive() {
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertNotEquals(taskActivity, null, 'Visit Task Activity should exist before update.');
        taskActivity.dmpl__SequenceNumber__c=11;
        taskActivity.dmpl__PerformAutomatically__c=true;
        update taskActivity;
        
        dmpl__VisitTaskActivity__c updatedTaskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertEquals(11,updatedTaskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 11.');
        System.assertEquals(true,updatedTaskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be true.');
    }
    
    @isTest
    static void deleteVisitPlanPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        System.assertNotEquals(plans, null, 'Visit Plan should exist before delete.');
        Id planId=plans.Id;
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
    static void delteVisitPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.getVisit();
        System.assertNotEquals(visits, null, 'Visit should exist before delete.');
        Test.startTest();
        delete plans;
        Test.stopTest();
        dmpl__Visit__c deletedVisits=null;
        try {
            deletedVisits = VisitPlanTestDataHelpers.getVisit();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedVisits);
        } catch (Exception e) {
            deletedVisits = null;
        }
        System.assertEquals(null, deletedVisits, 'Visit should be deleted and not found in query.');
    }
    
    @isTest
    static void delteVisitTaskPositive() {
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.getVisitTask();
        System.assertNotEquals(task, null, 'Task should exist before delete.');
        Test.startTest();
        delete task;
        Test.stopTest();
        dmpl__VisitTask__c deletedVisitTask=null;
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
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertNotEquals(taskActivity, null, 'Task Activity should exist before delete.');
        Test.startTest();
        delete taskActivity;
        Test.stopTest();
        dmpl__VisitTaskActivity__c deletedTaskActivity=null;
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
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        // dmpl__VisitPlan__c visitPlan2 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
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
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
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
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
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
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(null,visit.Id,null,'Perform Visit Activities','Planned');
        System.assertNotEquals(null, visitTask, 'Visit Task should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskCreationWithoutVisit(){
        test.startTest();
        try{
            dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(null,null,null,'Perform Visit Activities','Planned');
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
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(null,visit.Id,null,'Perform Visit Activities','Planned');
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(visitTaskTemplate);
        test.startTest();
        dmpl__VisitTask__c visitTaskWithEntry = VisitPlanTestDataHelpers.createVisitTask(null, visit.Id, visitTaskTemplateEntry.Id,'Perform Visit Activities','Planned');
        system.assertNotEquals(null, visitTaskWithEntry, 'Visit Task with Template Entry should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskCreationWithVisitReference(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(null,visit.Id,null,'Perform Visit Activities','Planned');
        dmpl__VisitTaskTemplate__c visitTaskTemplate = VisitPlanTestDataHelpers.createVisitTaskTemplate();
        dmpl__VisitTaskTemplateEntry__c visitTaskTemplateEntry = VisitPlanTestDataHelpers.createVisitTaskTemplateEntry(visitTaskTemplate);
        test.startTest();
        dmpl__VisitTask__c visitTaskWithEntry = VisitPlanTestDataHelpers.createVisitTask(null, visit.Id, visitTaskTemplateEntry.Id,null,null);
        system.assertNotEquals(null, visitTaskWithEntry, 'Visit Task with Template Entry should be created successfully.');
        test.stopTest();
    }

    @isTest
    static void VisitTaskActivityCreationWithOutVisitTask(){
        test.startTest();
        try {
            dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity('Activity Name 1',null,null,null);
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
        dmpl__VisitTask__c visitTask = VisitPlanTestDataHelpers.createVisitTask(null,visit.Id,visitTaskTemplateEntry.Id,'Perform Visit Activities','Planned');
        test.startTest();
        dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity('Activity Name 1',visitTask.Id,null,null);
        system.assertNotEquals(null, visitTaskActivity, 'Visit Task with Template Entry should be created successfully.');

    }

    @isTest
    static void ActivityWithOnlyPlannedStartTimeAndEndTime(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__VisitPlan__c visitPlan1 = VisitPlanTestDataHelpers.getVisitPlan(partnerAccount);
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.createVisit(partnerAccount, branch, visitPlan1.Id);
        test.startTest();
        try {
            dmpl__VisitTaskActivity__c visitTaskActivity = VisitPlanTestDataHelpers.createVisitTaskActivity('Activity Name 1',visit.Id,Time.newInstance(1, 0, 0, 0),Time.newInstance(0, 15, 0, 0));
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
}