public with sharing class QuoteMasterData {
    public static void createServiceRequestForQuote(){
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__BranchTimeSlot__c brTimeSlot = TestDataHelpers.createBranchTimeSlot(branch, item);
        dmpl__ServiceRequest__c ServiceRequest= ServiceRequestTestDataHelpers.createServiceRequest(
            customerAccount,
            branch,
            item,
            asset,
            brTimeSlot
        );
    }

    public static void createQuoteWithServiceRequest(){
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = TestDatahelpers.getResource('Resource 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(
            branch,
            customerAccount, 
            priceList,
            asset,
            serviceRequest, 
            resource, 
            null, 
            item
        );
    }

    public static void createInvalidBranchForQuote(){
        dmpl__Branch__c invalidBranch = TestDataHelpers.createBranch('Invalid Branch', null, true, true, true, true);
    }

    public static void createDiscountGroupForQuote() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount Group 1', partnerAccount.Id, branch.Id);
    }

    public static void createInvalidItemForQuoteLine(){
        dmpl__Item__c invalidItem = TestDataHelpers.createItem('Invalid Item', 'Product');
        invalidItem.dmpl__IsActive__c = false;
        invalidItem.dmpl__IsPackage__c = false;
        invalidItem.dmpl__IsSKURequired__c = false;
        invalidItem.dmpl__IsDiscontinued__c = true;
        update invalidItem;
    }

    public static void createExpiredPriceListforQuoteLine(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPricelistRules(priceList.Id, item.Id, 1500);
    }

    public static void createAlternateItem(){
        TestDataHelpers.createItem('Alternate Item', 'Product');
    }
    
    public static void createOutdatedPriceList(){
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        priceList.dmpl__IsActive__c = false;
        update priceList;
    }

    public static void createSaleOrderForQuote(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
    }
}