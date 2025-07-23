@isTest
public with sharing class PartnerAccountMappingHandler_Test {
    @TestSetup
    static void createRequiredDate() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping('Testing');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6=TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
        
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001',false);
        dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress('Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Shipping Address', '440001', false);
        
        Contact contact = TestDataHelpers.createContact('Contact 1', '9113150885', '9889198008', customerAccount1.Id);
        
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount1.id);
        dmpl__AccountGroupMember__c accountGroupMember2 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount2.id);
        
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');
        
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
        
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item1.Id);
        dmpl__ItemGroupMember__c itemGroupMemeber2 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item2.Id);
        
        dmpl__ItemAlternate__c itemAlternate16 = TestDataHelpers.createItemAlternate(item15.Id,item16.Id,'Superseded',Date.newInstance(2025, 6, 30));
        dmpl__ItemAlternate__c itemAlternate13 = TestDataHelpers.createItemAlternate(item14.Id, item13.Id, 'Superseded', Date.newInstance(2025, 6, 30));
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule13 = TestDataHelpers.createPriceListRules(priceList1.id, item13.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule14 = TestDataHelpers.createPriceListRules(priceList1.id, item14.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule12 = TestDataHelpers.createPriceListRules(priceList1.id, item15.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule16 = TestDataHelpers.createPriceListRules(priceList1.id, item16.id,null,null,1500, System.today()-1,System.today()+9);
        
        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);
        
        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax('IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');
        
        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item5.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item4 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleIGST18 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,null,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item13.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item14 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item14.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item15 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item15.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item16 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item16.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule18Item5IGST = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item5.Id,null,null,null);
        
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, false);
        
        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.createDiscountGroup('Discount 1',partnerAccount4.Id,branch4.Id,null,true,'Sale Price');
        dmpl__DiscountGroup__c discountGroup2 = DiscountDataHelper.createDiscountGroup('Discount 2',partnerAccount1.Id,branch1.Id,null,true,'Purchase Price');
        
        dmpl__DiscountGroupRule__c discountGroupRule1 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30));
        dmpl__DiscountGroupRule__c discountGroupRule2 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item5.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30));
        dmpl__DiscountGroupRule__c discountGroupRule3 = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 5, 6),Date.newInstance(2025, 11, 30));
        
        dmpl__ItemUnitOfMeasure__c uomCaseItem5 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem5 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem1 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem1 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem6 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item6.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem6 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item6.Id);
        
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
        
        dmpl__Scheme__c scheme9 = SchemeDataHelper.createScheme('Scheme 9', 'Auto Apply', 'Draft', 'Per Sale Order And Invoice', 'per order', Date.newInstance(2025, 5, 26), Date.newInstance(2025, 6, 26), 0, 'Apply all Fulfilled', 1,false, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine9 = SchemeDataHelper.createSchemeLine(1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme9.Id);
        dmpl__SchemeCondition__c schemeCondition9 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit9 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Line Level Discount Percent', null, 1, 5, null, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget9 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme9.Id, partnerAccount1.Id);
        scheme9.dmpl__Status__c = 'Approved';
        update scheme9;
        
        dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme('Scheme 20', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme20.Id);
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 18, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partnerAccount1.Id);
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;
    }
    
    @isTest
    static void createPartnerAccountMapping() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertEquals(Date.today(), partnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.today().addDays(1), partnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void updatePartnerAccountMapping() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        partnerAccountMapping.dmpl__ToDate__c = Date.today().addDays(2);
        update partnerAccountMapping;
        dmpl__PartnerAccountMapping__c updatedPartnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertEquals(Date.today(), updatedPartnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.today().addDays(2), updatedPartnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void deletePartnerAccountMapping() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertNotEquals(null, partnerAccountMapping, 'Partner Account Mapping should exist before deletion.');
        Id mappingId = partnerAccountMapping.Id;
        delete partnerAccountMapping;
        dmpl__PartnerAccountMapping__c deletedMapping;
        try {
            deletedMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping(mappingId);
        } catch (Exception e) {
            deletedMapping = null;
        }
        System.assertEquals(null, deletedMapping, 'Partner Account Mapping should be marked as deleted.');
    }
    
    
    @isTest
    static void editPartnerAccountMappingToExtendToDatePositiveEdit() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');        
        Date fromDate = Date.newInstance(2024, 8, 21);
        Date toDate = Date.newInstance(2025, 5, 21);
        Date toDateExtended = Date.newInstance(2025, 6, 21);
        
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMappingCustom(
            'Mapping 1',
            partnerAccount.id,
            fromDate,
            toDate
       
            
        );
        
        mapping.dmpl__ToDate__c = toDateExtended;
        update mapping;
        
        dmpl__PartnerAccountMapping__c updated = PartnerAccountMappingTestDataHelpers.getPartnerAccountMappingById(mapping.Id);
        System.assertEquals(partnerAccount.Id, updated.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(fromDate, updated.dmpl__FromDate__c, 'From Date should match');
        System.assertEquals(toDateExtended, updated.dmpl__ToDate__c, 'To Date should be updated/extended');
        Test.stopTest();
    }
    
    
    @isTest
    static void createPartnerAccountMappingWithoutNameNegativeNew() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Date fromDate = Date.newInstance(2024, 8, 21);
        Date toDate = Date.newInstance(2025, 6, 21);
        
        
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        
        Boolean exceptionThrown = false;
        try {
            dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
                null,
            customerAccount,
            branch,
            itemGroup,
            item,
            partnerAccount,
            toDate
                );
            System.assert(false, 'Exception should be thrown when Partner Account Mapping Name is missing, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Partner Account Mapping Name is missing');
        Test.stopTest();
    }
    
    @isTest
    static void createMappingBetweenValidPartnerAccountAndCustomerWithCorrectBranchSelectedPositiveNew(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        Date toDate = Date.newInstance(2025, 6, 30);
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
            'Mapping 1',
        customerAccount,
        branch,
        itemGroup,
        item,
        partnerAccount,
        toDate
            );
        
        mapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMappingById(mapping.Id);
        
        System.assertNotEquals(null, mapping, 'Mapping should be created successfully');
        System.assertEquals(partnerAccount.Id, mapping.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(customerAccount.Id, mapping.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(branch.Id, mapping.dmpl__BranchId__c, 'Branch should match');
        Test.stopTest();
    }

    @isTest
static void createPartnerAccountMappingWithMismatchedBranchAndPartnerAccountNegativeNew() {
    Test.startTest();
    Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c mismatchedBranch = TestDataHelpers.getBranch('Branch 6');
    Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
    Date toDate = Date.newInstance(2025, 6, 30);

    Boolean exceptionThrown = false;
    try {
        dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
            'Mapping Mismatch',
            customerAccount,
            mismatchedBranch,
            itemGroup,
            item,
            partnerAccount,
            toDate
        );
        System.assert(false, 'Exception should be thrown when Branch and Partner Account do not match, but record was created.');
    } catch (Exception e) {
        exceptionThrown = true;
    }
    System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched Branch and Partner Account');
    Test.stopTest();
}

@isTest
static void excludeAnItemGroupFromPartnerAccountMappingToRestrictPurchaseVisibilityPositiveEdit() {
    Test.startTest();
    Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
    Date toDate = Date.newInstance(2025, 6, 30);

    dmpl__PartnerAccountMapping__c mapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping(
        'Mapping 1',
        customerAccount,
        branch,
        null, 
        item,
        partnerAccount,
        toDate
    );

    mapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMappingById(mapping.Id);

    System.assertNotEquals(null, mapping, 'Mapping should be created successfully');
    System.assertEquals('Mapping 1', mapping.Name, 'Name should match');
    System.assertEquals(customerAccount.Id, mapping.dmpl__AccountId__c, 'Customer Account should match');
    System.assertEquals(branch.Id, mapping.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(null, mapping.dmpl__ItemGroupId__c, 'Item Group should be excluded (null)');
    System.assertEquals(item.Id, mapping.dmpl__ItemId__c, 'Item should match');
    System.assertEquals(partnerAccount.Id, mapping.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(toDate, mapping.dmpl__ToDate__c, 'To Date should match');
    Test.stopTest();
}
    
    
}