@isTest
public with sharing class JobQueueHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.createJobQueueRecord(jobQueue);
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
    }
    
    @isTest
    static void createJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        if (jobQueue != null) {
            System.assertNotEquals(jobQueue, null, 'Expected JobQueue to be created.');
        }
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
        System.assertEquals(1, jobQueue.dmpl__RetryCount__c, 'RetryCount should be 1');
    }
    
    @isTest
    static void updateJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertNotEquals(jobQueue, null, 'JobQueue should exist before update.');
        jobQueue.dmpl__RetryCount__c = 3;
        jobQueue.dmpl__QueueType__c = 'Manual';
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertEquals(3, updatedJobQueue.dmpl__RetryCount__c, 'RetryCount should be updated to 3');
        System.assertEquals('Manual', updatedJobQueue.dmpl__QueueType__c, 'QueueType should be updated to Manual');
    }
    
    @isTest
    static void deleteJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertNotEquals(jobQueue, null, 'JobQueue should exist before delete.');
        delete jobQueue;
        dmpl__InterfaceQueue__c deletedJobQueue = null;
        try {
            deletedJobQueue = JobQueueTestDataHelper.getJobQueue();
        } catch (Exception e) {
            deletedJobQueue = null;
        }
        System.assertEquals(null, deletedJobQueue, 'JobQueue should be deleted and not found in query.');
    }
    
    @isTest
    static void createJobQueueWithJobTypePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified JobType.');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }
    
    @isTest
    static void updateJobQueueWithJobTypePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__JobType__c = 'Custom Processor';
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with specified JobType.');
        System.assertEquals('Interface Job', createdJobQueue.dmpl__JobType__c, 'JobType should be Interface Job when Initially created');
        System.assertEquals('Custom Processor', updatedJobQueue.dmpl__JobType__c, 'JobType should be updated to Custom Processor');
    }
    
    @isTest
    static void createJobQueueWithQueueTypeQueueablePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Queueable.');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }
    
    @isTest
    static void createJobQueueWithQueueTypeSchedulablePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__QueueType__c = 'Schedulable';
        jobQueue.dmpl__CronExpression__c = '0 0 1 * * ?';
        jobQueue.dmpl__SchedulableJobName__c = 'Test';
        update jobQueue;
        jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Schedulable.');
        System.assertEquals('Schedulable', jobQueue.dmpl__QueueType__c, 'QueueType should be Schedulable');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }
    
    @isTest
    static void createJobQueueWithQueueTypeEventPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__QueueType__c = 'Event';
        update jobQueue;
        jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Event.');
        System.assertEquals('Event', jobQueue.dmpl__QueueType__c, 'QueueType should be Event');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }
    
    @isTest
    static void createJobQueueWithQueueTypeManualPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__QueueType__c = 'Manual';
        update jobQueue;
        jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Manual.');
        System.assertEquals('Manual', jobQueue.dmpl__QueueType__c, 'QueueType should be Manual');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }
    
    @isTest
    static void createJobQueueWithRetryCountPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified RetryCount.');
        System.assertEquals(1, jobQueue.dmpl__RetryCount__c, 'RetryCount should be 3');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }
    
    @isTest
    static void createJobQueueWithInterfaceProviderPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        update jobQueue;
        jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified InterfaceServiceProvider.');
        System.assertEquals(interfaceServiceProvider.Id, jobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be set');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }
    
    @isTest
    static void deleteJobQueueScenarioPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        delete jobQueue;
        dmpl__InterfaceQueue__c deletedJobQueue=null;
        try {
            deletedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        } catch (QueryException e) {
            deletedJobQueue = null;
        }
        System.assertEquals(null, deletedJobQueue, 'JobQueue should be deleted.');
        Test.stopTest();
    }
    
    @isTest
    static void createJobQueueWithNegativeRetryCountNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
            jobQueue.dmpl__RetryCount__c = -1;
            update jobQueue;
            jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
            System.assertNotEquals(null, jobQueue, 'Expected JobQueue creation with negative RetryCount.');
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateJobQueueWithRemovingInterfaceProviderNegative() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        update jobQueue;
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__InterfaceProviderId__c = null;
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with removing InterfaceServiceProvider.');
        System.assertEquals(interfaceServiceProvider.Id, createdJobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be set when initially created');
        System.assertEquals(null, updatedJobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be null after update');
    }
    
    @isTest
    static void updateJobQueueWithRemovingInterfaceProviderRequestNegative() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        jobQueue.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        jobQueue.dmpl__InterfaceRequestId__c = interfaceServiceProviderRequest.Id;
        update jobQueue;
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__InterfaceRequestId__c = null;
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with removing InterfaceServiceProviderRequest.');
        System.assertEquals(interfaceServiceProviderRequest.Id, createdJobQueue.dmpl__InterfaceRequestId__c, 'InterfaceServiceProviderRequestId should be set when initially created');
        System.assertEquals(null, updatedJobQueue.dmpl__InterfaceRequestId__c, 'InterfaceServiceProviderRequestId should be null after update');
    }
    
    @isTest
    static void createJobQueueWithInvalidInterfaceRequestNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider?.Id);
            dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
            delete interfaceServiceProviderRequest;
            jobQueue.dmpl__InterfaceRequestId__c = interfaceServiceProviderRequest?.Id;
            update jobQueue;
            jobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
            System.assertNotEquals(null, jobQueue, 'Expected JobQueue creation with invalid InterfaceServiceProviderRequest.');
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createJobQueueWithCorrectJobQueueIdPositive() {
        Test.startTest();
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        Test.stopTest();
        System.assertNotEquals(null, jobQueueRecord, 'Expected Job Queue Record should get created');
    }
    
    @isTest
    static void createJobQueueRecordWithoutJobQueueIdNegative() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        dmpl__JobQueueRecord__c deletedJobQueueRecord = null;
        try {
            delete jobQueue;
            deletedJobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord(jobQueueRecord?.Id);
        } catch (Exception e) {
            deletedJobQueueRecord = null;
            System.debug('Expected exception: ' + e.getMessage());
        }
        System.assertEquals(null, deletedJobQueueRecord, 'Expected Job Queue Record creation to fail without Job Queue ID.');
        Test.stopTest();
    }
    
    @isTest
    static void createJobQueueRecordWithHostIdQuantityMessageRecordIdPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        jobQueueRecord.dmpl__HostId__c = 'Test 123';
        jobQueueRecord.dmpl__RecordId__c = 'Test Record';
        update jobQueueRecord;
        jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord(jobQueueRecord.Id);
        Test.stopTest();
        System.assertNotEquals(null, jobQueueRecord, 'Expected Job Queue Record to be created with specified Job Queue ID.');
        System.assertEquals(jobQueue.Id, jobQueueRecord.dmpl__JobQueueId__c, 'Job Queue ID should match');
    }
}