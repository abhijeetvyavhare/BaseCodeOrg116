@isTest
public class PerformanceKPIHelper_Test {
	@TestSetup
	static void createRequiredData(){
		CreateAccount();
		CreateBranch();
		CreateItems();
		CreateScheme();

		dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__Scheme__c scheme = [SELECT Id,Name from dmpl__Scheme__c LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];

		dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__AccountId__c = null,
                                                dmpl__SchemeId__c = scheme.Id,
                                                dmpl__SchemePeriodId__c = null, // 
                                                dmpl__ItemId__c = listofitem.Id,
                                                dmpl__TotalAmount__c = 0,
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = 0,
                                                dmpl__TotalSaleOrderAmount__c = 0,
                                                dmpl__TotalSaleInvoiceAmount__c =  0,
                                                dmpl__TotalPurchaseOrderAmount__c =  0,
                                                dmpl__TotalBillAmount__c = 0,
                                                dmpl__TotalRepairOrderAmount__c = 0,
                                                dmpl__TotalSaleOrderQuantity__c =  0,
                                                dmpl__TotalSaleInvoiceQuantity__c = 0,
                                                dmpl__TotalPurchaseOrderQuantity__c =  0,
                                                dmpl__TotalBillQuantity__c =  0,
                                                dmpl__TotalRepairOrderQuantity__c = 0,
                                                dmpl__PostingType__c = 'KPI'
                                                );
		insert newRecord;
	}

	 private static void CreateScheme()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup = [Select Id,Name from dmpl__ItemGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Purchase Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Purchase Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
            								   dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        insert new dmpl__SchemeCondition__c(
                                                dmpl__SchemeId__c = scheme1[0].Id,
                                                dmpl__ItemId__c=item.Id,  
                                                dmpl__ConditionType__c='Item Quantity',
                                                dmpl__ConditionQuantity__c =5,
                                                dmpl__SequenceNumber__c = 1,
                                                dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                dmpl__ConditionOperator__c = 'Greater Than',
        										dmpl__ItemGroupId__c = itemGroup.Id);
        
         insert new dmpl__SchemeBenefit__c(
                                                 dmpl__DiscountPercent__c = 100,
                                                 dmpl__RewardType__c = 'Discounted Item',
                                                 dmpl__SequenceNumber__c = 1,
                                                 dmpl__RepeatReward__c =  true,
                                                 dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                 dmpl__DiscountedItemId__c = item.id);
        
    }
    

	@isTest
	private static void CreatePerformanceKPI()
    {
		dmpl__PerformanceKPI__c performanceKPI = [SELECT Id FROM dmpl__PerformanceKPI__c LIMIT 1];
		

		Test.startTest();
		List<dmpl__PerformanceKPIEvent__e>  event = new List<dmpl__PerformanceKPIEvent__e> ();
		event.add(new dmpl__PerformanceKPIEvent__e(dmpl__ObjectAPIName__c = 'dmpl__SaleOrder__c', dmpl__PerformanceKPIType__c = '', dmpl__RecordId__c = performanceKPI.Id));
        
        Database.SaveResult[] results = EventBus.publish(event);
		Test.stopTest();
    }

	private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Order',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                NumberOfEmployees = 2,
                                Industry = 'Education',
                                AnnualRevenue = 1000,
                                Description = 'Accounts added',
                                dmpl__IsPartnerAccount__c = false,
                                dmpl__IsActive__c = True,
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
    }
    
    private static void CreateItems()
    {
		List<dmpl__ItemGroup__c> itemGroup1 = new List<dmpl__ItemGroup__c> ();
        itemGroup1.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup1;

        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup.Id,
                                          dmpl__Description__c = '',
                                          dmpl__ItemFamily__c = 'Sample',
                                          dmpl__ItemSegment__c = 'Sample',
                                          dmpl__Make__c = 'Sample',
                                          dmpl__Model__c = 'Sample',
                                          dmpl__TrackInventory__c = true,
                                          dmpl__TrackLots__c = true,
                                          dmpl__IsSKURequired__c = true,
                                          dmpl__RequireInspectionOnReceipt__c = true,
                                          dmpl__RequireInspectionOnDelivery__c = true,
                                          dmpl__AllowService__c = true,
                                          dmpl__TrackAsset__c = true,                               
                                          dmpl__IsActive__c = true,
                                          dmpl__IsRegistrationRequired__c = true,
                                          dmpl__GTIN__c = 'BR123',
                                          dmpl__RFID__c = 'O1234fgh',
                                          dmpl__IsPackage__c = true
                                         ));
        insert productItem;
     
    }
}