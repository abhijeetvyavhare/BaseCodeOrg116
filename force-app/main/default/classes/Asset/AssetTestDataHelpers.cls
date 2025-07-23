@isTest
public with sharing class AssetTestDataHelpers {
    public static Asset CreateAsset(
        Account account,
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku
    ){
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = 'Test-Asset',
                AccountId = account.Id,
                dmpl__LastServiceBranchId__c = branch.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__IsPDIDone__c=true,
                dmpl__RegistrationNumber__c = 'Axb371',
                dmpl__SaleDate__c = date.today()
            ),
            'AssetDefaults',
            true
        );
    }

    public static Asset getAsset() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__IsPDIDone__c,
                dmpl__RegistrationNumber__c
            FROM Asset
            LIMIT 1
        ];
    }

    public static Asset getAsset(
        Id assetId
    ) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__IsPDIDone__c,
                dmpl__RegistrationNumber__c
            FROM Asset 
            WHERE Id = :assetId
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContract__c createAssetServiceContract(
        Asset asset,
        dmpl__Item__c item
    ){
        return (dmpl__AssetServiceContract__c)TestFactory.createSObject(
            new dmpl__AssetServiceContract__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ServiceContractItemId__c = item.Id,
                dmpl__ActivatedDate__c = Datetime.now().Date(),
                dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
                dmpl__DueDate__c = Datetime.now().addDays(365).Date()),
                true
        );
    }

    public static dmpl__AssetServiceContract__c getAssetServiceContract(){
        return [
            SELECT
                Id,
                name,
                dmpl__ActivatedDate__c,
                dmpl__ValidtillDate__c,
                dmpl__DueDate__c
            FROM dmpl__AssetServiceContract__c 
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContract__c getAssetServiceContract(id assetServiceContractId){
        return [
            SELECT
                Id,
                name,
                dmpl__ActivatedDate__c,
                dmpl__ValidtillDate__c,
                dmpl__DueDate__c
            FROM dmpl__AssetServiceContract__c 
            WHERE Id= :assetServiceContractId 
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContractLine__c createAssetServiceContractLine(
        dmpl__AssetServiceContract__c assetServiceContract,
        dmpl__Item__c item
    ){
        return (dmpl__AssetServiceContractLine__c)TestFactory.createSObject(
            new dmpl__AssetServiceContractLine__c(
                dmpl__AssetServiceContractId__c = assetServiceContract.Id,
                dmpl__ComponentItemId__c = item.Id,
                dmpl__Quantity__c = 10,
                dmpl__UtilizedQuantity__c = 5
                ),
            true
        );
    }

    public static dmpl__AssetServiceContractLine__c getAssetServiceContractLine(){
        return [
            SELECT
                Id,
                name,
                dmpl__ComponentItemId__c,
                dmpl__AssetServiceContractId__c,
                dmpl__Quantity__c,
                dmpl__UtilizedQuantity__c,
                dmpl__PendingQuantity__c
            FROM dmpl__AssetServiceContractLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContractLine__c getAssetServiceContractLine(
        id assetServiceContractLineId
    ){
        return [
            SELECT
                Id,
                name,
                dmpl__ComponentItemId__c,
                dmpl__AssetServiceContractId__c,
                dmpl__Quantity__c,
                dmpl__UtilizedQuantity__c,
                dmpl__PendingQuantity__c
            FROM dmpl__AssetServiceContractLine__c 
            WHERE Id= :assetServiceContractLineId 
            LIMIT 1
        ];
    }

    public static dmpl__AssetMaintenance__c createAssetMaintenance(
        Asset asset,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__RepairOrder__c repairOrder,
        dmpl__ServiceCampaign__c serviceCampaign,
        dmpl__ItemServiceContract__c itemServiceContract,
        dmpl__Item__c item
    ){
        return (dmpl__AssetMaintenance__c)TestFactory.createSObject(
            new dmpl__AssetMaintenance__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                dmpl__ServiceCampaignId__c = serviceCampaign.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__isExecuted__c = false,
                dmpl__isMandatory__c = false
            ),
            true
        );
    }

    public static dmpl__AssetMaintenance__c getAssetMaintenance(){
        return [
            SELECT
                Id,
                name,
                dmpl__AssetId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__RepairOrderId__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceCampaignId__c,
                dmpl__ItemId__c,
                dmpl__isExecuted__c,
                dmpl__isMandatory__c
            FROM dmpl__AssetMaintenance__c 
            LIMIT 1
        ];
    }

    public static dmpl__AssetMaintenance__c getAssetMaintenance(
        id assetMaintenanceId
    ){
        return [
            SELECT
                Id,
                name,
                dmpl__AssetId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__RepairOrderId__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceCampaignId__c,
                dmpl__ItemId__c,
                dmpl__isExecuted__c,
                dmpl__isMandatory__c
            FROM dmpl__AssetMaintenance__c 
            WHERE Id= :assetMaintenanceId 
            LIMIT 1
        ];
    }

    public static dmpl__AssetDiagnosticData__c createAssetDiagnosticData(
        Asset asset,
        dmpl__Item__c item
    ){
        return (dmpl__AssetDiagnosticData__c)TestFactory.createSObject(
            new dmpl__AssetDiagnosticData__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__StandardValue__c = 'StandardValue',
                dmpl__Remarks__c = 'Remark',
                dmpl__MinValue__c = 10.0,
                dmpl__MaxValue__c = 100.0
            ),
            true
        );
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticData(){
        return [
            SELECT
                Id,
                name,
                dmpl__ItemId__c,
                dmpl__AssetId__c,
                dmpl__StandardValue__c,
                dmpl__Remarks__c,
                dmpl__MinValue__c,
                dmpl__MaxValue__c,
                dmpl__ValueType__c
            FROM dmpl__AssetDiagnosticData__c 
            LIMIT 1
        ];
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticData(
        id assetDiagnosticDataId
    ){
        return [
            SELECT
                Id,
                name,
                dmpl__ItemId__c,
                dmpl__AssetId__c,
                dmpl__StandardValue__c,
                dmpl__Remarks__c,
                dmpl__MinValue__c,
                dmpl__MaxValue__c,
                dmpl__ValueType__c
            FROM dmpl__AssetDiagnosticData__c 
            WHERE Id= :assetDiagnosticDataId 
            LIMIT 1
        ];
    }

    public static dmpl__ShippingAssetLine__c createShippingAssetLine(
        Asset asset,
        dmpl__Item__c item,
        dmpl__ItemLot__c itemLot,
        dmpl__ItemLotType__c itemLotType,
        dmpl__SKU__c sku,
        dmpl__Branch__c branch,
        Account partnerAccount,
        dmpl__Shipment__c shipment,
        dmpl__ShipmentLine__c shipmentLine
    ){
        return (dmpl__ShippingAssetLine__c)TestFactory.createSObject(
            new dmpl__ShippingAssetLine__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__ItemLotTypeId__c = itemLotType.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__SellingBranchId__c = branch.Id,
                dmpl__SellingPartnerAccountId__c = partnerAccount.Id,
                dmpl__ShipmentId__c = shipment.Id,
                dmpl__ShipmentLineId__c = shipmentLine.Id
            ),
            true
        );
    }

    public static dmpl__ShippingAssetLine__c getShippingAssetLine(){
        return [
            SELECT
                Id,
                name,
                dmpl__AssetId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__SellingBranchId__c,
                dmpl__SellingPartnerAccountId__c,
                dmpl__ShipmentId__c,
                dmpl__ShipmentLineId__c,
                dmpl__Quantity__c,
                dmpl__LotNumber__c,
                dmpl__PlantName__c,
                dmpl__EngineNumber__c,
                dmpl__SerialNumber__c,
                dmpl__Status__c
            FROM dmpl__ShippingAssetLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__ShippingAssetLine__c getShippingAssetLine(
        id shippingAssetLineId
    ){
        return [
            SELECT
                Id,
                name,
                dmpl__AssetId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__SellingBranchId__c,
                dmpl__SellingPartnerAccountId__c,
                dmpl__ShipmentId__c,
                dmpl__ShipmentLineId__c,
                dmpl__DeliveryDate__c,
                dmpl__Quantity__c,
                dmpl__LotNumber__c,
                dmpl__ManufacturingMonth__c,
                dmpl__PlantName__c,
                dmpl__EngineNumber__c,
                dmpl__SerialNumber__c,
                dmpl__Status__c
            FROM dmpl__ShippingAssetLine__c 
            WHERE Id= :shippingAssetLineId 
            LIMIT 1
        ];
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ){
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 7,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__PopulateContractLines__c = true
            ),
            true
        );
    }

    public static dmpl__ItemServiceContract__c getItemServiceContract() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__GraceUsageDays__c,
                dmpl__ItemId__c,
                dmpl__GraceUsageReading__c,
                dmpl__GraceUsageHours__c,
                dmpl__MaximumUsageHours__c,
                dmpl__FromDays__c,
                (
                    SELECT 
                        Id,
                        Name,
                        dmpl__ComponentItemId__c,
                        dmpl__Quantity__c 
                    FROM 
                        dmpl__ItemServiceContractLines__r
                )
            FROM dmpl__ItemServiceContract__c
            LIMIT 1
        ];
    }

    public static Asset createAsset(
        String assetName,
        Account account,
        dmpl__Item__c item,
        Date saleDate
    ) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = assetName,
                AccountId = account != null ? account.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__SaleDate__c = saleDate
            ),
            true
        );
    }

    public static Asset getAssetBySerialNumber(
        String serialNumber
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                AccountId, 
                dmpl__ItemId__c, 
                dmpl__SaleDate__c, 
                SerialNumber, 
                dmpl__ComponentNumber__c
            FROM Asset
            WHERE SerialNumber = :serialNumber
            LIMIT 1
        ];
    }

    public static Asset getAssetByComponentNumber(
        String componentNumber
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                AccountId, 
                dmpl__ItemId__c, 
                dmpl__SaleDate__c, 
                SerialNumber, 
                dmpl__ComponentNumber__c
            FROM Asset
            WHERE dmpl__ComponentNumber__c = :componentNumber
            LIMIT 1
        ];
    }

    public static dmpl__AssetAccountHistory__c createAssetAccountHistory(
        Asset asset,
        Account account
    ) {
        return (dmpl__AssetAccountHistory__c) TestFactory.createSObject(
            new dmpl__AssetAccountHistory__c(
                dmpl__InstallbaseId__c = asset != null ? asset.Id : null,
                dmpl__AccountId__c = account != null ? account.Id : null
            ),
            'AssetAccountHistoryDefaults',
            true
        );
    }

    public static dmpl__AssetAccountHistory__c getAssetAccountHistoryByAsset(
        Id assetId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__InstallbaseId__c, 
                dmpl__AccountId__c,
                dmpl__AtUsageReading__c,
                dmpl__AtUsageHour__c,
                dmpl__OwnershipStartDate__c, 
                dmpl__OwnershipEnddate__c, 
                dmpl__ExternalId__c
            FROM dmpl__AssetAccountHistory__c
            WHERE dmpl__InstallbaseId__c = :assetId
            LIMIT 1
        ];
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticDataByAsset(
        Id assetId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__AssetId__c, 
                dmpl__ItemId__c, 
                dmpl__ValueType__c,
                dmpl__Condition__c, 
                dmpl__MinValue__c 
            FROM dmpl__AssetDiagnosticData__c
            WHERE dmpl__AssetId__c = :assetId
            LIMIT 1
        ];
    }

    public static dmpl__AssetMaintenance__c createAssetMaintenance(
        Asset asset,
        Account partnerAccount,
        Id branchId,
        dmpl__Item__c item,
        Decimal quantity
    ) {
        return (dmpl__AssetMaintenance__c) TestFactory.createSObject(
            new dmpl__AssetMaintenance__c(
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branchId,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Quantity__c = quantity
            ),
            true
        );
    }

    public static dmpl__AssetMaintenance__c getAssetMaintenanceByAsset(
        Id assetId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__AssetId__c, 
                dmpl__ItemId__c, 
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c, 
                dmpl__IsMandatory__c, 
                dmpl__Quantity__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__AssetId__c = :assetId
            LIMIT 1
        ];
    }

    public static List<dmpl__AssetMaintenance__c> getByServiceCampaign(
        Id campaignId
    ) {
        return [
            SELECT
                Id, 
                Name, 
                dmpl__ServiceCampaignId__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__ServiceCampaignId__c = :campaignId
        ];
    }

    public static List<dmpl__AssetMaintenance__c> getByCampaignMember(
        Id campaignMemberId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ServiceCampaignMemberId__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__ServiceCampaignMemberId__c = :campaignMemberId
        ];
    }

    public static dmpl__AssetServiceContract__c createAssetServiceContract(
        Account billingAccount,
        dmpl__Item__c item,
        Id serviceContractId
    ) {
        return (dmpl__AssetServiceContract__c) TestFactory.createSObject(
            new dmpl__AssetServiceContract__c(
                dmpl__BillingAccountId__c = billingAccount != null ? billingAccount.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ItemServiceContractId__c = serviceContractId
            ),
            true
        );
    }

    public static List<dmpl__AssetServiceContract__c> getAssetServiceContractByServiceContract(
        Id serviceContractId
    ) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ItemServiceContractId__c, 
                dmpl__ItemId__c, 
                dmpl__AssetId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ItemServiceContractId__c = :serviceContractId
        ];
    }

    public static List<dmpl__AssetServiceContract__c> getAssetServiceContractByItem(
        Id itemId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ItemId__c, 
                dmpl__AssetId__c,
                dmpl__ItemServiceContractId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ItemId__c = :itemId
        ];
    }

    public static dmpl__AssetServiceContract__c getByExternalId(
        String externalId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ExternalId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ExternalId__c = :externalId
            LIMIT 1
        ];
    }

    public static ServiceContract createServiceContract(
        Account account,
        String contractName,
        Date startDate,
        Date endDate,
        String status
    ) {
        return (ServiceContract) TestFactory.createSObject(
            new ServiceContract(
                Name = contractName,
                AccountId = account != null ? account.Id : null,
                StartDate = startDate != null ? startDate : Date.today(),
                EndDate = endDate != null ? endDate : Date.today().addMonths(6)
            ),
            true 
        );
    }

    public static ServiceContract getServiceContractByName(
        String name
    ) {
        return [
            SELECT
                Id, 
                Name, 
                AccountId, 
                StartDate, 
                EndDate, 
                Status
            FROM ServiceContract
            WHERE Name = :name
            LIMIT 1
            ALL ROWS
        ];
    }

    public static List<ServiceContract> getServiceContractsByAccount(
        Id accountId
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                Status, 
                StartDate, 
                EndDate
            FROM ServiceContract
            WHERE AccountId = :accountId
            ALL ROWS
        ];
    }

    public static dmpl__ProductHealthCheck__c createProductHealthCheck(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account customer,
        Asset asset,
        String externalId,
        String name 
    ) {
        return (dmpl__ProductHealthCheck__c) TestFactory.createSObject(
            new dmpl__ProductHealthCheck__c(
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__AccountId__c = customer != null ? customer.Id : null,
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__ExternalId__c = externalId
            ),
            true
        );
    }

    public static dmpl__AssetServiceContractLine__c createAssetServiceContractLine(
        dmpl__Item__c item,
        dmpl__AssetServiceContract__c assetServiceContract,
        dmpl__Item__c componentItem,
        Decimal quantity,
        Decimal utilizedQuantity
    ) {
        return (dmpl__AssetServiceContractLine__c) TestFactory.createSObject(
            new dmpl__AssetServiceContractLine__c(
                dmpl__AssetServiceContractId__c = assetServiceContract != null ? assetServiceContract.Id : null,
                dmpl__ComponentItemId__c = componentItem != null ? componentItem.Id : null,
                dmpl__Quantity__c = quantity != null ? quantity : 1,
                dmpl__UtilizedQuantity__c = utilizedQuantity != null ? utilizedQuantity : 0
            ),
            true
        );
    }

    public static Asset createAsset(
        String name, 
        Id accountId, 
        Id itemId
    ) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = name,
                AccountId = accountId,
                dmpl__ItemId__c = itemId,
                dmpl__SaleDate__c = Date.newInstance(2025, 1, 6)
            ),
            true
        );
    }

    public static Asset getAsset(
        String name
    ) {
        return [
            SELECT 
                Id, 
                Name, 
                AccountId, 
                dmpl__ItemId__c,
                dmpl__SaleDate__c
            FROM Asset
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__ServiceCampaign__c createServiceCampaign( 
        dmpl__Item__c item,
        dmpl__Branch__c branch, 
        Account partnerAccount
    ){
    return (dmpl__ServiceCampaign__c)TestFactory.createSObject(  
        new dmpl__ServiceCampaign__c(
                dmpl__ServiceContractItemId__c = item != null ? item.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null
            ),
            'ServiceCampaignDefaults',
            true
        ); 
    }

    public static dmpl__ServiceCampaignItem__c createServiceCampaignItem(
        dmpl__ServiceCampaign__c serviceCampaign, 
        dmpl__Item__c item, 
        dmpl__ItemServiceContract__c itemServiceContract
    ) {
        return (dmpl__ServiceCampaignItem__c)TestFactory.createSObject(  
            new dmpl__ServiceCampaignItem__c(
                dmpl__ServiceCampaignId__c = serviceCampaign.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemServiceContractId__c = itemServiceContract != null ? itemServiceContract.Id : null
            ),
            'ServiceCampaignItemDefaults',
            true
        ); 
    }

    public static dmpl__ServiceCampaignMember__c createServiceCampaignMember(
        dmpl__ServiceCampaign__c serviceCampaign, 
        dmpl__Item__c item, 
        dmpl__Branch__c branch, 
        Asset asset, 
        Account partnerAccount, 
        Account account
    ) {
        return (dmpl__ServiceCampaignMember__c) TestFactory.createSObject(  
            new dmpl__ServiceCampaignMember__c(
                dmpl__ServiceCampaignId__c = serviceCampaign != null ? serviceCampaign.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__AccountId__c = account != null ? account.Id : null
            ),
            true
        ); 
    }
}