@isTest
private class VisitRouteHandler_Test {
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
    }

    @isTest
    static void createVisitRoutePositive() {
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        if(route != null) {
            System.assertNotEquals(route, null, 'Expected Visit Route to be created.');
        }
        System.assertEquals(10,route.dmpl__CoverageMidpointDistance__c, 'Expected Cov. mid pt. distance to be 10.');
        System.assertEquals('Order Capture',route.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
    }
    
    @isTest
    static void createVisitRouteStopPositive() {
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        if(routeStop != null) {
            System.assertNotEquals(routeStop, null, 'Expected Visit Route Stop to be created.');
        }
        System.assertEquals(10,routeStop.dmpl__AllowedGeofencingTolerance__c, 'Expected Geoefencing Tolerance to be 10.');
        System.assertEquals(1,routeStop.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }

    @isTest
    static void updateVisitRoutePositive() {
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        System.assertNotEquals(route, null, 'Visit Route should exist before update.');
        route.dmpl__CoverageMidpointDistance__c = 20;
        route.dmpl__VisitPurpose__c = 'Order Delivery';
        update route;
        dmpl__VisitRoute__c updatedRoute = VisitPlanTestDataHelpers.getVisitRoute();
        System.assertEquals(20,updatedRoute.dmpl__CoverageMidpointDistance__c, 'Expected Cov. mid pt. distance to be 20.');  
        System.assertEquals('Order Delivery',updatedRoute.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Delivery.');
    }

    @isTest
    static void updateVisitRouteStopPositive() {
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        System.assertNotEquals(routeStop, null, 'Visit Route Stop should exist before update.');
        routeStop.dmpl__AllowedGeofencingTolerance__c = 15;
        routeStop.dmpl__SequenceNumber__c = 2;
        update routeStop;
        dmpl__VisitRouteStop__c updatedRouteStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        System.assertEquals(15,updatedRouteStop.dmpl__AllowedGeofencingTolerance__c, 'Expected Geoefencing Tolerance to be 15.');
        System.assertEquals(2,updatedRouteStop.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 2.');
    }
    
    @isTest
    static void deleteVisitRoutePositive() {
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        System.assertNotEquals(route, null, 'Visit Route should exist before update.');
        Test.startTest();
        delete route;
        Test.stopTest();
        dmpl__VisitRoute__c deletedRoute = null;
        try {
            deletedRoute = VisitPlanTestDataHelpers.getVisitRoute();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedRoute);
        } catch (Exception e) {
            deletedRoute = null;
        }
        System.assertEquals(null, deletedRoute, 'Route should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteVisitRouteStopPositive() {
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        System.assertNotEquals(routeStop, null, 'Visit Route Stop should exist before update.');
        Test.startTest();
        delete routeStop;
        Test.stopTest();
        dmpl__VisitRouteStop__c deletedRouteStop = null;
        try {
            deletedRouteStop = VisitPlanTestDataHelpers.getVisitRouteStop();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedRouteStop);
        } catch (Exception e) {
            deletedRouteStop = null;
        }
        System.assertEquals(null, deletedRouteStop, 'Route Stop should be deleted and not found in query.');      
    }
    
    @isTest
    static void createVisitRouteWithValidRouteNamePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        Test.stopTest();
        System.assertEquals('Visit Route 1', route.Name, 'Expected Visit Route Name to be "Visit Route 1".');
    }
    
    @isTest
    static void tagVisitRouteWithValidDataPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        route.dmpl__VisitTaskTemplateId__c = taskTemplate.Id;
        update route;
        Test.stopTest();
        System.assertEquals('Visit Route 1', route.Name, 'Expected Visit Route Name to be "Visit Route 1".');
        System.assertEquals(taskTemplate.Id, route.dmpl__VisitTaskTemplateId__c, 'Expected Visit Task Template to be associated with the route.');
        System.assertEquals(partnerAccount1.Id, route.dmpl__PartnerAccountId__c, 'Expected Partner Account to be associated with the route.');
        System.assertEquals(resource.Id, route.dmpl__ResourceId__c, 'Expected Resource to be associated with the route.');
    }
    
    @isTest
    static void createVisitRouteWithValidFromAndToDatePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        route.dmpl__EffectiveFrom__c = Date.today();
        route.dmpl__EffectiveTo__c = Date.today();
        update route;
        Test.stopTest();
        System.assertEquals('Visit Route 1', route.Name, 'Expected Visit Route Name to be "Visit Route 1".');
        System.assertEquals(Date.today(), route.dmpl__EffectiveFrom__c, 'Expected From Date to be today.');
        System.assertEquals(Date.today(), route.dmpl__EffectiveTo__c, 'Expected To Date to be 30 days from today.');
    }
    
    @isTest
    static void createVisitRouteWithIsActiveTruePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        Test.stopTest();
        System.assertEquals('Visit Route 1', route.Name, 'Expected Visit Route Name to be "Visit Route 1".');
        System.assertEquals(true, route.dmpl__IsActive__c, 'Expected Is Active to be true.');
    }
    
    @isTest
    static void visitRouteStopAutoTaggedWithVisitRoutePositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
    }
    
    @isTest
    static void createVisitRouteStopWithoutVisitRouteNegative() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        try {
            dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop('Visit Route Stop 1',customerAccount1,null);
            System.assert(false, 'Expected exception when inserting Visit Route Stop without Visit Route.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Attempt to de-reference a null object'), 
            'Expected exception for missing Visit Route: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createVisitRouteStopWithValidDataPositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(customerAccount1.Id, routeStop.dmpl__AccountId__c, 'Expected Customer Account to be associated with the Visit Route Stop.');
        System.assertEquals(1, routeStop.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }
    
    @isTest
    static void createVisitRouteStopWithDayAndWeekNumbersPositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        routeStop.dmpl__WeekNumbers__c = '5';
        routeStop.dmpl__DayNumbers__c = '1,2';
        update routeStop;
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals('5', routeStop.dmpl__WeekNumbers__c, 'Expected Week Numbers to be "5".');
        System.assertEquals('1,2', routeStop.dmpl__DayNumbers__c, 'Expected Day Numbers to be "1,2".');
    }
    
    @isTest
    static void createVisitRouteStopWithoutDayAndWeekNumbersPositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        routeStop.dmpl__WeekNumbers__c = null;
        routeStop.dmpl__DayNumbers__c = null;
        update routeStop;
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(null, routeStop.dmpl__WeekNumbers__c, 'Expected Week Numbers to be null.');
        System.assertEquals(null, routeStop.dmpl__DayNumbers__c, 'Expected Day Numbers to be null.');
    }
    
    @isTest
    static void createMultipleStopsWithUniqueSequenceNumbersPositive() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__VisitRouteStop__c routeStop1 = VisitPlanTestDataHelpers.getVisitRouteStop();
        dmpl__VisitRouteStop__c routeStop2 = VisitPlanTestDataHelpers.CreateVisitRouteStop('Visit Route Stop 2',customerAccount1,route);
        routeStop2.dmpl__SequenceNumber__c = 2;
        update routeStop2;
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop1.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop1.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(1, routeStop1.dmpl__SequenceNumber__c, 'Expected Sequence Number for Stop 1 to be 1.');
        System.assertEquals('Visit Route Stop 2', routeStop2.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 2".');
        System.assertEquals(route.Id, routeStop2.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(2, routeStop2.dmpl__SequenceNumber__c, 'Expected Sequence Number for Stop 2 to be 2.');
    }
    
    @isTest
    static void createMultipleStopsWithDuplicateSequenceNumbersNegative() {
        Test.startTest();
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__VisitRouteStop__c routeStop1 = VisitPlanTestDataHelpers.getVisitRouteStop();
        dmpl__VisitRouteStop__c routeStop2 = VisitPlanTestDataHelpers.CreateVisitRouteStop('Visit Route Stop 2',customerAccount1,route);
        Test.stopTest();
        System.assertEquals('Visit Route Stop 1', routeStop1.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 1".');
        System.assertEquals(route.Id, routeStop1.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(1, routeStop1.dmpl__SequenceNumber__c, 'Expected Sequence Number for Stop 1 to be 1.');
        System.assertEquals('Visit Route Stop 2', routeStop2.Name, 'Expected Visit Route Stop Name to be "Visit Route Stop 2".');
        System.assertEquals(route.Id, routeStop2.dmpl__VisitRouteId__c, 'Expected Visit Route Stop to be associated with the Visit Route.');
        System.assertEquals(1, routeStop2.dmpl__SequenceNumber__c, 'Expected Sequence Number for Stop 2 to be 2.');
    }
}