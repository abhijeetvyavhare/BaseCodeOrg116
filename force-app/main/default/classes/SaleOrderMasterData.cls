@isTest
public with sharing class SaleOrderMasterData {
    public static void createSaleOrderLineWithAlternateItemData() {
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13' ,  'Product');
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part');
        dmpl__ItemAlternate__c itemAlternate13 = TestDataHelpers.createItemAlternate(
            item14.Id,
            item13.Id,
            'Superseded',
            Date.today().addDays(10)
        );
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c  priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item13.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__TaxGroupRule__c taxGroupRule28Item = TestDataHelpers.createTaxGroupRule(item13.Id, taxGroup.Id);
    }

    public static void editSaleOrderLineWithSupercedingItemPositiveData() {
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part');
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part');
        dmpl__ItemAlternate__c itemAlternate15 = TestDataHelpers.createItemAlternate(
            item15.Id,
            item16.Id,
            'Superseded',
            Date.today().addDays(10)
        );
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c  priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item16.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__TaxGroupRule__c taxGroupRule28Item = TestDataHelpers.createTaxGroupRule(item16.Id, taxGroup.Id);
    }

    public static void saleOrderWithWrongPartnerAndBranchSelectionNegativeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3' ,partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        branch.dmpl__AllowPurchase__c = false;
        branch.dmpl__AllowInventory__c = false;
        update branch;
    }

    public static void saleOrderWithWrongBranchSelectionNegativeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2' ,partnerAccount.Id);
        branch.dmpl__AllowSales__c = false;
        branch.dmpl__AllowPurchase__c = true;
        update branch;
    }

    public static void saleOrderwithInActivePriceListNegativeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 6');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 6',partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 5',partnerAccount.Id, branch.Id);
    }

    public static void createSaleOrderWithPriceListForPartnerAccountAndBranchPositiveData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
    }

    public static void saleOrderLineWithDiscontinuedItemData(Id priceListId){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__Item__c discontinuedItem = TestDataHelpers.createItem('Item 4','Product');
        discontinuedItem.dmpl__IsDiscontinued__c = true;
        update discontinuedItem;
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceListId, discontinuedItem.Id, 2000);
    }

    public static void createSaleOrderWithInactiveCustomerAccountNegativeData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 7');
        customerAccount.dmpl__IsActive__c = false;
        update customerAccount;
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2',partnerAccount.Id);
    }

    public static void createSaleOrderWithInactivePartnerAccountNegativeData(Id customerAccountId) {
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customerAccountId);
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount.Id);
    }

    public static void saleOrderLineAddingItemWithIsSKURequiredTrueNewNegativeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        branch.dmpl__AllowInventory__c = false;
        update branch;
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.id, false);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3',partnerAccount.Id,branch.Id);
    }

    public static void createSaleOrderWithDiscountGroupEditData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3',partnerAccount.Id,branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6','Product');
        item.dmpl__ItemCode__c = '765456';
        update item;
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1',partnerAccount.Id,branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id,2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partnerAccount.Id,branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CSGT', taxGroup.Id,6 );
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id,6 );
        dmpl__TaxGroupRule__c taxGroupRule12Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }

    public static void saleOrderLineQuantityZeroEditNegativeData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__Item__c Item = TestDataHelpers.createItem('Item 5','Product');    
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1',partnerAccount.Id,branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, Item.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3',partnerAccount.Id,branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id ,Item.Id,1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partnerAccount.Id,branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id,6 );
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id ,6);
        dmpl__TaxGroupRule__c taxGroupRule12Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }
  
    public static void createSaleOrderLineWithInactiveItemData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2','Product');
        item.dmpl__IsActive__c = false;
        update item;
    }

    public static void createSaleOrderLineItemWithoutTaxGroupEditNegativeData(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId,
        Id priceListId
    ) {
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customerAccountId);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3','Charge Item');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceListId, item.Id, 2000);
    }

    public static void createSaleOrderLineItemWithoutTaxGroupNewNegativeData(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId,
        Id priceListId
    ) {
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', customerAccountId);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3','Charge Item');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceListId, item.Id, 2000);
    }

    public static void schemeAutoApplyDiscountAmountData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 2');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 2',
            partnerAccount.Id,
            null,
            branch.Id
        );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'NET RATE');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Greater Than Or Equal',
            item.Id,
            10
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccount.Id);
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }

    public static void  saleOrsderWithDiscountGroupData(){
     Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule12Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }

    public static void saleOrderLineAddingItemWithIsSKURequiredTrueEditNegativeData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        branch.dmpl__AllowInventory__c = false;
        update branch;
        dmpl__Item__c item = TestDataHelpers.createItem('Item 8','Product');
        item.dmpl__IsSKURequired__c = true;
        update item;
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item.id, false);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3',partnerAccount.Id,branch.Id);
        dmpl__PriceListRules__c  priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id,1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 28',partnerAccount.Id,branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 14);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule28Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }
  
    public static void saleOrderLineWithInactiveItemEditData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4',partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partnerAccount.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 28',partnerAccount.Id,branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule28Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
        item2.dmpl__IsActive__c = false;
        update item2;
    }

    public static void createSaleOrderWithDiscountGroupAndSchemeNewData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme('Scheme 2', partnerAccount.Id, null, branch.Id);
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'NET RATE');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Greater Than Or Equal',
            item.Id,
            10
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccount.Id);
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }
 
    public static void saleOrderLineWithSchemeAutoApplyDiscountAmountNewData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 2',
            partnerAccount.Id,
            null,
            branch.Id
        );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'NET RATE');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Greater Than Or Equal',
            item.Id,
            10
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccount.Id);
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }
 
    public static void createAutoApplySchemeDiscountPercentageData(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId,
        Id priceListId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 6','Product');
        item.dmpl__ItemCode__c = '765456';
        update item;
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListid, item.id,2400);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partnerAccountId,branchId);
        dmpl__Tax__c taxCGST =  TestDataHelpers.createTax('CGST', taxGroup.Id,6);
        dmpl__Tax__c taxSGST =  TestDataHelpers.createSGSTTax('SGST', taxGroup.Id,6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1',partnerAccountId,branchId);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme('Scheme 9',partnerAccountId,customerAccountId,branchId);
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'Percentage');
        dmpl__SchemeCondition__c condition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Equals',
            item.Id,
            2
        );
        condition.dmpl__ConditionType__c = 'Item Quantity';
        update condition;
        dmpl__SchemeBenefit__c benefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        benefit.dmpl__Title__c = 'FREE ITEM';
        benefit.dmpl__DiscountedItemQuantity__c = 1;
        benefit.dmpl__DiscountPercent__c = 5;
        benefit.dmpl__SequenceNumber__c = 1;
        benefit.dmpl__DiscountAmount__c = null;
        benefit.dmpl__RewardType__c = 'Line Level Discount Percent';
        update benefit;
        dmpl__SchemeAccountBudget__c budget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccountId);
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }

    public static void createschemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetEditData(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5','Product');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id ,item.Id,1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id , 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id , 6);
        dmpl__TaxGroupRule__c taxGroupRule12Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }

    public static void createschemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetData(
        Id partnerAccountId,
        Id branchId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5','Product');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id ,item.Id,1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partnerAccountId,branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id ,6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id,6);        
        dmpl__TaxGroupRule__c taxGroupRule12Item = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }

    public static void SchemeApplicabilityForPartnerAccDefinedNewData(){
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 4');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 1', partnerAccount.Id, branch.Id);
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme('Scheme 2', partnerAccount.Id, null, branch.Id);
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'NET RATE');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Greater Than Or Equal',
            item.Id,
            10
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccount.Id);
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }

    public static void  saleOrderWithMultipleBillingAndShippingAddressData(
        Id CustomerId,
        Id PartnerId,
        Id BranchId,
        Id PriceListId,
        Id BillingAddressId
    ){
        dmpl__ContactAddress__c address3 = TestDataHelpers.createContactAddress('Address 3' ,CustomerId);
        address3.dmpl__AddressType__c = 'Billing Address';             
        address3.dmpl__PostalCode__c = '440022';
        address3.dmpl__IsDefault__c = false;
        update address3;
    }

    public static void saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetData(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId,
        Id itemId
    ) {
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme('Scheme 9',partnerAccountId,customerAccountId,branchId);
        scheme.dmpl__SchemeBudget__c = 0;
        update scheme;
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'Percentage');
        dmpl__SchemeCondition__c condition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Equals',
            itemId,
            2
        );
        condition.dmpl__ConditionType__c = 'Item Quantity';
        update condition;
        dmpl__SchemeBenefit__c benefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        benefit.dmpl__Title__c = 'FREE ITEM';
        benefit.dmpl__DiscountedItemQuantity__c = 1;
        benefit.dmpl__DiscountPercent__c = 5;
        benefit.dmpl__SequenceNumber__c = 1;
        benefit.dmpl__DiscountAmount__c = null;
        benefit.dmpl__RewardType__c = 'Line Level Discount Percent';
        update benefit;
        dmpl__SchemeAccountBudget__c budget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccountId);
        budget.dmpl__BudgetAmount__c = 0;
        update budget;
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }

    public static void createSaleOrderwithNegativeQuantityNegativeData(
        Id partnerAccountId,
        dmpl__Branch__c branch
    ) {
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product');
        dmpl__TaxGroup__c taxGroupGST12 = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branch.Id);
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', taxGroupGST12.Id, 6);
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST12.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item7.Id, taxGroupGST12.Id);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch, 'Warehouse');
    }
}