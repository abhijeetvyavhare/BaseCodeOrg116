@isTest
public with sharing class BillTestDataHelpers {
    public static dmpl__Bill__c createBill(
        Account supplierAccount,
        dmpl__Branch__c branch,
        dmpl__PriceList__c priceList,
        dmpl__PurchaseOrder__c purchaseOrder,
        dmpl__GoodsReceipt__c goodsReceipts   
    ){
        return (dmpl__Bill__c)TestFactory.createSObject(
            new dmpl__Bill__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                dmpl__GoodsReceiptId__c = goodsReceipts.Id,
                dmpl__DocumentDate__c = date.today(),
                dmpl__TypeOfBill__c = 'Expense Bill',
                dmpl__PriceListId__c = priceList.Id,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__SupplierInvoiceAmount__c = 100,
                dmpl__TCSEligibleAmount__c = 100,
                dmpl__PerformGLPosting__c = false
            ),
            'BillDefaults',
            true       
        );
    }

    public static dmpl__Bill__c getBill(){
        return [
            SELECT
                Id,
                Name,
                dmpl__PerformGLPosting__c ,
                dmpl__PerformKPICalculation__c ,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__BranchId__c,
                dmpl__IsGLPostingApproved__c,
                dmpl__Remarks__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__TypeOfBill__c,
                dmpl__TaxGroupId__c,
                dmpl__DiscountGroupId__c,
                dmpl__SupplierAccountId__c,
                dmpl__TransactionType__c,
                dmpl__SupplierInvoiceAmount__c,
                dmpl__TotalAmount__c,
                dmpl__TotalLineAmount__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalLineTaxAmount__c,
                dmpl__GLAmount__c,
                dmpl__TotalSchemeDiscountAmount__c,
                dmpl__TotalDiscountAmount__c
            FROM dmpl__Bill__c 
            LIMIT 1
        ];
    }

    public static dmpl__Bill__c getBill(Id billId){
        return [
            SELECT
                Id,
                Name,
                dmpl__PerformGLPosting__c ,
                dmpl__PerformKPICalculation__c ,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__BranchId__c,
                dmpl__IsGLPostingApproved__c,
                dmpl__Remarks__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__TypeOfBill__c,
                dmpl__TaxGroupId__c,
                dmpl__DiscountGroupId__c,
                dmpl__SupplierAccountId__c,
                dmpl__TransactionType__c,
                dmpl__SupplierInvoiceAmount__c,
                dmpl__TotalAmount__c,
                dmpl__TotalLineAmount__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalLineTaxAmount__c,
                dmpl__ShippingStreet__c,
                dmpl__ShippingCity__c,
                dmpl__ShippingState__c,
                dmpl__ShippingPostalCode__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__ShippingCountry__c,
                dmpl__BillingState__c,
                dmpl__BillingPostalCode__c,
                dmpl__Status__c,
                dmpl__AccountName__c,
                dmpl__BillingCountry__c,
                dmpl__GLAmount__c,
                dmpl__TotalSchemeDiscountAmount__c,
                dmpl__TotalDiscountAmount__c
            FROM dmpl__Bill__c 
            WHERE Id = : billId
            LIMIT 1
        ];
    }
 
    public static dmpl__Bill__c createBill(
        Account supplierAccount,
        dmpl__Branch__c branch,
        dmpl__PriceList__c priceList 
    ){
        return (dmpl__Bill__c)TestFactory.createSObject(
            new dmpl__Bill__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = date.today(),
                dmpl__TypeOfBill__c = 'Expense Bill',
                dmpl__PriceListId__c = priceList.Id,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__SupplierInvoiceAmount__c = 100,
                dmpl__TCSEligibleAmount__c = 100,
                dmpl__PerformGLPosting__c = false
            ),
            'BillDefaults',
            true       
        );
    }

    public static dmpl__Bill__c createBill(
        Id supplierAccountId,
        Id branchId,
        Id partnerAccountId 
    ){
        return (dmpl__Bill__c)TestFactory.createSObject(
        new dmpl__Bill__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SupplierAccountId__c = supplierAccountId
            ),
            true       
        );
    }

    public static dmpl__BillLine__c createBillLine(
        Account customerAccount,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__ItemLot__c itemLot,
        dmpl__Bill__c bill,
        dmpl__PriceListRules__c rule,
        dmpl__TaxGroup__c taxGroup
    ){
        return (dmpl__BillLine__c)TestFactory.createSObject(
            new dmpl__BillLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__PriceListRuleId__c = rule.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Quantity__c = 10,
                dmpl__UnitCost__c = 100,
                dmpl__IsCustomerBillable__c = true,
                dmpl__ItemLotTypeId__c = itemLot.dmpl__ItemLotTypeId__c,
                dmpl__PurchaseInvoiceId__c = bill.Id
            ),
            'BillLineDefaults',
            true
        );
    }

    public static dmpl__BillLine__c createBillLine(
        Id BillId,
        Id itemId,
        Decimal quantity,
        Id skuId
        
    ) {
        return (dmpl__BillLine__c)TestFactory.createSObject(
            new dmpl__BillLine__c(
                dmpl__PurchaseInvoiceId__c = BillId,
                dmpl__SKUId__c = skuId,
                dmpl__ItemId__c = itemId,
                dmpl__Quantity__c = quantity
            ),
            true
        );
    }

    public static dmpl__BillLine__c createBillLine(
        Id BillId,
        Id itemId
    ) {
        return (dmpl__BillLine__c)TestFactory.createSObject(
            new dmpl__BillLine__c(
                dmpl__ItemId__c = itemId,
                dmpl__PurchaseInvoiceId__c = BillId
            ),
            'BillLineDefaults',
            true
        );
    }

    public static dmpl__BillLine__c getBillLine(){
        return [
            SELECT 
                Id,
                Name,
                dmpl__ItemId__c,
                dmpl__SKUId__c ,
                dmpl__Quantity__c,
                dmpl__ReturnedQuantity__c,
                dmpl__GeneralLedgerId__c,
                dmpl__GLAccountId__c ,
                dmpl__InventoryLedgerId__c ,
                dmpl__ItemLotId__c,
                dmpl__Discount__c,
                dmpl__DiscountAmount__c,
                dmpl__Discount2__c,
                dmpl__DiscountAmount2__c,
                dmpl__IsCustomerBillable__c,
                dmpl__TaxAmount__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c,
                dmpl__SchemeLineId__c,
                dmpl__StorageLocationId__c ,
                dmpl__TaxGroupId__c,
                dmpl__UnitCost__c,
                dmpl__PurchaseInvoiceId__c ,
                dmpl__GoodsReceiptLineId__c ,
                dmpl__EligibleReturnQuantity__c,
                dmpl__InvoiceQuantity__c,
                dmpl__ContractDiscount__c,
                dmpl__ContractDiscountAmount__c,
                dmpl__Amount__c,
                dmpl__BaseAmount__c
            FROM dmpl__BillLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__BillLine__c getBillLine(Id billId){
        return [
            SELECT 
                Id,
                Name,
                dmpl__ItemId__c,
                dmpl__SKUId__c ,
                dmpl__Quantity__c,
                dmpl__ReturnedQuantity__c,
                dmpl__GeneralLedgerId__c,
                dmpl__GLAccountId__c ,
                dmpl__InventoryLedgerId__c ,
                dmpl__ItemLotId__c,
                dmpl__Discount__c,
                dmpl__DiscountAmount__c,
                dmpl__Discount2__c,
                dmpl__DiscountAmount2__c,
                dmpl__IsCustomerBillable__c,
                dmpl__TaxAmount__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c,
                dmpl__SchemeLineId__c,
                dmpl__StorageLocationId__c ,
                dmpl__TaxGroupId__c,
                dmpl__UnitCost__c,
                dmpl__PurchaseInvoiceId__c ,
                dmpl__GoodsReceiptLineId__c ,
                dmpl__EligibleReturnQuantity__c,
                dmpl__ContractDiscount__c,
                dmpl__ContractDiscountAmount__c,
                dmpl__Amount__c,
                dmpl__InvoiceQuantity__c,
                dmpl__BaseAmount__c
            FROM dmpl__BillLine__c
            WHERE dmpl__PurchaseInvoiceId__c = : billId 
            LIMIT 1
        ];
    }

    public static dmpl__BillLine__c createBillLine(
        Account customerAccount,
        dmpl__Item__c item,
        dmpl__Bill__c bill,
        dmpl__TaxGroup__c taxGroup
    ){
        return (dmpl__BillLine__c)TestFactory.createSObject(
            new dmpl__BillLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Quantity__c = 10,
                dmpl__UnitCost__c = 100,
                dmpl__IsCustomerBillable__c = true,
                dmpl__PurchaseInvoiceId__c = bill.Id
            ),     
            'BillLineDefaults',
            true
        );
    }

    public static dmpl__BillReturn__c createBillReturn(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__PriceList__c priceList
    ){
        return (dmpl__BillReturn__c)TestFactory.createSObject(
            new dmpl__BillReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__PerformReturn__c = false,
                dmpl__PriceListId__c = priceList.Id,
                dmpl__IsReturned__c = false,
                dmpl__PerformInventoryPosting__c = false,
                dmpl__DocumentDate__c = date.today()
            ),
            'BillReturnDefaults',
            true
        );
    }

    public static dmpl__BillReturn__c createBillReturn(
        Id supplierAccountId,
        Id partnerAccountId,
        Id branchId,
        Id goodReceiptId,
        Id purchaseOrderId
    ){
        return (dmpl__BillReturn__c)TestFactory.createSObject(
            new dmpl__BillReturn__c(
                dmpl__SupplierAccountId__c = supplierAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__GoodsReceiptId__c = goodReceiptId,
                dmpl__PurchaseOrderId__c = purchaseOrderId
            ),
            'BillReturnDefaults',
            true
        );
    }

    public static dmpl__BillReturn__c createBillReturn(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch
    ){
        return (dmpl__BillReturn__c)TestFactory.createSObject(
            new dmpl__BillReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount != null ? supplierAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__DocumentDate__c = date.today()
            ),
            'BillReturnDefaults',
            true
        );
    }

    public static dmpl__BillReturn__c getBillReturn(){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PerformGLPosting__c,
                dmpl__PerformReturn__c,
                dmpl__DocumentDate__c,
                dmpl__PartnerAccountId__c,
                dmpl__PerformInventoryPosting__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c
            FROM dmpl__BillReturn__c 
            LIMIT 1
        ];         
    }

    public static dmpl__BillReturn__c getBillReturn(
        Id id
    ){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PerformGLPosting__c,
                dmpl__PerformReturn__c,
                dmpl__DocumentDate__c,
                dmpl__PartnerAccountId__c,
                dmpl__PerformInventoryPosting__c,
                dmpl__BranchId__c,
                dmpl__PurchaseOrderId__c,
                dmpl__GoodsReceiptId__c,
                dmpl__SupplierAccountId__c,
                dmpl__PriceListId__c
            FROM dmpl__BillReturn__c 
            WHERE Id = :id
            LIMIT 1
        ];         
    }
   
    public static dmpl__BillReturnLine__c createBillReturnLine(
        dmpl__Bill__c bill,
        dmpl__BillReturn__c billReturn,
        dmpl__Item__c item,
        dmpl__BillLine__c billLine
    ){
       return (dmpl__BillReturnLine__c)TestFactory.createSObject(
            new dmpl__BillReturnLine__c(
                dmpl__BillId__c=bill.Id,
                dmpl__BillReturnId__c=billReturn.Id,
                dmpl__ItemId__c=item.Id,
                dmpl__BillLineId__c=billLine.Id,
                dmpl__Quantity__c=2
            ),
            'BillReturnLineDefaults',
            true
        );  
    }

    public static dmpl__BillReturnLine__c createBillReturnLine(
        dmpl__BillReturn__c billReturn,
        dmpl__Item__c item,
        Integer quantity,
        Decimal unitCost
    ){
       return (dmpl__BillReturnLine__c)TestFactory.createSObject(
            new dmpl__BillReturnLine__c(
                dmpl__BillReturnId__c= billReturn != null ? billReturn.Id : null,
                dmpl__ItemId__c= item != null ? item.Id : null,
                dmpl__Quantity__c= quantity,
                dmpl__UnitCost__c = unitCost
            ),
            'BillReturnLineDefaults',
            true
        );  
    }

    public static dmpl__BillReturnLine__c createBillReturnLine(
        Id billReturnId,
        Id itemId,
        Id skuId
    ){
       return (dmpl__BillReturnLine__c)TestFactory.createSObject(
            new dmpl__BillReturnLine__c(
                dmpl__BillReturnId__c= billReturnId,
                dmpl__ItemId__c= itemId,
                dmpl__SKUId__c = skuId
            ),
            true
        );  
    }
    
    public static dmpl__BillReturnLine__c getBillReturnLine(){
        return [
            SELECT
                Id,
                Name,
                dmpl__BillReturnId__c,
                dmpl__BillLineId__c,
                dmpl__TaxGroupId__c,
                dmpl__Amount__c,
                dmpl__IsClaimed__c,
                dmpl__Quantity__c,
                dmpl__BillReturnId__r.dmpl__Status__c
            FROM dmpl__BillReturnLine__c 
            LIMIT 1
        ];  
    }

    public static dmpl__BillReturnLine__c getBillReturnLine(
        Id billOrderLineId
    ){
        return [
            SELECT
                Id,
                Name,
                dmpl__BillReturnId__c,
                dmpl__BillLineId__c,
                dmpl__SKUId__c,
                dmpl__UnitCost__c,
                dmpl__ClaimableQuantity__c,
                dmpl__PendingDeliveryQuantity__c,
                dmpl__TaxGroupId__c,
                dmpl__Amount__c,
                dmpl__IsClaimed__c,
                dmpl__Quantity__c,
                dmpl__BillReturnId__r.dmpl__Status__c,
                dmpl__ItemId__c,
                dmpl__BaseAmount__c
            FROM dmpl__BillReturnLine__c 
            WHERE Id = :billOrderLineId 
            LIMIT 1
        ];  
    }

    public static dmpl__PurchaseReturn__c createPurchaseReturn(
        Account supplierAccount,
        Account partnerAccount, 
        dmpl__Branch__c branch 
    ){
        return (dmpl__PurchaseReturn__c)TestFactory.createSObject(
            new dmpl__PurchaseReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__PerformReturn__c = false,
                dmpl__IsReturned__c = false,
                dmpl__PerformInventoryPosting__c=false,
                dmpl__DocumentDate__c = date.today()
            ),
            'PurchaseReturnDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturn__c getPurchaseReturn(){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PerformReturn__c,
                dmpl__PerformInventoryPosting__c,
                dmpl__PerformGLPosting__c,
                dmpl__BranchId__c,
                (
                    SELECT
                        Id, 
                        Name,
                        dmpl__GoodsReceiptLineId__c,
                        dmpl__Quantity__c,
                        dmpl__PurchaseReturnId__c,
                        dmpl__BillLineId__c,
                        dmpl__PurchaseInvoiceId__c
                    FROM PurchaseReturnLine__r
                ) 
            FROM dmpl__PurchaseReturn__c
        ];  
    }

    public static dmpl__PurchaseReturnLine__c createPurchaseReturnLine(
        Account account,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__Bill__c bill,
        dmpl__BillLine__c billLine,
        dmpl__PurchaseReturn__c purchaseReturn,
        dmpl__GoodsReceiptLine__c grnLines
    ){
        return (dmpl__PurchaseReturnLine__c)TestFactory.createSObject(
            new dmpl__PurchaseReturnLine__c(
                dmpl__AccountId__c = account.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = 2,
                dmpl__UnitCost__c = 100,
                dmpl__SKUId__c = sku.Id,
                dmpl__BillLineId__c = billLine.Id,
                dmpl__GoodsReceiptLineId__c = grnLines.Id,
                dmpl__PurchaseInvoiceId__c = bill.Id,
                dmpl__PurchaseReturnId__c = purchaseReturn.Id
            ),
            'PurchaseReturnLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturnLine__c getPurchaseReturnLine(){
        return [
            SELECT
                Id,
                Name,
                dmpl__Quantity__c 
            FROM dmpl__PurchaseReturnLine__c 
            LIMIT 1
        ];  
    }
    
    public static dmpl__BillReturnTax__c createBillReturnTax(
        dmpl__BillReturn__c billReturn,
        dmpl__BillReturnLine__c billReturnLine,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__Bill__c bill,
        dmpl__BillLine__c billLine,
        dmpl__GoodsReceiptLine__c grnLines,
        dmpl__TaxGroup__c taxGroup,
        dmpl__Tax__c tax
    ){
        return (dmpl__BillReturnTax__c)TestFactory.createSObject(
            new dmpl__BillReturnTax__c(
                dmpl__BillReturnId__c =  billReturn.Id,
                dmpl__BillReturnLineId__c = billReturnLine.Id,
                dmpl__TaxId__c = tax.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__TaxOnAmount__c = true
            ),
            'BillReturnTaxDefaults',
            true
        );
    }

    public static dmpl__BillReturnTax__c createBillReturnTax(
        dmpl__BillReturn__c billReturn,
        dmpl__BillReturnLine__c billReturnLine,
        dmpl__TaxGroup__c taxGroup,
        dmpl__Tax__c tax,
        Integer taxRate,
        Decimal taxAmount
    ){
        return (dmpl__BillReturnTax__c)TestFactory.createSObject(
            new dmpl__BillReturnTax__c(
                dmpl__BillReturnId__c = billReturn != null ? billReturn.Id : null,
                dmpl__BillReturnLineId__c = billReturnLine != null ? billReturnLine.Id : null,
                dmpl__TaxId__c = tax != null ? tax.Id : null,
                dmpl__TaxGroupId__c = taxGroup != null ? taxGroup.Id : null,
                dmpl__TaxRate__c = taxRate,
                dmpl__TaxAmount__c = taxAmount,
                dmpl__TaxOnAmount__c = true
            ),
            'BillReturnTaxDefaults',
            true
        );
    }

    public static dmpl__BillReturnTax__c getBillReturnTax(){
        return [
            SELECT 
                Id,
                Name,
                dmpl__TaxOnAmount__c,
                dmpl__IsGLPosted__c,
                dmpl__IsGLPostingApproved__c,
                dmpl__TaxAmount__c,
                dmpl__TaxOnLineAmount__c,
                dmpl__TaxRate__c
            FROM dmpl__BillReturnTax__c 
            LIMIT 1
        ];  
    }

    public static dmpl__PurchaseInvoiceTax__c createBillTax(
        dmpl__Tax__c tax,
        dmpl__Bill__c bill
    ){
        return (dmpl__PurchaseInvoiceTax__c)TestFactory.createSObject(
            new dmpl__PurchaseInvoiceTax__c(
                dmpl__BillId__c = bill.Id,
                dmpl__TaxId__c = tax.Id
            ),
            'PurchaseInvoiceTaxDefaults',
            true
        );
    }

    public static dmpl__PurchaseInvoiceTax__c createBillTax(
        dmpl__TaxGroup__c taxGroup,
        dmpl__Tax__c tax,
        dmpl__Bill__c bill,
        dmpl__BillLine__c billLine,
        Integer taxRate,
        Decimal taxAmount,
        Decimal taxOnAmount
    ){
        return (dmpl__PurchaseInvoiceTax__c)TestFactory.createSObject(
            new dmpl__PurchaseInvoiceTax__c(
                dmpl__BillId__c = bill != null ? bill.Id : null,
                dmpl__BillLineId__c = billLine != null ? billLine.Id : null,
                dmpl__TaxOnAmount__c = taxOnAmount,
                dmpl__TaxId__c = tax != null ? tax.Id : null,
                dmpl__TaxRate__c = taxRate,
                dmpl__TaxAmount__c = taxAmount,
                dmpl__TaxGroupId__c = taxGroup != null ? taxGroup.Id : null
            ),
            'PurchaseInvoiceTaxDefaults',
            true
        );
    }

    public static dmpl__PurchaseInvoiceTax__c getBillTax(){
        return [
            SELECT 
                Id,
                dmpl__BillId__c,
                Name,
                dmpl__GLAmount__c,
                dmpl__IsGLPosted__c,
                dmpl__IsGLPostingApproved__c,
                dmpl__TaxAmount__c,
                dmpl__TaxRate__c,
                dmpl__TaxOnAmount__c
            FROM dmpl__PurchaseInvoiceTax__c 
            LIMIT 1
        ];  
    }
}