@isTest
public with sharing class BillReturnHandler_Test {
  @TestSetup
  static void createRequiredData() {
    Account partnerAccount = TestDataHelpers.createPartnerAccount();
    Account customerAccount = TestDataHelpers.createCustomerAccount();
    dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
    dmpl__ContactAddress__c contactAddress =
        TestDataHelpers.CreateContactAddress(customerAccount);
    dmpl__Item__c item = TestDataHelpers.createItem();
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
    dmpl__TaxGroup__c taxGroup =
        TestDataHelpers.createTaxGroup(partnerAccount, branch);
    dmpl__PriceList__c priceList =
        TestDataHelpers.createPriceList(partnerAccount, branch);
    dmpl__PriceListRules__c priceListRule =
        TestDataHelpers.createPriceListRules(priceList, item);

    dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
        customerAccount, branch, contactAddress, priceList);
    dmpl__SaleOrderLine__c saleOrderLine =
        SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, sku, taxGroup);
    dmpl__SaleOrderTax__c saleOrderTax =
        SaleOrderDataHelper.createSaleOrderTax(saleOrder, saleOrderLine);

    Account supplierAccount1 = TestDataHelpers.createSupplierAccount(
        'Supplier 1', '55 Industrial Park Road', 'Ahmedabad', 'Gujarat',
        'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'Gujarat',
        'India', '380015', '-9988776564');
    dmpl__StorageLocation__c storageLocation =
        TestDataHelpers.createStorageLocation(branch);
    dmpl__ItemLot__c itemLot =
        TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
    dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);

    Test.startTest();
    dmpl__PurchaseOrder__c purchaseOrder =
        PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,
                                                         supplierAccount1);
    dmpl__GoodsReceipt__c goodsReceipt =
        GoodRecieptsTestDataHelpers.createGoodsReceipt(
            partnerAccount, branch, purchaseOrder, supplierAccount1);
    dmpl__GoodsReceiptLine__c grnLine =
        GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item,
                                                          sku);
    dmpl__Bill__c bill = BillTestDataHelpers.createBill(
        supplierAccount1, branch, priceList, purchaseOrder, goodsReceipt);
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
        customerAccount, item, sku, itemLot, bill, priceListRule, taxGroup);
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1, partnerAccount, branch, priceList);
    dmpl__BillReturnLine__c billReturnLine =
        BillTestDataHelpers.createBillReturnLine(bill, billReturn, item,
                                                 billLine);
    dmpl__BillReturnTax__c billReturnTax =
        BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine,
                                                item, sku, bill, billLine,
                                                grnLine, taxGroup, tax);
    Test.stopTest();

    Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
        'Partner 1', false, true, false, true, 'MG Road', 'Bengaluru',
        'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru',
        'Karnataka', 'India', '560095', '9876543210');
    Account partnerAccount2 = TestDataHelpers.createPartnerAccount(
        'Partner 2', false, true, false, true, '45 Residency Road', 'Pune',
        'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune',
        'Maharashtra', 'India', '411038', '91-99665544433');
    Account partnerAccount3 = TestDataHelpers.createPartnerAccount(
        'Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai',
        'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai',
        'Tamil Nadu', 'India', '600042', '91-9123456789');
    Account partnerAccount4 = TestDataHelpers.createPartnerAccount(
        'Partner 4', false, true, false, true, '12 Industrial Zone',
        'Hyderabad', 'Telangana', 'India', '500032', '12 Industrial Zone',
        'Hyderabad', 'Telangana', 'India', '500032', '9876012345');
    Account partnerAccount6 = TestDataHelpers.createPartnerAccount(
        'Partner 6', false, true, false, true, 'MS Road', 'Bengaluru',
        'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru',
        'Karnataka', 'India', '560095', '9845543210');

    Account customerAccount1 = TestDataHelpers.createCustomerAccount(
        'Customer 1', true, false, false, true, 'MG Road', 'Pune',
        'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra',
        'India', '440001', '9876543210', 'Created');
    Account customerAccount2 = TestDataHelpers.createCustomerAccount(
        'Customer 2', true, false, false, true, 'Park St', 'Kolkata',
        'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal',
        'India', '700029', '9876543210', 'Created');
    Account customerAccount3 = TestDataHelpers.createCustomerAccount(
        'Customer 3', true, false, false, true, 'Anna Salai', 'Chennai',
        'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu',
        'India', '600017', '9012345678', 'Created');
    Account customerAccount4 = TestDataHelpers.createCustomerAccount(
        'Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad',
        'Gujarat', 'India', '380054', 'C G Road', 'Ahmedabad', 'Gujarat',
        'India', '380009', '9988776655', 'Created');
    Account customerAccount6 = TestDataHelpers.createCustomerAccount(
        'Customer 6', true, false, false, true, 'Sector 18', 'Noida',
        'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida',
        'Uttar Pradesh', 'India', '201309', '9876501234', 'Created');
    Account customerAccount7 = TestDataHelpers.createCustomerAccount(
        'Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru',
        'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka',
        'India', '560038', '9811122233', 'Created');

    Account customerAccount10 = TestDataHelpers.createCustomerAccount(
        'Customer 10', true, false, false, true, 'Park Street', 'Kolkata', 'WB',
        'India', '700017', 'Salt Lake', 'Kolkata', 'WB', 'India', '700091',
        '9123456701', 'Created');

    dmpl__Branch__c branch1 = TestDataHelpers.createBranch(
        'Branch 1', partnerAccount1.Id, true, true, false, true);
    dmpl__Branch__c branch2 = TestDataHelpers.createBranch(
        'Branch 2', partnerAccount2.Id, true, false, true, true);
    dmpl__Branch__c branch3 = TestDataHelpers.createBranch(
        'Branch 3', partnerAccount1.Id, false, true, true, false);
    dmpl__Branch__c branch4 = TestDataHelpers.createBranch(
        'Branch 4', partnerAccount4.Id, true, true, false, false);
    dmpl__Branch__c branch6 = TestDataHelpers.createBranch(
        'Branch 6', partnerAccount6.Id, true, true, false, true);

    dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress(
        'Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id,
        'Billing Address', '440001', false);
    dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress(
        'Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id,
        'Billing Address', '440001', false);
    dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress(
        'Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,
        'Billing Address', '440022', false);
    dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress(
        'Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id,
        'Billing Address', '440001', false);
    dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress(
        'Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id,
        'Shipping Address', '440001', false);

    Contact contact = TestDataHelpers.createContact(
        'Contact 1', '9113150885', '9889198008', customerAccount1.Id);

    dmpl__AccountGroup__c accountGroup1 =
        TestDataHelpers.createAccountGroup('Account Group 1', null);
    dmpl__AccountGroupMember__c accountGroupMember1 =
        TestDataHelpers.createAccountGroupMember(accountGroup1.id,
                                                 partnerAccount1.id);
    dmpl__AccountGroupMember__c accountGroupMember2 =
        TestDataHelpers.createAccountGroupMember(accountGroup1.id,
                                                 partnerAccount2.id);

    dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList(
        'Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false,
        'Sale Price');
    dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList(
        'Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false,
        'Sale Price');
    dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList(
        'Price List 3', partnerAccount4.Id, branch4.Id, null, null, true, false,
        'Sale Price');
    dmpl__PriceList__c priceList5 = TestDataHelpers.createPriceList(
        'Price List 5', partnerAccount6.Id, branch6.Id, null, null, false,
        false, 'Sales');
    dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList(
        'Price List 7', null, null, null, null, true, false, 'Sales');

    dmpl__Item__c item1 = TestDataHelpers.createItem(
        'Item 1', 'Product', true, false, false, '675654', false, false);
    dmpl__Item__c item2 = TestDataHelpers.createItem(
        'Item 2', 'Product', false, false, false, '654345', false, false);
    dmpl__Item__c item3 = TestDataHelpers.createItem(
        'Item 3', 'Charge Item', true, false, false, '765434', true, false);
    dmpl__Item__c item4 = TestDataHelpers.createItem(
        'Item 4', 'Product', true, false, false, '765676', true, false);
    dmpl__Item__c item5 = TestDataHelpers.createItem(
        'Item 5', 'Product', true, false, false, '876543', false, false);
    dmpl__Item__c item6 = TestDataHelpers.createItem(
        'Item 6', 'Product', true, false, false, '765456', false, false);
    dmpl__Item__c item7 = TestDataHelpers.createItem(
        'Item 7', 'Product', true, false, true, '765456', false, false);
    dmpl__Item__c item8 = TestDataHelpers.createItem(
        'Item 8', 'Product', true, false, true, '765456', false, false);
    dmpl__Item__c item13 = TestDataHelpers.createItem(
        'Item 13', 'Product', true, false, false, '765456', true, false);
    dmpl__Item__c item14 = TestDataHelpers.createItem(
        'Item 14', 'Part', true, false, false, '765458', true, false);
    dmpl__Item__c item15 = TestDataHelpers.createItem(
        'Item 15', 'Part', true, false, false, '765459', false, true);
    dmpl__Item__c item16 = TestDataHelpers.createItem(
        'Item 16', 'Part', true, false, false, '765460', false, true);

    dmpl__ItemGroup__c itemGroup1 =
        TestDataHelpers.createItemGroup('Item Group 1', 'Tax');
    dmpl__ItemGroupMember__c itemGroupMemeber1 =
        TestDataHelpers.createItemGroupMember(itemGroup1.Id, item1.Id);
    dmpl__ItemGroupMember__c itemGroupMemeber2 =
        TestDataHelpers.createItemGroupMember(itemGroup1.Id, item2.Id);

    dmpl__ItemAlternate__c itemAlternate16 =
        TestDataHelpers.createItemAlternate(item15.Id, item16.Id, 'Superseded',
                                            Date.newInstance(2025, 6, 30));
    dmpl__ItemAlternate__c itemAlternate13 =
        TestDataHelpers.createItemAlternate(item14.Id, item13.Id, 'Superseded',
                                            Date.newInstance(2025, 6, 30));

    dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
    dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);

    dmpl__PriceListRules__c priceListRule1 =
        TestDataHelpers.createPriceListRules(
            priceList1.id, item1.id, null, null, 1500,
            System.today().addDays(-15), System.today() + 9);
    dmpl__PriceListRules__c priceListRule10 =
        TestDataHelpers.createPriceListRules(priceList3.id, item1.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule3 =
        TestDataHelpers.createPriceListRules(priceList1.id, item3.id, null,
                                             null, 2000, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule4 =
        TestDataHelpers.createPriceListRules(priceList1.id, item4.id, null,
                                             null, 2000, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule5 =
        TestDataHelpers.createPriceListRules(priceList3.id, item6.id, null,
                                             null, 2000, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule7 =
        TestDataHelpers.createPriceListRules(priceList3.id, item5.id, null,
                                             null, 1000, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule8 =
        TestDataHelpers.createPriceListRules(
            priceList1.id, item5.id, null, null, 1000,
            System.today().addDays(-1), System.today() + 9);
    dmpl__PriceListRules__c priceListRule9 =
        TestDataHelpers.createPriceListRules(priceList1.id, item6.id, null,
                                             null, 2400, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule11 =
        TestDataHelpers.createPriceListRules(priceList3.id, item8.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule13 =
        TestDataHelpers.createPriceListRules(priceList1.id, item13.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule14 =
        TestDataHelpers.createPriceListRules(priceList1.id, item14.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule12 =
        TestDataHelpers.createPriceListRules(priceList1.id, item15.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);
    dmpl__PriceListRules__c priceListRule16 =
        TestDataHelpers.createPriceListRules(priceList1.id, item16.id, null,
                                             null, 1500, System.today() - 1,
                                             System.today() + 9);

    dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup(
        'GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
    dmpl__TaxGroup__c taxGroupGST18partner1 = TestDataHelpers.createTaxGroup(
        'GST 18', true, 'Line Level', partnerAccount1.Id, branch1.Id,
        accountGroup1.Id);
    dmpl__TaxGroup__c taxGroupGST28partner4 = TestDataHelpers.createTaxGroup(
        'GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
    dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup(
        'GST 12', true, 'Line Level', null, null, null);
    dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup(
        'IGST 18', true, 'Line Level', null, null, null);

    dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax(
        'CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
    dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax(
        'SGST18', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
    dmpl__Tax__c taxCGST18 = TestDataHelpers.createTax(
        'CGST18', 'CGST', 18, taxGroupGST18partner1.Id, 'Tax1');
    dmpl__Tax__c taxSGST18 = TestDataHelpers.createTax(
        'SGST', 'SGST', 18, taxGroupGST18partner1.Id, 'Tax2');
    dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax(
        'CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
    dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax(
        'SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
    dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax(
        'IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
    dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax(
        'CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
    dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax(
        'SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');

    dmpl__TaxGroupRule__c taxGroupRule28Item1 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner1.Id, item1.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule12Item5 =
        TestDataHelpers.createTaxGroupRule(
            'Within State', taxGroupGST12Global.Id, item5.Id, null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule12Item4 =
        TestDataHelpers.createTaxGroupRule(
            'Within State', taxGroupGST12Global.Id, item6.Id, null, null, null);
    dmpl__TaxGroupRule__c taxGroupRuleItem1 =
        TestDataHelpers.createTaxGroupRule(
            'Within State', taxGroupGST12Global.Id, item1.Id, null, null, null);
    dmpl__TaxGroupRule__c taxGroupRuleIGST18 =
        TestDataHelpers.createTaxGroupRule('Outside State', taxGroupIGST18.Id,
                                           null, null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule28item8 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner4.Id, item8.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule28Item13 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner1.Id, item13.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule28Item14 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner1.Id, item14.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule28Item15 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner1.Id, item15.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule28Item16 =
        TestDataHelpers.createTaxGroupRule('Within State',
                                           taxGroupGST28partner1.Id, item16.Id,
                                           null, null, null);
    dmpl__TaxGroupRule__c taxGroupRule18Item5IGST =
        TestDataHelpers.createTaxGroupRule('Outside State', taxGroupIGST18.Id,
                                           item5.Id, null, null, null);

    dmpl__Resource__c resource2 = TestDataHelpers.createResource(
        'Resource 2', partnerAccount1.Id, branch1.Id, false);

    dmpl__DiscountGroup__c discountGroup1 =
        DiscountDataHelper.createDiscountGroup('Discount 1', partnerAccount4.Id,
                                               branch4.Id, null, true,
                                               'Sale Price');
    dmpl__DiscountGroup__c discountGroup2 =
        DiscountDataHelper.createDiscountGroup('Discount 2', partnerAccount1.Id,
                                               branch1.Id, null, true,
                                               'Purchase Price');

    dmpl__DiscountGroupRule__c discountGroupRule1 =
        DiscountDataHelper.createDiscountGroupRule(
            discountGroup1.Id, item6.Id, null, null, null, 4,
            Date.newInstance(2025, 1, 5), Date.newInstance(2025, 7, 30));
    dmpl__DiscountGroupRule__c discountGroupRule2 =
        DiscountDataHelper.createDiscountGroupRule(
            discountGroup1.Id, item5.Id, null, null, null, 4,
            Date.newInstance(2025, 1, 5), Date.newInstance(2025, 7, 30));
    dmpl__DiscountGroupRule__c discountGroupRule3 =
        DiscountDataHelper.createDiscountGroupRule(
            discountGroup2.Id, item6.Id, null, null, null, 4,
            Date.newInstance(2025, 5, 6), Date.newInstance(2025, 11, 30));

    dmpl__ItemUnitOfMeasure__c uomCaseItem5 =
        TestDataHelpers.ItemUnitOfMeasure('Case', 'Case', 1, item5.Id);
    dmpl__ItemUnitOfMeasure__c uomPiecesItem5 =
        TestDataHelpers.ItemUnitOfMeasure('Pieces', 'Pieces', 0.033333,
                                          item5.Id);
    dmpl__ItemUnitOfMeasure__c uomCaseItem1 =
        TestDataHelpers.ItemUnitOfMeasure('Case', 'Case', 1, item1.Id);
    dmpl__ItemUnitOfMeasure__c uomPiecesItem1 =
        TestDataHelpers.ItemUnitOfMeasure('Pieces', 'Pieces', 0.033333,
                                          item1.Id);
    dmpl__ItemUnitOfMeasure__c uomCaseItem6 =
        TestDataHelpers.ItemUnitOfMeasure('Case', 'Case', 1, item6.Id);
    dmpl__ItemUnitOfMeasure__c uomPiecesItem6 =
        TestDataHelpers.ItemUnitOfMeasure('Pieces', 'Pieces', 0.033333,
                                          item6.Id);

    dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme(
        'Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice',
        'Per Order', Date.newInstance(2025, 5, 1),
        Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false,
        partnerAccount4.Id, null, null, null, branch4.Id, 100000);
    dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(
        1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
    dmpl__SchemeCondition__c schemeCondition2 =
        SchemeDataHelper.createSchemeCondition(
            'Item Quantity', 'Greater Than Or Equal', item5.Id, 10,
            schemeLine2.Id, scheme2.Id, 1);
    dmpl__SchemeBenefit__c schemeBenefit2 =
        SchemeDataHelper.createSchemeBenefit(
            'Rate Off', 'Line Level Discount Amount', null, null, null, 1000,
            schemeLine2.Id, scheme2.Id, 1);
    dmpl__SchemeAccountBudget__c schemeBudget2 =
        SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id,
                                                    partnerAccount4.Id);
    scheme2.dmpl__Status__c = 'Approved';
    update scheme2;

    dmpl__Scheme__c scheme9 = SchemeDataHelper.createScheme(
        'Scheme 9', 'Auto Apply', 'Draft', 'Per Sale Order And Invoice',
        'per order', Date.newInstance(2025, 5, 26),
        Date.newInstance(2025, 6, 26), 0, 'Apply all Fulfilled', 1, false,
        partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id,
        100000);
    dmpl__SchemeLine__c schemeLine9 = SchemeDataHelper.createSchemeLine(
        1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme9.Id);
    dmpl__SchemeCondition__c schemeCondition9 =
        SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals',
                                               item6.Id, 2, schemeLine9.Id,
                                               scheme9.Id, 1);
    dmpl__SchemeBenefit__c schemeBenefit9 =
        SchemeDataHelper.createSchemeBenefit(
            'FREE ITEM', 'Line Level Discount Percent', null, 1, 5, null,
            schemeLine9.Id, scheme9.Id, 1);
    dmpl__SchemeAccountBudget__c schemeBudget9 =
        SchemeDataHelper.createSchemesAccountBudget(100000, scheme9.Id,
                                                    partnerAccount1.Id);
    scheme9.dmpl__Status__c = 'Approved';
    update scheme9;

    dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme(
        'Scheme 20', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER',
        Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2,
        'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null,
        customerAccount1.Id, branch1.Id, 100000);
    dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(
        1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards',
        scheme20.Id);
    dmpl__SchemeCondition__c schemeCondition20 =
        SchemeDataHelper.createSchemeCondition(
            'Item Quantity', 'Greater Than Or Equal', item1.Id, 18,
            schemeLine20.Id, scheme20.Id, 1);
    dmpl__SchemeBenefit__c schemeBenefit20 =
        SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item',
                                             item1.Id, 1, 5, null,
                                             schemeLine20.Id, scheme20.Id, 1);
    dmpl__SchemeAccountBudget__c schemeBudget20 =
        SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id,
                                                    partnerAccount1.Id);
    scheme20.dmpl__Status__c = 'Approved';
    update scheme20;
 }

  @isTest
  static void createBillReturnPositive() {
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
    if (billReturn != null) {
      System.assertNotEquals(
        billReturn,
        null,
        'Expected BillReturn to be created.'
      );
    }
    System.assertEquals(
      false,
      billReturn.dmpl__PerformReturn__c,
      'PerformReturn should be true'
    );
    System.assertEquals(
      false,
      billReturn.dmpl__PerformInventoryPosting__c,
      'PerformInventoryPosting should be false'
    );
    System.assertEquals(
      Date.today(),
      billReturn.dmpl__DocumentDate__c,
      'DocumentDate should ' + Date.today()
    );
  }

  @isTest
  static void updateBillReturnPositive() {
    Test.startTest();
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
    System.assertNotEquals(
      billReturn,
      null,
      'Bill Return should exist before update.'
    );
    billReturn.dmpl__PerformReturn__c = false;
    update billReturn;
    dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn();
    System.assertEquals(
      false,
      updatedBillReturn.dmpl__PerformReturn__c,
      'PerformReturn should be false'
    );
    Test.stopTest();
  }

  @isTest
  static void deleteBillReturn() {
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
    System.assertNotEquals(
      billReturn,
      null,
      'BillReturn should exist before delete.'
    );
    delete billReturn;
    dmpl__BillReturn__c deletedBillReturn = null;
    try {
      deletedBillReturn = BillTestDataHelpers.getBillReturn();
      System.assert(
        false,
        'Expected exception when querying deleted record, but got: ' +
        deletedBillReturn
      );
    } catch (Exception e) {
      deletedBillReturn = null;
    }
    System.assertEquals(
      null,
      deletedBillReturn,
      'BillReturn should be deleted and not found in query.'
    );
  }

  @isTest
  static void createBillReturnLinePositive() {
    Test.startTest();
    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
    Test.stopTest();
    if (billReturnLine != null) {
      System.assertNotEquals(
        billReturnLine,
        null,
        'Expected BillReturnLine to be created.'
      );
    }
    System.assertEquals(
      2,
      billReturnLine.dmpl__Quantity__c,
      'Quantity should be 2'
    );
  }

  @isTest
  static void updateBillReturnLinePositive() {
    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
    System.assertNotEquals(
      billReturnLine,
      null,
      'BillReturnLine should exist before update.'
    );
    Test.startTest();
    billReturnLine.dmpl__Quantity__c = 5;
    update billReturnLine;
    Test.stopTest();
    dmpl__BillReturnLine__c updatedBillReturnLine = BillTestDataHelpers.getBillReturnLine();
    System.assertEquals(
      5,
      updatedBillReturnLine.dmpl__Quantity__c,
      'Quantity should be 5'
    );
  }

  @isTest
  static void deleteBillReturnLine() {
    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
    System.assertNotEquals(
      billReturnLine,
      null,
      'BillReturnLine should exist before delete.'
    );

    Test.startTest();
    Boolean exceptionCaught = false;
    String exceptionMessage = '';

    try {
      delete billReturnLine;
      System.assert(false, 'Expected exception when deleting BillReturnLine');
    } catch (Exception e) {
      exceptionCaught = true;
      exceptionMessage = e.getMessage();
      System.debug(
        'Exception caught: Type=' +
          e.getTypeName() +
          ', Message=' +
          exceptionMessage
      );
      System.assert(
        exceptionMessage.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'),
        'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error. Actual: ' +
        exceptionMessage
      );
      System.assert(
        exceptionMessage.contains('BillReturnLineTrigger'),
        'Error should be from BillReturnLineTrigger. Actual: ' +
        exceptionMessage
      );
      System.assert(
        exceptionMessage.contains('null SObject') ||
        exceptionMessage.contains('ListException'),
        'Expected null SObject or ListException error. Actual: ' +
        exceptionMessage
      );
    }
    Test.stopTest();
    System.assert(
      exceptionCaught,
      'An exception should have been thrown during delete'
    );
    dmpl__BillReturnLine__c nonDeletedLine = BillTestDataHelpers.getBillReturnLine();
    System.assertNotEquals(
      null,
      nonDeletedLine,
      'BillReturnLine should still exist after failed delete'
    );
  }

  @isTest
  static void createBillReturnTaxPositive() {
    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
    System.assertNotEquals(
      billReturnTax,
      null,
      'Expected BillReturnTax to be created.'
    );
    System.assertEquals(
      true,
      billReturnTax.dmpl__TaxOnAmount__c,
      'TaxOnAmount should be true'
    );
  }

  @isTest
  static void updateBillReturnTaxPositive() {
    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
    System.assertNotEquals(
      billReturnTax,
      null,
      'BillReturnTax should exist before update.'
    );
    billReturnTax.dmpl__TaxAmount__c = 100;
    Test.startTest();
    update billReturnTax;
    Test.stopTest();
    dmpl__BillReturnTax__c updated = BillTestDataHelpers.getBillReturnTax();
    System.assertEquals(
      100,
      updated.dmpl__TaxAmount__c,
      'TaxAmount should be 100'
    );
  }

  @isTest
  static void deleteBillReturnTax() {
    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
    System.assertNotEquals(
      billReturnTax,
      null,
      'BillReturnTax should exist before delete.'
    );
    Test.startTest();
    delete billReturnTax;
    Test.stopTest();
    dmpl__BillReturnTax__c deleted = null;
    try {
      deleted = BillTestDataHelpers.getBillReturnTax();
      System.assert(
        false,
        'Expected exception when querying deleted record, but got: ' + deleted
      );
    } catch (Exception e) {
      deleted = null;
    }
    System.assertEquals(
      null,
      deleted,
      'BillReturnTax should be deleted and not found in query.'
    );
  }

  @isTest
  public static void billReturnTaxCreateRecordWithValidBillReturnBillReturnLineAndTaxPositiveNew() {

    Test.startTest();
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 0,0);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxCreateWithValidTaxGroupAndTaxRatePositiveNew() {

    Test.startTest();
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,0);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxPopulateValidTaxAmountFieldAsPerTaxRateAndBasePositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,null);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxTaxGroupLookupFiltersOnlyActiveValuesPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,null);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxTaxLookupFiltersOnlyActiveTaxValuesPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,null);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxEditTaxRateValueFrom18To9AndSaveSuccessfullyPositiveEdit() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,null);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    billReturnTax.dmpl__TaxRate__c = 9;
    update billReturnTax;

    System.assertEquals(9, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billReturnTaxUpdateTaxGroupAfterCreationPositiveEdit() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');

    dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, taxGroup, tax, 18,null);

    System.assertEquals(taxGroup.Id, billReturnTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billReturnTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount does not match');
    System.assertEquals(billReturn.Id, billReturnTax.dmpl__BillReturnId__c, 'BillReturnId does not match');
    System.assertEquals(18, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    billReturnTax.dmpl__TaxRate__c = 9;
    update billReturnTax;

    System.assertEquals(9, billReturnTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxCreateRecordWithValidBillBillLineAndTaxFieldsPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxEnterCorrectTaxRateAndVerifyCalculationOnTaxAmountPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxProvideTaxOnAmountAndVerifyTaxAmountAutoCalculationPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxEnsureTaxGroupIsSelectedAndValidPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxCreatedByFieldReflectsLoggedInUserPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxLeaveTaxBlankAndAttemptSavePositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,null,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(null, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxProvideTaxGroupThatIsInactivePositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(null,null,bill,billLine,9,null,null);

    System.assertEquals(null, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(null, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxTryCreatingWithInvalidOrArchivedBillPositiveNew() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    try{
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,null,null,9,null,null);
        System.assert(false,'Exception should be thrown');
    } catch(exception e){
        System.assert(true,'Exception should be thrown');
    }

    Test.stopTest();
  }

  @isTest
  public static void billTaxEditTaxRateFrom9To18AndVerifyRecalculatedTaxAmountPositiveEdit() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    billTax.dmpl__TaxRate__c = 18;
    update billTax;

    System.assertEquals(18, billTax.dmpl__TaxRate__c, 'TaxRate does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxChangeTaxGroupToUpdatedConfigurationAndSavePositiveEdit() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    billTax.dmpl__TaxGroupId__c = null;
    update billTax;

    System.assertEquals(null, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');

    Test.stopTest();
  }

  @isTest
  public static void billTaxEditBillLineToBlankAfterSavePositiveEdit() {

    Test.startTest();

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount1, partnerAccount1, branch1);

    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'BranchId does not match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'SupplierAccountId does not match');
    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'PartnerAccountId does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__SupplierInvoiceDate__c, 'SupplierInvoiceDate does not match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate does not match');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn, item1, null, 5, 1500);

    billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, billReturnLine.dmpl__ItemId__c, 'ItemId does not match');
    System.assertEquals(null, billReturnLine.dmpl__SKUId__c, 'SKUId does not match');
    System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity does not match');
    System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'UnitCost does not match');
    System.assertEquals(1000, billReturnLine.dmpl__Amount__c, 'Amount does not match');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
    dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

    dmpl__Bill__c bill = BillTestDataHelpers.getBill();
    dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(bill.Id,item1.Id,10,null);

    dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(taxGroup,tax,bill,billLine,9,null,null);

    System.assertEquals(taxGroup.Id, billTax.dmpl__TaxGroupId__c, 'TaxGroupId does not match');
    System.assertEquals(tax.Id, billTax.dmpl__TaxId__c, 'TaxId does not match');
    System.assertEquals(9, billTax.dmpl__TaxRate__c, 'TaxRate does not match');
    System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'BillId does not match');
    System.assertEquals(billLine.Id, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    billTax.dmpl__BillLineId__c = null;
    update billTax;

    System.assertEquals(null, billTax.dmpl__BillLineId__c, 'BillLineId does not match');

    Test.stopTest();
  }

}