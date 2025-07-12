@isTest 
public with sharing class JournalEntryHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Id partnerAccountId = partnerAccount.Id;
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partnerAccountId);
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.createJournalEntryLines(journal.Id);


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
        //dmpl__AccountGroupMember__c accountGroupMember3 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount5.Id, 'Batch Instance 3');
        dmpl__AccountGroupMember__c accountGroupMember4 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount3.Id, 'Batch Instance 4');
        dmpl__AccountGroupMember__c accountGroupMember5 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount4.Id, 'Batch Instance 5');

        dmpl__AccountGroupMember__c accountGroupMember6 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount1.Id, 'Batch Instance 6');
        dmpl__AccountGroupMember__c accountGroupMember7 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount3.Id, 'Batch Instance 7');
        //dmpl__AccountGroupMember__c accountGroupMember8 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount5.Id, 'Batch Instance 8');
        dmpl__AccountGroupMember__c accountGroupMember9 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount6.Id, 'Batch Instance 9');
        //dmpl__AccountGroupMember__c accountGroupMember10 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount8.Id, 'Batch Instance 10');
        dmpl__AccountGroupMember__c accountGroupMember11 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount10.Id, 'Batch Instance 11');
        dmpl__AccountGroupMember__c accountGroupMember12 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount2.Id, 'Batch Instance 12');
        dmpl__AccountGroupMember__c accountGroupMember13 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount4.Id, 'Batch Instance 13');
        dmpl__AccountGroupMember__c accountGroupMember14 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount7.Id, 'Batch Instance 14');
        //dmpl__AccountGroupMember__c accountGroupMember15 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount9.Id, 'Batch Instance 15');

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

        dmpl__ItemAlternate__c itemAlternate16 = TestDataHelpers.createItemAlternate(item15.Id,item16.Id,'Superseded',Date.newInstance(2025, 6, 30));
        dmpl__ItemAlternate__c itemAlternate13 = TestDataHelpers.createItemAlternate(item14.Id, item13.Id, 'Superseded', Date.newInstance(2025, 6, 30));
        

        dmpl__SKU__c sku7 = TestDataHelpers.createSKU('SKU 7', item7.id, true);
        dmpl__SKU__c sku8 = TestDataHelpers.createSKU('SKU 8', item8.id, false);

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
    static void createJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        System.assertNotEquals(journal, null, 'Expected Journal Entry to be created.');
        System.assertEquals('INR', journal.dmpl__Currency__c, 'Expected currency to be INR.');
    }
     
    @isTest
    static void updateJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        journal.dmpl__Notes__c = 'Updated notes';
        update journal;        
        dmpl__JournalEntry__c updatedJournal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals('Updated notes', updatedJournal.dmpl__Notes__c, 'Expected notes to be updated.');
    }

    @isTest
    static void deleteJournalEntry() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        delete journal;
        
        Integer count = [SELECT COUNT() FROM dmpl__JournalEntry__c WHERE Id = :journal.Id];
        System.assertEquals(0, count, 'Expected Journal Entry to be deleted.');
    }
     
    @isTest
    static void createJournalEntryLinesPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        
        System.assert(lines.size() > 0, 'Expected at least one Journal Entry Line.');
    }
     
    @isTest
    static void updateJournalEntryLinePositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            dmpl__JournalEntryLine__c line = lines[0];
            
            line.dmpl__Credit__c = 500;
            update line;
            dmpl__JournalEntryLine__c updatedLine = JournalEntryDataHelper.getJournalEntryLine(line.Id);
            System.assertEquals(500, updatedLine.dmpl__Credit__c, 'Expected credit amount to be updated.');
        }
    }
     
    @isTest
    static void deleteJournalEntryLine() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            Id lineIdToDelete = lines[0].Id;
            delete lines[0];
            
            Integer count = [SELECT COUNT() FROM dmpl__JournalEntryLine__c WHERE Id = :lineIdToDelete];
            System.assertEquals(0, count, 'Expected Journal Entry Line to be deleted.');
        }
    }

    @isTest 
    static void createRecordWithValidDocumentDateCurrencyAndPartnerAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals(journal.dmpl__PartnerAccountId__c, partner1.Id, 'Expected journal entry to be linked to the correct partner.');
        System.assertEquals(journal.dmpl__Currency__c, 'INR', 'Expected journal entry to have the correct currency.');
        System.assertEquals(journal.dmpl__DocumentDate__c, Date.today(), 'Expected journal entry to have the correct document date.');
        Test.stopTest();
    }

    @isTest
    static void validateCreationWithOnlyRequiredFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals(journal.dmpl__PartnerAccountId__c, partner1.Id, 'Expected journal entry to be linked to the correct partner.');
        System.assertEquals(journal.dmpl__Currency__c, 'INR', 'Expected journal entry to have the correct currency.');
        System.assertEquals(journal.dmpl__DocumentDate__c, Date.today(), 'Expected journal entry to have the correct document date.');
        Test.stopTest();
    }

    @isTest
    static void skipMandatoryFieldDocumentDateNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        try{
            dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
                partner1.Id,
                'INR',
                null
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch(Exception e) {
            System.Assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void useInvalidValueInCurrencyNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        try{
            dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
                partner1.Id,
                'LRDT',
                System.today()
            );
            System.assert(false, 'Expected an exception to be thrown due to invalid currency.');
        } catch(Exception e) {
            System.assert(true, 'Expected exception due to invalid currency.');
        }
        Test.stopTest();
    }


    @isTest
    static void createRecordWithValidDebitCreditJournalEntryPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);

        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(
            journal.Id,
            100,
            200
        );
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        System.assertEquals(journalEntryLine.dmpl__Credit__c, 200, 'Expected journal entry line to have the correct credit amount.');
        System.assertEquals(journalEntryLine.dmpl__Debit__c, 100, 'Expected journal entry line to have the correct debit amount.');
        Test.stopTest();
    }

    @isTest
    static void validateEntryWithOnlyDebitOrCreditPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);

        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(
            journal.Id,
            100,
            null
        );
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        Test.stopTest();
    }

    @isTest
    static void doNotPopulateMandatoryJournalEntryLineFieldNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        try{
            dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(
                null,
                100,
                200
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch( Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void inputNegativeValuesInCreditAndDebitPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(
            partner1.Id,
            'INR',
            Date.today()
        );
        System.assertNotEquals(journal, null, 'Expected journal entry to be created.');
        journal = JournalEntryDataHelper.getJournalEntry(journal.Id);

        dmpl__JournalEntryLine__c journalEntryLine = JournalEntryDataHelper.createJournalEntryLine(
            journal.Id,
            -100,
            -200
        );
        System.assertNotEquals(journalEntryLine, null, 'Expected journal entry line to be created.');
        journalEntryLine = JournalEntryDataHelper.getJournalEntryLine(journalEntryLine.Id);
        System.assertEquals(journalEntryLine.dmpl__JournalEntryId__c, journal.Id, 'Expected journal entry line to be linked to the correct journal entry.');
        System.assertEquals(journalEntryLine.dmpl__Credit__c, -200, 'Expected journal entry line to have the correct credit amount.');
        System.assertEquals(journalEntryLine.dmpl__Debit__c, -100, 'Expected journal entry line to have the correct debit amount.');
        Test.stopTest();
    }
}