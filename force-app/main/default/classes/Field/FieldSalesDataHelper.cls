@isTest
public class FieldSalesDataHelper {
    public static dmpl__FieldSales__c createFieldSales(
        Account partnerAccount, 
        dmpl__Branch__c branch, 
        dmpl__Resource__c resource
    ) {
        return (dmpl__FieldSales__c) TestFactory.createSObject(
            new dmpl__FieldSales__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__ResourceId__c = resource.Id
            ),
            'FieldSalesDefault',
            true
        );
    }

    public static dmpl__FieldSales__c createFieldSales(
        Id partnerAccountId, 
        Id branchId, 
        Id resourceId, 
        Id storageLocationId, 
        Id visitPlanId
    ) {
        return (dmpl__FieldSales__c) TestFactory.createSObject(
            new dmpl__FieldSales__c(
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__ResourceId__c = resourceId,
                dmpl__StorageLocationId__c = storageLocationId,
                dmpl__VisitPlanId__c = visitPlanId
            ),
            'FieldSalesDefault',
            true
        );
    }

    public static dmpl__FieldSales__c createFieldSales(
        Id partnerAccountId, 
        Id branchId
    ) {
        return (dmpl__FieldSales__c) TestFactory.createSObject(
            new dmpl__FieldSales__c(
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            'FieldSalesDefault',
            true
        );
    }

    public static dmpl__FieldSalesLine__c createFieldSalesLine(
        dmpl__FieldSales__c fieldSales, 
        dmpl__Item__c item, 
        dmpl__SKU__c sku
    ) {
        return (dmpl__FieldSalesLine__c) TestFactory.createSObject(
            new dmpl__FieldSalesLine__c(
                dmpl__FieldSalesId__c = fieldSales.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id
            ),
            'FieldSalesLineDefaults',
            true
        );
    }

    public static dmpl__FieldSalesLine__c createFieldSalesLine(
        Id itemId, 
        Id skuId, 
        Integer quantity
    ) {
        return (dmpl__FieldSalesLine__c) TestFactory.createSObject(
            new dmpl__FieldSalesLine__c(
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId,
                dmpl__Quantity__c = quantity
            ),
            'FieldSalesLineDefaults',
            true
        );
    }

    public static dmpl__FieldSalesLine__c createFieldSalesLine(
        Id fieldSales,
        Id itemId, 
        Id skuId, 
        Integer quantity,
        Id ItemlotID
    ) {
        return (dmpl__FieldSalesLine__c) TestFactory.createSObject(
            new dmpl__FieldSalesLine__c(
                dmpl__FieldSalesId__c = fieldSales,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId,
                dmpl__ItemLotId__c = ItemlotID,
                dmpl__Quantity__c = quantity
            ),
            'FieldSalesLineDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c createFieldSalesInvoice(
        Id fieldSalesId, 
        Id accountId
    ) {
        return (dmpl__FieldSalesInvoice__c) TestFactory.createSObject(
            new dmpl__FieldSalesInvoice__c(
                dmpl__FieldSalesId__c = fieldSalesId,
                dmpl__AccountId__c = accountId
            ),
            'FieldSalesInvoiceDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c createFieldSalesInvoice(
        Id fieldSalesId, 
        Id accountId,
        Id invoiceId
    ) {
        return (dmpl__FieldSalesInvoice__c) TestFactory.createSObject(
            new dmpl__FieldSalesInvoice__c(
                dmpl__FieldSalesId__c = fieldSalesId,
                dmpl__AccountId__c = accountId,
                dmpl__InvoiceId__c = invoiceId
            ),
            'FieldSalesInvoiceDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c createFieldSalesInvoice(
    dmpl__FieldSales__c fieldSales, 
    Account account, 
    dmpl__SaleInvoice__c invoice
    ) {
        return (dmpl__FieldSalesInvoice__c) TestFactory.createSObject(
            new dmpl__FieldSalesInvoice__c(
                dmpl__FieldSalesId__c = fieldSales.Id,
                dmpl__AccountId__c = account.Id,
                dmpl__InvoiceId__c = invoice.Id
            ),
            'FieldSalesInvoiceDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c getFieldSalesInvoice() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FieldSalesId__c, 
                dmpl__AccountId__c, 
                dmpl__InvoiceId__c, 
                dmpl__CollectedAmount__c, 
                dmpl__InvoiceAmount__c
            FROM dmpl__FieldSalesInvoice__c 
            LIMIT 1
        ];
    }

    public static dmpl__FieldSalesInvoice__c getFieldSalesInvoice(
        Id fieldSalesInvoiceId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FieldSalesId__c, 
                dmpl__AccountId__c, 
                dmpl__InvoiceId__c,
                dmpl__CollectedAmount__c, 
                dmpl__InvoiceAmount__c 
            FROM dmpl__FieldSalesInvoice__c 
            WHERE Id = :fieldSalesInvoiceId 
            LIMIT 1
        ];
    }

    public static dmpl__FieldSales__c getFieldSales() {
        return [
            SELECT  
                Id, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__ResourceId__c,
                dmpl__StorageLocationId__c, 
                dmpl__VisitPlanId__c, 
                dmpl__Status__c, 
                dmpl__DocumentDate__c
            FROM dmpl__FieldSales__c 
            LIMIT 1
        ];
    }

    public static dmpl__FieldSales__c getFieldSales(
        Id fieldSalesId
    ) {
        return [
            SELECT 
                Id, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__ResourceId__c,
                dmpl__StorageLocationId__c, 
                dmpl__VisitPlanId__c, 
                dmpl__Status__c, 
                dmpl__DocumentDate__c
            FROM dmpl__FieldSales__c 
            WHERE Id = :fieldSalesId 
            LIMIT 1
        ];
    }

    public static dmpl__FieldSalesLine__c getFieldSalesLine() {
        return [
            SELECT 
                Id, 
                dmpl__FieldSalesId__c, 
                dmpl__ItemId__c, 
                dmpl__SKUId__c, 
                dmpl__Quantity__c,
                dmpl__ReceivedQuantity__c, 
                dmpl__SoldQuantity__c, 
                dmpl__DamagedQuantity__c
            FROM dmpl__FieldSalesLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__FieldSalesLine__c getFieldSalesLine(
        Id fieldSalesId
    ) {
        return [
            SELECT 
                Id, 
                dmpl__FieldSalesId__c, 
                dmpl__ItemId__c, 
                dmpl__SKUId__c, 
                dmpl__Quantity__c,
                dmpl__ReceivedQuantity__c, 
                dmpl__SoldQuantity__c, 
                dmpl__DamagedQuantity__c
            FROM dmpl__FieldSalesLine__c 
            WHERE dmpl__FieldSalesId__c = :fieldSalesId 
            LIMIT 1
        ];
    }
}