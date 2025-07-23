@isTest
public class KYCDocumentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();

        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(TestDataHelpers.getCustomerAccount(),TestDataHelpers.getBranch(),
        TestDataHelpers.getContactAddress(),TestDataHelpers.getPriceList());
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.createKYCDocuments(saleOrder);

        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, partnerAccount.ID, accGroup.Id);

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
    static void createKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        
        System.assertEquals('3534534', KYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void updateKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        
        KYCDocument.dmpl__DocumentNumber__c = '343434';
        
        update KYCDocument;
        
        dmpl__KYCDocument__c updatedKYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertEquals('343434', updatedKYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void deleteKYCDocument() {
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertNotEquals(null, kycDocument, 'KYC Document should exist before deletion.');
        
        Id docId = kycDocument.Id;
        
        delete kycDocument;
        
        dmpl__KYCDocument__c deletedDoc;
        
        try {
            deletedDoc = KYCDocumentsTestDataHelpers.getKYCDocument(docId);
        } catch (Exception e) {
            deletedDoc = null;
        }
        
        System.assertEquals(null, deletedDoc, 'KYC Document should be deleted and not found in query.');
    }
    
    @isTest
    static void createKYCDocumentWithValidDocumentTypeAndKYCTypeLinkedToASaleOrderAndBranchPositiveNew() {
        Test.startTest();
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        
        
        
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        priceList = TestDataHelpers.getPriceList();
        
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount,
        branch,
        null,
        priceList
            
        );
        saleOrder = saleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.debug('Sale Order : ' + saleOrder);
        
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            
        saleOrder,
        item,
        sku,
        taxGroup
            );
        
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
            saleOrder,
        'Sample',
        'Identity Proof',
        'DOC25060203'
            );
        
        System.assertNotEquals(null, kycDocument, 'KYC Document should be created');
        System.assertEquals(saleOrder.Id, kycDocument.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals('Sample', kycDocument.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Identity Proof', kycDocument.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('DOC25060203', kycDocument.dmpl__DocumentNumber__c, 'Document Number should match');
        Test.stopTest();
    }
    
    
    @isTest
    static void attemptToSaveTheKYCWithoutSelectingValidKYCTypeNegativeNew() {
        Test.startTest();
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        priceList = TestDataHelpers.getPriceList();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount,
        branch,
        null,
        priceList
            
        );
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            
        saleOrder,
        item,
        sku,
        taxGroup
            );
        
        Boolean exceptionThrown = false;
        try {
            dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
                saleOrder,
            branch,
            'Sample',
            null,
            'DOC25060203'
                );
            System.assert(false, 'Exception should be thrown when KYC Type is missing, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when KYC Type is missing');
        Test.stopTest();
    }
    
    @isTest
    public static void linkTheKYCDocumentToAnExistingFinanceCaseForValidationTrackingPositiveNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
        branch,
        financer,
        scheme
        );
        
        financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
        saleOrder,
        financeCase,
        'Sample',
        'Address Proof',
        'DOC25060016'
            );
        
        System.assertNotEquals(null, kycDocument, 'KYC Document should be created');
        System.assertEquals(financeCase.Id, kycDocument.dmpl__FinanceCaseId__c, 'Finance Case should match');
        System.assertEquals('Sample', kycDocument.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Address Proof', kycDocument.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('DOC25060016', kycDocument.dmpl__DocumentNumber__c, 'Document Number should match');
        Test.stopTest();
        
        
    }
    
    @isTest
    public static void verifyAndMarkTheIsVerifiedCheckboxAfterCrossVerifyingTheAttachedDocumentsPositiveEdit() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
            saleOrder,
        'Sample',
        'Address Proof',
        'DOC25060012'
            );
        
        
        kycDocument.dmpl__IsVerified__c = true;
        update kycDocument;
        
        dmpl__KYCDocument__c updated = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        
        System.assertEquals('DOC25060012', updated.dmpl__DocumentNumber__c, 'Document Number should match');
        System.assertEquals('Sample', updated.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals(true, updated.dmpl__IsVerified__c, 'Is Verified should be true');
        System.assertEquals('Address Proof', updated.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals(saleOrder.Id, updated.dmpl__SaleOrderId__c, 'Sale Order should match');
        Test.stopTest();
    }
    
    @isTest
    public static void updateExistingKYCRecordWithNewDocumentNumberForAuditTrailPositiveEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCaseForTest(
            customer,
        partner,
        branch,
        financer,
        scheme,
        saleOrder
            );
        
        financeCase = FinanceCaseDataHelper.getFinanceCase(financeCase.Id);
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
            saleOrder,
            financeCase,
        'Sample',
        'Address Proof',
        'DOC25060012'
            );
        
        kycDocument.dmpl__DocumentNumber__c = 'DOC25060016';
        update kycDocument;
        
        dmpl__KYCDocument__c updated = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        System.assertEquals(financeCase.Id, updated.dmpl__FinanceCaseId__c, 'Finance Case should match');
        System.assertEquals('Sample', updated.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals(false, updated.dmpl__IsVerified__c, 'Is Verified should be true');
        System.assertEquals('Address Proof', updated.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals('DOC25060016', updated.dmpl__DocumentNumber__c, 'Document Number should be updated');
        Test.stopTest();
    }
    
    @isTest
    public static void tryLinkingKYCDocumentToSaleOrderNotAssociatedWithBranchNegativeNew() {
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        
        
        Boolean exceptionThrown = false;
        try {
            dmpl__KYCDocument__c kycdocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
                saleOrder,
            branch2,
            'Sample',
            'Address Proof',
            'DOC25060012'
                );
            
            System.assert(false, 'Exception should be thrown when Sale Order is not associated with the Branch, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Sale Order is not associated with the Branch');
        Test.stopTest();
    }
    
    @isTest
    public static void populateSaleOrderLineFieldToRelateDocumentToSpecificProductLinesPositiveEdit() {
        Test.startTest();
        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

         dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            
        saleOrder,
        item,
        sku,
        taxGroup
            );

                     saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();

        
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
            saleOrder,
        'Sample',
        'Address Proof',
        'DOC25060012'
            );
        
        kycDocument.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
        update kycDocument;
        
        dmpl__KYCDocument__c updated = KYCDocumentsTestDataHelpers.getKYCDocument(kycDocument.Id);
        System.assertEquals('DOC25060012', updated.dmpl__DocumentNumber__c, 'Document Number should match');
        System.assertEquals('Sample', updated.dmpl__DocumentType__c, 'Document Type should match');
        System.assertEquals('Address Proof', updated.dmpl__KYCType__c, 'KYC Type should match');
        System.assertEquals(saleOrder.Id, updated.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(saleOrderLine.Id, updated.dmpl__SaleOrderLineId__c, 'Sale Order Line should match');
        Test.stopTest();
    }
    
    // DH 204 205 bhi nhi hai excel me
    
    @isTest
    public static void leaveMandatoryFieldsLikeBranchOrSaleOrderEmptyNegativeNew() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        
        Boolean exceptionThrown = false;
        try {
            dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.createKYCDocumentCustom(
                null,
            branch,
            'Sample',
            'Address Proof',
            'DOC25060012'
                );
            System.assert(false, 'Exception should be thrown when mandatory Sale Order is missing, but record was created.');
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when mandatory Sale Order is missing');
        Test.stopTest();
    }
    
}