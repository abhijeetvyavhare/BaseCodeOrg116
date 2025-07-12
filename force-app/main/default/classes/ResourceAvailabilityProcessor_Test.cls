@isTest
public with sharing class ResourceAvailabilityProcessor_Test {
	@TestSetup
	static void createRequiredData(){
		BusinessHours businessHours = BusinessHoursHelper.getCachedDefaultBusinessHours();
		CreateAccount();
        CreateBranch();
		CreateResource();
		dmpl__LeaveType__c type = ResourceDataHelper.createLeaveType();
		createResourceBusinessHours();
		createResourceAvailability();
	}

	private static dmpl__Resource__c CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
		return resource[0];
    }

	public static dmpl__ResourceAvailability__c createResourceAvailability(){
		dmpl__Resource__c resource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
		return (dmpl__ResourceAvailability__c) TestFactory.createSObject(
			new dmpl__ResourceAvailability__c (
				dmpl__ResourceId__c = resource.Id,
				dmpl__AvailabilityType__c = 'Present',
				dmpl__Date__c = Date.Today()
			),
			'ResourceAvailabilityDefaults',
			true
		);
	}

	public static dmpl__ResourceBusinessHours__c createResourceBusinessHours(){
		dmpl__Resource__c resource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
		BusinessHours businessHours = [SELECT
            IsActive,
            Name,
            IsDefault,
            FridayEndTime,
            FridayStartTime,
            MondayEndTime,
            MondayStartTime,
            SaturdayEndTime,
            SaturdayStartTime,
            SundayEndTime,
            SundayStartTime,
            ThursdayEndTime,
            ThursdayStartTime,
            TimeZoneSidKey,
            TuesdayEndTime,
            TuesdayStartTime,
            WednesdayEndTime,
            WednesdayStartTime
        FROM BusinessHours
        WHERE IsDefault = true LIMIT 1];
		return (dmpl__ResourceBusinessHours__c) TestFactory.createSObject(
            new dmpl__ResourceBusinessHours__c(
				dmpl__BusinessHoursId__c = businessHours.Id,
				dmpl__ResourceId__c = resource.Id,
				dmpl__FromDate__c = Date.today()
			),
			'ResourceBusinessHoursDefaults',
			true
        );
	}

	private static void CreateAccount()
    {   
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'PartnerAccount',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'CustomerAccount',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'SupplierAccount',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
		BusinessHours businessHours = [SELECT
            IsActive,
            Name,
            IsDefault,
            FridayEndTime,
            FridayStartTime,
            MondayEndTime,
            MondayStartTime,
            SaturdayEndTime,
            SaturdayStartTime,
            SundayEndTime,
            SundayStartTime,
            ThursdayEndTime,
            ThursdayStartTime,
            TimeZoneSidKey,
            TuesdayEndTime,
            TuesdayStartTime,
            WednesdayEndTime,
            WednesdayStartTime
        FROM BusinessHours
        WHERE IsDefault = true LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '8888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7777777777',
									   dmpl__PayrollBusinessHoursId__c = businessHours.Id,
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
    }

	@isTest
	private static void ResourceAvailabilityProcessorTest(){
		string query = 'SELECT Id, Name, dmpl__BusinessHoursId__c, dmpl__DefaultBranchId__c, dmpl__DefaultBranchId__r.dmpl__PayrollBusinessHoursId__c FROM  dmpl__Resource__c ';
		dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
		Test.startTest();
		//ResourceAvailabilityProcessor result = new ResourceAvailabilityProcessor(query, jobQueue.Id).processResourceAvailabilities(null, jobQueue.Id);
		JobResponseResult result = ResourceAvailabilityProcessor.processResourceAvailabilities(null, jobQueue.Id); 
		Test.stopTest();
	}
}