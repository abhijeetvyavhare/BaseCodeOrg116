@isTest
public class PurchaseOrderTestDataHelpers {

  public static dmpl__PurchaseOrder__c createPurchaseOrder(
    dmpl__Branch__c branch,
    Account supplierAccount
  ) {
    return (dmpl__PurchaseOrder__c) TestFactory.createSObject(
      new dmpl__PurchaseOrder__c(
        dmpl__BranchId__c = branch.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__PurchaseOrderType__c = 'Part PO',
        dmpl__DocumentDate__c = date.today(),
        dmpl__Remarks__c = 'Test-Remarks',
        dmpl__PerformReleaseInvoice__c = false,
        dmpl__IsInvoiceReleased__c = false
      ),
      'PurchaseOrderDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrder__c createPurchaseOrder(
    Id supplierAccountId,
    Id partnerAccountId,
    Id branchId
  ){
    return (dmpl__PurchaseOrder__c)TestFactory.createSObject(
      new dmpl__PurchaseOrder__c(
          dmpl__SupplierAccountId__c = supplierAccountId,
          dmpl__PartnerAccountId__c = partnerAccountId,
          dmpl__BranchId__c = branchId
      ),
      'PurchaseOrderDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderTax__c CreatePurchaseOrderTax(
    dmpl__PurchaseOrder__c purchaseOrder,
    dmpl__Tax__c tax,
    dmpl__PurchaseOrderLine__c purchaseOrderLine
  ) {
    return (dmpl__PurchaseOrderTax__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderTax__c(
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__TaxId__c = tax.Id,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id
      ),
      'PurchaseOrderTaxDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderTax__c CreatePurchaseOrderTax(
    dmpl__PurchaseOrder__c purchaseOrder,
    Id taxId,
    Id taxGroupId,
    dmpl__PurchaseOrderLine__c purchaseOrderLine
  ) {
    return (dmpl__PurchaseOrderTax__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderTax__c(
        dmpl__TaxName__c = 'CGST',
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__TaxId__c = taxId,
        dmpl__TaxGroupId__c = taxGroupId,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine != null ? purchaseOrderLine.Id : null,
        dmpl__TaxRate__c = 9
      ),
      'PurchaseOrderTaxDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderTax__c CreatePurchaseOrderTax(
    dmpl__PurchaseOrder__c purchaseOrder,
    Id taxId,
    Id taxGroupId,
    dmpl__PurchaseOrderLine__c purchaseOrderLine,
    Integer taxRate,
    String taxName,
    Decimal taxAmount,
    Decimal taxOnAmount
  ) {
    return (dmpl__PurchaseOrderTax__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderTax__c(
        dmpl__TaxName__c = taxName,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__TaxId__c = taxId,
        dmpl__TaxGroupId__c = taxGroupId,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine != null ? purchaseOrderLine.Id : null,
        dmpl__TaxRate__c = taxRate,
        dmpl__TaxAmount__c = taxAmount,
        dmpl__TaxOnAmount__c = taxOnAmount
      ),
      'PurchaseOrderTaxDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrder__c getPurchaseOrder() {
    return [
      SELECT
        Id,
        Name,
        dmpl__DocumentDate__c,
        dmpl__DiscountGroupId__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__TotalLineGrossAmount__c,
        dmpl__TotalOrderAmount__c,
        dmpl__OpenAmount__c,
        dmpl__TotalLineAmount__c,
        dmpl__TaxGroupId__c,
        dmpl__TCSEligibleAmount__c,
        dmpl__RepairOrderId__c,
        dmpl__Status__c,
        dmpl__PerformReleaseInvoice__c,
        dmpl__PerformReleaseReceipt__c,
        dmpl__PerformKPICalculation__c,
        dmpl__SupplierAccountId__c,
        dmpl__TransactionType__c
      FROM dmpl__PurchaseOrder__c
      LIMIT 1
    ];
  }
  
  public static dmpl__PurchaseOrder__c getPurchaseOrder(Id purchaseOrder) {
    return [
      SELECT
        Id,
        Name,
        dmpl__DocumentDate__c,
        dmpl__DiscountGroupId__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__TotalOrderAmount__c,
        dmpl__TotalLineGrossAmount__c,
        dmpl__TaxGroupId__c,
        dmpl__TCSEligibleAmount__c,
        dmpl__RepairOrderId__c,
        dmpl__Status__c,
        dmpl__PerformReleaseInvoice__c,
        dmpl__PerformReleaseReceipt__c,
        dmpl__PerformKPICalculation__c,
        dmpl__SupplierAccountId__c,
        dmpl__TransactionType__c,
        dmpl__ShippingStreet__c,
        dmpl__ShippingCity__c,
        dmpl__ShippingState__c,
        dmpl__ShippingAddress__c,
        dmpl__ShippingPostalCode__c,
        dmpl__BillingStreet__c,
        dmpl__BillingCity__c,
        dmpl__BillingState__c,
        dmpl__BillingCountry__c,
        dmpl__BillingAddress__c,
        dmpl__BillingPostalCode__c,
        dmpl__ShippingCountry__c,
        dmpl__TotalLineBaseAmount__c,
        dmpl__TotalLineAmount__c,
        dmpl__TotalSchemeDiscountAmount__c,
        dmpl__TotalDiscountAmount__c,
        dmpl__TotalLineTaxAmount__c,
        dmpl__OpenAmount__c,
        dmpl__TotalTaxAmount__c,
        dmpl__BillingAddressId__c
      FROM dmpl__PurchaseOrder__c
      WHERE ID = :purchaseOrder
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
    dmpl__Item__c listofitem,
    dmpl__SKU__c sku,
    dmpl__PurchaseOrder__c purchaseorder,
    dmpl__TaxGroup__c taxgroup,
    dmpl__PurchaseRequisition__c purchaseRequisition
  ) {
    return (dmpl__PurchaseOrderLine__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderLine__c(
        dmpl__ItemId__c = listofitem.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__Quantity__c = 1,
        dmpl__UnitCost__c = 100,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__SchemeDiscount__c = 2,
        dmpl__SchemeDiscountAmount__c = 4,
        dmpl__DiscountAmount__c = 100,
        dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id
      ),
      'PurchaseOrderLineDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
     Id purchaseorderId,
     Id itemId,
     Id taxGroupId,
     Integer quantity
  ) {
    return (dmpl__PurchaseOrderLine__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderLine__c(
        dmpl__PurchaseOrderId__c =purchaseorderId,
        dmpl__ItemId__c =itemId,
        dmpl__TaxGroupId__c =taxGroupId,
        dmpl__Quantity__c=quantity
        
      ),
      true
    );
  }

  public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
    dmpl__Item__c listofitem,
    dmpl__SKU__c sku,
    dmpl__PurchaseOrder__c purchaseorder,
    dmpl__TaxGroup__c taxgroup
  ) {
    return (dmpl__PurchaseOrderLine__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderLine__c(
        dmpl__ItemId__c = listofitem.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__Quantity__c = 1,
        dmpl__UnitCost__c = 100,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__SchemeDiscount__c = 2,
        dmpl__SchemeDiscountAmount__c = 4,
        dmpl__DiscountAmount__c = 100
      ),
      'PurchaseOrderLineDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
    dmpl__Item__c listofitem,
    dmpl__SKU__c sku,
    dmpl__PurchaseOrder__c purchaseorder,
    dmpl__TaxGroup__c taxgroup,
    Integer Quantity
  ) {
    return (dmpl__PurchaseOrderLine__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderLine__c(
        dmpl__ItemId__c = listofitem.Id,
        dmpl__SKUId__c = sku != null ? sku.Id : null,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__Quantity__c = Quantity,
        dmpl__UnitCost__c = 2000,
        dmpl__TaxGroupId__c = taxGroup != null ? taxGroup.Id : null,
        dmpl__SchemeDiscount__c = 0,
        dmpl__SchemeDiscountAmount__c = 0,
        dmpl__DiscountAmount__c = 0
      ),
      'PurchaseOrderLineDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrderLine__c getPurchaseOrderLine() {
    return [
      SELECT
        id,
        Name,
        dmpl__PurchaseOrderId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__TaxGroupId__c,
        dmpl__ItemComponentId__c,
        dmpl__Quantity__c,
        dmpl__Amount__c,
        dmpl__UnitCost__c,
        dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
        dmpl__PendingQuantity__c,
        dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
        dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c
      FROM dmpl__PurchaseOrderLine__c
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseOrderLine__c getPurchaseOrderLine(
    Id purchaseOrderLineId
  ) {
    return [
      SELECT
        Id,
        Name,
        dmpl__PurchaseOrderId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__TaxGroupId__c,
        dmpl__ItemComponentId__c,
        dmpl__Quantity__c,
        dmpl__Amount__c,
        dmpl__UnitCost__c,
        dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
        dmpl__PendingQuantity__c,
        dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
        dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
        dmpl__Tax1__c,
        dmpl__Tax1Name__c,
        dmpl__Tax1Rate__c,
        dmpl__Tax1Type__c,
        dmpl__Tax2__c,
        dmpl__Tax2Name__c,
        dmpl__Tax2Rate__c,
        dmpl__Tax2Type__c,
        dmpl__BaseAmount__c,
        dmpl__NetSchemeDiscount__c,
        dmpl__NetDiscount__c,
        dmpl__TaxAmount__c,
        dmpl__GrossAmount__c,
        dmpl__SchemeLineId__c
      FROM dmpl__PurchaseOrderLine__c
      WHERE Id = :purchaseOrderLineId
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseRequisition__c CreatePurchaseRequisition(
    dmpl__Branch__c branch,
    Account supplierAccount
  ) {
    return (dmpl__PurchaseRequisition__c) TestFactory.createSObject(
      new dmpl__PurchaseRequisition__c(
        dmpl__BranchId__c = branch.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__PerformReleaseOrder__c = false,
        dmpl__IsOrderReleased__c = true,
        dmpl__DocumentDate__c = Date.today(),
        dmpl__Remarks__c = 'sample'
      ),
      'PurchaseRequistionDefaults',
      true
    );
  }

  public static dmpl__PurchaseRequisition__c CreatePurchaseRequisition(
    Id partnerAccountId,
    Id branchId,
    Id supplierAccountId
  ){
    return (dmpl__PurchaseRequisition__c) TestFactory.createSObject(
      new dmpl__PurchaseRequisition__c(
          dmpl__PartnerAccountId__c = partnerAccountId,
          dmpl__BranchId__c = branchId,
          dmpl__SupplierAccountId__c = supplierAccountId
      ),
      'PurchaseRequistionDefaults',
      true
    );
  }

  public static dmpl__PurchaseRequisition__c getPurchaseRequisition() {
    return [
      SELECT
        Id,
        Name,
        dmpl__Status__c,
        dmpl__PerformReleaseOrder__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c
      FROM dmpl__PurchaseRequisition__c
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseRequisitionLine__c CreatePurchaseRequisitionLine(
    dmpl__PurchaseRequisition__c purchaseRequisition,
    dmpl__Item__c item,
    dmpl__SKU__c sku
  ) {
    return (dmpl__PurchaseRequisitionLine__c) TestFactory.createSObject(
      new dmpl__PurchaseRequisitionLine__c(
        dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__Quantity__c = 1
      ),
      true
    );
  }

  
public static dmpl__PurchaseRequisitionLine__c CreatePurchaseRequisitionLine(
    Id purchaseRequistionId,
    Id itemId,
    Decimal Quantity
  ){
    return (dmpl__PurchaseRequisitionLine__c) TestFactory.createSObject(
      new dmpl__PurchaseRequisitionLine__c(
        dmpl__PurchaseRequisitionId__c = purchaseRequistionId,
        dmpl__ItemId__c = itemId,
        dmpl__Quantity__c = Quantity

      ),
      true
    );
  }

  public static dmpl__PurchaseRequisitionLine__c getPurchaseRequisitionLine() {
    return [SELECT 
              Id, 
              Name 
              FROM 
              dmpl__PurchaseRequisitionLine__c 
              LIMIT 1
            ];
  }

    public static dmpl__PurchaseRequisitionLine__c getPurchaseRequisitionLine(Id id) {
    return [SELECT 
                Id, 
                Name, 
                dmpl__Quantity__c, 
                dmpl__UnitCost__c 
                FROM 
                dmpl__PurchaseRequisitionLine__c 
                WHERE 
                Id =: id
            ];
  }

  public static dmpl__PurchaseOrder__c CreatePurchaseOrderFromPurchaseRequisition(
    dmpl__PurchaseRequisition__c purchaseRequisition
  ) {
    return (dmpl__PurchaseOrder__c) TestFactory.createSObject(
      new dmpl__PurchaseOrder__c(
        dmpl__BranchId__c = purchaseRequisition.dmpl__BranchId__c,
        dmpl__PartnerAccountId__c = purchaseRequisition.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = purchaseRequisition.dmpl__SupplierAccountId__c
      ),
      'PurchaseOrderDefaults',
      true
    );
  }

  public static dmpl__PurchaseOrder__c getPurchaseOrderFromPurchaseRequisition() {
    return [SELECT 
              Id, 
              Name 
              FROM 
              dmpl__PurchaseOrder__c 
              LIMIT 1
            ];
  }

  public static dmpl__PurchaseOrderTax__c getPurchaseOrderTax() {
    return [
      SELECT Id, dmpl__TaxOnAmount__c, dmpl__TaxRate__c
      FROM dmpl__PurchaseOrderTax__c
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseOrderTax__c getPurchaseOrderTax(
    Id purchaseOrderTax
  ) {
    return [
      SELECT Id, dmpl__TaxOnAmount__c, dmpl__TaxRate__c
      FROM dmpl__PurchaseOrderTax__c
      WHERE Id = :purchaseOrderTax
      LIMIT 1
    ];
  }
  
  public static dmpl__PurchaseOrderRequisition__c createPurchaseOrderRequisition(
    Account partnerAccount,
    dmpl__PurchaseOrder__c purchaseOrder,
    dmpl__PurchaseOrderLine__c purchaseOrderLine,
    dmpl__PurchaseRequisition__c requisition,
    dmpl__PurchaseRequisitionLine__c requisitionLine,
    dmpl__Branch__c branch
  ) {
    return (dmpl__PurchaseOrderRequisition__c) TestFactory.createSObject(
      new dmpl__PurchaseOrderRequisition__c(
        dmpl__PartnerAccountId__c = partnerAccount.Id,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id,
        dmpl__PurchaseRequisitionId__c = requisition.Id,
        dmpl__PurchaseRequisitionLineId__c = requisitionLine.Id,
        dmpl__BranchId__c = branch.Id,
        dmpl__RequestedQuantity__c = 5,
        dmpl__OrderedQuantity__c = 4
      ),
      'PurchaseOrderRequisitionDefault',
      true
    );
  }

  public static dmpl__PurchaseOrderRequisition__c getPurchaseOrderRequisition(
    Id requisitionId
  ) {
    return [
      SELECT
        Id,
        Name,
        dmpl__RequestedQuantity__c,
        dmpl__OrderedQuantity__c,
        dmpl__PartnerAccountId__c,
        dmpl__PurchaseOrderId__c,
        dmpl__PurchaseOrderLineId__c,
        dmpl__PurchaseRequisitionId__c,
        dmpl__PurchaseRequisitionLineId__c,
        dmpl__BranchId__c
      FROM dmpl__PurchaseOrderRequisition__c
      WHERE Id = :requisitionId
      LIMIT 1
    ];
  }

  public static dmpl__PurchaseOrderRequisition__c getPurchaseOrderRequisition() {
    return [
      SELECT
        Id,
        Name,
        dmpl__RequestedQuantity__c,
        dmpl__OrderedQuantity__c,
        dmpl__PartnerAccountId__c,
        dmpl__PurchaseOrderId__c,
        dmpl__PurchaseOrderLineId__c,
        dmpl__PurchaseRequisitionId__c,
        dmpl__PurchaseRequisitionLineId__c,
        dmpl__BranchId__c
      FROM dmpl__PurchaseOrderRequisition__c
      LIMIT 1
    ];
  }

  public static List<dmpl__PurchaseOrderTax__c> getPurchaseOrderTaxPO(Id purchaseOrderLineId) {
        return [SELECT 
            Id,
            dmpl__TaxId__c,
            dmpl__TaxAmount__c,
            dmpl__TaxOnAmount__c,
            dmpl__TaxGroupId__c,
            dmpl__TaxRate__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderLineId__c
            FROM dmpl__PurchaseOrderTax__c 
            WHERE dmpl__PurchaseOrderLineId__c = :purchaseOrderLineId];
  }
}