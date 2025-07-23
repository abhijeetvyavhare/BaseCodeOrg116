public with sharing class PurchaseOrderMasterData {
    public static dmpl__PurchaseOrder__c purchaseOrderLineWithQuantity(Id supplierAccountId) {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 3', partnerAccount.Id, branch.Id);
        priceList.dmpl__PriceListType__c = 'Purchase Price';
        update priceList;
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccount.Id, branch.Id);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 13', 
            partnerAccount.Id, 
            null, 
            branch.Id
        );
        scheme.dmpl__SchemeType__c = 'Per Purchase Order';
        update scheme;
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'PERCENTAGE');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id, 
            scheme.Id, 
            'Greater Than Or Equal', 
            item.Id, 
            5
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        schemeBenefit.dmpl__RewardType__c = 'Line Level Discount Percent';
        schemeBenefit.dmpl__DiscountedItemId__c = item.Id;
        schemeBenefit.dmpl__DiscountedItemQuantity__c = 1;
        schemeBenefit.dmpl__DiscountPercent__c = 50;
        update schemeBenefit;
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplierAccountId, partnerAccount.Id, branch.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            taxGroup.Id,
            5
        );
        return purchaseOrder;
    }

    public static void schemeApplicabilityUnavailabilityofBudgetData(
        Id supplierAccountId, 
        Id branchId, 
        Id partnerAccountId, 
        Id priceListId
    ) {
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 11', 
            partnerAccountId, 
            null, 
            branchId
        );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'FREE OF COST');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id, 
            scheme.Id, 
            'Equals', 
            item.Id, 
            7
        );
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccountId);
        schemeBudget.dmpl__BudgetAmount__c = 0;
        update schemeBudget;
        scheme.dmpl__SchemeBudget__c = 0;
        scheme.dmpl__Status__c = 'Approved';
        scheme.dmpl__SchemeType__c = 'Per Purchase Order';
        update scheme;
    }

    public static void purchaseOrderLineWithItemWithoutTaxGroup(
        Id priceListId, 
        Id partnerAccountId, 
        Id branchId
    ){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 2000);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
    }

    public static void schemeApplicabilityInCaseOfDiscountedItemData(
        Id partnerAccountId, 
        Id branchId, 
        Id itemId
    ){
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, itemId);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 18', 
            partnerAccountId, 
            null, 
            branchId
        );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'FREE OF COST');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id, 
            scheme.Id, 
            'Greater Than Or Equal', 
            itemId, 
            17
        );
        schemeCondition.dmpl__ConditionType__c = 'Quantity';
        update schemeCondition;
        dmpl__SchemeBenefit__c schemeBenefit = TestDataHelpers.createSchemeBenefit(schemeLine.Id, scheme.Id);
        schemeBenefit.dmpl__Title__c = 'FREE ITEM';
        schemeBenefit.dmpl__RewardType__c = 'Discounted Item';
        schemeBenefit.dmpl__DiscountedItemId__c = itemId;
        schemeBenefit.dmpl__DiscountPercent__c = 5;
        schemeBenefit.dmpl__DiscountedItemQuantity__c = 1;
        update schemeBenefit;
        dmpl__SchemeAccountBudget__c schemeBudget = TestDataHelpers.createSchemesAccountBudget(scheme.Id, partnerAccountId);
        dmpl__SchemeAccountBudget__c schemeBudgetWithoutPartner = TestDataHelpers.createSchemesAccountBudget(scheme.Id);
        scheme.dmpl__SchemeType__c = 'Per Purchase Order';
        scheme.dmpl__Status__c = 'Approved';
        update scheme;
    }

    public static void taxApplicationObjectModelInlineTaxData(
        Id partnerAccountId, 
        Id branchId, 
        Id itemId
    ){
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, itemId);
    }

    public static void purchaseOrderLineWithSkuRequiredData(
        Id partnerAccountId, 
        Id branchId, 
        Id priceListId
    ){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
    }

    public static void purchaseOrderLineWithAndWithouPriceData(
        Id priceListId, 
        Id partnerAccountId, 
        Id branchId, 
        Id itemId
    ){
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item5.Id, 0);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRuleItem1 = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, itemId);
        dmpl__DiscountGroupRule__c discountGroupRuleItem5 = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item5.Id);
    }

    public static void purchaseOrderSchemeNotAppliedDueToExceedingBudgetEdit(
        Id partnerAccountId, 
        Id branchId, 
        Id itemId
    ){
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, itemId);
    }

    public static void purchaseOrderLineWithEnteredQuantityNew(
        Id partnerAccountId, 
        Id branchId, 
        Id priceListId
    ){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item.Id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item.Id);
    }

    public static void purchaseOrderLineWithSkuRequiredData(
        Id partnerAccountId, 
        Id branchId, 
        Id priceListId, 
        Id itemId
    ){
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Charge Item');
        item9.dmpl__IsSKURequired__c = true;
        update item9;
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceListId, item9.Id, 2000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item9.Id, taxGroup.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRuleItem1 = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, itemId);
    }

    public static void purchaseOrderLineWithDiscontinuedItemData(
        Id partnerAccountId, 
        Id branchId, 
        Id priceListId
    ){
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product');
        dmpl__PriceListRules__c priceListRuleItem3 = TestDataHelpers.createPriceListRules(priceListId, item3.Id, 2000);
        dmpl__PriceListRules__c priceListRuleItem4 = TestDataHelpers.createPriceListRules(priceListId, item4.Id, 1000);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partnerAccountId, branchId);
        dmpl__Tax__c taxCGST = TestDataHelpers.createTax('CGST', taxGroup.Id, 6);
        dmpl__Tax__c taxSGST = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 6);
        dmpl__TaxGroupRule__c taxGroupRuleItem3 = TestDataHelpers.createTaxGroupRule(item3.Id, taxGroup.Id);
        dmpl__TaxGroupRule__c taxGroupRuleItem4 = TestDataHelpers.createTaxGroupRule(item4.Id, taxGroup.Id);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup('Discount 2', partnerAccountId, branchId);
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        dmpl__DiscountGroupRule__c discountGroupRule = TestDataHelpers.createDiscountGroupRule(discountGroup.Id, item3.Id);
    }
    public static void purchaseOrderFullFlowValidationWithEdgeCasesinvalidItemAndQuantityData(
        Id partner1Id
    ){
        Account partner2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner1Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2','Product');
        item.dmpl__IsActive__c = false;
        update item;

    }
}