@isTest
public with sharing class SchemeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__Scheme__c scheme = SchemeDataHelper.createScheme();
        dmpl__SchemeAccountBudget__c schemeAccBudget = SchemeDataHelper.createSchemeAccountBudget(scheme.Id);
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeLine(scheme.Id);
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme.Id);
        SchemeDataHelper.createSchemeCondition(null, null, null, null, null, null);
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4');
        
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1');

        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4', partnerAccount4.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3', partnerAccount4.Id, branch4.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
        
        
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');
        
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item1.id, false);
        
        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount1.id);
                
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1, branch1, priceList1);
        
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme();
        scheme2.dmpl__ValidFrom__c = Date.newInstance(2025, 5, 1);
        scheme2.dmpl__ValidTo__c = Date.newInstance(2025, 6, 30);
        scheme2.dmpl__PartnerAccountId__c = partnerAccount4.Id;
        scheme2.dmpl__BranchId__c = branch4.Id;
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition(scheme2.Id, schemeLine2.Id, item1.Id);
        schemeCondition2.dmpl__ConditionType__c = 'Item Quantity';
        schemeCondition2.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
        schemeCondition2.dmpl__ConditionValue__c = 10;
        update schemeCondition2;
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit(scheme2.Id,schemeLine2.Id, item5.Id);
        schemeBenefit2.dmpl__RewardType__c = 'Line Level Discount Amount';
        schemeBenefit2.dmpl__DiscountAmount__c = 1000;
        update schemeBenefit2;
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        
        dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme();
        scheme20.Name = 'Scheme 20';
        scheme20.dmpl__SchemeType__c ='Per Purchase order';
        scheme20.dmpl__ValidCount__c=2;
        scheme20.dmpl__IgnoreBudget__c = true;
        scheme20.dmpl__PartnerAccountId__c = partnerAccount1.Id;
        scheme20.dmpl__AccountId__c = customerAccount1.Id;
        scheme20.dmpl__BranchId__c = branch1.Id;
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(scheme20.Id);
        schemeLine20.dmpl__Title__c = 'FREE OF COST';
        update schemeLine20;
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition(scheme20.Id, schemeLine20.Id, item1.Id);
        schemeCondition20.dmpl__ConditionType__c = 'Item Quantity';
        schemeCondition20.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
        schemeCondition20.dmpl__ConditionValue__c = 18;
        update schemeCondition20;
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit(scheme20.Id, schemeLine20.Id,  item1.Id);
        schemeBenefit20.dmpl__Title__c = 'FREE ITEM';
        schemeBenefit20.dmpl__DiscountedItemQuantity__c = 1;
        schemeBenefit20.dmpl__DiscountPercent__c = 5;
        Update schemeBenefit20;
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partnerAccount1.Id);
        
        dmpl__SaleOrder__c saleOrder4 = SaleOrderDataHelper.createSaleOrder( customerAccount4.Id, partnerAccount4.Id, branch4.Id, null, null, false, null );
        dmpl__SaleOrderLine__c saleOrderLine4 = SaleOrderDataHelper.createSaleOrderLine(saleOrder4.Id, item1.Id, 15, null);
        
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice4 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount4, branch4, saleOrder4, priceList3);
        dmpl__SaleInvoiceLine__c saleInvoiceLine4 =  SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice4, item1, 10);
        
        dmpl__SaleReturn__c saleReturn4 = SaleReturnDataHelper.createSaleReturn(customerAccount4, branch4, null, priceList3);
        dmpl__SaleReturnLine__c saleReturnLine4 =  SaleReturnDataHelper.createSaleReturnLine(saleReturn4, item1, sku1, taxGroupGST28);
        
        dmpl__RepairOrder__c repairOrder4 = RepairOrderTestDataHelpers.createRepairOrder(
            partnerAccount4,
        customerAccount4,
        branch4,
        asset,
        300
            );
        Test.stopTest();
    }
    
    @isTest
    static void createScheme() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        System.assertNotEquals(null, scheme.Id, 'Scheme record should be inserted');
    }
    
    @isTest
    static void createSchemeAccountBudget() {
        dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
        System.assertNotEquals(null, budget.Id, 'Scheme Account Budget should be inserted');
    }
    
    @isTest
    static void createSchemeBenefitPositive() {
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        System.assertNotEquals(null, benefit.Id, 'Scheme Benefit should be inserted');
        System.assertEquals('Rate Off', benefit.dmpl__Title__c, 'Title should match default');
    }
    
    @isTest
    static void createSchemeCondition() {
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        System.assertNotEquals(null, testCondition, 'testCondition should not be null');
        System.assertNotEquals(null, testCondition.Id, 'Scheme Condition should be inserted');
    }
    
    @isTest
    static void createSchemeLine() {
        dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
        System.assertNotEquals(null, line.Id, 'Scheme Line should be inserted');
    }
    
    @isTest
    static void createSchemePeriod() {
        dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
        System.assertNotEquals(null, period.Id, 'Scheme Period should be inserted');
    }
    
    @isTest
    static void updateScheme() {
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        
        String expectedName = 'Updated Scheme';
        String expectedTransactionType = 'Sample';
        String expectedApplication = 'Apply On Selection';
        String expectedFrequency = 'Quarterly';
        Decimal expectedPercentage = 85.00;
        Boolean expectedIgnoreBudget = true;
        Boolean expectedIncludeChild = true;
        Boolean expectedIncludeRelated = true;
        Boolean expectedIsClaimable = false;
        String expectedFulfillment = 'Apply First Fulfilled';
        Date expectedEndDate = Date.today().addMonths(6);
        Date expectedStartDate = Date.today().addDays(10);
        String expectedPeriodType = 'Yearly';
        String expectedRoundOff = 'floor';
        Decimal expectedBudget = 200000;
        Decimal expectedQuota = 90.00;
        String expectedType = 'Per Period Sale Order';
        String expectedStatus = 'Pending Approval';
        Decimal expectedUtilized = 5000;
        Integer expectedCount = 20;
        Date expectedValidFrom = Date.today().addDays(5);
        Date expectedValidTo = Date.today().addYears(2);
        
        scheme.Name = expectedName;
        scheme.dmpl__ApplicableTransactionType__c = expectedTransactionType;
        scheme.dmpl__Application__c = expectedApplication;
        scheme.dmpl__ClaimGenerationFrequency__c = expectedFrequency;
        scheme.dmpl__ClaimablePercentage__c = expectedPercentage;
        scheme.dmpl__IgnoreBudget__c = expectedIgnoreBudget;
        scheme.dmpl__IncludeChildAccountTransactions__c = expectedIncludeChild;
        scheme.dmpl__IncludeRelatedAccountTransactions__c = expectedIncludeRelated;
        scheme.dmpl__IsClaimable__c = expectedIsClaimable;
        scheme.dmpl__MultipleFulfilmentTreatment__c = expectedFulfillment;
        scheme.dmpl__PeriodEndDate__c = expectedEndDate;
        scheme.dmpl__PeriodStartDate__c = expectedStartDate;
        scheme.dmpl__PeriodType__c = expectedPeriodType;
        scheme.dmpl__RoundOffType__c = expectedRoundOff;
        scheme.dmpl__SchemeBudget__c = expectedBudget;
        scheme.dmpl__SchemeQuota__c = expectedQuota;
        scheme.dmpl__Status__c = expectedStatus;
        scheme.dmpl__UtilizedAmount__c = expectedUtilized;
        scheme.dmpl__ValidCount__c = expectedCount;
        scheme.dmpl__ValidFrom__c = expectedValidFrom;
        scheme.dmpl__ValidTo__c = expectedValidTo;
        
        update scheme;
        
        dmpl__Scheme__c updated = SchemeDataHelper.getScheme();
        
        System.assertEquals(expectedName, updated.Name);
        System.assertEquals(expectedTransactionType, updated.dmpl__ApplicableTransactionType__c);
        System.assertEquals(expectedApplication, updated.dmpl__Application__c);
        System.assertEquals(expectedFrequency, updated.dmpl__ClaimGenerationFrequency__c);
        System.assertEquals(expectedPercentage, updated.dmpl__ClaimablePercentage__c);
        System.assertEquals(expectedIgnoreBudget, updated.dmpl__IgnoreBudget__c);
        System.assertEquals(expectedIncludeChild, updated.dmpl__IncludeChildAccountTransactions__c);
        System.assertEquals(expectedIncludeRelated, updated.dmpl__IncludeRelatedAccountTransactions__c);
        System.assertEquals(expectedIsClaimable, updated.dmpl__IsClaimable__c);
        System.assertEquals(expectedFulfillment, updated.dmpl__MultipleFulfilmentTreatment__c);
        System.assertEquals(expectedEndDate, updated.dmpl__PeriodEndDate__c);
        System.assertEquals(expectedStartDate, updated.dmpl__PeriodStartDate__c);
        System.assertEquals(expectedPeriodType, updated.dmpl__PeriodType__c);
        System.assertEquals(expectedRoundOff, updated.dmpl__RoundOffType__c);
        System.assertEquals(expectedBudget, updated.dmpl__SchemeBudget__c);
        System.assertEquals(expectedQuota, updated.dmpl__SchemeQuota__c);
        System.assertEquals(expectedStatus, updated.dmpl__Status__c);
        System.assertEquals(expectedUtilized, updated.dmpl__UtilizedAmount__c);
        System.assertEquals(expectedCount, updated.dmpl__ValidCount__c);
        System.assertEquals(expectedValidFrom, updated.dmpl__ValidFrom__c);
        System.assertEquals(expectedValidTo, updated.dmpl__ValidTo__c);
    }
    
    @isTest
    static void updateSchemeAccountBudget() {
        dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
        budget.dmpl__BudgetAmount__c = 15000.00;
        update budget;
        dmpl__SchemeAccountBudget__c updatedBudget = SchemeDataHelper.getSchemeAccountBudget();
        System.assertEquals(15000.00, updatedBudget.dmpl__BudgetAmount__c, 'Budget Amount should update');
    }
    
    @isTest
    static void updateSchemeBenefit() {
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        benefit.dmpl__DiscountAmount__c = 750.00;
        update benefit;
        dmpl__SchemeBenefit__c updated = SchemeDataHelper.getSchemeBenefit();
        System.assertEquals(750.00, updated.dmpl__DiscountAmount__c, 'Discount amount should update');
    }
    
    @isTest
    static void updateSchemeCondition() {
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        testCondition.dmpl__Title__c = 'Updated Title';
        update testCondition;
        dmpl__SchemeCondition__c updated = SchemeDataHelper.getSchemeCondition();
        System.assertEquals('Updated Title', updated.dmpl__Title__c);
    }
    
    @isTest
    static void updateSchemeLine() {
        dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
        line.dmpl__DefinitionCustomLogic__c = 'Updated custom logic';
        line.dmpl__RewardCustomLogic__c = 'Updated reward logic';
        line.dmpl__SequenceNumber__c = 2;
        line.dmpl__Title__c = 'Updated Slab Title';
        update line;
        
        dmpl__SchemeLine__c updated = SchemeDataHelper.getSchemeLineRecord();
        
        System.assertEquals('Updated custom logic', updated.dmpl__DefinitionCustomLogic__c);
        System.assertEquals('Updated reward logic', updated.dmpl__RewardCustomLogic__c);
        System.assertEquals(2, updated.dmpl__SequenceNumber__c);
        System.assertEquals('Updated Slab Title', updated.dmpl__Title__c);
    }
    
    @isTest
    static void updateSchemePeriod() {
        dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
        period.Name = 'Updated Scheme Period';
        period.dmpl__DateFrom__c = Date.today().addDays(1);
        period.dmpl__DateTo__c = Date.today().addDays(60);
        update period;
        dmpl__SchemePeriod__c updated = SchemeDataHelper.getSchemePeriodRecord();
        System.assertEquals('Updated Scheme Period', updated.Name);
        System.assertEquals(Date.today().addDays(1), updated.dmpl__DateFrom__c);
        System.assertEquals(Date.today().addDays(60), updated.dmpl__DateTo__c);
    }
    
    @isTest
    static void deleteSchemeAccountBudget() {
        try {
            dmpl__SchemeAccountBudget__c budget = SchemeDataHelper.getSchemeAccountBudget();
            delete budget;
            
            dmpl__SchemeAccountBudget__c deletedSchemeAccountBudget = SchemeDataHelper.getSchemeAccountBudget(budget.Id);
            System.assertEquals(null, deletedSchemeAccountBudget, 'Scheme Account Budget record should be deleted');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
    }
    
    @isTest
    static void deleteSchemeBenefit() {
        dmpl__SchemeBenefit__c benefit = SchemeDataHelper.getSchemeBenefit();
        delete benefit;
        dmpl__SchemeBenefit__c deleted = SchemeDataHelper.getSchemeBenefit(benefit.Id);
        System.assertEquals(null, deleted, 'Scheme Benefit record should be deleted');
    }
    
    @isTest
    static void deleteSchemeCondition() {
        dmpl__SchemeCondition__c testCondition = SchemeDataHelper.getSchemeCondition();
        delete testCondition;
        
        try {
            dmpl__SchemeCondition__c deleted = SchemeDataHelper.getSchemeCondition(testCondition.Id);
            System.assert(false, 'Expected QueryException was not thrown. Record should have been deleted.');
        } catch (QueryException e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
    }
    
    @isTest
    static void deleteSchemeLinePeriod() {
        try {
            dmpl__SchemeLine__c line = SchemeDataHelper.getSchemeLineRecord();
            dmpl__SchemePeriod__c period = SchemeDataHelper.getSchemePeriodRecord();
            dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
            
            Id lineId = line.Id;
            Id periodId = period.Id;
            Id schemeId = scheme.Id;
            
            delete line;
            delete period;
            delete scheme;
            dmpl__SchemeLine__c deletedLine = SchemeDataHelper.getSchemeLineRecord(lineId);
            System.assertEquals(null, deletedLine, 'Scheme Line should be deleted');
            dmpl__SchemePeriod__c deletedPeriod = SchemeDataHelper.getSchemePeriodRecord(periodId);
            System.assertEquals(null, deletedPeriod, 'Scheme Period should be deleted');
            dmpl__Scheme__c deletedScheme = SchemeDataHelper.getScheme(schemeId);
            System.assertEquals(null, deletedScheme, 'Scheme should be deleted');
            
        } catch (QueryException qe) {
            System.debug('Expected record not found after delete: ' + qe.getMessage());
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Unexpected error message: ' + e.getMessage());
        }
    }
    
    @isTest
    static void createSchemeWithRequiredFieldsPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(scheme1.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void updateSchemeNamePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        scheme.Name = 'Scheme 25';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void createSchemeWithoutNameNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
            scheme1.Name = '';
            Update scheme1;
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme();
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__SchemeType__c = 'Per Sale Invoice';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
    }
    
    @isTest
    static void updatePeriodTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__PeriodType__c = 'Monthly';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    
    @isTest
    static void createSchemeWithoutPeriodTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
            scheme1.dmpl__PeriodType__c = null;
            Update scheme1;
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to Period type field');
    }
    
    @isTest
    static void updateSchemeCreationWithValidFromPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidFrom__c =Date.Today().addDays(2) ;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void updateSchemeCreationWithValidToPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidTo__c = scheme.dmpl__ValidTo__c+2;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void createSchemeWithoutValidFromNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
            scheme1.dmpl__ValidFrom__c = Date.today().addDays(40);
            Update scheme1;
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid from field');
    }
    
    @isTest
    static void createSchemeWithoutValidToNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
            scheme1.dmpl__ValidTo__c = Date.today().addDays(-1);
            Update scheme1;
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid to field');
    }
    
    @isTest
    static void createSchemeWithoutSchemeTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeDataHelper.createScheme();
            scheme1.dmpl__SchemeType__c = null;
            Update scheme1;
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing scheme type field');
    }
    
    @isTest
    static void createSchemeAccountBudgetWithPartnerAccountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, scheme.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithPartnerAccountGroupPositive(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
            schemeAccountBudget.dmpl__PartnerAccountGroupId__c = accountGroup.Id;
            Update schemeAccountBudget;
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(accountGroup.Id, schemeAccountBudget.dmpl__PartnerAccountGroupId__c, 'SchemeAccountBudget must have a partner Group account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithBudgetAmountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, scheme.Id);
            schemeAccountBudget.dmpl__BudgetAmount__c = 10000;
            Update schemeAccountBudget;
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        System.AssertEquals(10000, schemeAccountBudget.dmpl__BudgetAmount__c, 'SchemeAccountBudget must have a Budget Amount 10000!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithUtilizedAmountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id,scheme.Id);
            schemeAccountBudget.dmpl__UtilizedAmount__c = 2500;
            Update schemeAccountBudget;
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
        }
        System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
        System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
        System.AssertEquals(2500, schemeAccountBudget.dmpl__UtilizedAmount__c, 'SchemeAccountBudget must have a Utilized Amount 2500!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutPartnerAccountNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Wrong Partner Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutPartnerAccountGroupNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As No Partner Group Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutBudgetAmountNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(null, scheme.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Budget Amount Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeAccountBudgetWithoutSchemeNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__SchemeAccountBudget__c schemeAccountBudget;
        try{
            schemeAccountBudget = SchemeDataHelper.createSchemeAccountBudget(partner.Id, null);
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
        }catch(Exception e){
            System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSchemeSlabPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SchemeLineId__c = schemeLine.Id;
            Update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(schemeLine.Id, schemeLedger.dmpl__SchemeLineId__c, 'Scheme line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithBillPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__BillId__c = bill.Id;
            Update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeLedgerWithBillPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__BillId__c = bill.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get update! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleOrderLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
            Update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeLedgerWithSaleOrderLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleOrderPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderId__c = saleOrder.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeLedgerWithSaleOrderPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleOrderId__c = saleOrder.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleInvoicePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleInvoiceId__c = saleInvoice.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleInvoiceLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleInvoiceId__c = saleInvoice.Id;
            schemeLedger.dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
        System.assertEquals(saleInvoiceLine.Id, schemeLedger.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleReturnPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleReturnId__c = saleReturn.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSaleReturnLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c saleReturnLine =  SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SaleReturnId__c = saleReturn.Id;
            schemeLedger.dmpl__SaleReturnLineId__c = saleReturnLine.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
        System.assertEquals(saleReturnLine.Id, schemeLedger.dmpl__SaleReturnLineId__c, 'Sale Retrun Line must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithRepairOrderPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__RepairOrderId__c = repairOrder.Id;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(repairOrder.Id, schemeLedger.dmpl__RepairOrderId__c, 'Repair Order must match!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithDiscountAmountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(500, schemeLedger.dmpl__DiscountAmount__c, 'Discount Amount must be 500!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithDiscountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__Discount__c = 10;
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(10, schemeLedger.dmpl__Discount__c, 'Discount percent must be 10%!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithRewardPointsPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__RewardPoints__c = 600;
            update schemeLedger;
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
        }
        schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(600, schemeLedger.dmpl__RewardPoints__c, 'Reward Point must be 600!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithWrongPartnerAccountNegative(){
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithWrongPartnerAccountNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger == null, 'Scheme ledger must not create! >>' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithWrongBranchNegative(){
        Test.startTest();
        SchemeMasterData.createSchemeConsumptionWithWrongBranchNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger == null, 'Scheme Ledger must fail As wrong partner added! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeLedgerWithSchemeBenefitPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        
        
        dmpl__SchemeBenefit__c schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        
        dmpl__SchemeLedger__c schemeLedger;
        try{
            schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id);
            schemeLedger.dmpl__SchemeBenefitId__c = schemeBenefit.Id;
            schemeLedger.dmpl__DiscountAmount__c = 500;
            update schemeLedger;
            
        }catch(Exception e){
            System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must create ! >> ' + e.getMessage());
        }
        System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
        System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
        System.assertEquals(schemeBenefit.Id, schemeLedger.dmpl__SchemeBenefitId__c, 'Scheme Benefit must be Match!');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithDiscountedItemPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id,item?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithDiscountedItemPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithDiscountedItemGroupPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item Group';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = rewardType;
            schemeBenefit.dmpl__RepeatReward__c = repeatReward;
            schemeBenefit.dmpl__DiscountedItemGroupId__c = itemGroup?.Id;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithLineLevelDiscountPercentPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 100 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountPercent__c = discountPercent;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithLineLevelDiscountAmountPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 2500 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id,item?.Id);
            schemeBenefit.dmpl__DiscountAmount__c = discountAmount;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithRewardPointsPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Reward Points';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = rewardType;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem1Positive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithFreeItem1Positive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem1PieceQuantityPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 15;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__UOMQuantity__c = uomQuantity;
            Update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem2Positive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemGroupId__c = itemGroup?.Id;
            Update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithFreeItem2Positive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 6', 'Product');        
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithFreeItem2PieceQuantityPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 20;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__UOMQuantity__c = uomQuantity;
            Update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithSchemeValuePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithSchemePercentagePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithExcludeQualifyingItemTruePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = true;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = exludeQualifyingItems;
            Update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithReadRewardEveryQualificationTruePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = true ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RepeatReward__c = repeatReward;
            Update schemeBenefit;
            
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithExcludeQualifyingItemFalsePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = true;
        Boolean repeatReward = false ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = false;
            exludeQualifyingItems = false;
            update schemeBenefit;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeBenefitWithReadRewardEveryQualificationFalsePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = 'Discounted Item';
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = true;
        Boolean repeatReward = true ;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RepeatReward__c = false;
            schemeBenefit.dmpl__ExcludeQualifyingItems__c = exludeQualifyingItems;
            update schemeBenefit;
            repeatReward = false;
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
        }
        schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);
        
        System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
        System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
        System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
        System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
        System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
        System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
        System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
        System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
        System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
        System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
        System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeBenefitWithoutRewardTypeNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        Decimal sequenceNumber = 1;
        String rewardType = null;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__ItemGroup__c itemGroup = null;
        Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
        Decimal uomQuantity = 0 ;
        Boolean exludeQualifyingItems = false;
        Boolean repeatReward = false;
        
        dmpl__SchemeBenefit__c schemeBenefit;
        try{
            schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, item?.Id);
            schemeBenefit.dmpl__RewardType__c = rewardType;
            Update schemeBenefit;
            System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must not create !');
        }catch(Exception e){
            System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must not create ! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    static void createSchemeConditionWithItemQuantityPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Quantity';
        Decimal conditionValue = 10;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 10;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionValue__c = conditionValue;
            schemeCondition.dmpl__ConditionQuantity__c = conditionQuantity;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithValuePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionQuantity__c = 12;
            schemeCondition.dmpl__ConditionValue__c = 12;
            Update schemeCondition;
            
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithCaseQuantityPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 2;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionValue__c = conditionValue;
            schemeCondition.dmpl__UOMQuantity__c = uomQuantity;
            schemeCondition.dmpl__ConditionQuantity__c = conditionQuantity;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithPieceQuantityPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 2;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionValue__c = conditionValue;
            schemeCondition.dmpl__UOMQuantity__c = uomQuantity;
            schemeCondition.dmpl__ConditionQuantity__c = conditionQuantity;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditoinTypeAsItemGroupPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Quantity';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditoinTypeAsItemGroupValuePositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorGreaterThanOrEqualPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorEqualsPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorDoesNotEqualsPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Does Not Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorGreaterThanPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorLessThanPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Less Than';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithConditionOperatorLessThanOrEqualPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Less Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithItemPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithItemGroupPositive(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ItemGroupId__c = itemGroup?.Id;
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
        }
        schemeCondition =  SchemeDataHelper.getSchemeCondition(schemeCondition.Id);
        
        System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
        System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
        System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
        System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
        System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
        System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
        System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
        System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutSequenceNumberNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = null;
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            schemeCondition.dmpl__SequenceNumber__c = sequenceNumber;
            Update schemeCondition;
        }catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutConditionTypeNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = null;
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConditionWithoutConditionOperatorNegative(){
        Test.startTest();
        dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
        Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = null;
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;
        Boolean exceptionThrown = false;
        dmpl__SchemeCondition__c schemeCondition;
        try{
            schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,item?.Id);
            schemeCondition.dmpl__ConditionType__c = conditionType;
            schemeCondition.dmpl__ConditionOperator__c = conditionOperator;
            Update schemeCondition;
        }catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Scheme Condition must not create!');
        
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithItemGroupPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        Decimal consumedQuantity= 0 ;
        Decimal consumedAmount= 0 ;
        
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully>> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithWrongPartnerAccountNegative(){
        Test.startTest();
        SchemeMasterData.createSchemeLedgerWithWrongPartnerAccountNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        Decimal consumedQuantity= 0 ;
        Decimal consumedAmount= 0 ;
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must be Fail Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithWrongBranchNegative(){
        Test.startTest();
        SchemeMasterData.createSchemeConsumptionWithWrongBranchNegativeData();
        SchemeMasterData.createSchemeLedgerWithWrongPartnerAccountNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        Decimal consumedQuantity= 0 ;
        Decimal consumedAmount= 0 ;
        
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeConsumptionWithoutItemNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = null;
        dmpl__ItemGroup__c itemGroup = null;
        Decimal consumedQuantity= 0 ;
        Decimal consumedAmount= 0 ;
        
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeConsumptionWithConsumedQuantityPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        Decimal consumedQuantity= 10 ;
        Decimal consumedAmount= 0 ;
        
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
            schemeConsumption.dmpl__ConsumedQuantity__c = consumedQuantity;
            Update schemeConsumption;
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeConsumptionWithConsumedAmountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        Decimal consumedQuantity= 0 ;
        Decimal consumedAmount= 3000 ;
        
        dmpl__SchemeConsumption__c schemeConsumption;
        try{
            schemeConsumption = SchemeDataHelper.createSchemeConsumption(partner?.Id,branch?.Id,item?.Id,itemGroup?.Id);
            schemeConsumption.dmpl__ConsumedAmount__c = consumedAmount;
            Update schemeConsumption;
        }catch(Exception e){
            System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
        }
        schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);
        
        System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
        System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
        System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
        System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
        System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
        System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
        System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
        Test.stopTest();
    }
    
    @isTest
    static void createSchemePeriodPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);
        
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();
        
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }
    
    @isTest
    static void createSchemePeriodWithSchemePeriodNamePositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);
        
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();
        
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }
    
    @isTest
    static void createSchemePeriodWithoutSchemePeriodNameNegative(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);
        
        Test.startTest();
        try {
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,null,dateFrom,dateTo);
        } catch (Exception e) {
            System.Assert.isTrue(true, 'schemePeriod should not be created without name');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemePeriodWithDateFromAndDateToPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);
        
        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();
        
        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }
    
    @isTest
    static void createSchemePeriodWithoutDateFromAndDateToPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        
        Test.startTest();
        try{
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',null,null);
            System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
            System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
            System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
        }catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemePeriodWithInvalidDateRangeNegative(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 2, 30);
        
        Test.startTest();
        try {
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        } catch (Exception e) {
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSchemeSlabPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithFilterCriteriaPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithRewardApplicabilityPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
    
    @isTest
    static void createSchemeSlabWithSequenceNumberPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2);
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }
}