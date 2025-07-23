@isTest
public class FulfillmentHandler_Test {
    @TestSetup
    static void createRequiredData() {       
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item1.Id, false); 
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.createStorageLocation(
            'Storage Location 1',
            branch1,
            true,
            'Warehouse'
        );  
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partnerAccount1,
            customerAccount1,
            branch1,
            null,
            null
        );
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
    }
    
    @isTest
    public static void editfulfillmentpickingLineWithRemovingRequiredSkuNegative() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU(item9);
        Test.startTest();
 		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item9, 1, 1500, null, null, sku3, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item9.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, fulfillmentOrderLine.dmpl__FulfillmentId__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item9 , 1,sku3 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fulfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fulfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item9.Id, fulfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item9,fulfillmentAllocationLine,null,1,null,null,sku3);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item9.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        try {
            dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
            fulfillmentPickingLine2.dmpl__SKUId__c = null;
            update fulfillmentPickingLine2;
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Specified field is not editable if there exists downstream transaction. Field Name : "dmpl__SKUId__c"'),'Exception message should mention the SKU field restriction, but was: ' + e.getMessage()); 
        }
        Test.stopTest();
    }

    @isTest
    public static void editfulfillmentpickingLineWithNoRequiredSku() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
  		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, null, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item1 , 10 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fulfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fulfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item1.Id, fulfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, fulfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillmentOrderLine.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item1,fulfillmentAllocationLine,10,1500,null);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item1.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(fulfillmentAllocationLine.Id, fulfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        fulfillmentPickingLine.dmpl__Quantity__c = 5;
        update fulfillmentPickingLine;
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        System.assertEquals(5, fulfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(item1.Id, fulfillmentPickingLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, fulfillmentPickingLine2.dmpl__UnitCost__c, 'UnitCost should match');
        System.assertEquals(fulfillmentAllocationLine.Id, fulfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        Test.stopTest();
    }
    
    @isTest
    public static void editFulfillmentpickinglineWithEnteredQuantity() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
 		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, null, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item1 , 10 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item1.Id, fullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, fullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillmentOrderLine.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item1,fullfillmentAllocationLine,10,1500,null);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item1.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fulfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        fulfillmentPickingLine.dmpl__Quantity__c = 5;
        update fulfillmentPickingLine;
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        System.assertEquals(5, fulfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(item1.Id, fulfillmentPickingLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, fulfillmentPickingLine2.dmpl__UnitCost__c, 'UnitCost should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fulfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        Test.stopTest();
    } 
    
    @isTest
    public static void editFulfillmentpickingLineWithSaleOrderLineReference() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.StartTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder1.Id,item.Id,3,null);
        System.assertNotEquals(null,saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals(priceList1.Id,saleOrder1.dmpl__PriceListId__c, 'Account Name should match');
        System.assertEquals('Customer 1',saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State',saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals(630.00,orderLine1.dmpl__Tax1__c,'Tax1 amount should match');
        System.assertEquals('CGST',orderLine1.dmpl__Tax1Name__c,'Tax1 name should match');
        System.assertEquals(14.00,orderLine1.dmpl__Tax1Rate__c,'Tax1 rate should match');
        System.assertEquals('CGST',orderLine1.dmpl__Tax1Type__c,'Tax1 type should match');
        System.assertEquals(630.00,orderLine1.dmpl__Tax2__c,'Tax2 amount should match');
        System.assertEquals('SGST',orderLine1.dmpl__Tax2Name__c,'Tax2 name should match');
        System.assertEquals(14.00,orderLine1.dmpl__Tax2Rate__c,'Tax2 rate should match');
        System.assertEquals('SGST',orderLine1.dmpl__Tax2Type__c,'Tax2 type should match');
        System.assertEquals(4500.00,orderLine1.dmpl__BaseAmount__c,'Base Amount should match');
        System.assertEquals(0.00,orderLine1.dmpl__NetSchemeDiscount__c,'Net Scheme Discount should match');
        System.assertEquals(0.00,orderLine1.dmpl__NetDiscount__c,'Net Discount should match');
        System.assertEquals(1260.00,orderLine1.dmpl__TaxAmount__c,'Total Tax Amount should match');
        System.assertEquals(5760.00,orderLine1.dmpl__GrossAmount__c,'Gross Amount should match');
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertEquals(4500.00,saleOrder2.dmpl__LineSubTotal__c, 'Line Sub Total should match');
        System.assertEquals(4500.00,saleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0.00,saleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(0.00,saleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(1260.00,saleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(1260.00,saleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillment(partnerAccount1,customerAccount1,branch1,null,saleOrder1);
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Fulfillment must get created with partner4');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Fulfillment must get created with branch4');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Fulfillment must get created with customer3');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Fulfillment must get created at draft stage');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(saleOrder2.Id, fulfillment.dmpl__SaleOrderId__c, 'Fulfillment must get created with sale order reference');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment,item,3,1500,null,null,null,orderLine1,null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item.Id,fulfillmentOrderLine.dmpl__ItemId__c,'item should match');
        System.assertEquals(3,fulfillmentOrderLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fulfillmentOrderLine.dmpl__UnitCost__c,'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item,3,1500,null,null,null,orderLine1,fulfillment,fulfillmentOrderLine);
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item.Id,fullfillmentAllocationLine.dmpl__ItemId__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentAllocationLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fullfillmentAllocationLine.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(fulfillmentOrderLine.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        System.assertEquals(orderLine1.Id, fullfillmentAllocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line should match');
        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine1=FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,fullfillmentAllocationLine,item,1500,3,3,orderLine1);
        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine=FulfillmentTestDataHelpers.getFulfillmentPickingLine(fullfillmentPickingLine1.Id);
		System.assertNotEquals(null, fullfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item.Id,fullfillmentPickingLine.dmpl__ItemId__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fullfillmentPickingLine.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__RequestedQuantity__c,'Requested Quantity should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__PickedQuantity__c,'Picked Quantity should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fullfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        fullfillmentPickingLine.dmpl__Quantity__c = 3;
        fullfillmentPickingLine.dmpl__RequestedQuantity__c= 2;
        fullfillmentPickingLine.dmpl__ReturnedQuantity__c= 1;
        update fullfillmentPickingLine;
        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine2=FulfillmentTestDataHelpers.getFulfillmentPickingLine(fullfillmentPickingLine.Id);
        System.assertEquals(3, fullfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2, fullfillmentPickingLine2.dmpl__PickedQuantity__c, 'Picked Quantity should match');
        System.assertEquals(2, fullfillmentPickingLine2.dmpl__RequestedQuantity__c, 'Requested Quantity should match');
        System.assertEquals(1500,fullfillmentPickingLine2.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fullfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithDiscountinuedItemPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item4.Id, false);
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item4, 
            10, 
            2400, 
            null, 
            null, 
            sku4, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item4.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2400, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item4, 
            10, 
            2400, 
            sku4, 
            null, 
            fulfillment, 
            fulfillmentOrderLine, 
            null
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item4.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 5;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item4.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithRemovingRequiredSKUNegativeEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 9', item9.Id, false);
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1,
            customerAccount1,
            branch1,
            null,
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item9, 
            1, 
            1500, 
            null, 
            null, 
            sku3, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item9.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(sku3.Id, retrievedFulfillmentOrderLine.dmpl__SKUId__c, 'SKU ID should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item9 , 
            1, 
            1500, 
            sku3, 
            null, 
            fulfillment, 
            fulfillmentOrderLine, 
            null
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item9.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(1, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        try {
            fullfillmentAllocationLine.dmpl__SKUId__c = null; 
            update fullfillmentAllocationLine;
            System.assert(false, 'Expected an exception due to removing required SKU');
        } catch (DmlException e) {
            String errorMsg = e.getMessage().toLowerCase();
            System.assert(errorMsg.contains('dmpl__skuid__c'), 'Expected validation exception related to dmpl__SKUId__c. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithNoRequiredSKUPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            10, 
            1500, 
            null, 
            null, 
            sku1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item1, 
            10, 
            1500, 
            sku1, 
            null, 
            fulfillment, 
            fulfillmentOrderLine, 
            null
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 3;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(3, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 3');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithStorageLocationPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            5, 
            1500, 
            storageLocation1, 
            null, 
            null, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(storageLocation1.Id, retrievedFulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item1, 
            5, 
            1500, 
            null, 
            null, 
            fulfillment, 
            fulfillmentOrderLine, 
            storageLocation1
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(storageLocation1.Id, retrievedFullfillmentAllocationLine.dmpl__StorageLocationId__c, 'Storage Location ID should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 4;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(4, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 4');
        System.assertEquals(storageLocation1.Id, updatedFullfillmentAllocationLine.dmpl__StorageLocationId__c, 'Storage Location ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithEnteredQuantityPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 8', item8.id, false);
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1,
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item8, 
            17, 
            1500, 
            null, 
            null, 
            sku, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item8.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFulfillmentOrderLine.dmpl__FulfillmentId__c, 'Fulfillment ID should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item8, 
            17, 
            1500,
            null, 
            sku, 
            null, 
            fulfillment, 
            fulfillmentOrderLine
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item8.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 10;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 10');
        System.assertEquals(item8.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be updated to 10');
        System.assertEquals(fulfillment.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should remain the same');
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should be updated to 10');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithSaleOrderLineReferencePositiveEdit(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.StartTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder1.Id,
            item.Id,
            3,
            null
        );
        System.assertNotEquals(null,saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals(priceList1.Id,saleOrder1.dmpl__PriceListId__c, 'Account Name should match');
        System.assertEquals('Customer 1',saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State',saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals(630.00,orderLine1.dmpl__Tax1__c,'Tax1 amount should match');
        System.assertEquals('CGST',orderLine1.dmpl__Tax1Name__c,'Tax1 name should match');
        System.assertEquals(14.00,orderLine1.dmpl__Tax1Rate__c,'Tax1 rate should match');
        System.assertEquals('CGST',orderLine1.dmpl__Tax1Type__c,'Tax1 type should match');
        System.assertEquals(630.00,orderLine1.dmpl__Tax2__c,'Tax2 amount should match');
        System.assertEquals('SGST',orderLine1.dmpl__Tax2Name__c,'Tax2 name should match');
        System.assertEquals(14.00,orderLine1.dmpl__Tax2Rate__c,'Tax2 rate should match');
        System.assertEquals('SGST',orderLine1.dmpl__Tax2Type__c,'Tax2 type should match');
        System.assertEquals(4500.00,orderLine1.dmpl__BaseAmount__c,'Base Amount should match');
        System.assertEquals(0.00,orderLine1.dmpl__NetSchemeDiscount__c,'Net Scheme Discount should match');
        System.assertEquals(0.00,orderLine1.dmpl__NetDiscount__c,'Net Discount should match');
        System.assertEquals(1260.00,orderLine1.dmpl__TaxAmount__c,'Total Tax Amount should match');
        System.assertEquals(5760.00,orderLine1.dmpl__GrossAmount__c,'Gross Amount should match');
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertEquals(4500.00,saleOrder2.dmpl__LineSubTotal__c, 'Line Sub Total should match');
        System.assertEquals(4500.00,saleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0.00,saleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(0.00,saleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(1260.00,saleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(1260.00,saleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(5760.00,saleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partnerAccount1,
            customerAccount1,
            branch1,
            null,
            saleOrder1
        );
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Fulfillment must get created with partner4');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Fulfillment must get created with branch4');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Fulfillment must get created with customer3');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Fulfillment must get created at draft stage');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(saleOrder2.Id, fulfillment.dmpl__SaleOrderId__c, 'Fulfillment must get created with sale order reference');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment,
            item,
            3,
            1500,
            null,
            null,
            null,
            orderLine1,
            null
        );
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item.Id,fulfillmentOrderLine.dmpl__ItemId__c,'item should match');
        System.assertEquals(3,fulfillmentOrderLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fulfillmentOrderLine.dmpl__UnitCost__c,'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item,
            3,
            1500,
            null,
            null,
            null,
            orderLine1,
            fulfillment,
            fulfillmentOrderLine
        );
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item.Id,fullfillmentAllocationLine.dmpl__ItemId__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentAllocationLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fullfillmentAllocationLine.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(fulfillmentOrderLine.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        System.assertEquals(orderLine1.Id, fullfillmentAllocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line should match');
        fullfillmentAllocationLine1.dmpl__Quantity__c = 3;
        update fullfillmentAllocationLine1;
        dmpl__InventoryFulfillmentAllocationLine__c updatedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertEquals(3, updatedAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingPickingQuantity__c, 'Pending Picking Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__Quantity__c, 'Quantity should be 3');
        System.assertEquals(1500, updatedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(saleOrderLine.Id, updatedAllocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithRepairOrderLineReferencePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset1 =FulfillmentTestDataHelpers.createAsset('Asset 1',customerAccount1,item1);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 8', item8.id, false);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = FulfillmentTestDataHelpers.createRepairOrder(
            partner1, 
            branch1, 
            customerAccount1, 
            asset1, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        dmpl__RepairOrder__c retrievedRepairOrder = FulfillmentTestDataHelpers.getRepairOrder(repairOrder.Id);
        System.assertEquals(partner1.Id, retrievedRepairOrder.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedRepairOrder.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedRepairOrder.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(asset1.Id, retrievedRepairOrder.dmpl__AssetId__c, 'Asset ID should match');
        System.assertEquals(Date.today(), retrievedRepairOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedRepairOrder.dmpl__Status__c, 'Status should be Draft');
        dmpl__RepairOrderLine__c repairOrderLine = FulfillmentTestDataHelpers.createRepairOrderLine(
            repairOrder, 
            item8,
            10, 
            999
        );
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        dmpl__RepairOrderLine__c retrievedRepairOrderLine = FulfillmentTestDataHelpers.getRepairOrderLine(repairOrderLine.Id);
        System.assertEquals(item8.Id, retrievedRepairOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedRepairOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(partner1.Id, retrievedRepairOrderLine.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedRepairOrderLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(9990, retrievedRepairOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(repairOrder.Id, retrievedRepairOrderLine.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(9990, retrievedRepairOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partner1, 
            customerAccount1, 
            branch1, 
            repairOrder, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(Date.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(repairOrder.Id, retrievedFulfillment.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item8, 
            17, 
            999, 
            null, 
            null, 
            sku, 
            null, 
            repairOrderLine
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item8.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(999, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(repairOrderLine.Id, retrievedFulfillmentOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__PendingAllocationQuantity__c, 'Pending Allocation Quantity should match');
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item8,
            10, 
            sku, 
            999, 
            fulfillment, 
            fulfillmentOrderLine, 
            repairOrderLine
        );
        System.assertNotEquals(null, allocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(allocationLine.Id);
        System.assertEquals(item8.Id, retrievedAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(999, retrievedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment Order ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        System.assertEquals(repairOrderLine.Id, retrievedAllocationLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should match');
        allocationLine.dmpl__Quantity__c = 8;
        update allocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(allocationLine.Id);
        System.assertEquals(8, updatedAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 8');
        System.assertEquals(item8.Id, updatedAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(999, updatedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(fulfillment.Id, updatedAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment Order ID should remain the same');
        System.assertEquals(fulfillmentOrderLine.Id, updatedAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should remain the same');
        System.assertEquals(repairOrderLine.Id, updatedAllocationLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should remain the same');
        Test.stopTest();
    }
    
    @isTest
    public static void fulfillmentAllocationLineWithNoItemLotPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            10, 
            1500, 
            null, 
            null, 
            sku1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item1, 
            10, 
            1500, 
            null, 
            sku1, 
            null, 
            fulfillment, 
            fulfillmentOrderLine
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 9;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(9, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 9');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        Test.stopTest();
    }

    @isTest
    public static void fulfillmentAllocationLineWithZeroQuantityNegativeNew(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            5, 
            1500, 
            null,
            null, 
            sku1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        try {
            dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine =
                FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
                    item1,
                    0, 
                    1500, 
                    null, 
                    sku1, 
                    null, 
                    fulfillment, 
                    fulfillmentOrderLine
                );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('dmpl__quantity__c') && errorMsg.contains('expects') && errorMsg.contains('postive');
            System.assert(correctExceptionThrown,'Expected validation exception related to dmpl__Quantity__c requiring positive decimal. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void fulfillmentAllocationLineWithZeroQuantityNegativeEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            15, 
            1500, 
            null, 
            null, 
            sku1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(15, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item1, 
            10, 
            1500,
            null, 
            sku1, 
            null, 
            fulfillment, 
            fulfillmentOrderLine
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        try {
            fullfillmentAllocationLine.dmpl__Quantity__c = 0;
            update fullfillmentAllocationLine;
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('dmpl__quantity__c') && errorMsg.contains('expects') && errorMsg.contains('postive decimals');
            System.assert(correctExceptionThrown,'Expected validation exception related to dmpl__Quantity__c requiring positive decimal. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void fulfillmentAllocationLineWithFulfillmentOrderLineReferencePositiveEdit() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partner1, 
            customerAccount1, 
            branch1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment, 
            item1, 
            10, 
            1500, 
            null, 
            null, 
            sku1, 
            null, 
            null
        );
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item1, 
            10, 
            1500, 
            null, 
            sku1, 
            null, 
            fulfillment, 
            fulfillmentOrderLine
        );
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        fullfillmentAllocationLine.dmpl__Quantity__c = 5;
        update fullfillmentAllocationLine;
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be updated to 5');
        System.assertEquals(fulfillment.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should remain the same');
        System.assertEquals(fulfillmentOrderLine.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should remain the same');  
        Test.stopTest();
    }
    
    @isTest
    public static void createFulfillmentOrderLineWithZeroQuantityNew() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation2 = FulfillmentTestDataHelpers.createStorageLocation('Storage Location 2',branch1,true,'Warehouse');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        try {
            dmpl__InventoryFulfillmentOrderLine__c invalidFulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
                fulfillment,
                item1,
                0,
                null,
                storageLocation2,
                null,
                null,
                null,
                null
            );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('quantity') &&
                                             (
                                                 errorMsg.contains('expects postive decimals') ||  
                                                 errorMsg.contains('at least') || 
                                                 errorMsg.contains('must be greater than') || 
                                                 errorMsg.contains('cannot be created') || 
                                                 errorMsg.contains('required')
                                             );
        
            System.assert(correctExceptionThrown, 
                'Expected validation exception related to dmpl__Quantity__c; actual message: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithZeroQuantityEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item5, 5, 1000, null, null, null, null, null);
        Test.stopTest();
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(item5.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        try {
            dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
            fulfillmentOrderLine1.dmpl__Quantity__c = 0;
            update fulfillmentOrderLine1;
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('dmpl__quantity__c') &&
                                             (errorMsg.contains('positive') || errorMsg.contains('postive') || errorMsg.contains('expects'));
            System.assert(correctExceptionThrown, 'Expected validation exception related to dmpl__Quantity__c requiring positive decimal. Actual message: ' + e.getMessage());
        }
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithDiscountinuedItemEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        dmpl__StorageLocation__c storageLocation2 = FulfillmentTestDataHelpers.createStorageLocation('Storage Location 2',branch1,true,'Warehouse');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment,item1,1,null,storageLocation2,null,null,null,null);
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account Id Mismatch');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch Id Mismatch');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account Id Mismatch');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'item Id Mismatch');
        System.assertEquals(1, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(storageLocation2.Id, fulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location Id Mismatch');
        fulfillmentOrderLine.dmpl__ItemId__c = item4.Id;
        update fulfillmentOrderLine;
        System.assertEquals(item4.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'item Id Mismatch');
        System.assertEquals(1.0, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(storageLocation2.Id, fulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location Id Mismatch');
        Test.stopTest();
    }
    
	@isTest
    static void updateFulfillmentOrderLineWithSaleOrderLineReferenceEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1=SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder1.Id,item1.Id,12,null);
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(partnerAccount1, customerAccount1, branch1,null,saleOrder1,Date.today(),'Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 12, 1500, null, null, null, saleOrderLine, null);
        dmpl__SaleOrderLine__c saleOrderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals(customerAccount1.Id, saleOrder1.dmpl__AccountId__c, 'Account ID should be Customer 1 ID');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List Id Mismatch');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        System.assertEquals(Date.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
        System.assertNotEquals(null, saleOrderLine1.Id, 'Sale Order Line should be created');
        System.assertEquals('GST 28', saleOrderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should be GST 28');
        System.assertEquals(18000, saleOrderLine1.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(0, saleOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
        System.assertEquals(0, saleOrderLine1.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(5040, saleOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, saleOrderLine1.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(1500, saleOrderLine1.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(2520, saleOrderLine1.dmpl__Tax1__c, 'Tax1 should be 2520');
        System.assertEquals('CGST', saleOrderLine1.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleOrderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', saleOrderLine1.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2520, saleOrderLine1.dmpl__Tax2__c, 'Tax2 should be 2520');
        System.assertEquals('SGST', saleOrderLine1.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleOrderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', saleOrderLine1.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(18000, saleOrderLine1.dmpl__BaseAmount__c, 'Base Amount should be 18000');
        System.assertEquals(0, saleOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, saleOrderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(5040, saleOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, saleOrderLine1.dmpl__GrossAmount__c, 'Gross Amount should be 23040');
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should be Partner 1');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should be Branch 1');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should be Customer 1');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(12, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 12');
        System.assertEquals(saleOrderLine.Id, fulfillmentOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should be same');
        fulfillmentOrderLine.dmpl__Quantity__c = 10;
        update fulfillmentOrderLine;
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(saleOrderLine.Id, fulfillmentOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should be same');
        Test.stopTest();
    }

    @isTest
    public static void updateFulfillmentOrderLineWithInactiveItemEdit() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id,true,true,false,false);
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.createInventoryFulfillment(partnerAccount,customerAccount,branch,null,null);
        System.assertEquals(partnerAccount.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account Id Mismatch');
        System.assertEquals(branch.Id, fulfillment.dmpl__BranchId__c, 'Branch Id Mismatch');
        System.assertEquals(customerAccount.Id, fulfillment.dmpl__AccountId__c, 'Customer Account Id Mismatch');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Satus should be Draft');
        try {
            dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment,item,8.0,2400,null,null,null,null,null);
            fulfillmentOrderLine.dmpl__Quantity__c = 10.0;
            update fulfillmentOrderLine;
            System.assert(true, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('field_filter_validation_exception') && errorMsg.contains('dmpl__itemid__c');
            System.assert(correctExceptionThrown, 'Expected FIELD_FILTER_VALIDATION_EXCEPTION related to dmpl__ItemId__c');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithRemovingRequiredSKUEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8', 'Product');
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU(item9);
        Test.startTest();        
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment,item9,1.0,1500,null,null,sku3,null,null);
        Test.stopTest(); 
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account Id Mismatch');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch Id Mismatch');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account Id Mismatch');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Date should be Today');
        System.assertEquals(item9.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'item Id Mismatch');
        System.assertEquals(1.0, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
        try {
            dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
            fulfillmentOrderLine1.dmpl__SKUId__c = null;
            update fulfillmentOrderLine;
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('sku') || errorMsg.contains('dmpl__SKUId__c') || errorMsg.contains('required');
            System.assert(correctExceptionThrown, 'Expected validation exception related to missing SKU for item9.');
        }
    }
    @isTest 
    public static void updateFulfillmentOrderLineWithNoRequiredSKUEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Product');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 5, 1500, null, null, null, null, null);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should be Partner 1');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should be Branch 1');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should be Customer 1');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(5, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        fulfillmentOrderLine.dmpl__ItemId__c = item3.Id;
        fulfillmentOrderLine.dmpl__UnitCost__c = 2000;
        System.assertEquals(item3.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 3');
        System.assertEquals(2000, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 2000');
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithStorageLocationEdit() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 20, null, storageLocation1, null, null, null, null);
        Test.stopTest();
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should be Partner 1');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should be Branch 1');
        System.assertEquals(storageLocation1.Id, fulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID should be Storage Location 1');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be item 1');
        System.assertEquals(20, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 20');
        fulfillmentOrderLine.dmpl__Quantity__c = 15;
        update fulfillmentOrderLine;
        System.assertEquals(15, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(storageLocation1.Id, fulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID should be Storage Location 1');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be item 1');

    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithEnteredQuantityEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 1, 1500, null, null, null, null, null);
        Test.stopTest();
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        fulfillmentOrderLine.dmpl__Quantity__c = 2;
        update fulfillmentOrderLine;
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(2, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');        
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithNoItemLotEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU(item7);        
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item7, 3, 1500, null, null, sku1, null, null);
        Test.stopTest();
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(item7.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(3, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        fulfillmentOrderLine.dmpl__ItemId__c = item1.Id;
        fulfillmentOrderLine.dmpl__Quantity__c = 8;
        update fulfillmentOrderLine;
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(8, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
    }

    @isTest
    public static void FulfillmentDoesNotGetCreatedWithInactiveBranch(){
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch(partner3);
        test.startTest();
        try {
            dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
                    partner3,
                    customerAccount1,
                    branch3,
                    null,
                    null
                );
            } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Fulfillment.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    public static void FulfillmentDoesNotGetCreatedWithInactivePartnerAccount(){
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch(partner2);
        test.startTest();
        try {
            dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
                    partner2,
                    customerAccount1,
                    branch2,
                    null,
                    null
                );
            } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create Fulfillment.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    public static void FulfillmentCreatedWithValidPartnerAccountAndBranch(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1,
            customerAccount1,
            branch1,
            null,
            null
        );
        system.assertNotEquals(null, fulfillment.Id, 'Fulfuillment should be created');
        test.stopTest();
    }

    @isTest
    public static void FulfillmentCreatedWithSaleOrder(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        test.startTest();
        dmpl__SaleOrder__c saleorder = FulfillmentTestDataHelpers.createSaleOrder(Partner1,branch1,customerAccount1);
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1,
            customerAccount1,
            branch1,
            null,
            null
        );
        system.assertNotEquals(null, fulfillment.Id, 'Fulfuillment should be created');
        fulfillment.dmpl__SaleOrderId__c = saleorder.ID;
        update fulfillment;
        test.stopTest();
    }

    @isTest
    public static void FulfillmentCreatedWithRepairOrder(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset1 = FulfillmentTestDataHelpers.createAsset('Asset 1',customerAccount1,item1);
        test.startTest();
        dmpl__RepairOrder__c repairOrder = FulfillmentTestDataHelpers.createRepairOrder(Partner1,branch1,customerAccount1,
            asset1,
            1000
        );
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            Partner1,
            customerAccount1,
            branch1,
            null,
            null
        );
        system.assertNotEquals(null, fulfillment.Id, 'Fulfuillment should be created');
        fulfillment.dmpl__RepairOrderId__c = repairOrder.Id;
        update fulfillment;
        test.stopTest();
    }
}