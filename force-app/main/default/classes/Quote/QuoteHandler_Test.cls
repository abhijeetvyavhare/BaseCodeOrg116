@isTest
public with sharing class QuoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        dmpl__Resource__c resource = TestDatahelpers.createResource('Resource 1');
        dmpl__Quote__c quote = QuoteTestDataHelpers.CreateServiceEstimate(
            branch1,
            customerAccount1,
            priceList1,
            asset,
            null,
            resource,
            null,
            item1
        );
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.CreateServiceEstimateLine(
            item1,
            priceListRule1,
            taxGroupGST28,
            null,
            quote
        );
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.CreateServiceEstimateTax(
            quote,
            quoteLine,
            taxCGST14_8,
            taxGroupGST28
        );
    }

    @isTest
    static void createQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Expected Quote to be created.');
    }

    @isTest
    static void updateQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Quote should exist before update.');
        quote.dmpl__TCSEligibleAmount__c = 100;
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
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
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
        System.assertNotEquals(quoteTax, null, 'Expected QuoteTax to be created.');
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
    static void createQuoteWithValidPartnerAccountPositive(){
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = TestDatahelpers.getResource('Resource 1');
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
    }

    @isTest
    static void createQuoteWithValidBranchPositive(){
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = TestDatahelpers.getResource('Resource 1');
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
    }

    @isTest
    static void createQuoteWithValidAssetPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = TestDatahelpers.getResource('Resource 1');
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(branch.Id, quote.dmpl__BranchId__c, 'Quote should have the correct Branch.');
        System.assertEquals(customerAccount.Id, quote.dmpl__AccountId__c, 'Quote should have the correct Customer Account.');
        System.assertEquals(asset.Id, quote.dmpl__AssetId__c, 'Quote should have the correct Asset.');
        System.assertEquals(resource.Id, quote.dmpl__ServiceAdvisorId__c, 'Quote should have the correct Resource.');
    }

    @isTest
    static void createQuoteWithInvalidPartnerBranchNegative() {
        QuoteMasterData.createInvalidBranchForQuote();
        dmpl__Branch__c invalidBranch = TestDataHelpers.getBranch('Invalid Branch');
        Test.startTest();
        dmpl__Quote__c quote;
        Boolean exceptionThrown = false;
        try {
            quote = QuoteTestDataHelpers.getServiceEstimate();
            quote.dmpl__BranchId__c = invalidBranch.Id;
            update quote;
            System.assertEquals(null, quote.Id, 'Quote should not be created for invalid branch-partner combination.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (quote == null || quote.Id == null), 'Quote should not be created and error should be thrown for invalid branch.');
    }

    @isTest
    static void createQuoteWithServiceRequestPositive() {
        QuoteMasterData.createServiceRequestForQuote();
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        QuoteMasterData.createQuoteWithServiceRequest();
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimateByServiceRequest(serviceRequest.Id);
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(serviceRequest.Id, quote.dmpl__ServiceRequestId__c, 'Quote should be linked to the correct Service Request.');
    }

    @isTest
    static void createQuoteLinkedToSaleOrderPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        dmpl__Resource__c resource = TestDataHelpers.getResource('Resource 1');
        QuoteMasterData.createSaleOrderForQuote();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__SaleOrderId__c = saleOrder.Id;
        update quote;
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
        Test.startTest();
        dmpl__Quote__c quote;
        Boolean exceptionThrown = false;
        try {
            quote = QuoteTestDataHelpers.getServiceEstimate();
            quote.dmpl__PartnerAccountId__c = null;
            update quote;
            System.assertEquals(null, quote.Id, 'Quote should not be created without a Partner Account.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (quote == null || quote.Id == null), 'Quote should not be created and error should be thrown for missing Partner Account.');
    }

    @isTest
    static void createQuoteWithPriceListAndDiscountGroup() {
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        QuoteMasterData.createDiscountGroupForQuote();
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.getDiscountGroup();
        Date priceAsOnDate = Date.newInstance(2025, 6, 19);
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__PriceListId__c = priceList.Id;
        quote.dmpl__DiscountGroupId__c = discountGroup.Id;
        quote.dmpl__PriceAsOnDate__c = priceAsOnDate;
        update quote;
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(priceList.Id, quote.dmpl__PriceListId__c, 'Quote should have the correct Price List.');
        System.assertEquals(discountGroup.Id, quote.dmpl__DiscountGroupId__c, 'Quote should have the correct Discount Group.');
        System.assertEquals(priceAsOnDate, quote.dmpl__PriceAsOnDate__c, 'Quote should have the correct Price As On Date.');
    }
    
    @isTest
    static void createQuoteWithPastPriceAsOnDateAndOutdatedPriceList() {
        QuoteMasterData.createOutdatedPriceList();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Date priceAsOnDate = Date.newInstance(2024, 9, 9);
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__PriceListId__c = priceList.Id;
        quote.dmpl__PriceAsOnDate__c = priceAsOnDate;
        update quote;
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(priceList.Id, quote.dmpl__PriceListId__c, 'Quote should have the correct Price List.');
        System.assertEquals(priceAsOnDate, quote.dmpl__PriceAsOnDate__c, 'Quote should have the correct Price As On Date.');
    }

    @isTest
    static void createQuoteWithWithinStateTaxSupplyType() {
        String taxSupplyType = 'Within State';
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__TaxSupplyType__c = taxSupplyType;
        update quote;
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(taxSupplyType, quote.dmpl__TaxSupplyType__c, 'Quote should have the correct Tax Supply Type.');
    }

    @isTest
    static void createQuoteWithOutsideStateTaxSupplyType() {
        String taxSupplyType = 'Outside State';
        Test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__TaxSupplyType__c = taxSupplyType;
        update quote;
        Test.stopTest();
        System.assertNotEquals(null, quote.Id, 'Quote should have been created and have an Id.');
        System.assertEquals(taxSupplyType, quote.dmpl__TaxSupplyType__c, 'Quote should have the correct Tax Supply Type.');
    }

    @isTest
    static void createQuoteLineWithValidItemPositive(){
        Test.startTest();
        dmpl__QuoteLine__c qLine = QuoteTestDataHelpers.getServiceEstimateLine();
        Test.stopTest();
        System.assertNotEquals(null, qLine, 'Quote Line should be created.');   
    }

    @isTest
    static void createQuoteLineWithInvalidItemNegative(){
        QuoteMasterData.createInvalidItemForQuoteLine();
        dmpl__Item__c item = TestDataHelpers.getItem('Invalid Item');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.getServiceEstimateLine();
            qLine.dmpl__ItemId__c = item.Id;
            update qLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should not be created and error should be thrown for invalid item.');
    }

    @isTest
    static void createQuoteLineWithNegativeQuantityNegative(){
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.getServiceEstimateLine();
            qLine.dmpl__Quantity__c = -2;
            update qLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should not be created and error should be thrown for negative quantity.');
    }

    @isTest
    static void createQuoteLineWithExpiredPriceListNegative(){
        QuoteMasterData.createOutdatedPriceList();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c qLine;
        try {
            qLine = QuoteTestDataHelpers.getServiceEstimateLine();
            qLine.dmpl__PriceListId__c = priceList.Id;
            update qLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertNotEquals(true, exceptionThrown || (qLine == null || qLine.Id == null), 'Quote Line should be created.');
    }
    
    @isTest
    static void createQuoteLineWithDiscounts() {
        Test.startTest();
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
        quoteLine.dmpl__DiscountAmount__c = 20;
        update quoteLine;
        Test.stopTest();
        System.assertNotEquals(null, quoteLine.Id, 'Quote Line should have been created and have an Id.');
        System.assertEquals(20, quoteLine.dmpl__DiscountAmount__c, 'Discount Amount should be set on Quote.');
    }
    
    @isTest
    static void updateQuoteLineWithAlternateItemNegative() {
        QuoteMasterData.createAlternateItem();
        dmpl__Item__c alternateItem = TestDataHelpers.getItem('Alternate Item');
        Test.startTest();
        Boolean exceptionThrown = false;
        dmpl__QuoteLine__c quoteLine;
        try {
            quoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
            quoteLine.dmpl__AlternateItemId__c = alternateItem.Id;
            quoteLine.dmpl__ItemId__c = null;
            update quoteLine;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (quoteLine == null || quoteLine.Id == null), 'Quote Line should not be updated with alternate item and should throw an error.');
    }
}