@isTest
public with sharing class ProductDemoHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
    }
    
    @isTest
    static void testInsertProductDemo() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount1, branch1);
        Test.startTest();
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount, 
            branch1, 
            resource
        );
        Test.stopTest();
        System.assert(productDemo != null && productDemo.Id != null, 'Product Demo should be inserted.');
    }
    
    @isTest
    static void testUpdateProductDemo() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount1, branch1);
        Test.startTest();
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount, 
            branch1, 
            resource
        );
        productDemo.dmpl__CancellationReason__c = 'Lapsed';
        productDemo.dmpl__DemoAddress__c = 'Address2';
        productDemo.dmpl__DemoAssetNumber__c = '2';
        productDemo.dmpl__DemoRating__c = '4';
        Database.SaveResult updateResult = Database.update(productDemo, false);
        Test.stopTest();
        System.assert(updateResult.isSuccess(), 'Update should be successful');
        System.assertEquals(0, updateResult.getErrors().size(), 'There should be no errors on update');
    }
    
    @isTest
    static void testDeleteProductDemo() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount1, branch1);
        Test.startTest();
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount, 
            branch1, 
            resource
        );
        Database.DeleteResult deleteResult = Database.delete(productDemo, false);
        Test.stopTest();
        System.assert(deleteResult.isSuccess(), 'Delete should be successful');
        System.assertEquals(0, deleteResult.getErrors().size(), 'There should be no errors on delete');
    }
    
    @isTest
    public static void appointmentCreationDemoTimeAcceptedIn12HourPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(12, 0, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationDemoTimeAcceptedIn24HourFormatPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(12, 0, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationAppointmentWithDemoDateTime30MinsAheadPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationAppointmentWithIsDemoOnsiteDisabledVirtualDemoPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationPartnerAccountLookupFiltersOnlyActivePartnersPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationAppointmentWithAssignedSalesExecutivePositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            neededTime, 
            UserInfo.getUserId(), 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationAppointmentSavedWithMinimalRequiredFieldsPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationMissingRequiredPartnerAccountNegativeNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        try{
            dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
                null, 
                customerAccount1, 
                branch1, 
                item1, 
                Date.today(), 
                neededTime, 
                UserInfo.getUserId(), 
                false, 
                '', 
                ''
            );
            System.assert(true, 'Exception should not be thrown');
        }catch(exception e){
            System.assert(true, 'Exception message should be PartnerAccountId is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationPastDemoDatePositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today().addDays(-7), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today().addDays(-7), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationDemoOnsiteCheckedButDemoAddressIsBlankPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today(), 
            null, 
            null, 
            true, 
            null, 
            null
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(true, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals(null, productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals(null, productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationDemoSlotIsUnavailableNegativeNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        try{
            dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
                partnerAccount1, 
                customerAccount1, 
                branch1, 
                null, 
                null, 
                null, 
                null, 
                false, 
                '', 
                ''
            );
            System.assert(false, 'It should not be created');
        }catch(exception e){
            System.assert(true, 'Exception message should be DemoDate is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationInactiveItemSelectedPositiveNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationExceedCharacterLimitInRemarksNegativeNew(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        try{
            dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
                partnerAccount1, 
                customerAccount1, 
                branch1, 
                item1, 
                Date.today(), 
                null, 
                null, 
                false, 
                '', 
                'Salesforce is a leading customer relationship management (CRM) platform that has revolutionized how businesses manage and interact with their customers. Founded in 1999, Salesforce has grown to become the worlds #1 CRM, offering a suite of cloud-based applications designed to help businesses streamline operations, improve customer engagement, and drive growth.At its core, Salesforce enables businesses to track and manage customer interactions across various touchpoints, providing a 360-degree view of the customer. This is crucial for creating personalized experiences, enhancing customer satisfaction, and boosting customer loyalty. With tools for sales, marketing, service, and analytics, Salesforce empowers organizations to optimize their processes and improve decision-making.One of the key features of Salesforce is its cloud-based architecture, which allows businesses to access their CRM data from anywhere, at any time, without the need for complex infrastructure. The platform is also highly customizable, enabling businesses to tailor the system to their specific needs using Salesforce rich set of tools like Apex (for server-side logic), Visualforce (for custom user interfaces), and Lightning (for building modern, responsive apps).Salesforce has also integrated artificial intelligence through Einstein, which leverages machine learning and data analytics to provide businesses with insights, recommendations, and predictive analytics. This allows sales teams to forecast more accurately and service teams to deliver proactive support to customers.The Salesforce ecosystem includes a vibrant AppExchange, where businesses can find and install third-party applications to extend Salesforce’s capabilities. Whether you are a small business or a large enterprise, Salesforce’s scalability and flexibility make it a powerful tool to drive growth, enhance productivity, and create stronger customer relationships. With continuous innovation, Salesforce remains at the forefront of digital transformation, enabling organizations to thrive in the digital age.'
            );
            System.assert(false, 'It should not be created');
        }catch(exception e){
            System.assert(true, 'Exception message should be Remarks exceeds the maximum length');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationEditDemoDateAndTimeForUpcomingAppointmentPositiveEdit(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        productDemo.dmpl__DemoDate__c = Date.today().addDays(7);
        productDemo.dmpl__DemoTime__c = neededTime;
        update productDemo;
        System.assertEquals(Date.today().addDays(7), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationChangeSalesExecutiveAssignedPositiveEdit(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        productDemo.dmpl__SalesExecutiveId__c = UserInfo.getUserId();
        update productDemo;
        System.assertEquals(UserInfo.getUserId(), productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationEditDemoDateToPastDatePositiveEdit(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            null, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(null, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        productDemo.dmpl__DemoDate__c = Date.today().addDays(-7);
        productDemo.dmpl__DemoTime__c = neededTime;
        update productDemo;
        System.assertEquals(Date.today().addDays(-7), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(neededTime, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationRemoveItemAfterCreationNegativeEdit(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        productDemo.dmpl__ItemId__c = null;
        try{
            update productDemo;
            System.assert(false, 'Item should not be updated');
        } catch(exception e){
            System.assert(true, 'Not wroking');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void appointmentCreationReplaceItemAfterCreationNegativeEdit(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        Time neededTime = Time.newInstance(2, 30, 0, 0);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(
            partnerAccount1, 
            customerAccount1, 
            branch1, 
            item1, 
            Date.today(), 
            null, 
            null, 
            false, 
            '', 
            ''
        );
        System.assertEquals(partnerAccount1.Id, productDemo.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
        System.assertEquals(branch1.Id, productDemo.dmpl__BranchId__c, 'BranchId does not match');
        System.assertEquals(item1.Id, productDemo.dmpl__ItemId__c, 'ItemId does not match');
        System.assertEquals(null, productDemo.dmpl__DemoSlotId__c, 'DemoSlotId should be blank');
        System.assertEquals(Date.today(), productDemo.dmpl__DemoDate__c, 'DemoDate does not match');
        System.assertEquals(null, productDemo.dmpl__DemoTime__c, 'DemoTime does not match');
        System.assertEquals(customerAccount1.Id, productDemo.dmpl__AccountId__c, 'AccountId does not match');
        System.assertEquals(null, productDemo.dmpl__SalesExecutiveId__c, 'SalesExecutiveId does not match');
        System.assertEquals(false, productDemo.dmpl__IsDemoOnsite__c, 'IsDemoOnsite should be false');
        System.assertEquals('', productDemo.dmpl__DemoAddress__c, 'DemoAddress should be blank');
        System.assertEquals('', productDemo.dmpl__Remarks__c, 'Remarks should be blank');
        productDemo.dmpl__ItemId__c = item4.Id;
        try{
            update productDemo;
            System.assert(false, 'Item should not be updated');
        } catch(exception e){
            System.assert(true, 'Not wroking');
        }
        Test.stopTest();
    }
}