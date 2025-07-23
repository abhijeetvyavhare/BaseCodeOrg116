@isTest
public with sharing class QuoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();  
        Account supplierAccount =TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__TaxGroup__c taxGroup =TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__BranchTimeSlot__c brTimeSlot = BranchTimeSlotDataHelper.createBranchTimeSlot(branch,item);

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042','9123456698');
		Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');

        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1',partnerAccount1.Id,true,true,false,false);
        dmpl__Branch__c branch3 =TestDataHelpers.createBranch('Branch 3',partnerAccount3.Id,true,true,false,false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        
        Account customerAccount10 = TestDataHelpers.createCustomerAccount('Customer 10', true, false, false, true, 'Park Street', 'Kolkata', 'West Bengal', 'India', '700017', 'Salt Lake', 'Kolkata', 'West Bengal', 'India', '700091','9123456701', 'Created');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',partnerAccount1.Id,branch1.Id,null,null,false,false,'Sale Price');

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false, false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true, false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true, false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false, false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false, false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false,false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false, false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true, false);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true, false);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false, true);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false, true);

        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule2 = TestDataHelpers.createPriceListRules(priceList2.id, item2.id, null, null, 2400, Date.newInstance(2025, 5, 1), Date.newInstance(2025, 10, 31));
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9); 
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule12 = TestDataHelpers.createPriceListRules(priceList1.id, item15.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule13 = TestDataHelpers.createPriceListRules(priceList1.id, item13.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule14 = TestDataHelpers.createPriceListRules(priceList1.id, item14.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule16 = TestDataHelpers.createPriceListRules(priceList1.id, item16.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule17 = TestDataHelpers.createPriceListRules(priceList7.id, item8.id,null,null,1500, System.today()-1,System.today()+9);

        dmpl__TaxGroup__c taxGroupGST12partner1 = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12partner1.Id, 'Tax2');
        dmpl__TaxGroupRule__c taxGroupRule12Item1 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupGST12partner1.Id,item1.Id,null,null,null);

        dmpl__TaxGroup__c taxGroupGST18partner4 = TestDataHelpers.createTaxGroup('GST 18', false, 'Line Level', partnerAccount4.Id, branch4.Id, null);

        Asset asset1 = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);

        dmpl__ServiceRequest__c ServiceRequest= ServiceRequestTestDataHelpers.createServiceRequest(customerAccount,branch,item,asset1,brTimeSlot);
        dmpl__Quote__c quote =QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, priceList, asset1, ServiceRequest, null, null, item1);
        dmpl__QuoteLine__c quoteLine=QuoteTestDataHelpers.CreateServiceEstimateLine(item,priceListRule,taxGroupGST12partner1,null,quote);
        dmpl__QuoteTax__c quoteTax=QuoteTestDataHelpers.CreateServiceEstimateTax(quote,quoteLine,tax,taxGroupGST12partner1);

        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup('Discount 1', partnerAccount4.Id, branch4.Id, null, true, 'Sale Price');

        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
    }

    @isTest
    static void createQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        if(quote != null){
            System.assertNotEquals(quote, null, 'Expected Quote to be created.');
        }
        System.assertEquals(false, quote.dmpl__PerformApproval__c, 'PerformApproval should be false');
        System.assertEquals(false, quote.dmpl__PerformDecline__c, 'PerformDecline should be false');
    }

    @isTest
    static void updateQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Quote should exist before update.');
        quote.dmpl__TCSEligibleAmount__c=100;
        Test.startTest();
        update quote;
        Test.stopTest();
        dmpl__Quote__c updatedQuote = QuoteTestDataHelpers.getServiceEstimate();       
        System.assertEquals(100, updatedQuote.dmpl__TCSEligibleAmount__c, 'dmpl__TCSEligibleAmount__c should be 100');
    }

    @isTest
    static void deleteQuote() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Quote should exist before delete.');
        delete quote;
        dmpl__Quote__c deletedQuote = null;
        try {
            deletedQuote = QuoteTestDataHelpers.getServiceEstimate();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedQuote);
        } catch (Exception e) {
            deletedQuote = null;
        }
        System.assertEquals(null, deletedQuote, 'Quote should be deleted and not found in query.');
    }
    
    @isTest
    static void createQuoteLinePositive() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        if(quoteLine != null){
            System.assertNotEquals(quoteLine, null, 'Expected Quote to be created.');
        }
        System.assertEquals(true, quoteLine.dmpl__IncludeinPackage__c, 'IncludeinPackage should be false');
        System.assertEquals(false, quoteLine.dmpl__IsPackageService__c, 'IsPackageService should be false');
    }

    @isTest
    static void updateQuoteLinePositive() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        System.assertNotEquals(quoteLine, null, 'QuoteLine should exist before update.');        
        quoteLine.dmpl__UnitPrice__c=100;
        Test.startTest();
        update quoteLine;
        Test.stopTest();
        dmpl__QuoteLine__c updatedQuoteLine = QuoteTestDataHelpers.getServiceEstimateLine();       
        System.assertEquals(100, updatedQuoteLine.dmpl__UnitPrice__c, 'UnitPrice should be 100');
    }

    @isTest
    static void deleteQuoteLine() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        System.assertNotEquals(quoteLine, null, 'QuoteLine should exist before delete.');
        delete quoteLine;
        dmpl__QuoteLine__c deletedQuoteLine = null;
        try {
            deletedQuoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedQuoteLine);
        } catch (Exception e) {
            deletedQuoteLine = null;
        }
        System.assertEquals(null, deletedQuoteLine, 'QuoteLine should be deleted and not found in query.');
    }
    
    @isTest
    static void createQuoteTaxPositive() {
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        if(quoteTax != null){
            System.assertNotEquals(quoteTax, null, 'Expected QuoteTax to be created.');
        }
        System.assertEquals(6, quoteTax.dmpl__TaxRate__c, 'TaxRate should be 10');
    }

    @isTest
    static void updateQuoteTaxPositive() {
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        System.assertNotEquals(quoteTax, null, 'QuoteTax should exist before update.');
        quoteTax.dmpl__TaxOnAmount__c=200;
        quoteTax.dmpl__TaxRate__c=20;
        Test.startTest();
        update quoteTax;
        Test.stopTest();
        dmpl__QuoteTax__c updatedQuoteTax = QuoteTestDataHelpers.getServiceEstimateTax();       
        System.assertEquals(200, updatedQuoteTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be 200');
        System.assertEquals(20, updatedQuoteTax.dmpl__TaxRate__c, 'TaxRate should be 20');
    }

    @isTest
    static void deleteQuoteTax() {
        dmpl__Quote__c quote =QuoteTestDataHelpers.getServiceEstimate();
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        System.assertNotEquals(quoteTax, null, 'QuoteTax should exist before delete.');
        Test.startTest();
        delete quote;
        Test.stopTest();
        dmpl__QuoteTax__c deletedQuoteTax = null;
        try {
            deletedQuoteTax =  QuoteTestDataHelpers.getServiceEstimateTax();
            System.assert(false, 'Expected exception when querying deleted record, but got: ' + deletedQuoteTax);
        } catch (Exception e) {
            deletedQuoteTax = null;
        }
        System.assertEquals(null, deletedQuoteTax, 'QuoteTax should be deleted and not found in query.');
    }

    @isTest
    static void createQuoteWithValidPartnerAccountAndAssetPositive(){
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = AssetTestDataHelpers.getAsset();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, null, resource, null, null);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
    }

    @isTest
    static void createQuoteWithValidAssetPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = AssetTestDataHelpers.getAsset();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, null, resource, null, null);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
    }

    @isTest
    static void createQuoteWithServiceRequestPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, serviceRequest, resource, null, null);
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(serviceRequest.Id, quote.dmpl__ServiceRequestId__c, 'Quote should be linked to the correct Service Request.');
    }

    @isTest
    static void createQuoteWithInvalidPartnerBranchNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c invalidBranch = TestDataHelpers.createBranch('Invalid Branch', null, true, true, true, true);
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = AssetTestDataHelpers.getAsset();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();

        Test.startTest();
        dmpl__Quote__c quote;
        Boolean exceptionThrown = false;
        try {
            quote = QuoteTestDataHelpers.CreateServiceEstimate(invalidBranch, customerAccount, null, asset, null, resource, null, null);
            System.assertEquals(null, quote.Id, 'Quote should not be created for invalid branch-partner combination.');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Branch is not valid') || e.getMessage().contains('not valid'), 'Expected error message for invalid branch.');
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (quote == null || quote.Id == null), 'Quote should not be created and error should be thrown for invalid branch.');
    }

    @isTest
    static void createQuoteLinkedToSaleOrderPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem1();
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList(); 
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount,
            branch,
            contactAddress,
            priceList
        );

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, null, resource, saleOrder.Id, null);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
        System.assertEquals(saleOrder.Id, quote.dmpl__SaleOrderId__c, 'Quote should be linked to the correct Sale Order.');
    }

    @isTest
    static void createQuoteWithoutPartnerAccountNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();

        Test.startTest();
        dmpl__Quote__c quote;
        Boolean exceptionThrown = false;
        try {
            quote = QuoteTestDataHelpers.CreateServiceEstimate(null, branch, customerAccount, asset);
            System.assertEquals(null, quote.Id, 'Quote should not be created without a Partner Account.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (quote == null || quote.Id == null), 'Quote should not be created and error should be thrown for missing Partner Account.');
    }

    @isTest
    static void createQuoteWithPriceListAndDiscountGroup() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 2');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        Date priceAsOnDate = Date.newInstance(2025, 6, 19);

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimateWithDiscount(partnerAccount.Id, branch.Id, customerAccount.Id, asset.Id, resource.Id, priceList.Id, discountGroup.Id, priceAsOnDate);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(priceList.Id, quote.dmpl__PriceListId__c, 'Quote should have the correct Price List.');
        System.assertEquals(discountGroup.Id, quote.dmpl__DiscountGroupId__c, 'Quote should have the correct Discount Group.');
        System.assertEquals(priceAsOnDate, quote.dmpl__PriceAsOnDate__c, 'Quote should have the correct Price As On Date.');
    }
    
    @isTest
    static void createQuoteWithPastPriceAsOnDateAndOutdatedPriceList() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Date priceAsOnDate = Date.newInstance(2026, 9, 9);

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimateWithDiscount(partnerAccount.Id, branch.Id, customerAccount.Id, asset.Id, resource.Id, priceList.Id, null, priceAsOnDate);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(priceList.Id, quote.dmpl__PriceListId__c, 'Quote should have the correct Price List.');
        System.assertEquals(priceAsOnDate, quote.dmpl__PriceAsOnDate__c, 'Quote should have the correct Price As On Date.');
    }

    @isTest
    static void createQuoteWithWithinStateTaxSupplyType() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        String taxSupplyType = 'Within State';

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimateWithTaxSupplyType(partnerAccount.Id, branch, customerAccount, asset, taxSupplyType);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(taxSupplyType, quote.dmpl__TaxSupplyType__c, 'Quote should have the correct Tax Supply Type.');
    }

    @isTest
    static void createQuoteWithOutsideStateTaxSupplyType() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 10');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        String taxSupplyType = 'Outside State';

        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimateWithTaxSupplyType(partnerAccount.Id, branch, customerAccount, asset, taxSupplyType);
        Test.stopTest();

        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(taxSupplyType, quote.dmpl__TaxSupplyType__c, 'Quote should have the correct Tax Supply Type.');
    }

    @isTest
    static void createQuoteLineWithValidItemPositive(){
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__QuoteLine__c qLine = QuoteTestDataHelpers.createServiceEstimateLine(2, 1500, item, quote);
        Test.stopTest();
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.getServiceEstimateLine(qLine.Id);
        System.assertNotEquals(null, qLine, 'Quote Line should be created.');
    }

    @isTest
    static void createQuoteLineWithInvalidItemNegative(){
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.createServiceEstimateLine(2, 1500, item, quote);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should not be created and error should be thrown for invalid item.');
    }

    @isTest
    static void createQuoteLineWithNegativeQuantityNegative(){
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.createServiceEstimateLine(-2, 15000, item, quote);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should not be created and error should be thrown for negative quantity.');
    }

    @isTest
    static void createQuoteLineWithExpiredPriceListPositive(){
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.createServiceEstimateLine(2, 1500, item, quote);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertNotEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should be created.');
    }
    
    @isTest
    static void createQuoteLineWithDiscounts() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, null, resource, null, null);
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.CreateServiceEstimateLineWithDiscount(20, 20, item, quote, 20);
        Test.stopTest();
        System.assertNotEquals(null, quoteLine.Id, 'Quote Line should have been created and have an Id.');
    }
    
    @isTest
    static void updateQuoteLineWithAlternateItemNegative() {
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c alternateItem = TestDataHelpers.getItem('Item 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, null, asset, null, resource, null, null);
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.createServiceEstimateLine(20, 1500, item, quote);
        Test.stopTest();
        Boolean exceptionThrown = false;
        try {
            quoteLine.dmpl__AlternateItemId__c = alternateItem.Id;
            quoteLine.dmpl__ItemId__c = null;
            update quoteLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (quoteLine == null || quoteLine.Id == null), 'Quote Line should not be updated with alternate item and should throw an error.');
    }
}