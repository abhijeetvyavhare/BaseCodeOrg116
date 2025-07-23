public with sharing class PurchaseReturnDataHelper {
    public static dmpl__PurchaseReturn__c createPurchaseRetrun(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__PurchaseReturn__c) TestFactory.createSObject(
            new dmpl__PurchaseReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__Status__c = '1',
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

    public static dmpl__PurchaseReturn__c createPurchaseRetrun(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        Id purchaseReturnId,
        Boolean isReturned,
        Boolean isGlPostingApproved,
        Id GoodsReceiptNumberId
    ) {
        return (dmpl__PurchaseReturn__c) TestFactory.createSObject(
            new dmpl__PurchaseReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount != null ? supplierAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__Status__c = '1',
                dmpl__PurchaseOrderId__c = purchaseReturnId,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__PerformReturn__c = false,
                dmpl__IsReturned__c = isReturned,
                dmpl__PerformInventoryPosting__c=false,
                dmpl__DocumentDate__c = date.today(),
                dmpl__IsGLPostingApproved__c = isGlPostingApproved,
                dmpl__GoodsReceiptNumberId__c = GoodsReceiptNumberId
            ),
            'PurchaseReturnDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturn__c updatePurchaseRetrun(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__PurchaseReturn__c purchaseReturn
    ) {
        return (dmpl__PurchaseReturn__c) TestFactory.createSObject(
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
            false
        );
    }

    public static dmpl__PurchaseReturn__c getPurchaseRetrun() {
        return [Select
            Id,
            Name,
            dmpl__Description__c,
            dmpl__Remarks__c,
            dmpl__Status__c,
            dmpl__SupplierInvoiceAmount__c,
            dmpl__SupplierInvoiceNumber__c
            FROM dmpl__PurchaseReturn__c
            LIMIT 1
        ];
    } 

    public static dmpl__PurchaseReturn__c getPurchaseRetrun(Id purchaseReturn) {
        return [Select
            Id,
            Name,
            dmpl__Description__c,
            dmpl__Remarks__c,
            dmpl__Status__c,
            dmpl__SupplierInvoiceAmount__c,
            dmpl__SupplierInvoiceNumber__c
            FROM dmpl__PurchaseReturn__c
            WHERE Id = :purchaseReturn
            LIMIT 1
        ];
    } 
    
    public static dmpl__PurchaseReturnLine__c createPurchaseRetrunLine(
        dmpl__PurchaseReturn__c purchaseReturn,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__Bill__c bill
    ) {
        return (dmpl__PurchaseReturnLine__c)TestFactory.createSObject(
            new dmpl__PurchaseReturnLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = 2,
                dmpl__UnitCost__c = 100.0,
                dmpl__SKUId__c = sku.Id,
                dmpl__PurchaseInvoiceId__c = bill.Id,
                dmpl__PurchaseReturnId__c = purchaseReturn.Id,
                dmpl__ReturnType__c = 'Damaged'
               
            ),
            'PurchaseReturnLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturnLine__c createPurchaseRetrunLine(
        dmpl__PurchaseReturn__c purchaseReturn,
        Account account,
        dmpl__Bill__c bill,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        Integer quantity,
        Decimal unitCost,
        dmpl__TaxGroup__c taxGroup
    ) {
        return (dmpl__PurchaseReturnLine__c)TestFactory.createSObject(
            new dmpl__PurchaseReturnLine__c(
                dmpl__AccountId__c	= account == null ? null : account.Id,
                dmpl__PurchaseInvoiceId__c = bill == null ? null : bill.Id,
                dmpl__ItemId__c = item == null ? null : item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__DeliveryQuantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__SKUId__c = sku == null ? null : sku.Id,
                dmpl__PurchaseReturnId__c = purchaseReturn == null ? null : purchaseReturn.Id,
                dmpl__ReturnType__c = 'Damaged',
                dmpl__TaxGroupId__c	= taxGroup == null ? null : taxGroup.Id
            ),
            'PurchaseReturnLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturnLine__c createPurchaseRetrunLine(
        dmpl__PurchaseReturn__c purchaseReturn,
        Account account,
        dmpl__Bill__c bill,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        Integer quantity,
        Decimal unitCost,
        dmpl__TaxGroup__c taxGroup,
        String returnType
    ) {
        return (dmpl__PurchaseReturnLine__c)TestFactory.createSObject(
            new dmpl__PurchaseReturnLine__c(
                dmpl__AccountId__c	= account == null ? null : account.Id,
                dmpl__PurchaseInvoiceId__c = bill == null ? null : bill.Id,
                dmpl__ItemId__c = item == null ? null : item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__DeliveryQuantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__SKUId__c = sku == null ? null : sku.Id,
                dmpl__PurchaseReturnId__c = purchaseReturn == null ? null : purchaseReturn.Id,
                dmpl__ReturnType__c = returnType,
                dmpl__TaxGroupId__c	= taxGroup == null ? null : taxGroup.Id
            ),
            'PurchaseReturnLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseReturnLine__c getPurchaseRetrunLine() {
        return [
            Select
            Id,
            Name,
            dmpl__ReturnType__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c
            FROM dmpl__PurchaseReturnLine__c
            LIMIT 1
        ];
    }

    public static dmpl__PurchaseReturnLine__c getPurchaseRetrunLine(Id purchaseReturnLine) {
        return [
            Select
            Id,
            Name,
            dmpl__ReturnType__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c
            FROM dmpl__PurchaseReturnLine__c
            WHERE Id = :purchaseReturnLine
            LIMIT 1
        ];
    }

    public static dmpl__Bill__c createBill() {
        return (dmpl__Bill__c) TestFactory.createSObject(
            new dmpl__Bill__c(
                dmpl__PartnerAccountId__c = TestDataHelpers.getPartnerAccount().Id,
                dmpl__BranchId__c = TestDataHelpers.getBranch().Id
            ),
            'BillDefaults',
            true
        );
    }

    public static dmpl__Bill__c getBill() {
        return [Select
            Id,
            Name
            FROM dmpl__Bill__c
            LIMIT 1
        ];
    }
}