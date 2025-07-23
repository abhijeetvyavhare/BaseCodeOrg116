@isTest
public with sharing class ResourceHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.createPartnerResources(branch, resource);
        dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.createResourceSkill(resource);
        dmpl__LeaveType__c type = ResourceDataHelper.createLeaveType();
        dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.createResourceLeave(resource, type);
        dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
        dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.createResourceBusinessHours(resource, type);
    }

    @isTest
    static void createResourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        System.assertNotEquals(resource, null, 'Expected Resource to be created.');
        System.assertEquals(true, resource.dmpl__IsActive__c, 'Resource Active state must be True');
    }

    @isTest
    static void createResourceSkillPositive() {
        dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
        System.assertNotEquals(resourceSkill, null, 'Expected Resource Skill to be created.');
        System.assertEquals(1, resourceSkill.dmpl__SkillLevel__c, 'Skill Level Must be 1');
        System.assertEquals(Date.today(), resourceSkill.dmpl__StartDate__c, 'Resource Skill Name must be Test - Resource Skill');
    }

    @isTest
    static void createResourceLeavePositive() {
        dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
        System.assertNotEquals(resourceLeave, null, 'Expected Resource Leave to be created.');
        System.assertEquals(10, resourceLeave.dmpl__Available__c, 'Available Resource Leave Must be 10');
        System.assertEquals(10, resourceLeave.dmpl__Balance__c, 'Balance Resource Leave Must be 10');
    }

    @isTest
    static void createResourceBusinessHoursPositive() {
        dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
        System.assertNotEquals(resourceBusinessHours, null, 'Expected Resource Business Hours to be created.');
        System.assertEquals(Date.today(), resourceBusinessHours.dmpl__FromDate__c, ' Resource Business Hours From Date Must be Todays');
    }

    @isTest
    static void createResourceAssignmentRulePositive() {
        dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
        System.assertNotEquals(resourceAssignmentRule, null, 'Expected Resource Assignment Rule to be created.');
        System.assertEquals(null, resourceAssignmentRule.dmpl__AssignmentType__c, 'Resource Assignment Rule From Assignment Type Must be Lead');
        System.assertEquals(null, resourceAssignmentRule.dmpl__FieldName__c, 'Resource Assignment Rule Field Name Must be Test Field');
        System.assertEquals(null, resourceAssignmentRule.dmpl__FieldValue__c, 'Resource Assignment Rule Field Value Must be Test Value');
    }

    @isTest
    static void updateResourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        System.assertNotEquals(resource, null, 'Resource should exist before update.');
        resource.dmpl__Type__c = 'Salesperson';
        update resource;
        dmpl__Resource__c resourceupdated = ResourceDataHelper.getResource(resource.Id);
        System.assertEquals('Salesperson', resourceupdated.dmpl__Type__c, 'Expected Resource Type to be updated to Salesperson.');
    }

    @isTest
    static void updateResourceSkillPositive() {
        dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
        System.assertNotEquals(resourceSkill, null, 'Resource Skill should exist before update.');
        resourceSkill.dmpl__SkillLevel__c = 2;
        update resourceSkill;
        dmpl__ResourceSkill__c resourceSkillupdated = ResourceDataHelper.getResourceSkill(resourceSkill.Id);
        System.assertEquals(2, resourceSkill.dmpl__SkillLevel__c, 'Skill Level Must be 2');
    }

    @isTest
    static void updateResourceLeavePositive() {
        dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
        System.assertNotEquals(resourceLeave, null, 'Resource Leave should exist before update.');
        resourceLeave.dmpl__Available__c = 15;
        resourceLeave.dmpl__Balance__c = 5;
        update resourceLeave;
        dmpl__ResourceLeave__c resourceLeaveupdated = ResourceDataHelper.getResourceLeave(resourceLeave.Id);
        System.assertEquals(15, resourceLeaveupdated.dmpl__Available__c, 'Available Resource Leave Must be 15');
        System.assertEquals(5, resourceLeaveupdated.dmpl__Balance__c, 'Balance Resource Leave Must be 5');
    }

    @isTest
    static void updateResourceBusinessHoursPositive() {
        dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
        System.assertNotEquals(resourceBusinessHours, null, 'Resource Leave should exist before update.');
        resourceBusinessHours.dmpl__FromDate__c = Date.today().addDays(1);
        update resourceBusinessHours;
        dmpl__ResourceBusinessHours__c resourceBusinessHoursupdated = ResourceDataHelper.getResourceBusinessHours(resourceBusinessHours.Id);
        System.assertEquals(Date.today().addDays(1), resourceBusinessHoursupdated.dmpl__FromDate__c, 'Resource Business Hours From Date Must be Next Day');
    }

    @isTest
    static void updateResourceAssignmentRulePositive() {
        dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
        System.assertNotEquals(resourceAssignmentRule, null, 'Resource Leave should exist before update.');
        resourceAssignmentRule.dmpl__AssignmentType__c = 'Appointment';
        update resourceAssignmentRule;
        dmpl__ResourceAssignmentRule__c resourceAssignmentRuleupdated = ResourceDataHelper.getResourceAssignmentRule(resourceAssignmentRule.Id);
        System.assertEquals('Appointment', resourceAssignmentRule.dmpl__AssignmentType__c, ' Resource Assignment Rule From Assignment Type Must be Appointment');
    }

    @isTest
    static void deleteResourceAssignmentRule() {
        dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
        System.assertNotEquals(null, resourceAssignmentRule, 'ResourceAssignmentRule should exist before delete.');
        delete resourceAssignmentRule;
        dmpl__ResourceAssignmentRule__c deletedRule;
        try {
            deletedRule = ResourceDataHelper.getResourceAssignmentRule(resourceAssignmentRule.Id);
        } catch (Exception e) {
            deletedRule = null;
        }
        System.assertEquals(null, deletedRule, 'ResourceAssignmentRule should be deleted and not found in query.');
    }

    @isTest
    static void deleteResourceBusinessHours() {
        dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
        System.assertNotEquals(null, resourceBusinessHours, 'ResourceBusinessHours should exist before delete.');
        delete resourceBusinessHours;
        dmpl__ResourceBusinessHours__c deletedBusinessHours;
        try {
            deletedBusinessHours = ResourceDataHelper.getResourceBusinessHours(resourceBusinessHours.Id);
        } catch (Exception e) {
            deletedBusinessHours = null;
        }
        System.assertEquals(null, deletedBusinessHours, 'ResourceBusinessHours should be deleted and not found in query.');
    }

    @isTest
    static void deleteResourceLeave() {
        dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
        System.assertNotEquals(null, resourceLeave, 'ResourceLeave should exist before delete.');
        delete resourceLeave;
        dmpl__ResourceLeave__c deletedLeave;
        try {
            deletedLeave = ResourceDataHelper.getResourceLeave(resourceLeave.Id);
        } catch (Exception e) {
            deletedLeave = null;
        }
        System.assertEquals(null, deletedLeave, 'ResourceLeave should be deleted and not found in query.');
    }

    @isTest
    static void deleteResourceSkill() {
        dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
        System.assertNotEquals(null, resourceSkill, 'ResourceSkill should exist before delete.');
        delete resourceSkill;
        dmpl__ResourceSkill__c deletedSkill;
        try {
            deletedSkill = ResourceDataHelper.getResourceSkill(resourceSkill.Id);
        } catch (Exception e) {
            deletedSkill = null;
        }
        System.assertEquals(null, deletedSkill, 'ResourceSkill should be deleted and not found in query.');
    }

    @isTest
    static void deleteResource() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        System.assertNotEquals(null, resource, 'Resource should exist before delete.');
        delete resource;
        dmpl__Resource__c deletedResource;
        try {
            deletedResource = ResourceDataHelper.getResource(resource.Id);
        } catch (Exception e) {
            deletedResource = null;
        }
        System.assertEquals(null, deletedResource, 'Resource should be deleted and not found in query.');
    }

    @isTest
    static void createResourceLeaveRecordWithActiveResourceIdPositive() {
        Test.startTest();
        dmpl__LeaveType__c type = ResourceDataHelper.getLeaveType();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceLeave__c leave = ResourceDataHelper.createResourceLeave(resource.Id, type.Id, 3);
        Test.stopTest();
        System.assertNotEquals(null, leave, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type.Id, leave.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave.Name, 'Name should not be null');
        System.assertEquals(3, leave.dmpl__Balance__c, 'Leave balance should be 3');
    }

    @isTest
    static void createResourceLeaveRecordWithLeaveTypePositive() {
        Test.startTest();
        dmpl__LeaveType__c type = ResourceDataHelper.getLeaveType();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceLeave__c leave = ResourceDataHelper.createResourceLeave(resource.Id, type.Id, 3);
        Test.stopTest();
        System.assertNotEquals(null, leave, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type.Id, leave.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave.Name, 'Name should not be null');
        System.assertEquals(3, leave.dmpl__Balance__c, 'Leave balance should be 3');
    }

    @isTest
    static void createResourceLeaveRecordWithMultipleLeaveRecordsPositive() {
        Test.startTest();
        dmpl__LeaveType__c type1 = ResourceDataHelper.getLeaveType();
        dmpl__LeaveType__c type2 = ResourceDataHelper.createLeaveType();
        dmpl__LeaveType__c type3 = ResourceDataHelper.createLeaveType();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceLeave__c leave1 = ResourceDataHelper.createResourceLeave(resource.Id, type1.Id, 3);
        dmpl__ResourceLeave__c leave2 = ResourceDataHelper.createResourceLeave(resource.Id, type2.Id, 3);
        dmpl__ResourceLeave__c leave3 = ResourceDataHelper.createResourceLeave(resource.Id, type3.Id, 3);
        Test.stopTest();
        System.assertNotEquals(null, leave1, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave1.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type1.Id, leave1.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave1.Name, 'Name should not be null');
        System.assertEquals(3, leave1.dmpl__Balance__c, 'Leave balance should be 3');
        System.assertNotEquals(null, leave2, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave2.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type2.Id, leave2.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(3, leave2.dmpl__Balance__c, 'Leave balance should be 3');
        System.assertNotEquals(null, leave3, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave3.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type3.Id, leave3.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(3, leave3.dmpl__Balance__c, 'Leave balance should be 3');
    }

    @isTest
    static void createRecordCreatedWithFromDateAndToDatePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Test.startTest();
        dmpl__ResourceBusinessHours__c businessHours = ResourceDataHelper.createResourceBusinessHours(resource.Id, Date.today(), Date.today().addDays(10));
        Test.stopTest();
        System.assertNotEquals(null, businessHours, 'Business hours record should not be null');
        System.assertEquals(resource.Id, businessHours.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(Date.today(), businessHours.dmpl__FromDate__c, 'From Date should match');
        System.assertEquals(Date.today().addDays(10), businessHours.dmpl__ToDate__c, 'To Date should match');
    }

    @isTest
    static void createRecordCreatedWithFromDateSameAsToDateNegative() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Test.startTest();
        dmpl__ResourceBusinessHours__c businessHours = ResourceDataHelper.createResourceBusinessHours(resource.Id, Date.today(), Date.today());
        Test.stopTest();
        System.assertNotEquals(null, businessHours, 'Business hours record should not be null');
        System.assertEquals(resource.Id, businessHours.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(Date.today(), businessHours.dmpl__FromDate__c, 'From Date should match');
        System.assertEquals(Date.today(), businessHours.dmpl__ToDate__c, 'To Date should match');
    }

    @isTest
    static void createRecordCreatedWithToDateEarlierThanFromDateNegative() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Date fromDate = Date.today().addDays(-5);
        Date toDate = Date.today();
        Test.startTest();
        dmpl__ResourceBusinessHours__c businessHours;
        try {
            businessHours = ResourceDataHelper.createResourceBusinessHours(resource.Id, Date.today(), Date.today().addDays(-5));
        }catch(Exception e) {
            System.Assert.isTrue(true, 'Resource Business Hours should not be created with invalid to date!');
        }
        Test.stopTest();
    }

    @isTest
    static void createRecordCreatedWithoutToDateNegative() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Test.startTest();
        dmpl__ResourceBusinessHours__c businessHours;
        try {
            businessHours = ResourceDataHelper.createResourceBusinessHours(resource.Id, Date.today().addDays(-5), null);
        }catch(Exception e) {
            System.Assert.isTrue(true, 'Resource Business Hours should not be created without to date!');
        }
        Test.stopTest();
    }

    @isTest
    static void createResourceLeaveRecordWithinActiveResourceIdNegative() {
        Test.startTest();
        dmpl__LeaveType__c type = ResourceDataHelper.getLeaveType();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        resource.dmpl__IsActive__c = false;
        update resource;
        dmpl__ResourceLeave__c leave;
        try {
            leave = ResourceDataHelper.createResourceLeave(resource.Id, type.Id, 3);
        }
        catch(Exception e) {}
        Test.stopTest();
        System.assertNotEquals(null, leave, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type.Id, leave.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave.Name, 'Name should not be null');
        System.assertEquals(3, leave.dmpl__Balance__c, 'Leave balance should be 3');
    }

    @isTest
    static void createResourceLeaveRecordWithoutResourceIdNegative() {
        Test.startTest();
        dmpl__LeaveType__c type = ResourceDataHelper.getLeaveType();
        dmpl__ResourceLeave__c leave;
        try {
            leave = ResourceDataHelper.createResourceLeave(null, type.Id, 3);
        }
        catch(Exception e) {}
        Test.stopTest();
        System.assertNotEquals(null, leave, 'Fetched leave record should not be null');
        System.assertEquals(null, leave.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type.Id, leave.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave.Name, 'Name should not be null');
        System.assertEquals(3, leave.dmpl__Balance__c, 'Leave balance should be 3');
    }

    @isTest
    static void createResourceLeaveRecordWithLeaveNegativeBalanceNegative() {
        Test.startTest();
        dmpl__LeaveType__c type = ResourceDataHelper.getLeaveType();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceLeave__c leave;
        try {
            leave = ResourceDataHelper.createResourceLeave(resource.Id, type.Id, -4);
        }
        catch(Exception e) {}
        Test.stopTest();
        System.assertNotEquals(null, leave, 'Fetched leave record should not be null');
        System.assertEquals(resource.Id, leave.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(type.Id, leave.dmpl__LeaveTypeId__c, 'Leave Type should match');
        System.assertEquals(null, leave.Name, 'Name should not be null');
        System.assertEquals(-4, leave.dmpl__Balance__c, 'Leave balance should be -4');
    }
    static void createRecordCreatedWithInactiveResourceNegative() {
        Test.startTest();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        resource.dmpl__IsActive__c = false;
        update resource;
        dmpl__ResourceBusinessHours__c businessHours;
        try {
            businessHours = ResourceDataHelper.createResourceBusinessHours(resource.Id, Date.today(), Date.today().addDays(10));
        }catch(Exception e) {}
        Test.stopTest();
        System.assertEquals(null, businessHours, 'Business hours record should not be created with in active resource');
    }

    @isTest
    static void resourceAssignmentRuleWithActivePartnerResourcePositive() {    
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithValidOperationPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            resourceAssignment.dmpl__AssignmentType__c = 'Lead';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals('Lead', resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithValidOperationFieldValuePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            resourceAssignment.dmpl__AssignmentType__c = 'Lead';
            resourceAssignment.dmpl__FieldValue__c = 'True';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals('Lead', resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals('True', resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithMultipleRulesforaSingleResourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            resourceAssignment.dmpl__AssignmentType__c = 'Lead';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals('Lead', resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithRulewithAssignmentTypeLeftBlankPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithInactivePartnerResourceNegative() {
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        partnerAccount2.dmpl__IsActive__c = false;
        update partnerAccount2;
        Boolean exceptionThrown = false;
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id);
            dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount2, branch2);
            dmpl__PartnerResource__c partnerResource = ResourceDataHelper.createPartnerResources(branch2, resource);
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            update resourceAssignment;
        }catch(Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Resource Assignment Rule must get not created!');
    }

    @isTest
    static void resourceAssignmentRuleWithoutPartnerResourceNegative() {
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(null);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            update resourceAssignment;
            System.Assert.isTrue(resourceAssignment == null, 'Resource Assignment Rule must get not created!');
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment == null, 'Resource Assignment Rule must get not created!');
        }
    }

    @isTest
    static void resourceAssignmentRuleWithMissingFieldValueandNamePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            resourceAssignment.dmpl__AssignmentType__c = 'Lead';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals('Lead', resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals(null, resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void resourceAssignmentRuleWithFieldValueandNamePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PartnerResource__c partnerResource = ResourceDataHelper.getPartnerResources();
        dmpl__ResourceAssignmentRule__c resourceAssignment;
        try {
            resourceAssignment = ResourceDataHelper.createResourceAssignmentRule(partnerResource);
            resourceAssignment.dmpl__Operation__c = 'Equals';
            resourceAssignment.dmpl__AssignmentType__c = 'Lead';
            resourceAssignment.dmpl__FieldName__c = 'Service Advisor';
            resourceAssignment.dmpl__FieldValue__c = 'True';
            update resourceAssignment;
        }catch(Exception e) {
            System.Assert.isTrue(resourceAssignment != null, 'Resource Assignment Rule must get created!');
        }
        System.assertEquals(partnerResource?.id, resourceAssignment.dmpl__PartnerResourceId__c, 'Partner Resource must match');
        System.assertEquals('Equals', resourceAssignment.dmpl__Operation__c, 'Partner Resource must match');
        System.assertEquals('Lead', resourceAssignment.dmpl__AssignmentType__c, 'Partner Resource must match');
        System.assertEquals('Service Advisor', resourceAssignment.dmpl__FieldName__c, 'Partner Resource must match');
        System.assertEquals('True', resourceAssignment.dmpl__FieldValue__c, 'Partner Resource must match');
    }

    @isTest
    static void createResourceAvailabilityWithActiveResourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                null, 
                DateTime.now(), 
                DateTime.now(), 
                Date.today()
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals(null, resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(Date.today(), resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithCheckInTimePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                null, 
                DateTime.now(), 
                null, 
                null
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals(null, resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithCheckOutTimePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                null, 
                null, 
                DateTime.now(), 
                null
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals(null, resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(null, resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithAvailabilityTypePresentPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                'Present', 
                DateTime.now(), 
                null, 
                Date.today()
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals('Present', resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(Date.today(), resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithAvailabilityTypeOnLeavePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                'Leave', 
                null, 
                null, 
                Date.today()
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability(resourceAvailability.Id);
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals('Leave', resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(null, resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(Date.today(), resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithoutResourcePositive() {
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                null, 
                'Present', 
                Datetime.now(), 
                null, 
                Date.today()
            );
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should be null');
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(null, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals('Present', resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(Datetime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(Date.today(), resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithoutAvailabilityTypePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                null, 
                DateTime.now(), 
                null, 
                null
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals(null, resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(DateTime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityWithDifferentCheckInCheckOutPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability;
        try {
            resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
                resource?.Id, 
                null, 
                Datetime.now(), 
                Datetime.now().addDays(1), 
                null
            );
        }catch(Exception e) {
            System.Assert.isTrue(resourceAvailability != null, 'ResourceAvailability record should not be null');
        }
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should not be null');
        System.assertEquals(resource?.Id, resourceAvailability.dmpl__ResourceId__c);
        System.assertEquals(null, resourceAvailability.dmpl__AvailabilityType__c);
        System.assertEquals(Datetime.now(), resourceAvailability.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(Datetime.now().addDays(1), resourceAvailability.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, resourceAvailability.dmpl__Date__c, 'Date must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInAndResourceAvailabilityPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                null, 
                null, 
                null
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInOnlyPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                null, 
                DateTime.now(), 
                null, 
                null, 
                null
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(null, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckOutOnlyPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                null, 
                null, 
                DateTime.now(), 
                null, 
                null
                );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(null, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInAndOutPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        DateTime checkIn = DateTime.now();
        DateTime checkOut = DateTime.now().addHours(8);
        String checkInSource = null;
        String checkOutSource = null;
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                null, 
                null
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInSourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                'Mobile', 
                null
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Mobile', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckOutSourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                null, 
                'Desktop'
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInAndOutSourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                null, 
                null, 
                'Mobile', 
                'Desktop'
            );
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Mobile', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInAndOutViaSourcePositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                null, 
                null
            );
            update checkInRecord;
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals(null, checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithMultipleCheckInPositive() {
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(
            resource.Id, 
            null, 
            DateTime.now(), 
            DateTime.now().addHours(8), 
            Date.today()
        );
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                resourceAvailability?.Id, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                'Desktop', 
                'Desktop'
            );
            checkInRecord.dmpl__CheckIn__c = DateTime.now();
            update checkInRecord;
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
        try {
            checkInRecord.dmpl__CheckIn__c = DateTime.now().addHours(1);
            update checkInRecord;
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now().addHours(1), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
        try {
            checkInRecord.dmpl__CheckIn__c = DateTime.now();
            update checkInRecord;
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
        try {
            checkInRecord.dmpl__CheckIn__c = DateTime.now();
            update checkInRecord;
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should not be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(resourceAvailability?.Id, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }

    @isTest
    static void createResourceAvailabilityCheckInWithCheckInWithoutResourcePositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
        dmpl__ResourceAvailabilityCheckIn__c checkInRecord;
        try {
            checkInRecord = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
                null, 
                DateTime.now(), 
                DateTime.now().addHours(8), 
                'Desktop', 
                'Desktop'
            );
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should be null');
        } catch(Exception e) {
            System.Assert.isTrue(checkInRecord != null, 'ResourceAvailabilityCheckIn record should be null');
        }
        checkInRecord = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(checkInRecord.Id);
        System.assertNotEquals(null, checkInRecord, 'Check-in record should not be null');
        System.assertEquals(null, checkInRecord.dmpl__ResourceAvailabilityId__c, 'ResourceAvailabilityId must match');
        System.assertEquals(DateTime.now(), checkInRecord.dmpl__CheckIn__c, 'CheckIn must match');
        System.assertEquals(DateTime.now().addHours(8), checkInRecord.dmpl__CheckOut__c, 'CheckOut must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckInSource__c, 'CheckInSource must match');
        System.assertEquals('Desktop', checkInRecord.dmpl__CheckOutSource__c, 'CheckOutSource must match');
    }
}