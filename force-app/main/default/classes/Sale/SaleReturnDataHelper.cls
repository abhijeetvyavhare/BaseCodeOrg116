@isTest
public class SaleReturnDataHelper {
    public static dmpl__SaleReturn__c createSaleReturn(
        Account customerAccount, 
        dmpl__Branch__c branch, 
        dmpl__ContactAddress__c contactAddress, 
        dmpl__PriceList__c priceList
    ) {
        return (dmpl__SaleReturn__c) TestFactory.createSObject(
            new dmpl__SaleReturn__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PriceListId__c = priceList.Id,
                dmpl__Status__c = 'Draft',
                dmpl__DocumentDate__c = Date.today(),
                dmpl__IsInJobQueue__c = false,
                dmpl__IsReturned__c = false,
                dmpl__PerformInventoryPosting__c = false,
                dmpl__PerformReturn__c = false,
                dmpl__TransactionType__c = 'Sample'
            ),
            'SaleReturnDeafults',
            true
        );
    }
    public static dmpl__SaleReturn__c createSaleReturn(
        Account customerAccount, 
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__SaleReturn__c) TestFactory.createSObject(
            new dmpl__SaleReturn__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch?.Id,
                dmpl__PartnerAccountId__c = partnerAccount?.Id
            ),
            'SaleReturnDeafults',
            true
        );
    }

    public static dmpl__SaleReturn__c createSaleReturn(
        Id partnerAccountId, 
        Id customerAccountId, 
        Id branchId,
        Id saleInvoiceId, 
        Date DocumentDate,
        Boolean isInJobQueue,
        Boolean isReturned, Boolean performInventoryPosting,
        Boolean performReturn
    ) {
        return (dmpl__SaleReturn__c) TestFactory.createSObject(
            new dmpl__SaleReturn__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SaleInvoiceId__c = saleInvoiceId,
                dmpl__DocumentDate__c = DocumentDate,
                dmpl__IsInJobQueue__c = isInJobQueue,
                dmpl__IsReturned__c = isReturned,
                dmpl__PerformInventoryPosting__c = performInventoryPosting,
                dmpl__PerformReturn__c = performReturn
            ),
            'SaleReturnDeafults',
            true
        );
    }

    public static dmpl__SaleReturnLine__c createSaleReturnLine(
        dmpl__SaleReturn__c saleReturn, 
        dmpl__Item__c item, 
        dmpl__SKU__c sku, 
        dmpl__TaxGroup__c taxGroup
    ) {
        return (dmpl__SaleReturnLine__c) TestFactory.createSObject(
            new dmpl__SaleReturnLine__c(
                dmpl__SaleReturnId__c = saleReturn.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Quantity__c = 1,
                dmpl__UnitPrice__c = 100,
                dmpl__ApplyPostTaxDiscount__c = true,
                dmpl__Discount2__c = 10,
                dmpl__DiscountAmount2__c = 100,
                dmpl__ContractDiscount__c = 10,
                dmpl__ContractDiscountAmount__c = 100
            ),
            'SaleReturnLineDefault',
            true
        );
    }
    public static dmpl__SaleReturnLine__c createSaleReturnLine(
        dmpl__SaleReturn__c saleReturn, 
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__SaleInvoiceLine__c saleInvoiceLine
    ) {
        return (dmpl__SaleReturnLine__c) TestFactory.createSObject(
            new dmpl__SaleReturnLine__c(
                dmpl__SaleReturnId__c = saleReturn.Id,
                dmpl__SaleInvoiceId__c = saleInvoice?.Id,
                dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id
            ),
            true
        );
    }

    public static dmpl__SaleReturnLine__c createSaleReturnLine(
        Id saleReturnId,
        Id saleInvoice,
        Id saleInvoiceLine,
        Id itemId,
        Id SKUId,
        Id itemLotId,
        Id taxGroupId,
        Decimal quantity,
        Decimal unitPrice,
        Boolean applyPostTaxDiscount,
        Boolean isApproved,
        Boolean isILPosted,
        Boolean isILPostingApproved,
        Boolean isSchemeGenerated
    ) {
        return (dmpl__SaleReturnLine__c) TestFactory.createSObject(
            new dmpl__SaleReturnLine__c(
                dmpl__SaleReturnId__c = saleReturnId,
                dmpl__SaleInvoiceId__c = saleInvoice,
                dmpl__SaleInvoiceLineId__c = saleInvoiceLine,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = SKUId,
                dmpl__ItemLotId__c = itemLotId,
                dmpl__TaxGroupId__c = taxGroupId,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__ApplyPostTaxDiscount__c = applyPostTaxDiscount,
                dmpl__IsApproved__c = isApproved,
                dmpl__IsILPosted__c = isILPosted,
                dmpl__IsILPostingApproved__c = isILPostingApproved,
                dmpl__IsSchemeGenerated__c = isSchemeGenerated
            ),
            'SaleReturnLineDefault',
            true
        );
    }

    public static dmpl__SaleReturnTax__c createSaleReturnTax(dmpl__SaleReturn__c saleReturn, dmpl__SaleReturnLine__c returnLine) {
        return (dmpl__SaleReturnTax__c) TestFactory.createSObject(
            new dmpl__SaleReturnTax__c(
                dmpl__SaleReturnId__c = saleReturn.Id,
                dmpl__SaleReturnLineId__c = returnLine.Id,
                dmpl__TaxAmount__c = 150,
                dmpl__IsGLPosted__c = false,
                dmpl__IsGLPostingApproved__c = false,
                dmpl__TaxOnAmount__c = 1000,
                dmpl__TaxRate__c = 15),
            'SaleReturnTaxDefault',
            true
        );
    }

    public static dmpl__SaleReturnTax__c createSaleReturnTax(
            Id saleReturnId,
            Id saleReturnLineId,
            Id GLAccountId,
            Id TaxGroupId,
            Boolean isGLPosted,
            Boolean isGLPostingApproved
        ) {
        return (dmpl__SaleReturnTax__c) TestFactory.createSObject(
            new dmpl__SaleReturnTax__c(
                dmpl__SaleReturnId__c = saleReturnId,
                dmpl__SaleReturnLineId__c = saleReturnLineId,
                dmpl__GLAccountId__c = GLAccountId,
                dmpl__TaxGroupId__c = TaxGroupId,
                dmpl__IsGLPosted__c = isGLPosted,
                dmpl__IsGLPostingApproved__c = isGLPostingApproved
            ),
            'SaleReturnTaxDefault',
            true
        );
    }

    public static dmpl__SaleReturnTax__c getSaleReturnTax() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__TaxAmount__c, 
                dmpl__SaleReturnId__c, 
                dmpl__SaleReturnLineId__c,
                dmpl__DocumentDate__c,
                dmpl__ExternalId__c, 
                dmpl__GeneralLedgerId__c,
                dmpl__GLAccountId__c, 
                dmpl__IsGLPosted__c, 
                dmpl__IsGLPostingApproved__c,
                dmpl__TaxGroupId__c, 
                dmpl__TaxId__c, 
                dmpl__TaxOnAmount__c, 
                dmpl__TaxRate__c
            FROM dmpl__SaleReturnTax__c 
            LIMIT 1
        ];
    }

    public static dmpl__SaleReturnTax__c getSaleReturnTax(Id taxId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__TaxAmount__c, 
                dmpl__SaleReturnId__c,
                dmpl__SaleReturnLineId__c,
                dmpl__DocumentDate__c,
                dmpl__ExternalId__c, 
                dmpl__GeneralLedgerId__c,
                dmpl__GLAccountId__c, 
                dmpl__IsGLPosted__c, 
                dmpl__IsGLPostingApproved__c,
                dmpl__TaxGroupId__c, 
                dmpl__TaxId__c, 
                dmpl__TaxOnAmount__c, 
                dmpl__TaxRate__c
            FROM dmpl__SaleReturnTax__c 
            WHERE Id = :taxId
            LIMIT 1
        ];
    }

    public static dmpl__SaleReturn__c getSaleReturn() {
        return [
            SELECT 
                Id,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__DocumentDate__c,
                dmpl__IsInJobQueue__c,
                dmpl__IsReturned__c,
                dmpl__PerformInventoryPosting__c,
                dmpl__PerformReturn__c,
                dmpl__PriceListId__c,
                dmpl__TransactionType__c,
                dmpl__Remarks__c,
                dmpl__Status__c
            FROM dmpl__SaleReturn__c
            LIMIT 1
        ];
    }

    public static dmpl__SaleReturn__c getSaleReturn(Id id) {
        return [
            SELECT 
                Id,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__DocumentDate__c,
                dmpl__IsInJobQueue__c,
                dmpl__IsReturned__c,
                dmpl__PerformInventoryPosting__c,
                dmpl__PerformReturn__c,
                dmpl__PriceListId__c,
                dmpl__TransactionType__c,
                dmpl__Remarks__c,
                dmpl__Status__c
            FROM dmpl__SaleReturn__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

    public static dmpl__SaleReturnLine__c getSaleReturnLine() {
        return [
            SELECT 
                Id,
                dmpl__SaleReturnId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotId__c,
                dmpl__TaxGroupId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__ContractDiscount__c,
                dmpl__Discount2__c,
                dmpl__ApplyPostTaxDiscount__c,
                dmpl__IsApproved__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__IsSchemeGenerated__c
            FROM dmpl__SaleReturnLine__c
            LIMIT 1
        ];
    }

    public static dmpl__SaleReturnLine__c getSaleReturnLine(Id saleReturnLineId) {
        return [
            SELECT Id,
                dmpl__SaleReturnId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotId__c,
                dmpl__TaxGroupId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__ContractDiscount__c,
                dmpl__Discount2__c,
                dmpl__ApplyPostTaxDiscount__c,
                dmpl__IsApproved__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__IsSchemeGenerated__c
            FROM dmpl__SaleReturnLine__c
            WHERE Id = :saleReturnLineId
            LIMIT 1
        ];
    }
    
    public static dmpl__SaleReturnLine__c getReturnLine(Id saleReturnId) {
        return [
            SELECT Id,
                dmpl__SaleReturnId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotId__c,
                dmpl__TaxGroupId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__ContractDiscount__c,
                dmpl__Discount2__c,
                dmpl__ApplyPostTaxDiscount__c,
                dmpl__IsApproved__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__IsSchemeGenerated__c
            FROM dmpl__SaleReturnLine__c
            WHERE dmpl__SaleReturnId__c = :saleReturnId
            LIMIT 1
        ];
    }

    public static dmpl__ItemLot__c createItemLot(
        Id branchId,
        Id partnerAccountId,
        Id itemId,
        Id skuId,
        Decimal cost
    ) {
        return (dmpl__ItemLot__c) TestFactory.createSObject(
            new dmpl__ItemLot__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId,
                dmpl__UnitCost__c = cost
            ),
            'ItemLotDefaults',
            true
        );
    }
}