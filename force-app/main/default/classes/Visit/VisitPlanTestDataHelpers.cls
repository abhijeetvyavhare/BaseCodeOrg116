public with sharing class VisitPlanTestDataHelpers {
    public static dmpl__VisitRouteStop__c CreateVisitRouteStop(
        String name,
        Account act,
        dmpl__VisitRoute__c route
    ) {
        return (dmpl__VisitRouteStop__c) TestFactory.createSObject(
            new dmpl__VisitRouteStop__c(
                Name = name,
                dmpl__AllowedGeofencingTolerance__c = 10,
                dmpl__AccountId__c = act.Id,
                dmpl__StartTime__c = time.newInstance(5, 20, 30, 60),
                dmpl__EndTime__c = time.newInstance(25, 10, 50, 10),
                dmpl__VisitPurpose__c = 'Order Capture',
                dmpl__VisitRouteId__c = route.Id,
                dmpl__SequenceNumber__c = 1,
                dmpl__WeekNumbers__c = '2',
                dmpl__DayNumbers__c = '5'
            ),
            'VisitRouteStopDefaults',
            true
        );
    }
    
    public static dmpl__VisitRouteStop__c getVisitRouteStop() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AllowedGeofencingTolerance__c,
                dmpl__AccountId__c,
                dmpl__StartTime__c,
                dmpl__EndTime__c,
                dmpl__VisitPurpose__c,
                dmpl__VisitRouteId__c,
                dmpl__SequenceNumber__c,
                dmpl__WeekNumbers__c,
                dmpl__DayNumbers__c
            FROM dmpl__VisitRouteStop__c   
            LIMIT 1
        ];
    }

    public static dmpl__VisitRouteStop__c getVisitRouteStop(
        Id visitRouteStopId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AllowedGeofencingTolerance__c,
                dmpl__AccountId__c,
                dmpl__StartTime__c,
                dmpl__EndTime__c,
                dmpl__VisitPurpose__c,
                dmpl__VisitRouteId__c,
                dmpl__SequenceNumber__c,
                dmpl__WeekNumbers__c,
                dmpl__DayNumbers__c
            FROM dmpl__VisitRouteStop__c   
            WHERE Id = :visitRouteStopId
            LIMIT 1
        ];
    }
    
    public static dmpl__Visit__c CreateVisit(
        Account act,
        dmpl__VisitPlan__c plan,
        dmpl__VisitTaskTemplate__c template
    ) {
        return (dmpl__Visit__c)TestFactory.createSObject(
            new dmpl__Visit__c(
                dmpl__SequenceNumber__c = 1,
                dmpl__GeofencingTolerance__c = 15,
                dmpl__AccountId__c = act.Id,
                dmpl__VisitTaskTemplateId__c = template.Id,
                dmpl__DocumentDate__c = date.today(),
                dmpl__VisitPlanId__c = plan.Id,
                dmpl__VisitStatus__c = 'Planned'
            ),
            'VisitDefaults',
            true
        );
    }

	public static dmpl__Visit__c getVisit() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AccountId__c,
                dmpl__VisitPlanId__c,
                dmpl__VisitTaskTemplateId__c,
                dmpl__DocumentDate__c,
                dmpl__VisitStatus__c,
                dmpl__SequenceNumber__c,
                dmpl__GeofencingTolerance__c,
            	dmpl__VisitPurpose__c
            FROM dmpl__Visit__c   
            WHERE dmpl__VisitStatus__c = 'Planned'
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitRoute__c CreateVisitRoute(
        String name,
        dmpl__AccountGroup__c actGroup,
        Account act,
        dmpl__Resource__c resource
    ) {
        return (dmpl__VisitRoute__c)TestFactory.createSObject(
            new dmpl__VisitRoute__c(
                Name = name,
                dmpl__PartnerAccountId__c = act.Id,
                dmpl__AccountGroupId__c = actGroup.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__CoverageMidpointDistance__c = 10,
                dmpl__IsActive__c = true,
                dmpl__VisitPurpose__c = 'Order Capture',
                dmpl__RoutingPriority__c = 'Shortest Distance',
                dmpl__WeekNumbers__c = '2',
                dmpl__DayNumbers__c = '5'
            ),
            'VisitRouteDefaults',
            true
        );
    }

    public static dmpl__VisitRoute__c CreateVisitRoute(
        Account act,
        dmpl__Resource__c resource
    ) {
        return (dmpl__VisitRoute__c)TestFactory.createSObject(
            new dmpl__VisitRoute__c(
                dmpl__PartnerAccountId__c = act.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__CoverageMidpointDistance__c = 10,
                dmpl__IsActive__c = true,
                dmpl__VisitPurpose__c = 'Order Capture',
                dmpl__RoutingPriority__c = 'Shortest Distance',
                dmpl__WeekNumbers__c = '2',
                dmpl__DayNumbers__c = '5'
            ),
            'VisitRouteDefaults',
            true
        );
    }
    
    public static dmpl__VisitRoute__c getVisitRoute() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ResourceId__c,
                dmpl__CoverageMidpointDistance__c,
                dmpl__IsActive__c,
                dmpl__VisitPurpose__c,
                dmpl__RoutingPriority__c,
                dmpl__WeekNumbers__c,
                dmpl__DayNumbers__c
            FROM dmpl__VisitRoute__c   
            LIMIT 1
        ];
    }

    public static dmpl__VisitRoute__c getVisitRoute(
        Id visitRouteId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ResourceId__c,
                dmpl__CoverageMidpointDistance__c,
                dmpl__IsActive__c,
                dmpl__VisitPurpose__c,
                dmpl__RoutingPriority__c,
                dmpl__WeekNumbers__c,
                dmpl__DayNumbers__c
            FROM dmpl__VisitRoute__c   
            WHERE Id = :visitRouteId
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitPlan__c CreateVisitPlan(
        Account act, 
        dmpl__VisitRoute__c route,
        dmpl__VisitTaskTemplate__c temp
    ) {
        return (dmpl__VisitPlan__c)TestFactory.createSObject(
            new dmpl__VisitPlan__c(
                dmpl__PartnerAccountId__c = act.Id,
                dmpl__Status__c = 'Task',
                dmpl__VisitPurpose__c = 'Order Capture',
                dmpl__VisitRouteId__c = route.Id,
                dmpl__VisitTaskTemplateId__c = temp.Id
            ),
            'VisitPlanDefaults',
            true
        );
    }
    
    public static dmpl__VisitPlan__c CreateVisitPlan(
        String name,
        Account act, 
        dmpl__VisitRoute__c route,
        dmpl__VisitTaskTemplate__c temp
    ) {
        return (dmpl__VisitPlan__c)TestFactory.createSObject(
            new dmpl__VisitPlan__c(
                Name = name,
                dmpl__PartnerAccountId__c = act.Id,
                dmpl__Status__c = 'Draft',
                dmpl__VisitPurpose__c = 'Order Capture',
                dmpl__VisitRouteId__c = route.Id,
                dmpl__VisitTaskTemplateId__c = temp.Id
            ),
            'VisitPlanDefaults',
            true
        );
    }

    public static dmpl__VisitPlan__c getVisitPlan() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__VisitRouteId__c,
                dmpl__VisitTaskTemplateId__c,
                dmpl__Status__c,
                dmpl__VisitPurpose__c,
            	dmpl__PlanStartDate__c,
            	dmpl__PlanEndDate__c
            FROM dmpl__VisitPlan__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitPlan__c getVisitPlan(
        Id visitPlanId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__VisitRouteId__c,
                dmpl__VisitTaskTemplateId__c,
                dmpl__Status__c,
                dmpl__VisitPurpose__c
            FROM dmpl__VisitPlan__c   
            WHERE Id = :visitPlanId
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTask__c CreateVisitTask(
        dmpl__Visit__c visit,
        dmpl__VisitTaskTemplateEntry__c entry
    ) {
        return (dmpl__VisitTask__c)TestFactory.createSObject(
            new dmpl__VisitTask__c(
                dmpl__VisitId__c = visit.Id,
                dmpl__VisitTaskTemplateEntryId__c = entry.Id
            ),
            'VisitTaskDefaults',
            true
        );
    }

    public static dmpl__VisitTaskTemplateEntry__c CreateVisitTaskTemplateEntry(
        dmpl__VisitTaskTemplate__c task,
        String entryName
    ) {
        return (dmpl__VisitTaskTemplateEntry__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplateEntry__c(
                Name = entryName,
                dmpl__TaskType__c = 'Perform Visit Activities',
                dmpl__SequenceNumber__c = 1,
                dmpl__VisitTaskTemplateId__c = task.Id
            ),
            'VisitTaskTemplateEntryDefaults',
            true
        );
    }

    public static dmpl__VisitTask__c getVisitTask() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__VisitId__c,
                dmpl__TaskType__c,
                dmpl__SequenceNumber__c,
                dmpl__VisitTaskTemplateEntryId__c,
                dmpl__Status__c
            FROM dmpl__VisitTask__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTask__c getVisitTask(
    	Id visitId
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__VisitId__c,
                dmpl__TaskType__c,
                dmpl__SequenceNumber__c,
                dmpl__VisitTaskTemplateEntryId__c,
                dmpl__Status__c
            FROM dmpl__VisitTask__c   
            WHERE dmpl__VisitId__c = :visitId
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTaskTemplate__c CreateVisitTaskTemplate() {
        return (dmpl__VisitTaskTemplate__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplate__c(
                dmpl__Description__c = 'Visit Task Template1',
                dmpl__Duration__c = 10,
                Name = 'Task Template'
            ),
            'VisitTaskTemplateDefaults',
            true
        );
    }
    
    public static dmpl__VisitTaskTemplate__c CreateVisitTaskTemplate(
        String name
    ) {
        return (dmpl__VisitTaskTemplate__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplate__c(
                Name = name
            ),
            'VisitTaskTemplateDefaults',
            true
        );
    }
    
    public static dmpl__VisitTaskTemplate__c getVisitTaskTemplate() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Description__c,
                dmpl__Duration__c
            FROM dmpl__VisitTaskTemplate__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTaskTemplateEntry__c CreateVisitTaskTemplateEntry(
        dmpl__VisitTaskTemplate__c task
    ) {
        return (dmpl__VisitTaskTemplateEntry__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplateEntry__c(
                dmpl__TaskType__c = 'Perform Visit Activities',
                dmpl__SequenceNumber__c = 1,
                dmpl__VisitTaskTemplateId__c = task.Id
            ),
            'VisitTaskTemplateEntryDefaults',
            true
        );
    }
    
    public static dmpl__VisitTaskTemplateEntry__c getVisitTaskTemplateEntry() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__TaskType__c,
                dmpl__SequenceNumber__c,
                dmpl__VisitTaskTemplateId__c,
            	dmpl__IsMandatory__c
            FROM dmpl__VisitTaskTemplateEntry__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTaskActivity__c CreateVisitTaskActivity(
        dmpl__VisitTask__c task
    ) {
        return (dmpl__VisitTaskActivity__c)TestFactory.createSObject(
            new dmpl__VisitTaskActivity__c(
                dmpl__VisitTaskId__c = task.Id,
                dmpl__Status__c = 'Planned',
                dmpl__NumericValue__c = 100,
                dmpl__PerformAutomatically__c = true,
                dmpl__URL__c = 'http://www.example.com'
            ),
            'VisitTaskActivityDefaults',
            true
        );
    }
    
    public static dmpl__VisitTaskActivity__c getVisitTaskActivity() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__VisitTaskId__c,
                dmpl__Status__c,
                dmpl__NumericValue__c,
                dmpl__SequenceNumber__c,
                dmpl__PerformAutomatically__c,
                dmpl__ActivityType__c,
                dmpl__URL__c
            FROM dmpl__VisitTaskActivity__c   
            WHERE dmpl__NumericValue__c = 100
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitTaskActivity__c getVisitTaskActivity(
        dmpl__VisitTask__c visitTask
    ) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__VisitTaskId__c,
                dmpl__Status__c,
                dmpl__NumericValue__c,
                dmpl__SequenceNumber__c,
                dmpl__PerformAutomatically__c,
                dmpl__ActivityType__c,
                dmpl__URL__c
            FROM dmpl__VisitTaskActivity__c   
            WHERE dmpl__VisitTaskId__c = :visitTask.Id
            LIMIT 1
        ];
    }
        
    public static dmpl__VisitTaskTemplateActivity__c CreateVisitTaskTemplateActivity(
        dmpl__VisitTaskTemplateEntry__c taskEntry
    ) {
        return (dmpl__VisitTaskTemplateActivity__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplateActivity__c(
                dmpl__VisitTaskTemplateEntryId__c = taskEntry.Id,
                dmpl__SequenceNumber__c = 1,
                dmpl__PerformAutomatically__c = false,
                dmpl__ActivityType__c = 'Record Text Value',
                dmpl__ReportURL__c = 'http://www.example.com'
            ),
            'VisitTaskTemplateActivityDefaults',
            true
         ); 
    }
    
    public static dmpl__VisitTaskTemplateActivity__c CreateVisitTaskTemplateActivity(
        String name,
        dmpl__VisitTaskTemplateEntry__c taskEntry
    ) {
        return (dmpl__VisitTaskTemplateActivity__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplateActivity__c(
                Name = name,
                dmpl__VisitTaskTemplateEntryId__c = taskEntry.Id,
                dmpl__SequenceNumber__c = 1,
                dmpl__PerformAutomatically__c = false,
                dmpl__ReportURL__c = 'http://www.example.com'
            ),
            'VisitTaskTemplateActivityDefaults',
            true
         ); 
    }
    
    public static dmpl__VisitTaskTemplateActivity__c getVisitTaskTemplateActivity() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__VisitTaskTemplateEntryId__c,
                dmpl__SequenceNumber__c,
                dmpl__PerformAutomatically__c,
                dmpl__ActivityType__c,
                dmpl__ReportURL__c,
            	dmpl__Duration__c,
            	dmpl__ObjectName__c,
            	dmpl__ObjectApiName__c,
            	dmpl__IsMandatory__c,
            	dmpl__ChecklistTemplateId__c
            FROM dmpl__VisitTaskTemplateActivity__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__VisitRouteGroup__c CreateVisitRouteGroup(
        Account act,
        dmpl__Resource__c resource,
        dmpl__Branch__c branch
    ) {
        return (dmpl__VisitRouteGroup__c)TestFactory.createSObject(
            new dmpl__VisitRouteGroup__c(
                dmpl__PartnerAccountId__c = act.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__BranchId__c = branch.id,
                name= 'Visit Route Group 1',
                dmpl__VisitPurpose__c='Order Delivery'
            ),
            'VisitRouteGroupDefaults',
            true
        );
    }
    
    public static dmpl__VisitRouteGroup__c getVisitRouteGroup() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__ResourceId__c,
                dmpl__BranchId__c,
                dmpl__VisitPurpose__c
            FROM dmpl__VisitRouteGroup__c   
            LIMIT 1
        ];
    }
    
    public static dmpl__Visit__c createVisit(
        Account partnerAccount, 
        dmpl__Branch__c branch, 
        Id VisitPlanId
    ) {
        return (dmpl__Visit__c)TestFactory.createSObject(
            new dmpl__Visit__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__VisitPlanId__c = VisitPlanId
            ),
            'VisitDefaults',
            true
        );
    }

    public static dmpl__VisitPlan__c createVisitPlan(
        Account partnerAccount, 
        dmpl__Branch__c branch,
        String visitPurpose, 
        String status, 
        DateTime StartDate, 
        DateTime EndDate
    ) {
        return (dmpl__VisitPlan__c)TestFactory.createSObject(
            new dmpl__VisitPlan__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__VisitPurpose__c = visitPurpose,
                dmpl__Status__c = status,
                dmpl__PlanStartDate__c = StartDate,
                dmpl__PlanEndDate__c = EndDate
            ),
            'VisitPlanDefaults',
            true
        );
    }

    public static dmpl__VisitPlan__c getVisitPlan(
        Account partnerAccount
    ) {
        return [
            SELECT 
                Id, 
                dmpl__VisitPurpose__c, 
                dmpl__Status__c, 
                dmpl__PlanStartDate__c, 
                dmpl__PlanEndDate__c 
            FROM dmpl__VisitPlan__c 
            WHERE dmpl__PartnerAccountId__c = :partnerAccount.Id 
            LIMIT 1
        ];
    }

    public static dmpl__VisitTask__c createVisitTask(
        String TaskNumber, 
        Id vist, 
        Id VisitPurpose,
        String TaskType,
        String status
    ) {
        return (dmpl__VisitTask__c)TestFactory.createSObject(
            new dmpl__VisitTask__c(
                dmpl__TaskName__c = TaskNumber,
                dmpl__VisitId__c = vist,
                dmpl__VisitTaskTemplateEntryId__c = VisitPurpose,
                dmpl__TaskType__c = TaskType,
                dmpl__Status__c = status
            ),
            'VisitTaskDefaults',
            true
        );
    }

    public static dmpl__VisitTask__c getVisitTask(
        String TaskNumber
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__VisitId__c, 
                dmpl__TaskType__c, 
                dmpl__Status__c, 
                dmpl__VisitTaskTemplateEntryId__c 
            FROM dmpl__VisitTask__c 
            WHERE Name = :TaskNumber 
            LIMIT 1
        ];
    }

    public static dmpl__VisitTaskActivity__c createVisitTaskActivity(
        String name, 
        Id visitid, 
        Time StartDateTime, 
        Time EndDateTime
    ) {
        return (dmpl__VisitTaskActivity__c)TestFactory.createSObject(
            new dmpl__VisitTaskActivity__c(
                dmpl__ActivityName__c = name,
                dmpl__VisitTaskId__c = visitid,
                dmpl__PlannedStartTime__c = StartDateTime,
                dmpl__PlannedEndTime__c = EndDateTime
            ),
            'VisitTaskActivityDefaults',
            true
        );
    }

    public static dmpl__VisitTaskActivity__c getVisitTaskActivity(
        String autonumber
    ) {
        return [
            SELECT 
                Id, 
                dmpl__ActivityName__c, 
                Name, 
                dmpl__PlannedStartTime__c, 
                dmpl__PlannedEndTime__c 
            FROM dmpl__VisitTaskActivity__c 
            WHERE Name = :autonumber 
            LIMIT 1
        ];
    }

    public static dmpl__VisitTaskTemplate__c createVisitTaskTemplate(
        String TemplateName,
        Integer Duration
    ) {
        return (dmpl__VisitTaskTemplate__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplate__c(
                Name = TemplateName,
                dmpl__Duration__c = Duration
            ),
            'VisitTaskTemplateDefaults',
            true
        );
    }

    public static dmpl__VisitTaskTemplateEntry__c createVisitTaskTemplateEntry(
        String Name,
        String VisitTaskTemplateId,
        String tasktype
    ) {
        return (dmpl__VisitTaskTemplateEntry__c)TestFactory.createSObject(
            new dmpl__VisitTaskTemplateEntry__c(
                Name = Name,
                dmpl__VisitTaskTemplateId__c = VisitTaskTemplateId,
                dmpl__TaskType__c = tasktype
            ),
            'VisitTaskTemplateEntryDefaults',
            true
        );
    }
}