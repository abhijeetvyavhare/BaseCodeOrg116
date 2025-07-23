public with sharing class ClaimBatchDataHelper {
    public static dmpl__ClaimBatch__c createClaimBatch(
        Account partnerAccount,
        Id branchId
    ) {
        return (dmpl__ClaimBatch__c) TestFactory.createSObject(
            new dmpl__ClaimBatch__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branchId,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Remarks__c = 'Default Remarks'
            ),
            'ClaimBatchDefaults',
            true
        );
    }

    public static dmpl__ClaimBatch__c createClaimBatch(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account supplier
    ) {
        return (dmpl__ClaimBatch__c) TestFactory.createSObject(
            new dmpl__ClaimBatch__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__SupplierNameId__c = supplier.Id
            ),
            'ClaimBatchDefaults',
            true
        );
    }

    public static dmpl__Claim__c createClaim() {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(),
            'ClaimDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c createClaimLine(
        dmpl__Claim__c claim,
        dmpl__ClaimBatch__c claimBatch,
        dmpl__ClaimBatchLine__c claimBatchLine
    ){
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claim.Id,
                dmpl__ClaimBatchId__c = claimBatch.Id,
                dmpl__ClaimBatchLineId__c = claimBatchLine.Id
            ),
            'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimBatchLine__c createClaimBatchLine(
        dmpl__ClaimBatch__c claimBatch,
        Id claimId
    ) {
        return (dmpl__ClaimBatchLine__c) TestFactory.createSObject(
            new dmpl__ClaimBatchLine__c(
                dmpl__ClaimBatchId__c = claimBatch.Id,
                dmpl__ClaimId__c = claimId
            ),
            'ClaimBatchLineDefaults',
            true
        );
    }

    public static Product2 createServiceContract(
        String name
    ){
        return (Product2) TestFactory.createSObject(
            new Product2(
                Name = name,
                IsActive = true
            ),
            true
        );
    }

    public static Product2 getServiceContract(){
        return [
            SELECT
                Id,
                Name,
                IsActive
            FROM Product2
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLine() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ClaimBatchId__c, 
                dmpl__ClaimId__c
            FROM dmpl__ClaimBatchLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLine(
        Id batchLineId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ClaimBatchId__c, 
                dmpl__ClaimId__c
            FROM dmpl__ClaimBatchLine__c
            WHERE Id = :batchLineId
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatch__c getClaimBatch() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__BranchId__c,
            	dmpl__TotalApprovedAmount__c,
            	dmpl__TotalApprovedQuantity__c,
                dmpl__Remarks__c,
                dmpl__SupplierNameId__c
            FROM dmpl__ClaimBatch__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatch__c getClaimBatch(
        Id batchId
    ) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ServiceContractId__c, 
                dmpl__ExternalId__c, 
            	dmpl__TotalApprovedAmount__c,
            	dmpl__TotalApprovedQuantity__c,
                dmpl__Status__c, 
                dmpl__Remarks__c
            FROM dmpl__ClaimBatch__c
            WHERE Id = :batchId
            LIMIT 1
        ];
    }

    public static dmpl__Claim__c getClaim(){
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ExternalId__c, 
                dmpl__Status__c, 
                dmpl__DocumentDate__c, 
                dmpl__ClaimType__c, 
                dmpl__InvoiceGroup__c, 
                dmpl__Remarks__c, 
                dmpl__ApproveAll__c,
                dmpl__RejectAll__c, 
                dmpl__AsOnDate__c, 
                dmpl__ServiceInvoiceAsOnDate__c,
                dmpl__WorkOrderAsonDate__c
            FROM dmpl__Claim__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c getClaimLine() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ExternalId__c, 
                dmpl__Status__c, 
                dmpl__ClaimType__c,
                dmpl__ItemCode__c, 
                dmpl__UnitPrice2__c, 
                dmpl__UnitPrice__c,
                dmpl__ApproveAmount__c, 
                dmpl__ApproveBaseAmount__c,
                dmpl__ApproveDiscount__c,
                dmpl__ApproveDiscountAmount__c, 
                dmpl__ApproveNetDiscount__c, 
                dmpl__ApproveQuantity__c,
                dmpl__BaseAmount__c, 
                dmpl__ClaimAmount__c, 
                dmpl__ClaimQuantity__c,
                dmpl__RepairOrderLineId__c,
                dmpl__Discount__c, 
                dmpl__DiscountAmount__c, 
                dmpl__NetDiscount__c,
            	dmpl__ClaimId__c,
            	dmpl__ItemId__c,
            	dmpl__ClaimBatchId__c,
            	dmpl__ClaimBatchLineId__c
            FROM dmpl__ClaimLine__c
            LIMIT 1
        ];
    }
    public static dmpl__ClaimLine__c getClaimLine(Id claimLineId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ExternalId__c, 
                dmpl__Status__c, 
                dmpl__ClaimType__c,
                dmpl__ItemCode__c, 
                dmpl__UnitPrice2__c, 
                dmpl__UnitPrice__c,
                dmpl__ApproveAmount__c, 
                dmpl__ApproveBaseAmount__c,
                dmpl__ApproveDiscount__c,
                dmpl__ApproveDiscountAmount__c, 
                dmpl__ApproveNetDiscount__c, 
                dmpl__ApproveQuantity__c,
                dmpl__BaseAmount__c, 
                dmpl__ClaimAmount__c, 
                dmpl__ClaimQuantity__c,
                dmpl__RepairOrderLineId__c,
                dmpl__Discount__c, 
                dmpl__DiscountAmount__c, 
                dmpl__NetDiscount__c,
            	dmpl__ClaimId__c,
            	dmpl__ItemId__c,
            	dmpl__ClaimBatchId__c,
            	dmpl__ClaimBatchLineId__c
            FROM dmpl__ClaimLine__c
            WHERE Id = :claimLineId
            LIMIT 1
        ];
    }
}