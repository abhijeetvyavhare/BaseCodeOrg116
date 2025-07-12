@isTest
public with sharing class BulkOrderLineBatch_Test {
	@TestSetup
	static void createRequiredData() {
		Account customerAccount = AccountDataHelper.createCustomerAccount('CustomerAccount');
		Account partnerAccount = AccountDataHelper.createPartnerAccount('Partner-Test-Account');
		dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
		CreateBranch();
		CreateItems();
		CreateSKu();
		CreateItemLot();
		CreateTaxGroup();
		//CreateContactAddress();
		CreateSaleOrder();
		Test.startTest();
		CreateSaleInvoice();
		CreateSaleInvoiceLine();
		Test.stopTest();
        dmpl__JobQueueRecord__c jobQueueRecord = createJobQueueRecord(jobQueue);
	}

	private static dmpl__JobQueueRecord__c createJobQueueRecord(dmpl__InterfaceQueue__c jobQueue) {
        return (dmpl__JobQueueRecord__c) TestFactory.createSObject(
            new dmpl__JobQueueRecord__c(
                dmpl__JobQueueId__c = jobQueue.Id,
                dmpl__Quantity__c = 12,
                dmpl__Message__c= 'This is job queue record message',
				dmpl__SaleOrderId__c = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1].id, 
            	dmpl__SaleOrderLineId__c = [SELECT Id FROM dmpl__SaleOrderLine__c LIMIT 1 ].Id,
				dmpl__Status__c = 'Pending', 
            	dmpl__ItemLotId__c  = [SELECT Id FROM dmpl__ItemLot__c LIMIT 1].Id
            ),
            'JobQueueRecordDefaults',
            true
        );
    }

	private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = '',
                                   dmpl__ItemSubType__c = '',
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
                                   dmpl__RFID__c = 'O1234fgh'
                                   
                                  ));
        insert item;
    }

	 private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
    }

	private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__BatchNo__c = '12345',
										 dmpl__SerialNumber__c = 'BBBC',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100,
										 dmpl__HoldCode__c = null
                                         //dmpl__QuantityExpired__c = 1,
                                         //dmpl__QuantityOnHold__c = 1,
                                         //dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(dmpl__LandedCost__c = 1000,
                                               dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c));
        insert relatedItemLot;
    }

	private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com',
                                       dmpl__Website__c = 'www.Dealer.com'));
        insert branch;
    }


	
	private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DocumentDate__c = Date.today(),
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AccountId__c = customerAccount.Id,
												//  dmpl__InvoiceGroup__c = 'Part',
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c =10
                                                ));
        insert saleInvoice;
    }

	private static void CreateSaleInvoiceLine()
    {
        dmpl__SaleInvoice__c saleInvoice = [SELECT Id FROM dmpl__SaleInvoice__c];
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c WHERE dmpl__ItemCode__c = 'DMPL' LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c WHERE dmpl__ItemId__r.dmpl__ItemCode__c = 'DMPL' LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id FROM dmpl__ItemLot__c WHERE dmpl__SerialNumber__c = 'BBBC' LIMIT 1];
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        saleInvoiceLine.add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                         dmpl__Quantity__c = 1,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SkuId__c = sku.Id,
                                                         dmpl__ItemId__c = item.Id));
        insert saleInvoiceLine;       
    }

	private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name,dmpl__IsActive__c From dmpl__Resource__c WHERE dmpl__IsActive__c = true LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             //dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
    
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        //dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c=taxGroup.Id,
                                                     dmpl__UnitPrice__c = 10,
                                                     dmpl__Discount__c = 3
													//  dmpl__InvoiceGroup__c = 'Parts'
                                                    ));
        insert saleOrderLine;
    }

	private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
    }

	private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> address = new List<dmpl__ContactAddress__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        address.Add(new dmpl__ContactAddress__c(dmpl__AccountId__c = partnerAccount.Id,
                                      			Name = 'Test-Branch',
                                                dmpl__City__c = 'Pune',
                                                dmpl__Street__c = 'Jalandhar',
                                                dmpl__Region__c= 'Panjab',
                                                dmpl__State__c = 'Punjab',
                                                dmpl__Country__c = 'India',
                                                dmpl__PostalCode__c = '144401',
                                                dmpl__AddressType__c = 'Both'
                                                ));
        insert address;
    }


	@isTest
	public static void runBulkOrderLineTest(){
		dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
		dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
		string query = 'SELECT Id,Name, dmpl__SaleOrderId__c, dmpl__SaleOrderLineId__c, dmpl__Status__c FROM dmpl__JobQueueRecord__c WHERE dmpl__Status__c = \'Pending\' AND dmpl__JobQueueId__c =  \'' +jobQueue.Id+ '\'  ORDER BY CreatedDate DESC';
		System.Assert.isTrue(jobQueue != null);
		BulkOrderLineBatch bulkBatch = new BulkOrderLineBatch(query,jobQueue.Id);
		dmpl__SaleInvoiceLine__c saleInvoiceLine = [SELECT dmpl__SaleOrderLineId__c,
															dmpl__ItemId__c,
															dmpl__UnitPrice__c,
															dmpl__UnitPrice2__c,  
															dmpl__Quantity__c,
															dmpl__TaxGroupId__c,
															dmpl__IsPriceBundled__c,
															dmpl__ItemComponentId__c,
															dmpl__PackageSaleOrderLineId__c,
															dmpl__Discount__c,
															dmpl__Discount2__c,
															dmpl__DiscountGroupRuleId__c,
															dmpl__DiscountAmount__c,
															dmpl__DiscountAmount2__c,
															dmpl__BillingType__c,
															dmpl__BillingFrequency__c,
															dmpl__ChargeType__c,
															dmpl__SaleInvoiceId__c  FROM dmpl__SaleInvoiceLine__c LIMIT 1 ];
		dmpl__SaleOrderLine__c saleOrderLine = [SELECT  dmpl__ItemLotTypeId__c  FROM dmpl__SaleOrderLine__c LIMIT 1 ];
		Test.startTest();
		Database.executeBatch(bulkBatch);
		// bulkBatch.perfromAction(jobQueueRecord.Id, jobQueue.Id);
		Test.stopTest();
	}
}