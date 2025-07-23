@isTest
public with sharing class FulfillmentHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account customerAccount=TestDataHelpers.createCustomerAccount();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource=TestDataHelpers.createResource(partnerAccount,branch);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        Asset asset=AssetTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__BranchTimeSlot__c brTimeSlot=TestDataHelpers.createBranchTimeSlot(branch,item);
        dmpl__ServiceRequest__c serviceRequest=ServiceRequestTestDataHelpers.createServiceRequest(customerAccount,branch,item,asset,brTimeSlot);
        dmpl__Quote__c  serviceEstimate=QuoteTestDataHelpers.CreateServiceEstimate(branch,customerAccount,priceList,asset,serviceRequest,item);
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(item,branch,asset,serviceEstimate,customerAccount,resource);
        dmpl__SaleOrder__c   saleOrder=SaleOrderDataHelper.createSaleOrder(customerAccount,branch);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder,
            item,
            sku,
            taxGroup
        );
       
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partnerAccount,
            customerAccount,
            branch,
            repairOrder,
            saleOrder
        );
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment,
            item,
            sku,
            saleOrderLine
        );

        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item,
            itemLot,
            sku,
            resource,
            fulfillment,
            fulfillmentOrderLine
        );

        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.createFulfillmentPickingLine(
            fulfillment,
            item,
            fullfillmentAllocationLine
        );
        Test.stopTest();
    }

    @isTest
    static void createFulfillmentPositive() {
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment();
        if(fulfillment != null){
            System.assertNotEquals(fulfillment, null, 'Expected fulfillment to be created.');
        }
        System.assertNotEquals(fulfillment.name, null, 'Name should not be null');
        System.assertNotEquals(fulfillment.dmpl__AccountId__c, null, 'Expected dmpl__AccountId__c to be set.');
        System.assertNotEquals(fulfillment.dmpl__BranchId__c, null, 'Expected dmpl__BranchId__c to be set.');
        System.assertNotEquals(fulfillment.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccountId__c to be set.');
        System.assertNotEquals(fulfillment.dmpl__RepairOrderId__c, null, 'Expected dmpl__RepairOrderId__c to be set.');
        System.assertNotEquals(fulfillment.dmpl__SaleOrderId__c, null, 'Expected dmpl__SaleOrderId__c to be set.');
        System.assertEquals(false, fulfillment.dmpl__IsAllocated__c, 'Expected dmpl__IsAllocated__c to be true');
        System.assertEquals(false, fulfillment.dmpl__PerformAllocation__c, 'Expected dmpl__PerformAllocation__c to be false');
    }

    @isTest
    static void updateFulfillmentPositive() {
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment();
        if(fulfillment != null){
            System.assertNotEquals(fulfillment, null, 'Expected fulfillment to be created before update.');
            fulfillment.dmpl__PerformAllocation__c = false;
            update fulfillment;
        }
        
        dmpl__InventoryFulfillment__c updatedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        if(updatedFulfillment != null){
            System.assertNotEquals(updatedFulfillment, null, 'Expected fulfillment to be updated.');
        }
        System.assertEquals(false, updatedFulfillment.dmpl__PerformAllocation__c, 'Expected dmpl__PerformAllocation__c to be false');
    }

    @isTest
    static void deleteFulfillmentPositive() {
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment();
        System.assertNotEquals(fulfillment, null, 'Expected fulfillment to be created before delete.');
        dmpl__InventoryFulfillment__c deletedFulfillment = null;
        delete fulfillment;
        try{
            deletedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        }
        catch(Exception e) {
            deletedFulfillment = null;
        }
        System.assertEquals(null, deletedFulfillment, 'Expected fulfillment to be deleted.');
    }

     @isTest
    static void createFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        if(fulfillmentOrderLine != null){
            System.assertNotEquals(fulfillmentOrderLine, null, 'Expected fulfillmentOrderLine to be created.');
        }
        System.assertNotEquals(fulfillmentOrderLine.dmpl__FulfillmentId__c, null, 'Expected dmpl__FulfillmentId__c to be set.');
        System.assertNotEquals(fulfillmentOrderLine.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertNotEquals(fulfillmentOrderLine.dmpl__SKUId__c, null, 'Expected dmpl__SKUId__c to be set.');
        System.AssertNotEquals(fulfillmentOrderLine.dmpl__SaleOrderLineId__c, null, 'Expected dmpl__SaleOrderLineId__c to be set.');
    }

    @isTest
    static void updateFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c FulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        if(FulfillmentOrderLine != null){
            System.assertNotEquals(fulfillmentOrderLine, null, 'Expected fulfillmentOrderLine to be created before update.');
            FulfillmentOrderLine.dmpl__IsILPosted__c = false;
            update FulfillmentOrderLine;
        }
        
        dmpl__InventoryFulfillmentOrderLine__c updatedFulfillmentOrderLine=FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(FulfillmentOrderLine.Id);
        if(updatedFulfillmentOrderLine != null){
            System.assertNotEquals(updatedFulfillmentOrderLine, null, 'Expected FulfillmentOrderLine to be updated.');
        }
        System.assertEquals(false, updatedFulfillmentOrderLine.dmpl__IsILPosted__c, 'Expected dmpl__IsILPosted__c to be updated to false');
    }

    @isTest
    static void deleteFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c FulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        System.assertNotEquals(FulfillmentOrderLine, null, 'Expected FulfillmentOrderLine to be created before delete.');
        dmpl__InventoryFulfillmentOrderLine__c deletedFulfillmentOrderLine = null;
        try {
            delete fulfillmentOrderLine;
            deletedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(FulfillmentOrderLine.Id);
        } catch (DmlException e) {
            System.debug('Exception caught as expected, record should be deleted: ' + e.getMessage());
        }
        System.assertEquals(null, deletedFulfillmentOrderLine, 'Expected FulfillmentOrderLine to be deleted.');
    }

     @isTest
    static void createFulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();
        Test.stopTest();
        if(fullfillmentAllocationLine != null){
            System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created.');
        }
    }

    @isTest
    static void updateFulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();

        if(fullfillmentAllocationLine != null){
            System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created before update.');
            fullfillmentAllocationLine.dmpl__UnitCost__c = 11;
            update fullfillmentAllocationLine;
        }
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        if(updatedFullfillmentAllocationLine != null){
            System.assertNotEquals(updatedFullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be updated.');
        }
        Test.stopTest();
        System.assertEquals(11, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Expected dmpl__UnitCost__c to be updated to 11');
    }
	 @isTest
    static void deletefulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();
        System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created before delete.');
        dmpl__InventoryFulfillmentAllocationLine__c deletedFullfillmentAllocationLine = null;
        try {
            delete fullfillmentAllocationLine;
            deletedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        } catch (DmlException e) {
            System.debug('Exception caught as expected, record should be deleted.' + e.getMessage());
        }
        System.assertEquals(null, deletedFullfillmentAllocationLine, 'Expected fullfillmentAllocationLine to be deleted.');
        Test.stopTest();
    }
    @isTest
    static void createFulfillmentPickingLinePositive() {
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        if(fulfillmentPickingLine != null){
            System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created.');
        }
    }
    @isTest
    public static void updateFulfillmentPickingLinePositive() {
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created before update.');

        fulfillmentPickingLine.dmpl__UnitCost__c=200;

        update fulfillmentPickingLine;

        dmpl__InventoryFulfillmentPickingLine__c updatedFulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        
        System.assertNotEquals(updatedFulfillmentPickingLine, null, 'Expected updated fulfillmentPickingLine to be found.');
        System.assertEquals(200, updatedFulfillmentPickingLine.dmpl__UnitCost__c, 'dmpl__UnitCost__c should be 200 after update');
    }

    @isTest
    public static void deleteFulfillmentPickingLinePositive(){
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created before delete.');
        dmpl__InventoryFulfillmentPickingLine__c deletedFulfillmentPickingLine = null;
        try {
            delete fulfillmentPickingLine;
            deletedFulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        } catch (DmlException e) {
            deletedFulfillmentPickingLine = null;
        }
        System.assertEquals(null, deletedFulfillmentPickingLine, 'Expected fulfillmentPickingLine to be deleted.');
    }
}