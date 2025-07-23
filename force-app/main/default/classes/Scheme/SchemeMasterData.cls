@isTest
public with sharing class SchemeMasterData {
    public static void createSchemeLedgerWithWrongPartnerAccountNegativeData(
        dmpl__AccountGroup__c accountGroup
    ) {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partnerAccount.Id);
        partnerAccount.dmpl__IsActive__c = false;
        update partnerAccount;
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup.id, partnerAccount.id); 
    }

    public static void createPartnerAccount1Data() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup('Account Group 1',null);
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup.id, partner.id); 
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        Account supplier = TestDataHelpers.createSupplierAccount('Supplier 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.id, item.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroupGST28.Id);
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier, branch, priceList);
    }

    public static void createScheme20(){
        createPartnerAccount1Data();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme();
        scheme20.Name = 'Scheme 20';
        scheme20.dmpl__SchemeType__c = 'Per Purchase order';
        scheme20.dmpl__ValidCount__c = 2;
        scheme20.dmpl__IgnoreBudget__c = true;
        scheme20.dmpl__PartnerAccountId__c = partner.Id;
        scheme20.dmpl__AccountId__c = customer.Id;
        scheme20.dmpl__BranchId__c = branch.Id;
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(scheme20.Id);
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition(scheme20.Id, schemeLine20.Id, item.Id);
        schemeCondition20.dmpl__ConditionOperator__c = 'Greater Than Or Equal';
        schemeCondition20.dmpl__ConditionValue__c = 18;
        update schemeCondition20;
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit(scheme20.Id, schemeLine20.Id,  item.Id);
        schemeBenefit20.dmpl__Title__c = 'FREE ITEM';
        schemeBenefit20.dmpl__DiscountedItemQuantity__c = 1;
        schemeBenefit20.dmpl__DiscountPercent__c = 5;
        update schemeBenefit20;
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partner.Id);
    }
    
    public static Void createSchemeConsumptionWithWrongBranchNegativeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        branch.dmpl__IsActive__c = false;
        update branch;
    }

    public static void createItem2(
        dmpl__ItemGroup__c itemGroup
    ){
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
        item2.dmpl__IsActive__c = false;
        update item2;
        dmpl__ItemGroupMember__c itemGroupMember1 = TestDataHelpers.createItemGroupMember(itemGroup.Id, item2.Id);
    } 
    
    public static void createSchemeLedgerWithRepairOrderPositiveData(
        Account partner, 
        Account customer,
        dmpl__Branch__c branch,
        dmpl__Item__c item
    ){
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);
        dmpl__RepairOrder__c repairOrder4 = RepairOrderTestDataHelpers.createRepairOrder(
            partner,
            customer,
            branch,
            asset,
            300
        );
    }

    public static void createSchemeLedgerWithSaleReturnPositiveData(
        dmpl__Branch__c branch,
        dmpl__PriceList__c priceList,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__TaxGroup__c taxGroup
    ){
        Account customer = TestDataHelpers.createCustomerAccount('Customer 4');
         dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(
            customer, 
            branch, 
            null, 
            priceList
        );
        dmpl__SaleReturnLine__c saleReturnLine4 = SaleReturnDataHelper.createSaleReturnLine(
            saleReturn, 
            item, 
            sku, 
            taxGroup
        );
    }

    public static void createSchemeLedgerWithSaleOrderPositiveData(
        dmpl__Branch__c branch,
        dmpl__PriceList__c priceList,
        dmpl__Item__c item
    ){
        Account customer = TestDataHelpers.createCustomerAccount('Customer 4');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__SaleOrderLine__c saleOrderLine4 = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item.Id, 
            15, 
            null
        );
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(
            customer, 
            branch, 
            saleOrder, 
            priceList
        );
        dmpl__SaleInvoiceLine__c saleInvoiceLine4 = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, 10);
    }  
}