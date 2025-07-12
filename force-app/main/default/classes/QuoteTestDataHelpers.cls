@isTest
public class QuoteTestDataHelpers {
    public static dmpl__Quote__c CreateServiceEstimate(
        dmpl__Branch__c branch,
        Account account,
        dmpl__PriceList__c priceList,
        Asset asset,
        dmpl__ServiceRequest__c serviceRequest,
        dmpl__Resource__c serviceAdvisorId,
        Id saleOrderId,
        dmpl__Item__c item
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = account.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PriceListId__c = priceList != null ? priceList.Id : null,
                dmpl__PerformEstimateLinesGeneration__c = false,
                dmpl__ServiceRequestId__c = serviceRequest != null ? serviceRequest.Id : null,
                dmpl__ServiceContractItemId__c = item != null ? item.Id : null,
                dmpl__PerformApproval__c = false,
                dmpl__PerformDecline__c = false,
                dmpl__ServiceAdvisorId__c = serviceAdvisorId != null ? serviceAdvisorId.Id : null,
                dmpl__PerformRepairOrderGeneration__c = false,
                dmpl__IsRepairOrderGenerated__c = false,
                dmpl__SaleOrderId__c = saleOrderId != null ? saleOrderId : null
            ),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__Quote__c CreateServiceEstimate(
        Id partnerAccountId,
        dmpl__Branch__c branch,
        Account customerAccount,
        Asset asset
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = partnerAccountId != null ? partnerAccountId : null,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PerformEstimateLinesGeneration__c = false,
                dmpl__PerformApproval__c = false,
                dmpl__PerformDecline__c = false,
                dmpl__PerformRepairOrderGeneration__c = false,
                dmpl__IsRepairOrderGenerated__c = false
            ),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__Quote__c CreateServiceEstimateWithTaxSupplyType(
        Id partnerAccountId,
        dmpl__Branch__c branch,
        Account customerAccount,
        Asset asset,
        String taxSupplyType
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = partnerAccountId != null ? partnerAccountId : null,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PerformEstimateLinesGeneration__c = false,
                dmpl__PerformApproval__c = false,
                dmpl__PerformDecline__c = false,
                dmpl__PerformRepairOrderGeneration__c = false,
                dmpl__IsRepairOrderGenerated__c = false,
                dmpl__TaxSupplyType__c = taxSupplyType
            ),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__Quote__c CreateServiceEstimateWithDiscount(
        Id partnerAccountId,
        Id branchId,
        Id customerAccountId,
        Id assetId,
        Id resourceId,
        Id priceListId,
        Id discountGroupId,
        Date priceAsOnDate
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__AssetId__c = assetId,
                dmpl__ServiceAdvisorId__c = resourceId,
                dmpl__PriceListId__c = priceListId,
                dmpl__DiscountGroupId__c = discountGroupId,
                dmpl__PriceAsOnDate__c = priceAsOnDate
            ),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__Quote__c CreateServiceEstimate(
        dmpl__Branch__c branch,
        Account account,
        dmpl__PriceList__c priceList,
        Asset asset,
        dmpl__ServiceRequest__c serviceRequest,
        dmpl__Item__c item,
        dmpl__TaxGroup__c taxGroup
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = account.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PriceListId__c = priceList != null ? priceList.Id : null,
                dmpl__PerformEstimateLinesGeneration__c = false,
                dmpl__ServiceRequestId__c = serviceRequest != null ? serviceRequest.Id : null,
                dmpl__ServiceContractItemId__c = item.Id,
                dmpl__PerformApproval__c = false,
                dmpl__PerformDecline__c = false,
                dmpl__PerformRepairOrderGeneration__c = false,
                dmpl__IsRepairOrderGenerated__c = false,
                dmpl__TaxGroupId__c = taxGroup != null ? taxGroup.Id : null),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__Quote__c createServiceEstimate_creator(
        Map<string,Id> lookups,
        Map<string,string> picklists
    ){
        dmpl__Quote__c quote=(dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(),
            'QuoteDefaults',
            false
        );
        return (dmpl__Quote__c)creator(quote,lookups,picklists);

    }

    public static dmpl__Quote__c getServiceEstimate(){
        return [SELECT 
            Id,
            Name,
            dmpl__AccountId__c,
            dmpl__AccountName__c,
            dmpl__RepairOrderId__c,
            dmpl__TotalLineGrossAmount__c,
            dmpl__TaxGroupId__c,
            dmpl__TCSEligibleAmount__c,
            dmpl__PerformSaleOrderGeneration__c,
            dmpl__Discount__c,
            dmpl__DiscountGroupId__c,
            dmpl__DocumentDate__c,
            dmpl__SaleOrderId__c,
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c,
            dmpl__Remarks__c,
            dmpl__ServiceRequestId__c ,
            dmpl__ServiceContractItemId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__AssetId__c,
            dmpl__PerformUpdateRepairOrder__c,
            dmpl__PerformApproval__c,
            dmpl__PerformDecline__c,
            dmpl__PerformEstimateLinesGeneration__c,
            dmpl__ServiceRequestRepairOrderId__c,
            dmpl__ServiceAdvisorId__c,
            dmpl__PerformRepairOrderGeneration__c
            FROM dmpl__Quote__c LIMIT 1];
    }

    public static dmpl__QuoteLine__c CreateServiceEstimateLine(
        dmpl__Item__c item,
        dmpl__PriceListRules__c priceListRules,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ProductHealthCheckRecommendation__c prodHealthCheckRecom,
        dmpl__Quote__c serviceEstimate
    ){
        return (dmpl__QuoteLine__c)TestFactory.createSObject(
            new dmpl__QuoteLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = 50,
                dmpl__UnitPrice__c = 10,
                dmpl__TaxGroupId__c=taxGroup != null ? taxGroup.Id : null,
                dmpl__PriceListRuleId__c=priceListRules != null ? priceListRules.Id : null,
                dmpl__DurationInHours__c = 12.00,
                dmpl__IsApproved__c = false,
                dmpl__IsDeclined__c = false,
                dmpl__ServiceContractId__c = item.Id,
                dmpl__PackageClassification__c = 'Optional Item',
                dmpl__IncludeinPackage__c = True,
                dmpl__IsPackageService__c = false,
                dmpl__QuoteId__c = serviceEstimate.Id,
                dmpl__AlternateItemId__c = item.Id,
                dmpl__OriginalItemId__c = item.Id
            ),
            'QuoteLineDefaults',
            true
        );
    }

    public static dmpl__QuoteLine__c CreateServiceEstimateLine(
        Decimal quantity,
        decimal unitPrice,
        dmpl__Item__c item,
        dmpl__Quote__c serviceEstimate
    ){
        return (dmpl__QuoteLine__c)TestFactory.createSObject(
            new dmpl__QuoteLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__QuoteId__c = serviceEstimate.Id
            ),
            'QuoteLineDefaults',
            true
        );
    }

    public static dmpl__QuoteLine__c CreateServiceEstimateLineWithDiscount(
        Decimal quantity,
        decimal unitPrice,
        dmpl__Item__c item,
        dmpl__Quote__c serviceEstimate,
        Decimal discount
    ){
        return (dmpl__QuoteLine__c)TestFactory.createSObject(
            new dmpl__QuoteLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__QuoteId__c = serviceEstimate.Id,
                dmpl__Discount__c = discount
            ),
            'QuoteLineDefaults',
            true
        );
    }

    public static dmpl__QuoteLine__c CreateServiceEstimateLineWithTaxGroup(
        Decimal quantity,
        decimal unitPrice,
        dmpl__Item__c item,
        dmpl__Quote__c serviceEstimate,
        Id taxGroupId
    ){
        return (dmpl__QuoteLine__c)TestFactory.createSObject(
            new dmpl__QuoteLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__QuoteId__c = serviceEstimate.Id,
                dmpl__TaxGroupId__c = taxGroupId
            ),
            'QuoteLineDefaults',
            true
        );
    }

    public static dmpl__QuoteLine__c getServiceEstimateLine(){
        return [SELECT Id, 
        Name,
        dmpl__QuoteId__c,
        dmpl__Amount__c,
        dmpl__TaxGroupId__c,
        dmpl__UnitPrice__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__IncludeinPackage__c,
        dmpl__PriceListRuleId__c,
        dmpl__IsPackageService__c,
        dmpl__BaseAmount__c,
        dmpl__GrossAmount__c,
        dmpl__Tax1__c,
        dmpl__Tax1Name__c,
        dmpl__Tax1Rate__c,
        dmpl__Tax1Type__c,
        dmpl__Tax2__c,
        dmpl__Tax2Name__c,
        dmpl__Tax2Rate__c,
        dmpl__Tax2Type__c
        FROM QuoteLine__c LIMIT 1];
    }

    public static dmpl__QuoteLine__c getServiceEstimateLine(Id id){
        return [SELECT Id, 
        Name,
        dmpl__QuoteId__c,
        dmpl__Amount__c,
        dmpl__TaxGroupId__c,
        dmpl__UnitPrice__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__IncludeinPackage__c,
        dmpl__PriceListRuleId__c,
        dmpl__IsPackageService__c,
        dmpl__BaseAmount__c,
        dmpl__GrossAmount__c,
        dmpl__Tax1__c,
        dmpl__Tax1Name__c,
        dmpl__Tax1Rate__c,
        dmpl__Tax1Type__c,
        dmpl__Tax2__c,
        dmpl__Tax2Name__c,
        dmpl__Tax2Rate__c,
        dmpl__Tax2Type__c
        FROM QuoteLine__c 
        WHERE Id = :id
        LIMIT 1];
    }

    public static dmpl__QuoteTax__c CreateServiceEstimateTax(
        dmpl__Quote__c serviceEstimate,
        dmpl__QuoteLine__c serviceEstimateLine,
        dmpl__Tax__c tax,
        dmpl__TaxGroup__c taxGroup
    ){
        return (dmpl__QuoteTax__c)TestFactory.createSObject(
            new dmpl__QuoteTax__c(
                dmpl__QuoteId__c = serviceEstimate.Id,
                dmpl__QuoteLineId__c = serviceEstimateLine.Id,
                dmpl__TaxId__c = tax.Id,
                dmpl__TaxOnAmount__c = 100,
                dmpl__TaxAmount__c = 100,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__TaxRate__c = 10),
                'QuoteTaxDefaults',
                true
        );
    }

    public static dmpl__QuoteTax__c getServiceEstimateTax(){
        return [SELECT Id, Name,dmpl__TaxOnAmount__c,dmpl__TaxRate__c FROM dmpl__QuoteTax__c  LIMIT 1];
    }

    public static SObject creator(SObject sobj,Map<String,Id> lookups, Map<string,string> picklists){
        for(string field:lookups.keySet()){
            sobj.put(field,(Id)lookups.get(field));
        }
        for(string  field : picklists.keySet()) {
            sobj.put(field,picklists.get(field));
        }
        insert sobj;
        return sobj;
    }

    public static dmpl__Quote__c CreateServiceEstimate(
        dmpl__Branch__c branch,
        Account account,
        dmpl__PriceList__c priceList,
        Asset asset,
        dmpl__ServiceRequest__c serviceRequest,
        dmpl__Item__c item
    ){
        return (dmpl__Quote__c)TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = account.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PriceListId__c = priceList != null ? priceList.Id : null,
                dmpl__PerformEstimateLinesGeneration__c = false,
                dmpl__ServiceRequestId__c = serviceRequest != null ? serviceRequest.Id : null,
                dmpl__ServiceContractItemId__c = item.Id,
                dmpl__PerformApproval__c = false,
                dmpl__PerformDecline__c = false,
                dmpl__PerformRepairOrderGeneration__c = false,
                dmpl__IsRepairOrderGenerated__c = false),
            'QuoteDefaults',
            true
        );
    }
}