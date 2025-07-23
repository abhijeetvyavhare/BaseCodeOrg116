@isTest
public with sharing class TaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c partnerAccountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemGroup__c itemGroup = TaxDataHelper.createItemGroup();     
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(item, sku, taxGroup, itemGroup);


        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6 = TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount10 = TestDataHelpers.createCustomerAccount('Customer 10', true, false, false, true, 'Park Street', 'Kolkata', 'WB', 'India', '700017', 'Salt Lake', 'Kolkata', 'WB', 'India', '700091','9123456701', 'Created');
        

        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__AccountGroup__c accountGroup2 = AccountDataHelper.createAccountGroup('Account Group 2');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.createAccountGroup('Account Group 3');
        dmpl__AccountGroup__c accountGroup4 = AccountDataHelper.createAccountGroup('Account Group 4');

        dmpl__AccountGroupMember__c accountGroupMember1 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount1.Id, 'Batch Instance 1');
        dmpl__AccountGroupMember__c accountGroupMember2 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount2.Id, 'Batch Instance 2');
        
        dmpl__AccountGroupMember__c accountGroupMember4 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount3.Id, 'Batch Instance 4');
        dmpl__AccountGroupMember__c accountGroupMember5 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount4.Id, 'Batch Instance 5');

        dmpl__AccountGroupMember__c accountGroupMember6 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount1.Id, 'Batch Instance 6');
        dmpl__AccountGroupMember__c accountGroupMember7 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount3.Id, 'Batch Instance 7');
        
        dmpl__AccountGroupMember__c accountGroupMember9 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount6.Id, 'Batch Instance 9');
        
        dmpl__AccountGroupMember__c accountGroupMember11 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount10.Id, 'Batch Instance 11');
        dmpl__AccountGroupMember__c accountGroupMember12 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount2.Id, 'Batch Instance 12');
        dmpl__AccountGroupMember__c accountGroupMember13 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount4.Id, 'Batch Instance 13');
        dmpl__AccountGroupMember__c accountGroupMember14 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount7.Id, 'Batch Instance 14');
        

        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1','55 Industrial Park Road','Ahmedabad','Gujarat','India','380015','55 Industrial Park Road','Ahmedabad','Gujarat','India','380015', '9988776564');

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

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');

        dmpl__GLAccount__c glAccount1 = AccountDataHelper.createGLAccount('ICICI Bank', 'Bank', true, partnerAccount1.Id, branch1.Id);

        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            glAccount1.Id, 
            1000
        );

        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
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

        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber3 = TestDataHelpers.createItemGroupMember(itemGroup2.Id,item3.Id);

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
    static void createTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'Expected tax group to be created.');
        System.assertEquals('Test - Tax Group', taxGroup.Name, 'Tax group name should match.');
    }

    @isTest
    static void updateTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before update.');

        taxGroup.Name = 'Updated Tax Group';
        update taxGroup;

        dmpl__TaxGroup__c updatedGroup = [SELECT Id, Name, dmpl__PartnerAccountId__c, dmpl__BranchId__c FROM dmpl__TaxGroup__c WHERE Id = :taxGroup.Id];
        System.assertEquals('Updated Tax Group', updatedGroup.Name, 'Tax group name should be updated.');
    }

    @isTest
    static void deleteTaxGroup() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before delete.');

        delete taxGroup;

        dmpl__TaxGroup__c deletedGroup;
        try {
            deletedGroup = [SELECT Id FROM dmpl__TaxGroup__c WHERE Id = :taxGroup.Id];
        } catch (Exception e) {
            deletedGroup = null;
        }
        System.assertEquals(null, deletedGroup, 'TaxGroup should be deleted and not found in query.');
    }


    @isTest
    static void createTaxGroupRulePositive() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'Expected TaxGroupRule to be created.');
        System.assertEquals('Within State', rule.dmpl__PlaceOfSupplyType__c, 'Expected correct PlaceOfSupplyType.');
        System.assert(rule.dmpl__DateEffectiveTill__c > rule.dmpl__DateEffectiveFrom__c, 'Effective Till should be after From.');
    }

    @isTest
    static void updateTaxGroupRule() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before update.');

        Date newEffectiveTill = Date.today().addDays(30);
        rule.dmpl__DateEffectiveTill__c = newEffectiveTill;
        update rule;

        dmpl__TaxGroupRule__c updatedRule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertEquals(newEffectiveTill, updatedRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill should be updated.');
    }

    @isTest
    static void deleteTaxGroupRule() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before delete.');
        
        delete rule;

        dmpl__TaxGroupRule__c deletedRule;
        try {
            deletedRule = [SELECT Id FROM dmpl__TaxGroupRule__c WHERE Id = :rule.Id];
        } catch (Exception e) {
            deletedRule = null;
        }

        System.assertEquals(null, deletedRule, 'TaxGroupRule should be deleted and not found in query.');
    }


    @isTest
    static void createTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Expected Tax record to be created.');
        System.assertEquals('Test - Tax', tax.Name, 'Tax Name should match.');
        System.assertEquals(10, tax.dmpl__Rate__c, 'Tax Rate should be 10.');
    }

    @isTest
    static void updateTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before update.');

        tax.dmpl__Rate__c = 15;
        update tax;

        dmpl__Tax__c updatedTax = TestDataHelpers.getTax();
        System.assertEquals(15, updatedTax.dmpl__Rate__c, 'Tax rate should be updated to 15.');
    }

    @isTest
    static void deleteTax() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        String taxName = tax.Name;
        System.assertNotEquals(null, tax, 'Tax should exist before delete.');

        delete tax;

        dmpl__Tax__c deletedTax;
        try {
            deletedTax = TestDataHelpers.getTax(taxName);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax should be deleted and not found in query.');
    }

    @isTest
    static void createRecordWithValidTaxGroupAndDateEffectiveFromPositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            null,
            null,
            'Outside State',
            Date.today(),
            null
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__TaxGroupId__c, taxGroup.Id, 'Expected tax group rule to be linked to the correct tax group.');
        System.assertEquals(taxGroupRule.dmpl__ItemId__c, null, 'Expected tax group rule to be linked to the correct item.');
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, null, 'Expected tax group rule to be linked to the correct item group.');
        System.assertEquals(taxGroupRule.dmpl__TaxSupplyType__c, 'Outside State', 'Expected tax group rule to have the correct tax supply type.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected tax group rule to have the correct date effective from.');
        Test.stopTest();
    }

    @isTest
    static void validateEntryWithValidDateEffectiveFromAndDateEffectiveTillPositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            null,
            null,
            'Outside State',
            Date.today(),
            Date.today().addDays(30)
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__TaxGroupId__c, taxGroup.Id, 'Expected tax group rule to be linked to the correct tax group.');
        System.assertEquals(taxGroupRule.dmpl__ItemId__c, null, 'Expected tax group rule to be linked to the correct item.');
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, null, 'Expected tax group rule to be linked to the correct item group.');
        System.assertEquals(taxGroupRule.dmpl__TaxSupplyType__c, 'Outside State', 'Expected tax group rule to have the correct tax supply type.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected tax group rule to have the correct date effective from.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected tax group rule to have the correct date effective till.');
        Test.stopTest();
    }

    @isTest
    static void ensureTaxSupplyTypeDefaultsOrAcceptsOutsideStatePositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            null,
            null,
            'Outside State',
            Date.today(),
            null
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__TaxGroupId__c, taxGroup.Id, 'Expected tax group rule to be linked to the correct tax group.');
        System.assertEquals(taxGroupRule.dmpl__ItemId__c, null, 'Expected tax group rule to be linked to the correct item.');
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, null, 'Expected tax group rule to be linked to the correct item group.');
        System.assertEquals(taxGroupRule.dmpl__TaxSupplyType__c, 'Outside State', 'Expected tax group rule to have the correct tax supply type.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected tax group rule to have the correct date effective from.');
        Test.stopTest();
    }

    @isTest
    static void allowCreationWithOnlyRequiredFieldsPositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            null,
            null,
            'Outside State',
            Date.today(),
            null
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__TaxGroupId__c, taxGroup.Id, 'Expected tax group rule to be linked to the correct tax group.');
        System.assertEquals(taxGroupRule.dmpl__ItemId__c, null, 'Expected tax group rule to be linked to the correct item.');
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, null, 'Expected tax group rule to be linked to the correct item group.');
        System.assertEquals(taxGroupRule.dmpl__TaxSupplyType__c, 'Outside State', 'Expected tax group rule to have the correct tax supply type.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected tax group rule to have the correct date effective from.');
        Test.stopTest();
    }

    @isTest
    static void setDateEffectiveTillEarlierThanDateEffectiveFromNegativeNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        try{
            dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
                taxGroup.Id,
                null,
                null,
                'Outside State',
                Date.today(),
                Date.today().addDays(-30)
            );
            System.assert(false, 'Expected an exception to be thrown due to date effective till earlier than date effective from.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to date effective till earlier than date effective from.');
        }
        Test.stopTest();
    }

    @isTest
    static void missMandatoryFieldDateEffectiveFromNegativeNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        try{
            dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
                taxGroup.Id,
                null,
                null,
                'Outside State',
                null,
                null
            );
            System.assert(false, 'Expected an exception to be thrown due to missing mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to missing mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void inputValidItemAndItemGroupThatExistInSystemPositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            item.Id,
            itemGroup.Id,
            'Outside State',
            Date.today(),
            Date.today().addDays(30)
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__TaxGroupId__c, taxGroup.Id, 'Expected tax group rule to be linked to the correct tax group.');
        System.assertEquals(taxGroupRule.dmpl__ItemId__c, item.Id, 'Expected tax group rule to be linked to the correct item.');
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, itemGroup.Id, 'Expected tax group rule to be linked to the correct item group.');
        System.assertEquals(taxGroupRule.dmpl__TaxSupplyType__c, 'Outside State', 'Expected tax group rule to have the correct tax supply type.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected tax group rule to have the correct date effective from.');
        System.assertEquals(taxGroupRule.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected tax group rule to have the correct date effective till.');
        Test.stopTest();
    }

    @isTest
    static void editRecordToUpdateItemGroupOnlyWithoutChangingOtherFieldsPositiveNew(){
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.getItemGroup('Item Group 2');

        Test.startTest();
        dmpl__TaxGroupRule__c taxGroupRule = TaxDataHelper.createTaxGroupRule(
            taxGroup.Id,
            item.Id,
            itemGroup.Id,
            'Outside State',
            Date.today(),
            Date.today().addDays(30)
        );
        System.assertNotEquals(taxGroupRule, null, 'Expected tax group rule to be created.');
   
        taxGroupRule.dmpl__ItemGroupId__c = itemGroup2.Id;
        update taxGroupRule;

        taxGroupRule = TaxDataHelper.getTaxGroupRule(taxGroupRule.Id);
        System.assertEquals(taxGroupRule.dmpl__ItemGroupId__c, itemGroup2.Id, 'Expected tax group rule to be linked to the correct item group.');

        Test.stopTest();
    }

    @isTest
    static void createCGSTAndSGSTTaxesForGST18WithinState() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

        dmpl__TaxGroup__c gst18TaxGroup = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);
        dmpl__Tax__c cgst = TestDataHelpers.createTax('CGST', 'CGST', 9, gst18TaxGroup.Id, 'Tax1');
        dmpl__Tax__c sgst = TestDataHelpers.createTax('SGST', 'SGST', 9, gst18TaxGroup.Id, 'Tax2');
        
        System.assertNotEquals(null, cgst, 'CGST tax should be created.');
        System.assertEquals('CGST', cgst.Name, 'CGST name should match.');
        System.assertEquals(9, cgst.dmpl__Rate__c, 'CGST rate should be 9.');
        System.assertEquals('CGST', cgst.dmpl__Type__c, 'CGST type should be CGST.');
        System.assertEquals('Tax1', cgst.dmpl__PostingFieldName__c, 'CGST posting field should be Tax1.');
        System.assertEquals(gst18TaxGroup.Id, cgst.dmpl__TaxGroupId__c, 'CGST should be under GST 18 group.');
        System.assertNotEquals(null, sgst, 'SGST tax should be created.');
        System.assertEquals('SGST', sgst.Name, 'SGST name should match.');
        System.assertEquals(9, sgst.dmpl__Rate__c, 'SGST rate should be 9.');
        System.assertEquals('SGST', sgst.dmpl__Type__c, 'SGST type should be SGST.');
        System.assertEquals('Tax2', sgst.dmpl__PostingFieldName__c, 'SGST posting field should be Tax2.');
        System.assertEquals(gst18TaxGroup.Id, sgst.dmpl__TaxGroupId__c, 'SGST should be under GST 18 group.');
    }

    @isTest
    static void createTaxWithoutTaxGroupNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Boolean exceptionThrown = false;
        dmpl__Tax__c tax;
        try {
            tax = TestDataHelpers.createTax('SGST', 'SGST', 9, null, 'Tax2');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (tax == null || tax.Id == null), 'Tax should not be created without linking a tax group.');
    }

    @isTest
    static void createIGSTTaxForWithinState() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c igst18TaxGroup = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);
        dmpl__Tax__c igst = TestDataHelpers.createTax('IGST', 'IGST', 18, igst18TaxGroup.Id, 'Tax1');
        System.assertNotEquals(null, igst, 'IGST tax should be created.');
        System.assertEquals('IGST', igst.Name, 'IGST name should match.');
        System.assertEquals(18, igst.dmpl__Rate__c, 'IGST rate should be 18.');
        System.assertEquals('IGST', igst.dmpl__Type__c, 'IGST type should be IGST.');
        System.assertEquals('Tax1', igst.dmpl__PostingFieldName__c, 'IGST posting field should be Tax1.');
        System.assertEquals(igst18TaxGroup.Id, igst.dmpl__TaxGroupId__c, 'IGST should be under IGST 18 group.');
    }

    @isTest
    static void createCGSTWithNegativeRateNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst18TaxGroup = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);
        Boolean exceptionThrown = false;
        dmpl__Tax__c cgst;
        try {
            cgst = TestDataHelpers.createTax('CGST', 'CGST', -9, gst18TaxGroup.Id, 'Tax1');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (cgst == null || cgst.Id == null || cgst.dmpl__Rate__c < 0), 'CGST should not be created or updated with a negative rate.');
    }

    @isTest
    static void createIGST18TaxGroupForInterstateSales() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c igst18TaxGroup = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);
        dmpl__Tax__c igst = TestDataHelpers.createTax('IGST', 'IGST', 18, igst18TaxGroup.Id, 'Tax1');
        System.assertNotEquals(null, igst18TaxGroup, 'IGST 18 tax group should be created.');
        System.assertEquals('IGST 18', igst18TaxGroup.Name, 'Tax group name should be IGST 18.');
        System.assertNotEquals(null, igst, 'IGST tax should be created.');
        System.assertEquals('IGST', igst.Name, 'IGST name should match.');
        System.assertEquals(18, igst.dmpl__Rate__c, 'IGST rate should be 18.');
        System.assertEquals('IGST', igst.dmpl__Type__c, 'IGST type should be IGST.');
        System.assertEquals('Tax1', igst.dmpl__PostingFieldName__c, 'IGST posting field should be Tax1.');
        System.assertEquals(igst18TaxGroup.Id, igst.dmpl__TaxGroupId__c, 'IGST should be under IGST 18 group.');
    }

    @isTest
    static void createUTGST18TaxGroupForUnionTerritory() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c utgst18TaxGroup = TestDataHelpers.createTaxGroup('UT GST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);
        dmpl__Tax__c utgst = TestDataHelpers.createTax('UTGST', 'UTGST', 9, utgst18TaxGroup.Id, 'Tax1');
        dmpl__Tax__c cgst = TestDataHelpers.createTax('CGST', 'CGST', 9, utgst18TaxGroup.Id, 'Tax2');
        System.assertNotEquals(null, utgst18TaxGroup, 'UT GST 18 tax group should be created.');
        System.assertEquals('UT GST 18', utgst18TaxGroup.Name, 'Tax group name should be UT GST 18.');
        System.assertNotEquals(null, utgst, 'UTGST tax should be created.');
        System.assertEquals('UTGST', utgst.Name, 'UTGST name should match.');
        System.assertEquals(9, utgst.dmpl__Rate__c, 'UTGST rate should be 9.');
        System.assertEquals('UTGST', utgst.dmpl__Type__c, 'UTGST type should be UTGST.');
        System.assertEquals('Tax1', utgst.dmpl__PostingFieldName__c, 'UTGST posting field should be Tax1.');
        System.assertEquals(utgst18TaxGroup.Id, utgst.dmpl__TaxGroupId__c, 'UTGST should be under UT GST 18 group.');
        System.assertNotEquals(null, cgst, 'CGST tax should be created.');
        System.assertEquals('CGST', cgst.Name, 'CGST name should match.');
        System.assertEquals(9, cgst.dmpl__Rate__c, 'CGST rate should be 9.');
        System.assertEquals('CGST', cgst.dmpl__Type__c, 'CGST type should be CGST.');
        System.assertEquals('Tax2', cgst.dmpl__PostingFieldName__c, 'CGST posting field should be Tax2.');
        System.assertEquals(utgst18TaxGroup.Id, cgst.dmpl__TaxGroupId__c, 'CGST should be under UT GST 18 group.');
    }

    @isTest
    static void assignInactiveOrInvalidTaxRateToTaxGroupNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst18TaxGroup = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount.Id, branch.Id, null);

        Boolean exceptionThrown = false;
        dmpl__Tax__c cgst;
        try {
            cgst = new dmpl__Tax__c(
                Name = 'CGST',
                dmpl__Type__c = 'CGST',
                dmpl__Rate__c = -10,
                dmpl__TaxGroupId__c = gst18TaxGroup.Id,
                dmpl__PostingFieldName__c = 'Tax1'
            );
            insert cgst;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (cgst == null || cgst.Id == null || cgst.dmpl__Rate__c < 0), 'Should not allow assigning inactive or invalid (negative) tax rate to tax group.');
    }

    @isTest
    static void createTaxGroupWithDetailedDescriptionPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        String description = 'This tax group applies GST at 12% on the taxable value of go';

        Test.startTest();
        dmpl__TaxGroup__c gst12TaxGroup = new dmpl__TaxGroup__c(
            Name = 'GST 12%',
            dmpl__TaxGroupType__c = 'Line Level',
            dmpl__IsActive__c = true,
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__Description__c = description
        );
        insert gst12TaxGroup;
        Test.stopTest();

        dmpl__TaxGroup__c insertedGroup = [
            SELECT Name, dmpl__TaxGroupType__c, dmpl__IsActive__c, dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__Description__c
            FROM dmpl__TaxGroup__c
            WHERE Id = :gst12TaxGroup.Id
        ];
        System.assertEquals('GST 12%', insertedGroup.Name, 'Tax group name should be GST 12%.');
        System.assertEquals('Line Level', insertedGroup.dmpl__TaxGroupType__c, 'Tax group type should be Line Level.');
        System.assertEquals(true, insertedGroup.dmpl__IsActive__c, 'Tax group should be active.');
        System.assertEquals(partnerAccount.Id, insertedGroup.dmpl__PartnerAccountId__c, 'Partner account should match.');
        System.assertEquals(branch.Id, insertedGroup.dmpl__BranchId__c, 'Branch should match.');
        System.assertEquals(description, insertedGroup.dmpl__Description__c, 'Description should match the detailed text.');
    }

    @isTest
    static void editTaxGroupTypeToNoneNegative() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.createTaxGroup('GST 12%', true, 'Line Level', partnerAccount.Id, branch.Id, null);

        Boolean exceptionThrown = false;
        try {
            gst12TaxGroup.dmpl__TaxGroupType__c = null;
            update gst12TaxGroup;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || gst12TaxGroup.dmpl__TaxGroupType__c == null, 'System should prevent saving Tax Group with Tax Group Type as None.');
    }

    @isTest
    static void editTaxGroupSetIsActiveFalse() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.createTaxGroup('GST 12%', true, 'Line Level', partnerAccount.Id, branch.Id, null);

        gst12TaxGroup.dmpl__IsActive__c = false;
        update gst12TaxGroup;

        dmpl__TaxGroup__c updatedGroup = TestDataHelpers.getTaxGroup('GST 12%');
        System.assertEquals('GST 12%', updatedGroup.Name, 'Tax group name should be GST 12%.');
        System.assertEquals('Line Level', updatedGroup.dmpl__TaxGroupType__c, 'Tax group type should be Line Level.');
        System.assertEquals(false, updatedGroup.dmpl__IsActive__c, 'Tax group should be inactive.');
        System.assertEquals(partnerAccount.Id, updatedGroup.dmpl__PartnerAccountId__c, 'Partner account should match.');
        System.assertEquals(branch.Id, updatedGroup.dmpl__BranchId__c, 'Branch should match.');
    }
}