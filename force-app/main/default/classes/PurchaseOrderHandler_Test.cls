@isTest
public with sharing class PurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax('CGST', 'CGST', 10, taxGroup.Id, 'Tax1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(branch, supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item, sku, purchaseOrder, taxGroup, purchaseRequisition);
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.createPurchaseOrderTax(purchaseOrder, tax, purchaseOrderLine);

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount5 = TestDataHelpers.createPartnerAccount('Partner 5', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038', '91-9966554432');

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
 
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015','9988776564');
        Account supplierAccount2 = TestDataHelpers.createSupplierAccount('Supplier 2', false, false, true, false, '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'Gujarat', 'India', '380015','9988745587');
 
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch5 = TestDataHelpers.createBranch('Branch 5', partnerAccount5.Id, true, true, false, false);
  
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1','All Rules Are Met', 'Scheme');
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount1.id);
        dmpl__AccountGroupMember__c accountGroupMember5 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount5.id);
        dmpl__AccountGroupMember__c accountGroupMember2 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount2.id);
 
        dmpl__PriceList__c purchasePriceList = TestDataHelpers.createPriceList('Purchase Price List', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Purchase Price');
        dmpl__PriceList__c purchasePriceList4 = TestDataHelpers.createPriceList('Purchase Price List', partnerAccount4.Id, branch4.Id, null, null, true, false, 'Purchase Price');
        dmpl__PriceList__c purchasePriceList5 = TestDataHelpers.createPriceList('Purchase Price List 3', partnerAccount5.Id, branch5.Id, null, null, true, false, 'Purchase Price');
 
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false, false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true, false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true, false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false, false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false, false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false,false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false, false);
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9','Product',true,false,true, '765456',false, false);
        dmpl__Item__c item12 = TestDataHelpers.createItem('Item 12','Product',true,false,false, '765456',false, true);
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
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item9.id, false);
 
        dmpl__PriceListRules__c priceListRulePurchase1 = TestDataHelpers.createPriceListRules(purchasePriceList.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRulePurchase2 = TestDataHelpers.createPriceListRules(purchasePriceList.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRulePurchase3 = TestDataHelpers.createPriceListRules(purchasePriceList.id, item5.id,null,null,0, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRulePurchase4 = TestDataHelpers.createPriceListRules(purchasePriceList4.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRulePurchase5 = TestDataHelpers.createPriceListRules(purchasePriceList5.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRulePurchase12 = TestDataHelpers.createPriceListRules(purchasePriceList.id, item12.id,null,null,1500, System.today()-1,System.today()+9);

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
        dmpl__TaxGroupRule__c taxGroupRule12Item12 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item12.Id,null,null,null);
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
        dmpl__DiscountGroupRule__c discountGroupRule4 = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id,item3.Id,null,null,null,4,Date.newInstance(2025, 5, 6),Date.newInstance(2025, 11, 30));
        dmpl__DiscountGroupRule__c discountGroupRule3 = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 5, 6),Date.newInstance(2025, 11, 30));
        dmpl__DiscountGroupRule__c discountGroupRule2purchase = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id, item1.Id, null, null, null, 4, Date.newInstance(2025, 6, 5), Date.newInstance(2025, 11, 30));
		dmpl__DiscountGroupRule__c discountGroupRule12purchase = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id, item12.Id, null, null, null, 4, Date.newInstance(2025, 6, 5), Date.newInstance(2025, 11, 30));
        
        dmpl__ItemUnitOfMeasure__c uomCaseItem5 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem5 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem1 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem1 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem6 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item6.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem6 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item6.Id);
 
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 7, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;

        dmpl__Scheme__c scheme9 = SchemeDataHelper.createScheme('Scheme 9', 'Auto Apply', 'Draft', 'Per Sale Order And Invoice', 'per order', Date.newInstance(2025, 5, 26), Date.newInstance(2025, 7, 26), 10, 'Apply all Fulfilled', 1,false, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine9 = SchemeDataHelper.createSchemeLine(1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme9.Id);
        dmpl__SchemeCondition__c schemeCondition9 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit9 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Line Level Discount Percent', null, 1, 5, null, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget9 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme9.Id, partnerAccount1.Id);
        scheme9.dmpl__Status__c = 'Approved';
        update scheme9;
        
        dmpl__Scheme__c scheme18 = SchemeDataHelper.createScheme('Scheme 18', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER',Date.newInstance(2025, 5, 20), Date.newInstance(2025, 7, 30), 2, 'Apply all Fulfilled', 1, false, null, accountGroup1.Id, null, null, null, 100000);
        dmpl__SchemeLine__c schemeLine18 = SchemeDataHelper.createSchemeLine( 1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme18.Id);
        dmpl__SchemeCondition__c schemeCondition18 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 15, schemeLine18.Id, scheme18.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit18 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine18.Id, scheme18.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget18 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme18.Id, accountGroup1);
        scheme18.dmpl__Status__c = 'Approved';
        update scheme18;
        
        dmpl__Scheme__c scheme17 = SchemeDataHelper.createScheme('Scheme 17', 'Auto Apply', 'Draft', 'Per Purchase Order And Bill', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 7, 30), 2, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine17 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme17.Id);
        dmpl__SchemeCondition__c schemeCondition17 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item3.Id, 20, schemeLine17.Id, scheme17.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit17 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item3.Id, 1, 100, null, schemeLine17.Id, scheme17.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget17 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme17.Id, partnerAccount4.Id);
        scheme17.dmpl__Status__c = 'Approved';
        update scheme17;

		dmpl__Scheme__c scheme13 = SchemeDataHelper.createScheme('Scheme 13', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 7, 30), 2, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine13 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme13.Id);
        dmpl__SchemeCondition__c schemeCondition13 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal ', item3.Id, 5, schemeLine13.Id, scheme13.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit13 = SchemeDataHelper.createSchemeBenefit('Percentage', 'Line Level Discount Percent', item3.Id, 1, 50, null, schemeLine13.Id, scheme13.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget13 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme13.Id, partnerAccount4.Id);
        
        Test.stopTest();
    }

    @isTest
    static void createPurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        if (purchaseOrder != null) {
            System.assertNotEquals(purchaseOrder, null, 'Expected purchaseOrder to be created.');
        }
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft.');
    }

    @isTest
    static void updatePurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before update.');
        purchaseOrder.dmpl__Status__c = 'Pending Approval';
        update purchaseOrder;
        dmpl__PurchaseOrder__c updatePurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals('Pending Approval', updatePurchaseOrder.dmpl__Status__c, 'Next status should be Released.');
    }

    @isTest
    static void deletePurchaseOrder() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before delete.');
        delete purchaseOrder;
        dmpl__PurchaseOrder__c deletedOrder = null;
        try {
            deletedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'PurchaseOrder should be deleted and not found in query.');
    }

    @isTest
    static void createPurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        if (purchaseOrderLine != null) {
            System.assertNotEquals(purchaseOrderLine, null, 'Expected purchaseOrderLine to be created.');
        }
        System.assertEquals(100, purchaseOrderLine.dmpl__UnitCost__c, 'Unit cost should be 100');
    }

    @isTest
    static void updatePurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        purchaseOrderLine.dmpl__UnitCost__c = 200;
        update purchaseOrderLine;
        System.assertEquals(200, purchaseOrderLine.dmpl__UnitCost__c, 'Unit cost should be 100');
    }

    @isTest
    static void deletePurchaseOrderLine() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        System.assertNotEquals(purchaseOrderLine, null, 'PurchaseOrderLine should exist before delete.');
        delete purchaseOrderLine;
        dmpl__PurchaseOrderLine__c deletedPOL = null;
        try {
            deletedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        } catch (Exception e) {
            deletedPOL = null;
        }
        System.assertEquals(null, deletedPOL, 'PurchaseOrderLine should be deleted and not found in query.');
    }

    @isTest
    static void createPurchaseOrderTaxPositive() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Expected purchase order tax to be created.');
        System.assertEquals(-4.00, purchaseOrderTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be -4.00');
        System.assertEquals(10.00, purchaseOrderTax.dmpl__TaxRate__c, 'TaxRate should be 10.00');
    }

    @isTest
    static void updatePurchaseOrderTaxPositive() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Purchase order tax should exist before update.');
        purchaseOrderTax.dmpl__TaxRate__c = 5;
        update purchaseOrderTax;
        dmpl__PurchaseOrderTax__c updatedTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax(purchaseOrderTax.Id);
        System.assertEquals(5, updatedTax.dmpl__TaxRate__c, 'TaxRate should be updated to 5.');
    }

    @isTest
    static void deletePurchaseOrderTax() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Purchase order tax should exist before delete.');
        delete purchaseOrderTax;
        dmpl__PurchaseOrderTax__c deletedTax = null;
        try {
            deletedTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax(purchaseOrderTax.Id);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Purchase order tax should be deleted and not found in query.');
    }

    @isTest
    static void purchaseOrderCreationWithInActiveSupplierAccEdit(){
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );

        po = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('56 Industrial Layout', po.dmpl__ShippingStreet__c, 'Shipping Street should be 56 Industrial Layout');
        System.assertEquals('Bengaluru', po.dmpl__ShippingCity__c, 'Shipping City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__ShippingState__c, 'Shipping State should be Karnataka');
        System.assertEquals('India', po.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('MG Road', po.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Bengaluru', po.dmpl__BillingCity__c, 'Billing City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__BillingState__c, 'Billing State should be Karnataka');
        System.assertEquals('560001', po.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 560001');
        System.assertEquals(System.today(), po.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', po.dmpl__Status__c, 'Status should be Draft');

        Account supplier2 = TestDataHelpers.getSupplierAccount('Supplier 2');
        po.dmpl__SupplierAccountId__c = supplier2.Id;

        try{
            update po;
            System.assert(false, 'Expected DmlException due to lookup filter on Supplier Account.');
            }catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Value does not exist or does not match filter criteria'),
                'Expected lookup filter error. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void purchaseOrderLineWithNoEnteredQuantityNew(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier1.Id, partnerAccount1.Id, branch1.Id);
        
        po = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('56 Industrial Layout', po.dmpl__ShippingStreet__c, 'Shipping Street should be 56 Industrial Layout');
        System.assertEquals('Bengaluru', po.dmpl__ShippingCity__c, 'Shipping City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__ShippingState__c, 'Shipping State should be Karnataka');
        System.assertEquals('560095', po.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 560095');
        System.assertEquals('India', po.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('MG Road', po.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Bengaluru', po.dmpl__BillingCity__c, 'Billing City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__BillingState__c, 'Billing State should be Karnataka');
        System.assertEquals('560001', po.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 560001');
        System.assertEquals(System.today(), po.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', po.dmpl__Status__c, 'Status should be Draft');

        try {
            dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(po.Id, item.Id, null, null);
            System.assert(false, 'Expected DmlException due to missing quantity.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') || e.getMessage().contains('Quantity'),
                'Expected validation error for missing quantity. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineTaxAppObjectModelObjectTaxesEdit(){
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
 
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id ,partner.Id,branch.Id);
        po = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
 
        System.assertEquals('56 Industrial Layout', po.dmpl__ShippingStreet__c, 'Shipping Street should be 56 Industrial Layout');
        System.assertEquals('Bengaluru', po.dmpl__ShippingCity__c, 'Shipping City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__ShippingState__c, 'Shipping State should be Karnataka');
        System.assertEquals('India', po.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('MG Road', po.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Bengaluru', po.dmpl__BillingCity__c, 'Billing City should be Bengaluru');
        System.assertEquals('Karnataka', po.dmpl__BillingState__c, 'Billing State should be Karnataka');
        System.assertEquals('560001', po.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 560001');
        System.assertEquals(System.today(), po.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', po.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            item.Id,
            taxGroup.Id,
            20
        );
 
        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertEquals(2000, insertedLine.dmpl__UnitCost__c, 'Unit Price should be 2000');
        System.assertEquals(2304, insertedLine.dmpl__Tax1__c, 'Tax1 should be 2304');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, insertedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2304, insertedLine.dmpl__Tax2__c, 'Tax2 should be 2304');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, insertedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(40000, insertedLine.dmpl__BaseAmount__c, 'Base Amount should be 40000');
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1600, insertedLine.dmpl__NetDiscount__c, 'Net Discount should be 1600');
        System.assertEquals(4608, insertedLine.dmpl__TaxAmount__c, 'Tax Amount should be 4608');
        System.assertEquals(43008, insertedLine.dmpl__GrossAmount__c, 'Gross Amount should be 43008');
 
       List<dmpl__PurchaseOrderTax__c> taxes = PurchaseOrderTestDataHelpers.getPurchaseOrderTaxPO(po.Id);
        Boolean foundCGST = false;
        Boolean foundSGST = false;
        for (dmpl__PurchaseOrderTax__c tax : taxes) {
            if (tax.dmpl__TaxId__c == 'CGST') {
                foundCGST = true;
                System.assertEquals('CGST', tax.dmpl__TaxId__c, 'TaxId should be CGST');
                System.assertEquals(2304, tax.dmpl__TaxAmount__c, 'TaxAmount for CGST should be 2304');
                System.assertEquals(38400, tax.dmpl__TaxOnAmount__c, 'TaxOnAmount for CGST should be 38400');
                System.assertEquals('GST 12%', tax.dmpl__TaxGroupId__c, 'TaxGroupId for CGST should be GST 12%');
                System.assertEquals(6, tax.dmpl__TaxRate__c, 'TaxRate for CGST should be 6');
                System.assertEquals(po.Id, tax.dmpl__PurchaseOrderId__c, 'PurchaseOrderId for CGST should match');
                System.assertEquals(insertedLine.Id, tax.dmpl__PurchaseOrderLineId__c, 'PurchaseOrderLineId for CGST should match');
            }
            if (tax.dmpl__TaxId__c == 'SGST') {
                foundSGST = true;
                System.assertEquals('SGST', tax.dmpl__TaxId__c, 'TaxId should be SGST');
                System.assertEquals(2304, tax.dmpl__TaxAmount__c, 'TaxAmount for SGST should be 2304');
                System.assertEquals(38400, tax.dmpl__TaxOnAmount__c, 'TaxOnAmount for SGST should be 38400');
                System.assertEquals('GST 12%', tax.dmpl__TaxGroupId__c, 'TaxGroupId for SGST should be GST 12%');
                System.assertEquals(6, tax.dmpl__TaxRate__c, 'TaxRate for SGST should be 6');
                System.assertEquals(po.Id, tax.dmpl__PurchaseOrderId__c, 'PurchaseOrderId for SGST should match');
                System.assertEquals(insertedLine.Id, tax.dmpl__PurchaseOrderLineId__c, 'PurchaseOrderLineId for SGST should match');
            }
        }

        dmpl__PurchaseOrder__c po2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(40000, po2.dmpl__TotalLineBaseAmount__c, 'TotalLineBaseAmount should be 40000');
        System.assertEquals(0, po2.dmpl__TotalSchemeDiscountAmount__c, 'TotalSchemeDiscountAmount should be 0');
        System.assertEquals(1600, po2.dmpl__TotalDiscountAmount__c, 'TotalDiscountAmount should be 1600');
        System.assertEquals(4608, po2.dmpl__TotalLineTaxAmount__c, 'TotalLineTaxAmount should be 4608');
        System.assertEquals(4608, po2.dmpl__TotalTaxAmount__c, 'TotalTaxAmount should be 4608');
        System.assertEquals(43008, po2.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be 43008');
        System.assertEquals('56 Industrial Layout', po2.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Bengaluru', po2.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Karnataka', po2.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('MG Road', po2.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Bengaluru', po2.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Karnataka', po2.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', po2.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('560001', po2.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals(Date.today(), po2.dmpl__DocumentDate__c, 'DocumentDate mismatch');
        System.assertEquals('Draft', po2.dmpl__Status__c, 'Status should be Draft');
       
        dmpl__PurchaseOrderLine__c purchaseOrderLine2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            item.Id,
            taxGroup.Id,
            5
        );
        dmpl__PurchaseOrderLine__c insertedLine2 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine2.Id);
        System.assertEquals(2000, insertedLine2.dmpl__UnitCost__c, 'UnitCost should be 2000');
        System.assertEquals(576, insertedLine2.dmpl__Tax1__c, 'Tax1 should be 576');
        System.assertEquals('CGST', insertedLine2.dmpl__Tax1Name__c, 'Tax1Name should be CGST');
        System.assertEquals(6, insertedLine2.dmpl__Tax1Rate__c, 'Tax1Rate should be 6');
        System.assertEquals('CGST', insertedLine2.dmpl__Tax1Type__c, 'Tax1Type should be CGST');
        System.assertEquals(576, insertedLine2.dmpl__Tax2__c, 'Tax2 should be 576');
        System.assertEquals('SGST', insertedLine2.dmpl__Tax2Name__c, 'Tax2Name should be SGST');
        System.assertEquals(6, insertedLine2.dmpl__Tax2Rate__c, 'Tax2Rate should be 6');
        System.assertEquals('SGST', insertedLine2.dmpl__Tax2Type__c, 'Tax2Type should be SGST');
        System.assertEquals(10000, insertedLine2.dmpl__BaseAmount__c, 'BaseAmount should be 10000');
        System.assertEquals(0, insertedLine2.dmpl__NetSchemeDiscount__c, 'NetSchemeDiscount should be 0');
        System.assertEquals(400, insertedLine2.dmpl__NetDiscount__c, 'NetDiscount should be 400');
        System.assertEquals(1152, insertedLine2.dmpl__TaxAmount__c, 'TaxAmount should be 1152');
        System.assertEquals(10752, insertedLine2.dmpl__GrossAmount__c, 'GrossAmount should be 10752');

        List<dmpl__PurchaseOrderTax__c> taxes2 = PurchaseOrderTestDataHelpers.getPurchaseOrderTaxPO(po.Id);
        Boolean foundCGST2 = false;
        Boolean foundSGST2 = false;
        for (dmpl__PurchaseOrderTax__c tax : taxes2) {
            if (tax.dmpl__PurchaseOrderLineId__c == insertedLine2.Id && tax.dmpl__TaxId__c == 'CGST') {
                foundCGST2 = true;
                System.assertEquals('CGST', tax.dmpl__TaxId__c, 'TaxId should be CGST');
                System.assertEquals(576, tax.dmpl__TaxAmount__c, 'TaxAmount for CGST should be 576');
                System.assertEquals(9600, tax.dmpl__TaxOnAmount__c, 'TaxOnAmount for CGST should be 9600');
                System.assertEquals('GST 12%', tax.dmpl__TaxGroupId__c, 'TaxGroupId for CGST should be GST 12%');
                System.assertEquals(6, tax.dmpl__TaxRate__c, 'TaxRate for CGST should be 6');
                System.assertEquals(po.Id, tax.dmpl__PurchaseOrderId__c, 'PurchaseOrderId for CGST should match');
                System.assertEquals(insertedLine2.Id, tax.dmpl__PurchaseOrderLineId__c, 'PurchaseOrderLineId for CGST should match');
            }
            if (tax.dmpl__PurchaseOrderLineId__c == insertedLine2.Id && tax.dmpl__TaxId__c == 'SGST') {
                foundSGST2 = true;
                System.assertEquals('SGST', tax.dmpl__TaxId__c, 'TaxId should be SGST');
                System.assertEquals(576, tax.dmpl__TaxAmount__c, 'TaxAmount for SGST should be 576');
                System.assertEquals(9600, tax.dmpl__TaxOnAmount__c, 'TaxOnAmount for SGST should be 9600');
                System.assertEquals('GST 12%', tax.dmpl__TaxGroupId__c, 'TaxGroupId for SGST should be GST 12%');
                System.assertEquals(6, tax.dmpl__TaxRate__c, 'TaxRate for SGST should be 6');
                System.assertEquals(po.Id, tax.dmpl__PurchaseOrderId__c, 'PurchaseOrderId for SGST should match');
                System.assertEquals(insertedLine2.Id, tax.dmpl__PurchaseOrderLineId__c, 'PurchaseOrderLineId for SGST should match');
            }
        }

         dmpl__PurchaseOrder__c po3 = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(50000, po3.dmpl__TotalLineBaseAmount__c, 'TotalLineBaseAmount should be 50000');
        System.assertEquals(0, po3.dmpl__TotalSchemeDiscountAmount__c, 'TotalSchemeDiscountAmount should be 0');
        System.assertEquals(2000, po3.dmpl__TotalDiscountAmount__c, 'TotalDiscountAmount should be 2000');
        System.assertEquals(5760, po3.dmpl__TotalLineTaxAmount__c, 'TotalLineTaxAmount should be 5760');
        System.assertEquals(5760, po3.dmpl__TotalTaxAmount__c, 'TotalTaxAmount should be 5760');
        System.assertEquals(53760, po3.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be 53760');
        System.assertEquals('56 Industrial Layout', po3.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Bengaluru', po3.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Karnataka', po3.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('MG Road', po3.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Bengaluru', po3.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Karnataka', po3.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', po3.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('560001', po3.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals(Date.today(), po3.dmpl__DocumentDate__c, 'DocumentDate mismatch');
        System.assertEquals('Draft', po3.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }

    @isTest
    static void createRequisitionLineWithZeroQuantity() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(
            partnerAccount1.Id,
            branch1.Id,
            supplier1.Id
        );
        try{
            dmpl__PurchaseRequisitionLine__c line = PurchaseOrderTestDataHelpers.CreatePurchaseRequisitionLine(
                requisition.Id,
                item.Id,       
                0          
            );
            }  catch (DmlException e) {
            System.assert(
                e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]'),
                'Expected validation error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
     
    @isTest
    static void editRequisitionLineWithZeroQuantity() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(
            partnerAccount1.Id,
            branch1.Id,
            supplier1.Id
        );
        try{
            dmpl__PurchaseRequisitionLine__c line = PurchaseOrderTestDataHelpers.CreatePurchaseRequisitionLine(
                requisition.Id,
                item.Id,     
                20      
            );
            dmpl__PurchaseRequisitionLine__c newLine = PurchaseOrderTestDataHelpers.getPurchaseRequisitionLine(line.Id);
            newLine.dmpl__Quantity__c = 0;
            update newLine;
            }  catch (DmlException e) {
            System.assert(
                e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]'),
                'Expected validation error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Quantity should be greater than 1: [dmpl__Quantity__c]. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void purchaseOrderLineWithEnteredQuantityNew() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );

        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
            item.Id,
            taxGroup.Id,
            10
        );
        Test.stopTest();

        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
        System.assertEquals(2000, insertedLine.dmpl__UnitCost__c);
        System.assertEquals(1152, insertedLine.dmpl__Tax1__c);
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c);
        System.assertEquals(6, insertedLine.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c);
        System.assertEquals(1152, insertedLine.dmpl__Tax2__c);
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c);
        System.assertEquals(6, insertedLine.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c);
        System.assertEquals(20000, insertedLine.dmpl__BaseAmount__c);
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(800, insertedLine.dmpl__NetDiscount__c);
        System.assertEquals(2304, insertedLine.dmpl__TaxAmount__c);
        System.assertEquals(21504, insertedLine.dmpl__GrossAmount__c);

        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(20000, updatedPO.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(800, updatedPO.dmpl__TotalDiscountAmount__c);
        System.assertEquals(19200, updatedPO.dmpl__TotalLineAmount__c);
        System.assertEquals(2304, updatedPO.dmpl__TotalTaxAmount__c);
        System.assertEquals(21504, updatedPO.dmpl__TotalOrderAmount__c);
        System.assertEquals(21504, updatedPO.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(21504, updatedPO.dmpl__OpenAmount__c);
        System.assertEquals('Draft', updatedPO.dmpl__Status__c);
    }

    @isTest
    static void PurchaseOrderCreationWithInactiveBranchNegative() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
    
        Test.startTest();
    
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch1.Id
        );
    
        dmpl__PurchaseOrder__c insertedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertNotEquals(null, insertedPO, 'Purchase Order should be created');
        System.assertEquals('Draft', insertedPO.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('MG Road\nBengaluru, Karnataka, India, 560001', insertedPO.dmpl__BillingAddress__c, 'Billing address mismatch');
        System.assertEquals('56 Industrial Layout\nBengaluru, Karnataka, India, 560095', insertedPO.dmpl__ShippingAddress__c, 'Shipping address mismatch');
    
        try {
            dmpl__PurchaseOrder__c poWithInactiveBranch = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id ,partner.Id,branch3.Id);
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Branch is not active'), 'Expected inactive branch validation');
        }    
        Test.stopTest();
    }

    @isTest
    static void purchaseOrderLineWithZeroQuantity() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );

        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals('56 Industrial Layout', updatedPO.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__ShippingCity__c, 'Shipping City mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__ShippingState__c, 'Shipping State mismatch');
        System.assertEquals('560095', updatedPO.dmpl__ShippingPostalCode__c, 'Shipping PostalCode mismatch');
        System.assertEquals('India', updatedPO.dmpl__ShippingCountry__c, 'Shipping Country mismatch');
        System.assertEquals('MG Road', updatedPO.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('560001', updatedPO.dmpl__BillingPostalCode__c, 'Billing PostalCode mismatch');
        System.assertEquals(Date.today(), updatedPO.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'PO status should be Draft');

        try {
            dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                purchaseOrder.Id,
                item.Id,
                taxGroup.Id,
                0
            );
            System.assert(false, 'Expected exception for zero quantity but none was thrown');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('The input field dmpl__Quantity__c expects postive decimals!'),
                'Expected validation error for zero quantity'
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void purchaseOrderLineWithDiscontinuedItem() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 3');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );        

        dmpl__PurchaseOrderLine__c pol1 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            activeItem.Id,
            taxGroup.Id,
            20
        );

        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol1.Id);
        System.assertEquals(2000, insertedLine.dmpl__UnitCost__c, 'Unit price mismatch');
        System.assertEquals(40000, insertedLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0');
        System.assertEquals(1600, insertedLine.dmpl__NetDiscount__c, 'Discount should be 0');
        System.assertEquals(2304, insertedLine.dmpl__Tax1__c, 'Tax1 mismatch');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c, 'Tax1 Name mismatch');
        System.assertEquals(6, insertedLine.dmpl__Tax1Rate__c, 'Tax1 Rate mismatch');
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c, 'Tax1 Type mismatch');
        System.assertEquals(2304, insertedLine.dmpl__Tax2__c, 'Tax2 mismatch');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c, 'Tax2 Name mismatch');
        System.assertEquals(6, insertedLine.dmpl__Tax2Rate__c, 'Tax2 Rate mismatch');
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c, 'Tax2 Type mismatch');
        System.assertEquals(4608, insertedLine.dmpl__TaxAmount__c, 'Tax amount mismatch');
        System.assertEquals(43008, insertedLine.dmpl__GrossAmount__c, 'Gross amount mismatch');

        dmpl__PurchaseOrder__c updatedPo = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(40000, updatedPo.dmpl__TotalLineBaseAmount__c, 'PO base amount mismatch');
        System.assertEquals(0, updatedPo.dmpl__TotalSchemeDiscountAmount__c, 'PO scheme discount mismatch');
        System.assertEquals(1600, updatedPo.dmpl__TotalDiscountAmount__c, 'PO discount mismatch');
        System.assertEquals(4608.00, updatedPo.dmpl__TotalTaxAmount__c, 'PO tax amount mismatch');
        System.assertEquals(43008, updatedPo.dmpl__TotalLineGrossAmount__c, 'PO gross amount mismatch');
        System.assertEquals('Draft', updatedPo.dmpl__Status__c, 'PO status mismatch');

        System.assertEquals('56 Industrial Layout', updatedPO.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__ShippingCity__c, 'Shipping City mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__ShippingState__c, 'Shipping State mismatch');
        System.assertEquals('560095', updatedPO.dmpl__ShippingPostalCode__c, 'Shipping PostalCode mismatch');
        System.assertEquals('India', updatedPO.dmpl__ShippingCountry__c, 'Shipping Country mismatch');
        System.assertEquals('MG Road', updatedPO.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('560001', updatedPO.dmpl__BillingPostalCode__c, 'Billing PostalCode mismatch');
        System.assertEquals(Date.today(), updatedPO.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'PO status should be Draft');

        dmpl__PurchaseOrderLine__c pol2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            inactiveItem.Id,
            taxGroup.Id,
            20
        );

        dmpl__PurchaseOrder__c poFetched = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(40000, poFetched.dmpl__TotalLineBaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, poFetched.dmpl__TotalSchemeDiscountAmount__c, 'Scheme discount amount mismatch');
        System.assertEquals(1600, poFetched.dmpl__TotalDiscountAmount__c, 'Total discount amount mismatch');
        System.assertEquals(4608, poFetched.dmpl__TotalLineTaxAmount__c, 'Line tax amount mismatch');
        System.assertEquals(4608, poFetched.dmpl__TotalTaxAmount__c, 'Total tax amount mismatch');
        System.assertEquals(43008, poFetched.dmpl__TotalLineGrossAmount__c, 'Line gross amount mismatch');
        Test.stopTest();
    }

    @isTest
    static void createPurchaseOrderLineWithAndWithoutPriceEdit() {
       
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');     
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 5');    
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');

        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );

        dmpl__PurchaseOrderLine__c purchaseOrderLine1 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item1.Id,
            taxGroup.Id,
            10
        );
          Test.startTest();
        purchaseOrderLine1 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine1.Id);
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);

        System.assertEquals(1500, purchaseOrderLine1.dmpl__UnitCost__c);
        System.assertEquals(2016, purchaseOrderLine1.dmpl__Tax1__c);
        System.assertEquals('CGST', purchaseOrderLine1.dmpl__Tax1Name__c);
        System.assertEquals(14, purchaseOrderLine1.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', purchaseOrderLine1.dmpl__Tax1Type__c);
        System.assertEquals(2016, purchaseOrderLine1.dmpl__Tax2__c);
        System.assertEquals('SGST', purchaseOrderLine1.dmpl__Tax2Name__c);
        System.assertEquals(14, purchaseOrderLine1.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', purchaseOrderLine1.dmpl__Tax2Type__c);
        System.assertEquals(15000, purchaseOrderLine1.dmpl__BaseAmount__c);
        System.assertEquals(0, purchaseOrderLine1.dmpl__NetSchemeDiscount__c);
        System.assertEquals(600, purchaseOrderLine1.dmpl__NetDiscount__c);
        System.assertEquals(4032, purchaseOrderLine1.dmpl__TaxAmount__c);
        System.assertEquals(18432, purchaseOrderLine1.dmpl__GrossAmount__c);

        System.assertEquals(15000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(600, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(4032, updatedPurchaseOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(18432, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals('56 Industrial Layout', updatedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals('560095', updatedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertEquals('MG Road', updatedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals('560001', updatedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(Date.today(), updatedPurchaseOrder.dmpl__DocumentDate__c);
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c);
        
        delete  purchaseOrderLine1;
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine2 = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        purchaseOrder.Id,
        item2.Id,
        taxGroup.Id,
        10
        );

        purchaseOrderLine2 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine2.Id);
        System.assertEquals(0, purchaseOrderLine2.dmpl__UnitCost__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__Tax1__c);
        System.assertEquals('CGST', purchaseOrderLine2.dmpl__Tax1Name__c);
        System.assertEquals(14, purchaseOrderLine2.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', purchaseOrderLine2.dmpl__Tax1Type__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__Tax2__c);
        System.assertEquals('SGST', purchaseOrderLine2.dmpl__Tax2Name__c);
        System.assertEquals(14, purchaseOrderLine2.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', purchaseOrderLine2.dmpl__Tax2Type__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__BaseAmount__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__NetSchemeDiscount__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__NetDiscount__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__TaxAmount__c);
        System.assertEquals(0, purchaseOrderLine2.dmpl__GrossAmount__c);

        updatedPurchaseOrder=PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c);
    
        System.assertEquals('56 Industrial Layout', updatedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals('560095', updatedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertEquals('MG Road', updatedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals('560001', updatedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(Date.today(), updatedPurchaseOrder.dmpl__DocumentDate__c);
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c);
        Test.stopTest();
    }

    @isTest
    static void createPurchaseOrderSchemeNotAppliedDueToExceedingBudgetEdit() {
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplierAccount.Id,
            partnerAccount.Id,
            branch.Id
        );
 
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
 
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            taxGroup.Id,
            14
        );
 
        purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
 
        System.assertEquals(1500, purchaseOrderLine.dmpl__UnitCost__c);
        System.assertEquals(2822.4, purchaseOrderLine.dmpl__Tax1__c);
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Name__c);
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Type__c);
        System.assertEquals(2822.4, purchaseOrderLine.dmpl__Tax2__c);
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Name__c);
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Type__c);
        System.assertEquals(21000, purchaseOrderLine.dmpl__BaseAmount__c);
        System.assertEquals(0, purchaseOrderLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(840, purchaseOrderLine.dmpl__NetDiscount__c);
        System.assertEquals(5644.80, purchaseOrderLine.dmpl__TaxAmount__c);
        System.assertEquals(25804.80, purchaseOrderLine.dmpl__GrossAmount__c);
 
        System.assertEquals(21000, purchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, purchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(840, purchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(5644.8, purchaseOrder.dmpl__TotalLineTaxAmount__c);
        System.assertEquals(5644.8, purchaseOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(25804.8, purchaseOrder.dmpl__TotalLineGrossAmount__c);
 
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c);
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c);
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c);
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c);
 
        purchaseOrderLine.dmpl__Quantity__c = 10;
        update purchaseOrderLine;
 
        purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
 
        System.assertEquals(1500, purchaseOrderLine.dmpl__UnitCost__c);
        System.assertEquals(2016, purchaseOrderLine.dmpl__Tax1__c);
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Name__c);
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', purchaseOrderLine.dmpl__Tax1Type__c);
        System.assertEquals(2016, purchaseOrderLine.dmpl__Tax2__c);
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Name__c);
        System.assertEquals(14, purchaseOrderLine.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', purchaseOrderLine.dmpl__Tax2Type__c);
        System.assertEquals(15000, purchaseOrderLine.dmpl__BaseAmount__c);
        System.assertEquals(0, purchaseOrderLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(600, purchaseOrderLine.dmpl__NetDiscount__c);
        System.assertEquals(4032, purchaseOrderLine.dmpl__TaxAmount__c);
        System.assertEquals(18432, purchaseOrderLine.dmpl__GrossAmount__c);
        System.assertEquals(null, purchaseOrderLine.dmpl__SchemeLineId__c);
 
        System.assertEquals(15000, purchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, purchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(600, purchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(4032, purchaseOrder.dmpl__TotalLineTaxAmount__c);
        System.assertEquals(4032, purchaseOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(18432, purchaseOrder.dmpl__TotalLineGrossAmount__c);
       
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c);
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c);
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c);
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c);
        Test.stopTest();
    }

    @isTest
    static void PurchaseOrderLineWithSkuRequiredNegative() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c itemRequiringSku = TestDataHelpers.getItem('Item 9'); 
        dmpl__Item__c validItem = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup12 = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__TaxGroup__c taxGroup28 = TestDataHelpers.getTaxGroup('GST 28');

        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id, partner.Id, branch.Id
        );

        Boolean exceptionThrown = false;
        try {
            dmpl__PurchaseOrderLine__c invalidPOL = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
                po.Id, itemRequiringSku.Id, taxGroup12.Id, 10
            );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('mandates selection of SKU'), 'Expected SKU validation error.');
        }

        dmpl__PurchaseOrderLine__c validPOL = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id, validItem.Id, taxGroup28.Id, 10
        );
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for item without SKU.');

        dmpl__PurchaseOrderLine__c insertedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(validPOL.Id);
        System.assertEquals(validItem.Id, insertedPOL.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, insertedPOL.dmpl__UnitCost__c, 'Unit price should be 1500');
        System.assertEquals(2016, insertedPOL.dmpl__Tax1__c, 'Tax1 should be 2016');
        System.assertEquals('CGST', insertedPOL.dmpl__Tax1Name__c);
        System.assertEquals(14, insertedPOL.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', insertedPOL.dmpl__Tax1Type__c);
        System.assertEquals(2016, insertedPOL.dmpl__Tax2__c);
        System.assertEquals('SGST', insertedPOL.dmpl__Tax2Name__c);
        System.assertEquals(14, insertedPOL.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', insertedPOL.dmpl__Tax2Type__c);
        System.assertEquals(15000, insertedPOL.dmpl__BaseAmount__c);
        System.assertEquals(600, insertedPOL.dmpl__NetDiscount__c);
        System.assertEquals(4032, insertedPOL.dmpl__TaxAmount__c);
        System.assertEquals(18432, insertedPOL.dmpl__GrossAmount__c);

        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(15000, updatedPO.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(600, updatedPO.dmpl__TotalDiscountAmount__c, 'Total discount amount should be 600');
        System.assertEquals(4032, updatedPO.dmpl__TotalTaxAmount__c, 'Total tax amount should be 4032');
        System.assertEquals(18432, updatedPO.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 18432');
        System.assertEquals(18432, updatedPO.dmpl__TotalOrderAmount__c, 'Total order amount should be 18432');

        System.assertEquals('56 Industrial Layout', updatedPO.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals('560095', updatedPO.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');

        System.assertEquals('MG Road', updatedPO.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals('Bengaluru', updatedPO.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals('Karnataka', updatedPO.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals('India', updatedPO.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals('560001', updatedPO.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        System.assertEquals(Date.today(), updatedPO.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void TaxApplicationObjectModelInlineTaxEdit() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');

        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id, partner.Id, branch.Id);

        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(po.Id, item.Id, taxGroup.Id, 3);

        dmpl__PurchaseOrderLine__c insertedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
        System.assertEquals(1500, insertedLine.dmpl__UnitCost__c);
        System.assertEquals(604.80, insertedLine.dmpl__Tax1__c);
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Name__c);
        System.assertEquals(14, insertedLine.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', insertedLine.dmpl__Tax1Type__c);
        System.assertEquals(604.80, insertedLine.dmpl__Tax2__c);
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Name__c);
        System.assertEquals(14, insertedLine.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', insertedLine.dmpl__Tax2Type__c);
        System.assertEquals(4500, insertedLine.dmpl__BaseAmount__c);
        System.assertEquals(0, insertedLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(180, insertedLine.dmpl__NetDiscount__c);
        System.assertEquals(1209.60, insertedLine.dmpl__TaxAmount__c);
        System.assertEquals(5529.60, insertedLine.dmpl__GrossAmount__c);

        dmpl__PurchaseOrder__c updatedPO1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(4500, updatedPO1.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPO1.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(180, updatedPO1.dmpl__TotalDiscountAmount__c);
        System.assertEquals(1209.60, updatedPO1.dmpl__TotalTaxAmount__c);
        System.assertEquals(5529.60, updatedPO1.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(5530, updatedPO1.dmpl__TotalOrderAmount__c);
        System.assertEquals('56 Industrial Layout', updatedPO1.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', updatedPO1.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', updatedPO1.dmpl__ShippingState__c);
        System.assertEquals('560095', updatedPO1.dmpl__ShippingPostalCode__c);
        System.assertEquals('MG Road', updatedPO1.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', updatedPO1.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', updatedPO1.dmpl__BillingState__c);
        System.assertEquals('India', updatedPO1.dmpl__ShippingCountry__c);
        System.assertEquals('560001', updatedPO1.dmpl__BillingPostalCode__c);
        System.assertEquals(Date.today(), updatedPO1.dmpl__DocumentDate__c);
        System.assertEquals('Draft', updatedPO1.dmpl__Status__c);

        insertedLine.dmpl__Quantity__c = 10;
        update insertedLine;

        dmpl__PurchaseOrderLine__c updatedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(insertedLine.Id);
        System.assertEquals(1500, updatedLine.dmpl__UnitCost__c);
        System.assertEquals(2016, updatedLine.dmpl__Tax1__c);
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Name__c);
        System.assertEquals(14, updatedLine.dmpl__Tax1Rate__c);
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Type__c);
        System.assertEquals(2016, updatedLine.dmpl__Tax2__c);
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Name__c);
        System.assertEquals(14, updatedLine.dmpl__Tax2Rate__c);
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Type__c);
        System.assertEquals(15000, updatedLine.dmpl__BaseAmount__c);
        System.assertEquals(0, updatedLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(600, updatedLine.dmpl__NetDiscount__c);
        System.assertEquals(4032, updatedLine.dmpl__TaxAmount__c);
        System.assertEquals(18432, updatedLine.dmpl__GrossAmount__c);

        dmpl__PurchaseOrder__c updatedPO2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(15000, updatedPO2.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, updatedPO2.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(600, updatedPO2.dmpl__TotalDiscountAmount__c);
        System.assertEquals(4032, updatedPO2.dmpl__TotalTaxAmount__c);
        System.assertEquals(18432, updatedPO2.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(18432, updatedPO2.dmpl__TotalOrderAmount__c);
        System.assertEquals('56 Industrial Layout', updatedPO2.dmpl__ShippingStreet__c);
        System.assertEquals('Bengaluru', updatedPO2.dmpl__ShippingCity__c);
        System.assertEquals('Karnataka', updatedPO2.dmpl__ShippingState__c);
        System.assertEquals('560095', updatedPO2.dmpl__ShippingPostalCode__c);
        System.assertEquals('MG Road', updatedPO2.dmpl__BillingStreet__c);
        System.assertEquals('Bengaluru', updatedPO2.dmpl__BillingCity__c);
        System.assertEquals('Karnataka', updatedPO2.dmpl__BillingState__c);
        System.assertEquals('India', updatedPO2.dmpl__ShippingCountry__c);
        System.assertEquals('560001', updatedPO2.dmpl__BillingPostalCode__c);
        System.assertEquals(Date.today(), updatedPO2.dmpl__DocumentDate__c);
        System.assertEquals('Draft', updatedPO2.dmpl__Status__c);
        Test.stopTest();
    }
    
    @isTest
    static void schemeApplicabilityForPartnerAccountDefinedEdit() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier.Id,
            partner.Id,
            branch.Id
        );

        dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            taxGroup.Id,
            20
        );

        pol = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
        System.assertEquals(2000, pol.dmpl__UnitCost__c, 'Unit cost mismatch');
        System.assertEquals(5376, pol.dmpl__Tax1__c, 'Tax1 amount mismatch');
        System.assertEquals('CGST', pol.dmpl__Tax1Name__c, 'Tax1 name mismatch');
        System.assertEquals(14, pol.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
        System.assertEquals('CGST', pol.dmpl__Tax1Type__c, 'Tax1 type mismatch');
        System.assertEquals(5376, pol.dmpl__Tax2__c, 'Tax2 amount mismatch');
        System.assertEquals('SGST', pol.dmpl__Tax2Name__c, 'Tax2 name mismatch');
        System.assertEquals(14, pol.dmpl__Tax2Rate__c, 'Tax2 rate mismatch');
        System.assertEquals('SGST', pol.dmpl__Tax2Type__c, 'Tax2 type mismatch');
        System.assertEquals(40000, pol.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, pol.dmpl__NetSchemeDiscount__c, 'Net scheme discount mismatch');
        System.assertEquals(1600, pol.dmpl__NetDiscount__c, 'Net discount mismatch');
        System.assertEquals(10752, pol.dmpl__TaxAmount__c, 'Tax amount mismatch');
        System.assertEquals(49152, pol.dmpl__GrossAmount__c, 'Gross amount mismatch');

        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(40000, purchaseOrder1.dmpl__TotalLineBaseAmount__c, 'PO total base amount mismatch');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalSchemeDiscountAmount__c, 'PO scheme discount mismatch');
        System.assertEquals(1600, purchaseOrder1.dmpl__TotalDiscountAmount__c, 'PO discount mismatch');
        System.assertEquals(10752, purchaseOrder1.dmpl__TotalLineTaxAmount__c, 'PO tax amount mismatch');
        System.assertEquals(10752, purchaseOrder1.dmpl__TotalTaxAmount__c, 'PO total tax mismatch');
        System.assertEquals(49152, purchaseOrder1.dmpl__TotalLineGrossAmount__c, 'PO gross amount mismatch');

        System.assertEquals('56 Industrial Layout', purchaseOrder1.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals('560095', purchaseOrder1.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        System.assertEquals('MG Road', purchaseOrder1.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals('560001', purchaseOrder1.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        System.assertEquals('India', purchaseOrder1.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals(Date.today(), purchaseOrder1.dmpl__DocumentDate__c, 'Document date mismatch');
        System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'PO status mismatch');

        pol.dmpl__Quantity__c = 14;
        update pol;

        dmpl__PurchaseOrderLine__c updatedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
        System.assertEquals(2000, updatedPOL.dmpl__UnitCost__c, 'Updated unit cost mismatch');
        System.assertEquals(3763.20, updatedPOL.dmpl__Tax1__c, 'Updated Tax1 amount mismatch');
        System.assertEquals('CGST', updatedPOL.dmpl__Tax1Name__c, 'Updated Tax1 name mismatch');
        System.assertEquals(14, updatedPOL.dmpl__Tax1Rate__c, 'Updated Tax1 rate mismatch');
        System.assertEquals('CGST', updatedPOL.dmpl__Tax1Type__c, 'Updated Tax1 type mismatch');
        System.assertEquals(3763.20, updatedPOL.dmpl__Tax2__c, 'Updated Tax2 amount mismatch');
        System.assertEquals('SGST', updatedPOL.dmpl__Tax2Name__c, 'Updated Tax2 name mismatch');
        System.assertEquals(14, updatedPOL.dmpl__Tax2Rate__c, 'Updated Tax2 rate mismatch');
        System.assertEquals('SGST', updatedPOL.dmpl__Tax2Type__c, 'Updated Tax2 type mismatch');
        System.assertEquals(28000, updatedPOL.dmpl__BaseAmount__c, 'Updated base amount mismatch');
        System.assertEquals(0, updatedPOL.dmpl__NetSchemeDiscount__c, 'Updated net scheme discount mismatch');
        System.assertEquals(1120, updatedPOL.dmpl__NetDiscount__c, 'Updated net discount mismatch');
        System.assertEquals(7526.40, updatedPOL.dmpl__TaxAmount__c, 'Updated tax amount mismatch');
        System.assertEquals(34406.40, updatedPOL.dmpl__GrossAmount__c, 'Updated gross amount mismatch');
        System.assertEquals(null, updatedPOL.dmpl__SchemeLineId__c, 'Updated SchemeLineId should be null');
        
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(28000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Updated PO total base amount mismatch');
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Updated PO scheme discount mismatch');
        System.assertEquals(1120, updatedPO.dmpl__TotalDiscountAmount__c, 'Updated PO discount mismatch');
        System.assertEquals(7526.40, updatedPO.dmpl__TotalLineTaxAmount__c, 'Updated PO tax amount mismatch');
        System.assertEquals(7526.40, updatedPO.dmpl__TotalTaxAmount__c, 'Updated PO total tax mismatch');
        System.assertEquals(34406.40, updatedPO.dmpl__TotalLineGrossAmount__c, 'Updated PO gross amount mismatch');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Updated PO status mismatch');
        Test.stopTest();
    }
    
    @isTest
static void schemeApplicabilityInCaseOfSchemeNotApprovedEditNegative() {
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

    Test.startTest();

    dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
        supplier.Id,
        partner.Id,
        branch.Id
    );

    dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
    System.assertEquals('12 Industrial Zone', purchaseOrder1.dmpl__ShippingStreet__c, 'Shipping street mismatch');
    System.assertEquals('Hyderabad', purchaseOrder1.dmpl__ShippingCity__c, 'Shipping city mismatch');
    System.assertEquals('Telangana', purchaseOrder1.dmpl__ShippingState__c, 'Shipping state mismatch');
    System.assertEquals('500032', purchaseOrder1.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
    System.assertEquals('12 Industrial Zone', purchaseOrder1.dmpl__BillingStreet__c, 'Billing street mismatch');
    System.assertEquals('Hyderabad', purchaseOrder1.dmpl__BillingCity__c, 'Billing city mismatch');
    System.assertEquals('Telangana', purchaseOrder1.dmpl__BillingState__c, 'Billing state mismatch');
    System.assertEquals('500032', purchaseOrder1.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
    System.assertEquals('India', purchaseOrder1.dmpl__ShippingCountry__c, 'Shipping country mismatch');
    System.assertEquals(Date.today(), purchaseOrder1.dmpl__DocumentDate__c, 'Document date mismatch');
    System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'PO status mismatch');

    dmpl__PurchaseOrderLine__c pol = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        purchaseOrder.Id,
        item.Id,
        taxGroup.Id,
        5
    );

    pol = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
    System.assertEquals(2000, pol.dmpl__UnitCost__c, 'Unit cost mismatch');
    System.assertEquals(600, pol.dmpl__Tax1__c, 'Tax1 amount mismatch');
    System.assertEquals('CGST', pol.dmpl__Tax1Name__c, 'Tax1 name mismatch');
    System.assertEquals(6, pol.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
    System.assertEquals('CGST', pol.dmpl__Tax1Type__c, 'Tax1 type mismatch');
    System.assertEquals(600, pol.dmpl__Tax2__c, 'Tax2 amount mismatch');
    System.assertEquals('SGST', pol.dmpl__Tax2Name__c, 'Tax2 name mismatch');
    System.assertEquals(6, pol.dmpl__Tax2Rate__c, 'Tax2 rate mismatch');
    System.assertEquals('SGST', pol.dmpl__Tax2Type__c, 'Tax2 type mismatch');
    System.assertEquals(10000, pol.dmpl__BaseAmount__c, 'Base amount mismatch');
    System.assertEquals(0, pol.dmpl__NetSchemeDiscount__c, 'Net scheme discount mismatch');
    System.assertEquals(0, pol.dmpl__NetDiscount__c, 'Net discount mismatch');
    System.assertEquals(1200, pol.dmpl__TaxAmount__c, 'Tax amount mismatch');
    System.assertEquals(11200, pol.dmpl__GrossAmount__c, 'Gross amount mismatch');
    System.assertEquals(null, pol.dmpl__SchemeLineId__c, 'SchemeLineId should be null');

    dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
    System.assertEquals(10000, po.dmpl__TotalLineBaseAmount__c, 'PO total base amount mismatch');
    System.assertEquals(0, po.dmpl__TotalSchemeDiscountAmount__c, 'PO scheme discount mismatch');
    System.assertEquals(0, po.dmpl__TotalDiscountAmount__c, 'PO discount mismatch');
    System.assertEquals(1200, po.dmpl__TotalTaxAmount__c, 'PO tax amount mismatch');
    System.assertEquals(11200, po.dmpl__TotalOrderAmount__c, 'PO total order amount mismatch');
    System.assertEquals('Draft', po.dmpl__Status__c, 'PO status mismatch');

    pol.dmpl__Quantity__c = 10;
    update pol;

    dmpl__PurchaseOrderLine__c updatedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(pol.Id);
    System.assertEquals(2000, updatedPOL.dmpl__UnitCost__c, 'Updated unit cost mismatch');
    System.assertEquals(1200, updatedPOL.dmpl__Tax1__c, 'Updated Tax1 amount mismatch');
    System.assertEquals('CGST', updatedPOL.dmpl__Tax1Name__c, 'Updated Tax1 name mismatch');
    System.assertEquals(6, updatedPOL.dmpl__Tax1Rate__c, 'Updated Tax1 rate mismatch');
    System.assertEquals('CGST', updatedPOL.dmpl__Tax1Type__c, 'Updated Tax1 type mismatch');
    System.assertEquals(1200, updatedPOL.dmpl__Tax2__c, 'Updated Tax2 amount mismatch');
    System.assertEquals('SGST', updatedPOL.dmpl__Tax2Name__c, 'Updated Tax2 name mismatch');
    System.assertEquals(6, updatedPOL.dmpl__Tax2Rate__c, 'Updated Tax2 rate mismatch');
    System.assertEquals('SGST', updatedPOL.dmpl__Tax2Type__c, 'Updated Tax2 type mismatch');
    System.assertEquals(20000, updatedPOL.dmpl__BaseAmount__c, 'Updated base amount mismatch');
    System.assertEquals(0, updatedPOL.dmpl__NetSchemeDiscount__c, 'Updated net scheme discount mismatch');
    System.assertEquals(0, updatedPOL.dmpl__NetDiscount__c, 'Updated net discount mismatch');
    System.assertEquals(2400, updatedPOL.dmpl__TaxAmount__c, 'Updated tax amount mismatch');
    System.assertEquals(22400, updatedPOL.dmpl__GrossAmount__c, 'Updated gross amount mismatch');
    System.assertEquals(null, updatedPOL.dmpl__SchemeLineId__c, 'Updated SchemeLineId should be null');

    dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
    System.assertEquals(20000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Updated PO total base amount mismatch');
    System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Updated PO scheme discount mismatch');
    System.assertEquals(0, updatedPO.dmpl__TotalDiscountAmount__c, 'Updated PO discount mismatch');
    System.assertEquals(2400, updatedPO.dmpl__TotalTaxAmount__c, 'Updated PO total tax mismatch');
    System.assertEquals(22400, updatedPO.dmpl__TotalOrderAmount__c, 'Updated PO total order amount mismatch');
    System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Updated PO status mismatch');

    Test.stopTest();
}
    
    @isTest
    static void editPurchaseOrderLineWithEnteredQuantityPositive() {
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroupGST12p = TestDataHelpers.getTaxGroup('GST 12');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            partner4.Id,
            branch4.Id
        );

        dmpl__PurchaseOrder__c createdPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder, 'Expected purchase order to be created.');
        System.assertEquals('Draft', createdPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('500032', createdPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals(System.today(), createdPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item3.Id,
            taxGroupGST12p.Id,
            5
        );

        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(1200, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(11200, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11200');

        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10000, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10000 after adding purchase order line.');
        System.assertEquals(11200, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11200 after updating purchase order line.');
        System.assertEquals(1200, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1200 after adding purchase order line.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0 after adding purchase order line.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0 after adding purchase order line.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder2.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder2.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder2.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder2.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('500032', createdPurchaseOrder2.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder2.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder2.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder2.dmpl__BillingState__c, 'Billing State should match the branch address.');  
        System.assertEquals('India', createdPurchaseOrder2.dmpl__BillingCountry__c, 'Billing Country should match the branch address.'); 
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');

        createdPurchaseOrderLine.dmpl__Quantity__c = 10;
        update createdPurchaseOrderLine;

        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(createdPurchaseOrderLine.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1200, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 1200');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(1200, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 1200');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(2400, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 2400');
        System.assertEquals(20000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(22400, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 22400');

        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(createdPurchaseOrder2.Id);
        System.assertNotEquals(null, updatedPurchaseOrder, 'Expected purchase order to be found after updating purchase order line.');
        System.assertEquals(20000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 20000 after updating purchase order line.');
        System.assertEquals(22400, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 22400 after updating purchase order line.');
        System.assertEquals(2400, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should be 2400 after updating purchase order line.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0 after updating purchase order line.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0 after updating purchase order line.');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft after updating purchase order line.');
        System.assertEquals('12 Industrial Zone', updatedPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address after updating purchase order line.');
        System.assertEquals('Hyderabad', updatedPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address after updating purchase order line.');
        System.assertEquals('Telangana', updatedPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address after updating purchase order line.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address after updating purchase order line.');
        System.assertEquals('500032', updatedPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal should match the branch address after updating purchase order line.');
        System.assertEquals('12 Industrial Zone', updatedPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address after updating purchase order line.');
        System.assertEquals('Hyderabad', updatedPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address after updating purchase order line.');
        System.assertEquals('Telangana', updatedPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address after updating purchase order line.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address after updating purchase order line.');
        System.assertEquals(System.today(), updatedPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should remain today after updating purchase order line.');
        Test.stopTest();
    }
    
    @isTest
    static void editSchemeApplicabilityWhenUnavailabilityofBudgetNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item12 = TestDataHelpers.getItem('Item 12');
        dmpl__TaxGroup__c taxGroupGST12p = TestDataHelpers.getTaxGroup('GST 12');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            partner1.Id,
            branch1.Id
        );

        dmpl__PurchaseOrder__c createdPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder, 'Expected purchase order to be created.');
        System.assertEquals('Draft', createdPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', createdPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', createdPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', createdPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', createdPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        System.assertEquals(System.today(), createdPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item12.Id,
            taxGroupGST12p.Id,
            7
        );

        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 1500.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(420, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 420');
        System.assertEquals(604.8, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 604.8');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(604.8, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 604.8');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(1209.6, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1209.6');
        System.assertEquals(10500, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10500');
        System.assertEquals(11289.6, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11289.6');

        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10500, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10500 after adding purchase order line.');
        System.assertEquals(11289.6, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11289.6 after updating purchase order line.');
        System.assertEquals(1209.6, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1209.6 after adding purchase order line.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0 after adding purchase order line.');
        System.assertEquals(420, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 420 after adding purchase order line.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', createdPurchaseOrder2.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder2.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder2.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder2.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', createdPurchaseOrder2.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', createdPurchaseOrder2.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder2.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder2.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder2.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', createdPurchaseOrder2.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.'); 
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');

        createdPurchaseOrderLine.dmpl__Quantity__c=14;
        update createdPurchaseOrderLine;

        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(createdPurchaseOrderLine.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 1500.');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1209.6, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 1209.6');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(1209.6, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 1209.6');
        System.assertEquals(6, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(2419.2, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 2419.2');
        System.assertEquals(21000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 21000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(840, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 840');
        System.assertEquals(22579.2, updatedPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 22579.2');

        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(createdPurchaseOrder2.Id);
        System.assertNotEquals(null, updatedPurchaseOrder, 'Expected purchase order to be found after updating purchase order line.');
        System.assertEquals(21000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 21000 after updating purchase order line.');
        System.assertEquals(22579.2, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 22579.2, after updating purchase order line.');
        System.assertEquals(2419.2, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should be 2419.2 after updating purchase order line.');
        System.assertEquals(2419.2, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2419.2 after updating purchase order line.');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0 after updating purchase order line.');
        System.assertEquals(840, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 840 after updating purchase order line.');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft after updating purchase order line.');
        System.assertEquals('56 Industrial Layout', updatedPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address after updating purchase order line.');
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address after updating purchase order line.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address after updating purchase order line.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address after updating purchase order line.');
        System.assertEquals('560095', updatedPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal should match the branch address after updating purchase order line.');
        System.assertEquals('MG Road', updatedPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address after updating purchase order line.');
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address after updating purchase order line.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address after updating purchase order line.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address after updating purchase order line.');
        System.assertEquals('560001', updatedPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address after updating purchase order line.');
        System.assertEquals(System.today(), updatedPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should remain today after updating purchase order line.');
        Test.stopTest();
    }
    
    @isTest
    static void editPurchaseOrderLineWithZeroQuantityNegative() {
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroupGST12p = TestDataHelpers.getTaxGroup('GST 12');

        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            partner4.Id,
            branch4.Id
        );

        dmpl__PurchaseOrder__c createdPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder, 'Expected purchase order to be created.');
        System.assertEquals('Draft', createdPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('500032', createdPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals(System.today(), createdPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item3.Id,
            taxGroupGST12p.Id,
            5
        );

        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(600, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(6, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(1200, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(11200, createdPurchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 11200');

        dmpl__PurchaseOrder__c createdPurchaseOrder2 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder2, 'Expected purchase order to be found after creation.');
        System.assertEquals(10000, createdPurchaseOrder2.dmpl__TotalLineBaseAmount__c, 'Base Amount should be 10000 after adding purchase order line.');
        System.assertEquals(11200, createdPurchaseOrder2.dmpl__TotalLineGrossAmount__c, 'Gross Amount should be 11200 after updating purchase order line.');
        System.assertEquals(1200, createdPurchaseOrder2.dmpl__TotalTaxAmount__c, 'Tax Amount should be 1200 after adding purchase order line.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0 after adding purchase order line.');
        System.assertEquals(0, createdPurchaseOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0 after adding purchase order line.');
        System.assertEquals('Draft', createdPurchaseOrder2.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder2.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder2.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder2.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder2.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('500032', createdPurchaseOrder2.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('12 Industrial Zone', createdPurchaseOrder2.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Hyderabad', createdPurchaseOrder2.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Telangana', createdPurchaseOrder2.dmpl__BillingState__c, 'Billing State should match the branch address.');  
        System.assertEquals('India', createdPurchaseOrder2.dmpl__BillingCountry__c, 'Billing Country should match the branch address.'); 
        System.assertEquals(System.today(), createdPurchaseOrder2.dmpl__DocumentDate__c, 'Document Date should be today');

        try {
            createdPurchaseOrderLine.dmpl__Quantity__c = 0;
            update createdPurchaseOrderLine;
            System.assert(false, 'Expected an exception due to zero quantity.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('The input field dmpl__Quantity__c expects postive decimals'), 'Expected exception for zero quantity: ' + e.getMessage());
        }
        Test.stopTest();
    }   

    @isTest
    static void editPurchaseOrderLineWithItemWithoutTaxGroup() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');

        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            partner1.Id,
            branch1.Id
        );

        dmpl__PurchaseOrder__c createdPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder, 'Expected purchase order to be created.');
        System.assertEquals('Draft', createdPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', createdPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', createdPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', createdPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', createdPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        System.assertEquals(System.today(), createdPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item3.Id,
            null,
            20
        );

        
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(null, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(40000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1600, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(40000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 40000');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(1600, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1600');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(38400, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', updatedPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', updatedPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', updatedPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', updatedPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine1 = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        purchaseOrderLine1.dmpl__Quantity__c = 5;
        update purchaseOrderLine1;
        
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(2000, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(null, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(10000.00, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(400, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(10000, purchaseOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 40000');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(400, purchaseOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1600');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(9600, purchaseOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', purchaseOrder1.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', purchaseOrder1.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', purchaseOrder1.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', purchaseOrder1.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', purchaseOrder1.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', purchaseOrder1.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        
        Test.stopTest();
    }

    @isTest
    static void editSchemeApplicabilityInCaseTheValidityOfSchemeHasPassed() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroupGST28p = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__Scheme__c scheme18 = SchemeDataHelper.getScheme('Scheme 18');
        scheme18.dmpl__ValidTo__c = Date.today().addDays(-10);
        update scheme18;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            partner1.Id,
            branch1.Id
            );
            
            dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item1.Id,
            taxGroupGST28p.Id,
            20
            );
            
            
        Test.startTest();
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4032, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(14, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(4032, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(14, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(8064, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(30000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(1200, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(30000, updatedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 40000');
        System.assertEquals(0, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(1200, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1600');
        System.assertEquals(8064, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(8064, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(36864, updatedPurchaseOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        
        createdPurchaseOrderLine.dmpl__Quantity__c = 14;
        update createdPurchaseOrderLine;
        
        dmpl__PurchaseOrderLine__c updatedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, updatedPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, updatedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 2000.');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2822.4, updatedPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 600');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(2822.4, updatedPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 600');
        System.assertEquals(14, updatedPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(5644.8, updatedPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 1200');
        System.assertEquals(21000, updatedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(0, updatedPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(840, updatedPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(21000, purchaseOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 40000');
        System.assertEquals(0, purchaseOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(840, purchaseOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1600');
        System.assertEquals(5644.8, purchaseOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 0');
        System.assertEquals(5644.8, purchaseOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(25804.8, purchaseOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', purchaseOrder1.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', purchaseOrder1.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', purchaseOrder1.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', purchaseOrder1.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', purchaseOrder1.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', purchaseOrder1.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', purchaseOrder1.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', purchaseOrder1.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');       
        Test.stopTest();
    }
    
    @isTest()
    static void createSchemeApplicabilityInCaseValidCountIsDefined() {
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account parner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.getTaxGroup('GST 28');
 
        Test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            supplier1.Id,
            parner1.Id,
            branch1.Id
        );

        dmpl__PurchaseOrder__c createdPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertNotEquals(null, createdPurchaseOrder, 'Expected purchase order to be created.');
        System.assertEquals('Draft', createdPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', createdPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', createdPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', createdPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', createdPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', createdPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', createdPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', createdPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        System.assertEquals(System.today(), createdPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item1.Id,
            taxGroupGST28.Id,
            18
        );
        Test.stopTest();
 
        dmpl__PurchaseOrderLine__c createdPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertNotEquals(null, createdPurchaseOrderLine, 'Expected purchase order line to be created.');
        System.assertEquals(1500, createdPurchaseOrderLine.dmpl__UnitCost__c, 'Unit Price should be 1500.');
        System.assertEquals(18, createdPurchaseOrderLine.dmpl__Quantity__c, 'Quantity should be 18');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST.');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdPurchaseOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdPurchaseOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3628.8, createdPurchaseOrderLine.dmpl__Tax1__c, 'Tax1 amount should be 3780');
        System.assertEquals(14, createdPurchaseOrderLine.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(3628.8, createdPurchaseOrderLine.dmpl__Tax2__c, 'Tax2 amount should be 3780');
        System.assertEquals(14, createdPurchaseOrderLine.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals(7257.6, createdPurchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 7560');
        System.assertEquals(27000, createdPurchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, createdPurchaseOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(1080, createdPurchaseOrderLine.dmpl__NetDiscount__c, 'Net Discount should be 0');

        dmpl__PurchaseOrder__c updatedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(75, updatedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(1140, updatedPurchaseOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(7257.6, updatedPurchaseOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 7560');
        System.assertEquals(7257.6, updatedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals('Draft', updatedPurchaseOrder.dmpl__Status__c, 'Status should be Draft.');
        System.assertEquals('56 Industrial Layout', updatedPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match the branch address.');

        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match the branch address.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match the branch address.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match the branch address.');
        System.assertEquals('560095', updatedPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match the branch address.');
        System.assertEquals('MG Road', updatedPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match the branch address.');
        System.assertEquals('Bengaluru', updatedPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match the branch address.');
        System.assertEquals('Karnataka', updatedPurchaseOrder.dmpl__BillingState__c, 'Billing State should match the branch address.');
        System.assertEquals('India', updatedPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match the branch address.');
        System.assertEquals('560001', updatedPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal should match the branch address.');
        System.assertEquals(System.today(), updatedPurchaseOrder.dmpl__DocumentDate__c, 'Document Date should be today');
    }
}