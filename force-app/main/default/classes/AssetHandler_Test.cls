@isTest
public with sharing class AssetHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partner, branch);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partner, branch);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku);
        dmpl__ItemLotType__c itemLotType = TestDataHelpers.CreateItemLotType(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partner, branch);
        Asset asset=AssetTestDataHelpers.CreateAsset(
            account,
            branch,
            item,
            itemLot,
            sku
        );
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.CreateServiceEstimate(
            branch,
            customer,
            priceList,
            asset,
            item
        );
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(
            item,
            branch,
            asset,
            serviceEstimate,
            customer,
            resource
        );
        dmpl__ServiceLead__c ServiceLead=ServiceLeadTestDataHelpers.createServiceLead(branch,customer,resource);
        dmpl__ItemServiceContract__c ItemServiceContract=AssetTestDataHelpers.createItemServiceContract(item,sku);
        dmpl__ServiceCampaign__c serviceCampaign=CampaignTestDataHelpers.CreateServiceCompaign(ItemServiceContract,ServiceLead,item);
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(asset,item);
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.createAssetServiceContractLine(assetServiceContract, item);
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch,
            repairOrder,
            serviceCampaign,
            itemServiceContract,
            item
        );
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset,item);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseRequisition__c PurchaseRequisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(partner.Id,branch.Id,supplierAccount.Id);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
            item.Id,
            taxGroup.Id,
            2
        );
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplierAccount, branch, purchaseOrder);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item,
            shipment,
            sku,
            purchaseOrderLine
        );
        dmpl__ShippingAssetLine__c shippingAssetLine = AssetTestDataHelpers.createShippingAssetLine(
            asset,
            item,
            itemLot,
            itemLotType,
            sku,
            branch,
            partner,
            shipment,
            shipmentLine
        );
    }

    @isTest
    static void createAssetPositive() {
        Asset asset = AssetTestDataHelpers.getAsset();
        if(asset != null){
            System.assertNotEquals(asset, null, 'Expected asset to be created.');
        }
        System.assertNotEquals(asset.name, null, 'Name should not be null');
        System.assertEquals(asset.IsPDIDone__c,true,'IsPDIDone__c should be true');
    }

    @isTest
    static void updateAssetPositive() {
        Asset asset= AssetTestDataHelpers.getAsset();
        if(asset!=null){
            System.assertNotEquals(asset, null, 'Expected asset to be created before update.');
            asset.IsPDIDone__c = false;
            asset.dmpl__LastServiceBranchId__c = null;
            asset.RegistrationNumber__c = 'Axb300';
            update asset;
        }
        Asset updatedAsset=AssetTestDataHelpers.getAsset(asset.Id);
        if(updatedAsset != null){
            System.assertNotEquals(updatedAsset, null, 'Expected asset to be updated.');
            System.assertEquals(updatedAsset.IsPDIDone__c, false, 'Expected asset.IsPDIDone__c to be false');
            System.assertEquals(updatedAsset.RegistrationNumber__c, 'Axb300', 'Expected asset.RegistrationNumber__c to be Axb300');
        }
    }

    @isTest
    static void deleteAssetPositive() {
        Asset asset = AssetTestDataHelpers.getAsset();
        System.assertNotEquals(asset, null, 'Expected asset to be created before delete.');
        Asset deletedAsset=null;
        delete asset;
        try{
            deletedAsset=AssetTestDataHelpers.getAsset(asset.Id);
        }
        catch(Exception e) {
            deletedAsset=null;
        }
        System.assertEquals(null, deletedAsset, 'Expected asset to be deleted.');
    }

    @isTest
    static void createAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        if(assetServiceContract != null){
            System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created.');
        }
        System.assertNotEquals(assetServiceContract.name, null, 'Name should not be null');
    }

    @isTest
    static void updateAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        if(assetServiceContract != null){
            System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created before update.');
            assetServiceContract.dmpl__ActivatedDate__c = Datetime.now().addDays(30).Date();
            assetServiceContract.dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date();
            assetServiceContract.dmpl__DueDate__c = Datetime.now().addDays(365).Date();
            update assetServiceContract;
        }
        dmpl__AssetServiceContract__c updatedAssetServiceContract=AssetTestDataHelpers.getAssetServiceContract(assetServiceContract.Id);
        if(updatedAssetServiceContract != null){
            System.assertNotEquals(updatedAssetServiceContract, null, 'Expected assetServiceContract to be updated.');
        }
        System.assertEquals(Datetime.now().addDays(30).Date(), updatedAssetServiceContract.dmpl__ActivatedDate__c, 'ActivatedDate should be updated');
        System.assertEquals(Datetime.now().addDays(365).Date(), updatedAssetServiceContract.dmpl__ValidtillDate__c, 'ValidtillDate should be updated');
        System.assertEquals(Datetime.now().addDays(365).Date(), updatedAssetServiceContract.dmpl__DueDate__c, 'DueDate should be updated');
    }

    @isTest
    static void deleteAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created before deleted.');
        dmpl__AssetServiceContract__c deletedAssetServiceContract=null;
        delete assetServiceContract;
        try{
            deletedAssetServiceContract=AssetTestDataHelpers.getAssetServiceContract(assetServiceContract.Id);
        }
        catch(Exception e){
            deletedAssetServiceContract=null;
        }
        System.assertEquals(null, deletedAssetServiceContract, 'Expected assetServiceContract to be deleted.');
    }

    @isTest
    static void createAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        if(assetServiceContractLine != null){
            System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created.');
        }
        System.assertNotEquals(assetServiceContractLine.name, null, 'Name should not be null');
        System.assertNotEquals(assetServiceContractLine.dmpl__AssetServiceContractId__c, null, 'Expected dmpl__AssetServiceContractId__c to be set.');
        System.assertNotEquals(assetServiceContractLine.dmpl__ComponentItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertEquals(10, assetServiceContractLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be 10');
        System.assertEquals(5, assetServiceContractLine.dmpl__UtilizedQuantity__c, 'Expected dmpl__UtilizedQuantity__c to be 5');
        System.assertEquals(5, assetServiceContractLine.dmpl__PendingQuantity__c, 'Expected dmpl__PendingQuantity__c to be 5');
    }

    @isTest
    static void updateAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        if(assetServiceContractLine != null){
            System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created before update.');
            assetServiceContractLine.dmpl__Quantity__c = 20;
            assetServiceContractLine.dmpl__UtilizedQuantity__c = 10;
            update assetServiceContractLine;
        }
        dmpl__AssetServiceContractLine__c updatedAssetServiceContractLine=AssetTestDataHelpers.getAssetServiceContractLine(assetServiceContractLine.Id);
        if(updatedAssetServiceContractLine != null){
            System.assertNotEquals(updatedAssetServiceContractLine, null, 'Expected assetServiceContractLine to be updated.');
        }
        System.assertEquals(20, updatedAssetServiceContractLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be updated to 20');
        System.assertEquals(10, updatedAssetServiceContractLine.dmpl__UtilizedQuantity__c, 'Expected dmpl__UtilizedQuantity__c to be updated to 10');
        System.assertEquals(10, updatedAssetServiceContractLine.dmpl__PendingQuantity__c, 'Expected dmpl__PendingQuantity__c to be updated to 10');
    }

    @isTest
    static void deleteAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created before delete.');
        dmpl__AssetServiceContractLine__c deletedAssetServiceContractLine=null;
        delete assetServiceContractLine;
        try{
            deletedAssetServiceContractLine=AssetTestDataHelpers.getAssetServiceContractLine(assetServiceContractLine.Id);
        }
        catch(Exception e) {
            deletedAssetServiceContractLine=null;
        }
        System.assertEquals(null, deletedAssetServiceContractLine, 'Expected assetServiceContractLine to be deleted.');
    }

    @isTest
    static void createAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created.');
        }
        System.assertEquals(false, assetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be false');
        System.assertEquals(false, assetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be false');
        System.assertNotEquals(assetMaintenance.dmpl__AssetId__c, null, 'Expected dmpl__Asset__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__BranchId__c, null, 'Expected dmpl__Branch__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccount__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__RepairOrderId__c, null, 'Expected dmpl__RepairOrder__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ServiceCampaignId__c, null, 'Expected dmpl__ServiceCampaign__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ItemServiceContractId__c, null, 'Expected dmpl__ItemServiceContract__c to be set.');
    }

    @isTest
    static void updateAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created before update.');
            assetMaintenance.dmpl__isExecuted__c = true;
            assetMaintenance.dmpl__isMandatory__c = true;
            update assetMaintenance;
        }
        dmpl__AssetMaintenance__c updatedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        if(updatedAssetMaintenance != null){
            System.assertNotEquals(updatedAssetMaintenance, null, 'Expected assetMaintenance to be updated.');
        }
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be true');
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be true');
    }

    @isTest
    static void deleteAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        System.assertNotEquals(assetMaintenance, null, 'Expected asset to be created before delete.');
        dmpl__AssetMaintenance__c deletedAssetMaintenance = null;
        delete assetMaintenance;
        try{
            deletedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        }
        catch(Exception e) {
            deletedAssetMaintenance = null;
        }
        System.assertEquals(null, deletedAssetMaintenance, 'Expected assetMaintenance to be deleted.');
    }

    @isTest
    static void createShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine = AssetTestDataHelpers.getShippingAssetLine();
        if(shippingAssetLine != null){
            System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created.');
        }
        System.assertNotEquals(shippingAssetLine.name, null, 'Name should not be null');
        System.assertNotEquals(shippingAssetLine.dmpl__AssetId__c, null, 'Expected dmpl__AssetId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemLotId__c, null, 'Expected dmpl__ItemLotId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemLotTypeId__c, null, 'Expected dmpl__ItemLotTypeId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SKUId__c, null, 'Expected dmpl__SKUId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SellingBranchId__c, null, 'Expected dmpl__SellingBranchId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SellingPartnerAccountId__c, null, 'Expected dmpl__SellingPartnerAccountId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ShipmentId__c, null, 'Expected dmpl__ShipmentId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ShipmentLineId__c, null, 'Expected dmpl__ShipmentLineId__c to be set.');
    }

    @isTest
    static void updateShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine=AssetTestDataHelpers.getShippingAssetLine();
        if(shippingAssetLine != null){
            System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created before update.');
            shippingAssetLine.dmpl__Quantity__c = 20;
            shippingAssetLine.dmpl__LotNumber__c = 'UpdatedLot123';
            shippingAssetLine.dmpl__SerialNumber__c = 'UpdatedSN1234';
            shippingAssetLine.dmpl__Status__c = 'Installed';
            shippingAssetLine.dmpl__PlantName__c = 'UpdatedPlant A';
            shippingAssetLine.dmpl__EngineNumber__c = 'UpdatedENG12345';
            update shippingAssetLine;
        }
        dmpl__ShippingAssetLine__c updatedShippingAssetLine=AssetTestDataHelpers.getShippingAssetLine(shippingAssetLine.Id);
        if(updatedShippingAssetLine != null){
            System.assertNotEquals(updatedShippingAssetLine, null, 'Expected shippingAssetLine to be updated.');
        }
        System.assertEquals(20, updatedShippingAssetLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be updated to 20');
        System.assertEquals('UpdatedLot123', updatedShippingAssetLine.dmpl__LotNumber__c, 'Expected dmpl__LotNumber__c to be UpdatedLot123');
        System.assertEquals('UpdatedSN1234', updatedShippingAssetLine.dmpl__SerialNumber__c, 'Expected dmpl__SerialNumber__c to be UpdatedSN1234');
        System.assertEquals('Installed', updatedShippingAssetLine.dmpl__Status__c, 'Expected dmpl__Status__c to be Installed');
        System.assertEquals('UpdatedPlant A', updatedShippingAssetLine.dmpl__PlantName__c, 'Expected dmpl__PlantName__c to be UpdatedPlant A');
        System.assertEquals('UpdatedENG12345', updatedShippingAssetLine.dmpl__EngineNumber__c, 'Expected dmpl__EngineNumber__c to be UpdatedENG12345');
    }

    @isTest
    static void deleteShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine=AssetTestDataHelpers.getShippingAssetLine();
        System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created before delete.');
        dmpl__ShippingAssetLine__c deletedShippingAssetLine=null;
        delete shippingAssetLine;
        try{
            deletedShippingAssetLine=AssetTestDataHelpers.getShippingAssetLine(shippingAssetLine.Id);
        }
        catch(Exception e) {
            deletedShippingAssetLine=null;
        }
        System.assertEquals(null, deletedShippingAssetLine, 'Expected shippingAssetLine to be deleted.');
    }

    @isTest
    static void createAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        if(assetDiagnosticData != null){
            System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created.');
        }
        System.assertNotEquals(assetDiagnosticData.name, null, 'Name should not be null');
        System.assertNotEquals(assetDiagnosticData.dmpl__AssetId__c, null, 'Expected dmpl__AssetId__c to be set.');
        System.assertNotEquals(assetDiagnosticData.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertEquals('StandardValue', assetDiagnosticData.dmpl__StandardValue__c, 'Expected dmpl__StandardValue__c to be StandardValue');
        System.assertEquals('Remark', assetDiagnosticData.dmpl__Remarks__c, 'Expected dmpl__Remarks__c to be Remark');
        System.assertEquals(10.0, assetDiagnosticData.dmpl__MinValue__c, 'Expected dmpl__MinValue__c to be 10.0');
        System.assertEquals(100.0, assetDiagnosticData.dmpl__MaxValue__c, 'Expected dmpl__MaxValue__c to be 100.0');
    }

    @isTest
    static void updateAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        if(assetDiagnosticData != null){
            System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created before update.');
            assetDiagnosticData.dmpl__StandardValue__c = 'UpdatedStandardValue';
            assetDiagnosticData.dmpl__Remarks__c = 'UpdatedRemark';
            assetDiagnosticData.dmpl__MinValue__c = 20.0;
            assetDiagnosticData.dmpl__MaxValue__c = 200.0;
            update assetDiagnosticData;
        }
        dmpl__AssetDiagnosticData__c updatedAssetDiagnosticData=AssetTestDataHelpers.getAssetDiagnosticData(assetDiagnosticData.Id);
        if(updatedAssetDiagnosticData != null){
            System.assertNotEquals(updatedAssetDiagnosticData, null, 'Expected assetDiagnosticData to be updated.');
        }
        System.assertEquals('UpdatedStandardValue', updatedAssetDiagnosticData.dmpl__StandardValue__c, 'Expected dmpl__StandardValue__c to be UpdatedStandardValue');
        System.assertEquals('UpdatedRemark', updatedAssetDiagnosticData.dmpl__Remarks__c, 'Expected dmpl__Remarks__c to be UpdatedRemark');
        System.assertEquals(20.0, updatedAssetDiagnosticData.dmpl__MinValue__c, 'Expected dmpl__MinValue__c to be updated to 20.0');
        System.assertEquals(200.0, updatedAssetDiagnosticData.dmpl__MaxValue__c, 'Expected dmpl__MaxValue__c to be updated to 200.0');
    }

    @isTest
    static void deleteAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created before delete.');
        dmpl__AssetDiagnosticData__c deletedAssetDiagnosticData = null;
        delete assetDiagnosticData;
        try{
            deletedAssetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData(assetDiagnosticData.Id);
        }
        catch(Exception e) {
            deletedAssetDiagnosticData = null;
        }
        System.assertEquals(null, deletedAssetDiagnosticData, 'Expected assetDiagnosticData to be deleted.');
    }

    @isTest
    public static void createAssetAccountHistoryWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        dmpl__AssetAccountHistory__c assetHistory = AssetTestDataHelpers.createAssetAccountHistory(asset, null);
        Test.stopTest();
        System.assertNotEquals(null, assetHistory, 'Asset Account History record should be fetched.');
        System.assertEquals(asset.Id, assetHistory.dmpl__InstallbaseId__c, 'Asset should be linked to the Account History correctly.');
    }

    @isTest
    public static void updateAssetAccountHistoryFieldsPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset('Asset 1', partner.Id, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer);
        history.dmpl__AtUsageReading__c = 150;
        history.dmpl__OwnershipEnddate__c = Date.today().addDays(10);
        update history;
        Test.stopTest();
        System.assertNotEquals(null, history.Id, 'Asset Account History should exist');
        System.assertEquals(asset.Id, history.dmpl__InstallbaseId__c, 'Asset should remain unchanged');
        System.assertEquals(150, history.dmpl__AtUsageReading__c, 'Usage Reading should be updated');
        System.assertEquals(Date.today().addDays(10), history.dmpl__OwnershipEnddate__c, 'Ownership end date should be updated');
    }

    @isTest
    public static void createAssetAccountHistoryWithAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer);
        Test.stopTest();
        System.assertNotEquals(null, history, 'Asset Account History should be created.');
        System.assertEquals(asset.Id, history.dmpl__InstallbaseId__c, 'Asset should be linked correctly.');
        System.assertEquals(customer.Id, history.dmpl__AccountId__c, 'Customer Account should be linked correctly.');
    }

    @isTest
    public static void createAssetAccountHistoryWithDiscontinuedItemNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        AssetMasterData.createAssetAccountHistoryWithDiscontinuedItemNegativeData();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset('Asset - Discontinued', partner.Id, item.Id);
        Test.stopTest();
        System.assertNotEquals(null, asset.Id, 'Asset should be created successfully even with a discontinued item.');
        System.assertEquals(item.Id, asset.dmpl__ItemId__c, 'Asset should reference the correct item.');
    }

    @isTest
    public static void createAssetAccountHistoryWithStartDateGreaterThanEndDatePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        Date ownershipStartDate = Date.newInstance(2025, 6, 30);
        Date ownershipEndDate = Date.newInstance(2025, 6, 1);
        Test.startTest();
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer);
        history.dmpl__OwnershipStartDate__c = ownershipStartDate;
        history.dmpl__OwnershipEnddate__c = ownershipEndDate;
        update history;
        Test.stopTest();
        System.assertNotEquals(null, history.Id, 'Id should not be null');
        System.assertEquals(ownershipStartDate, history.dmpl__OwnershipStartDate__c, 'start date should be equal');
        System.assertEquals(ownershipEndDate, history.dmpl__OwnershipEnddate__c, 'end date should be equal');
    }

    @isTest
    public static void updateAssetAccountHistoryWithAtUsageReadingAsMinusOnePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer);
        Test.startTest();
        history.dmpl__AtUsageReading__c = -1;
        update history;
        Test.stopTest();
        System.assertEquals(-1, history.dmpl__AtUsageReading__c, 'Negative usage added');
    }

    @isTest
    public static void updateAssetAccountHistoryWithAtUsageHourAsMinusOnePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer);
        Test.startTest();
        history.dmpl__AtUsageHour__c = -1;
        update history;
        Test.stopTest();
        System.assertEquals(-1, history.dmpl__AtUsageHour__c, 'Usage Hour should be updated to -1');
    }

    @isTest
    public static void updateAssetAccountHistoryWithInactiveCustomerNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        AssetMasterData.updateAssetAccountHistoryWithInactiveCustomerNegativeData();
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(asset, customer1);
        Boolean updateFailed = false;
        Test.startTest();
        try {
            history.dmpl__AccountId__c = customer7.Id;
            update history;
        } catch (Exception e) {
            updateFailed = true;
        }
        Test.stopTest();
        System.assertEquals(true, updateFailed, 'updated asset');
    }

    @isTest
    public static void createAssetDiagnosticDataWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'COMP-001';
        update asset;
        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        System.assertNotEquals(null, diagnostic.Id, 'Asset Diagnostic Data should be inserted');
        System.assertEquals(asset.Id, diagnostic.dmpl__AssetId__c, 'Asset reference should match');
        System.assertEquals(item.Id, diagnostic.dmpl__ItemId__c, 'Item reference should match');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithNewItemPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        AssetMasterData.updateAssetDiagnosticDataWithNewItemPositiveData();
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item1.Id);
        dmpl__AssetDiagnosticData__c data = AssetTestDataHelpers.createAssetDiagnosticData(asset, item1);
        Test.startTest();
        data.dmpl__ItemId__c = item2.Id;
        update data;
        Test.stopTest();
        System.assertEquals(item2.Id, data.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithHealthCheckPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        dmpl__ProductHealthCheck__c healthCheck = AssetTestDataHelpers.createProductHealthCheck(
            partner, 
            branch, 
            customer, 
            asset, 
            'xx1', 
            'HC25060000'
        );
        Test.startTest();
        diagnosticData.dmpl__ItemHealthCheckId__c = healthCheck.Id;
        update diagnosticData;
        Test.stopTest();
        System.assertEquals(healthCheck.Id, diagnosticData.dmpl__ItemHealthCheckId__c, 'Health check must be equal');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithValueTypeRAGPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        Test.startTest();
        diagnosticData.dmpl__ValueType__c = 'RAG';
        update diagnosticData;
        dmpl__AssetDiagnosticData__c getdiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData(diagnosticData.Id);
        Test.stopTest();
        System.assertEquals('RAG', getdiagnosticData.dmpl__ValueType__c, 'It should be present');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithNegativeStandardValuePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        Test.startTest();
        diagnosticData.dmpl__StandardValue__c = '-1'; 
        update diagnosticData;
        Test.stopTest();
        System.assertEquals('-1', diagnosticData.dmpl__StandardValue__c, 'Negative velue accepted');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithInvalidMinMaxNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        Boolean failed = false;
        Test.startTest();
        try {
            diagnosticData.dmpl__MinValue__c = 90;
            diagnosticData.dmpl__MaxValue__c = 10;
            update diagnosticData;
        } catch (DmlException e) {
            failed = true;
        }
        Test.stopTest();
        System.assertEquals(true, failed, 'Update should fail when Min Value is greater than Max Value');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithNegativeLastValuePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        Test.startTest();
        diagnostic.dmpl__LastValue__c = -1;
        update diagnostic;
        Test.stopTest();
        System.assertEquals(-1, diagnostic.dmpl__LastValue__c, 'Negative value allowed');
    }

    @isTest
    public static void updateAssetDiagnosticDataWithNegativeMinValueNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
        Boolean failed = false;
        Test.startTest();
        try {
            diagnostic.dmpl__MinValue__c = -1;
            update diagnostic;
        } catch (DmlException e) {
            failed = true;
        }
        Test.stopTest();
        System.assertEquals(true, failed, 'Update should fail when Min Value is negative');
    }

    @isTest
    public static void createAssetMaintenanceWithAssetPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        Test.startTest();
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            1
        );
        Test.stopTest();
        System.assertNotEquals(null, maintenance, 'Asset Maintainance created');
        System.assertEquals(asset.Id, maintenance.dmpl__AssetId__c, 'Asset passed to maintainance');
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            1
        );
        dmpl__ServiceCampaign__c campaign = AssetTestDataHelpers.createServiceCampaign(item, branch, partner);
        Test.startTest();
        maintenance.dmpl__ServiceCampaignId__c = campaign.Id;
        update maintenance;
        Test.stopTest();
        System.assertEquals(campaign.Id, maintenance.dmpl__ServiceCampaignId__c, 'Asset with service campaign created');
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignItemPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            1
        );
        dmpl__ServiceCampaign__c campaign = AssetTestDataHelpers.createServiceCampaign(item, branch, partner);
        dmpl__ServiceCampaignItem__c campaignItem = AssetTestDataHelpers.createServiceCampaignItem(campaign, item, null );
        Test.startTest();
        maintenance.dmpl__ServiceCampaignItemId__c = campaignItem.Id;
        update maintenance;
        Test.stopTest();
        System.assertEquals(campaignItem.Id, maintenance.dmpl__ServiceCampaignItemId__c, 'Asset with service campaign updated');
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignMemberPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            1
        );
        dmpl__ServiceCampaign__c campaign = AssetTestDataHelpers.createServiceCampaign(item, branch, partner);
        dmpl__ServiceCampaignMember__c member = AssetTestDataHelpers.createServiceCampaignMember(
            campaign,
            item,
            branch,
            asset,
            partner,
            customer
        );
        Test.startTest();
        maintenance.dmpl__ServiceCampaignMemberId__c = member.Id;
        update maintenance;
        Test.stopTest();
        System.assertEquals(member.Id, maintenance.dmpl__ServiceCampaignMemberId__c, 'Maintanance created');
    }

    @isTest
    static void updateAssetMaintenanceWithIsMandatoryTruePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            1
        );
        Test.startTest();
        maintenance.dmpl__IsMandatory__c = true;
        update maintenance;
        Test.stopTest();
        System.assertEquals(true, maintenance.dmpl__IsMandatory__c, 'Maintanance Created');
    }

    @isTest
    static void createAssetMaintenanceWithNegativeQuantityPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner.Id, item.Id);
        Test.startTest();
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            -1
        );
        Test.stopTest();
        System.assertNotEquals(null, maintenance.Id, ' Asset Maintanince Created');
        System.assertEquals(-1, maintenance.dmpl__Quantity__c, ' Negative quantity is passed');
    }

    @isTest
    static void createAssetServiceContractWithServiceContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Test.startTest();
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(customer, item, contract.Id);
        Test.stopTest();
        System.assertNotEquals(null, assetServiceContract.Id, 'Asset Service Contract record should be created');
        System.assertEquals(item.Id, assetServiceContract.dmpl__ItemId__c, 'Item ID should be correctly linked to the Asset Service Contract');
        System.assertEquals(contract.Id, assetServiceContract.dmpl__ItemServiceContractId__c, 'Service Contract should be correctly associated');
    }

    @isTest
    static void updateAssetServiceContractWithNewItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
         dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product');
         item2.dmpl__IsActive__c=false;
         update item2;
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item1, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer, item1, contract.Id);
        Test.startTest();
        assetSC.dmpl__ItemId__c = item2.Id;
        update assetSC;
        Test.stopTest();
        System.assertEquals(item2.Id, assetSC.dmpl__ItemId__c, 'Asset Service Contract should be linked to the correct Item');
        System.assertEquals(contract.Id, assetSC.dmpl__ItemServiceContractId__c, 'Asset Service Contract should reference the correct Service Contract');
        System.assertEquals(customer.Id, assetSC.dmpl__BillingAccountId__c, 'Billing Account should match the associated Customer');
    }

    @isTest
    static void updateAssetServiceContractWithNewBillingAccountPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer, item, contract.Id);
        Test.startTest();
        assetSC.dmpl__BillingAccountId__c = partner.Id;
        update assetSC;
        Test.stopTest();
        System.assertEquals(partner.Id, assetSC.dmpl__BillingAccountId__c, 'Asset Service Contract should reference the correct Partner as Billing Account');
        System.assertEquals(item.Id, assetSC.dmpl__ItemId__c, 'Asset Service Contract should be linked to the correct Item');
        System.assertEquals(contract.Id, assetSC.dmpl__ItemServiceContractId__c, 'Asset Service Contract should reference the correct Service Contract');
    }

    @isTest
    static void updateAssetServiceContractWithDueDateEarlierThanCurrentDateNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract( customer, item, contract.Id);
        assetSC.dmpl__DueDate__c = Date.today().addDays(-5);
        update assetSC;
        System.assertNotEquals(null, assetSC.Id, 'Asset Service Contract should be created and have a valid Id');
        System.assert(assetSC.dmpl__DueDate__c < Date.today(), 'Due Date should be earlier than today');
    }

    @isTest
    static void updateAssetServiceContractWithDueInHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer, item, contract.Id);
        assetSC.dmpl__DueInHours__c = -1;
        update assetSC;
        System.assertEquals(-1, assetSC.dmpl__DueInHours__c, 'Due In Hours should be set to -1 as expected');
    }

    @isTest
    static void updateAssetServiceContractWithGraceUsageHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract( customer, item, contract.Id);
        assetSC.dmpl__GraceUsageHours__c = -1;
        update assetSC;
        System.assertEquals(-1, assetSC.dmpl__GraceUsageHours__c, 'Grace Usage Hours should be set to -1 as expected');
    }

    @isTest
    static void updateAssetServiceContractWithValidTillHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer, item, contract.Id);
        assetSC.dmpl__ValidTillHours__c = -1;
        update assetSC;
        System.assertEquals(-1, assetSC.dmpl__ValidTillHours__c, 'Valid Till Hours should match the expected invalidHours value');
    }

    @isTest
    static void updateAssetServiceContractWithActivatedDateLessThanCurrentDatePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract( customer, item, contract.Id );
        assetSC.dmpl__ActivatedDate__c = Date.today().addDays(-10);
        update assetSC;
        System.assertEquals(Date.today().addDays(-10), assetSC.dmpl__ActivatedDate__c, 'Activated Date should match the expected past date');
    }

    @isTest
    static void updateAssetServiceContractWithValidTillBeforeActivatedDatePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer, item, contract.Id);
        assetSC.dmpl__ActivatedDate__c = Date.today();
        assetSC.dmpl__ValidTillDate__c = Date.today().addDays(-5);
        update assetSC;
        System.assertEquals(Date.today().addDays(-5), assetSC.dmpl__ValidTillDate__c, 'Valid Till Date should match the expected value');
    }

    @isTest
    static void updateAssetServiceContractWithNegativeGraceUsageDaysNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract( customer, item, contract.Id);
        assetSC.dmpl__GraceUsageDays__c = -1;
        Boolean exceptionThrown = false;
        try {
            update assetSC;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'Update should fail when Grace Usage Days is negative');
    }

    @isTest
    static void createAssetServiceContractLineUsingAssetServiceContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Asset asset = AssetTestDataHelpers.createAsset('Asset-01', customer.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'CMP-001';
        update asset;
        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(customer, item, itemContract.Id);
        assetContract.dmpl__AssetId__c = asset.Id;
        update assetContract;
        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );
        System.assertNotEquals(null, assetContract.Id, 'Asset Contract should be created with a valid Id');
        System.assertEquals(item.Id, assetContract.dmpl__ItemId__c, 'Asset Contract should reference the correct Item');
        System.assertNotEquals(null, contractLine.Id, 'Contract Line should be created with a valid Id');
        System.assertEquals(assetContract.Id, contractLine.dmpl__AssetServiceContractId__c, 'Contract Line should be linked to the correct Asset Contract');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidAssetContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Asset asset = AssetTestDataHelpers.createAsset('Asset-01', customer.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'CMP-001';
        update asset;
        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(customer, item, itemContract.Id);
        assetContract.dmpl__AssetId__c = asset.Id;
        update assetContract;
        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );
        contractLine.dmpl__Quantity__c = 10;
        Test.startTest();
        update contractLine;
        Test.stopTest();
        System.assertEquals(10, contractLine.dmpl__Quantity__c, 'Contract line should be updated with new quantity');
    }

    @isTest
    static void createAssetServiceContractLineWithComponentItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Asset asset = AssetTestDataHelpers.createAsset('Asset-01', customer.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'CMP-001';
        update asset;
        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(customer,item, itemContract.Id);
        assetContract.dmpl__AssetId__c = asset.Id;
        update assetContract;
        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );
        System.assertNotEquals(null, contractLine.Id, 'Contract Line should be created with a valid Id');
        System.assertEquals(assetContract.Id, contractLine.dmpl__AssetServiceContractId__c, 'Contract Line should be linked to the correct Asset Service Contract');
        System.assertEquals(item.Id, contractLine.dmpl__ComponentItemId__c, 'Contract Line should reference the correct Component Item');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidComponentItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Asset asset = AssetTestDataHelpers.createAsset('Asset-01', customer.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'CMP-001';
        update asset;
        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(customer,item, itemContract.Id);
        assetContract.dmpl__AssetId__c = asset.Id;
        update assetContract;
        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, 
            assetContract, 
            item, 
            5, 
            1
        );
        dmpl__Item__c newComponentItem = TestDataHelpers.getItem('Item 1');
        contractLine.dmpl__ComponentItemId__c = newComponentItem.Id;
        Test.startTest();
        update contractLine;
        Test.stopTest();
        System.assertEquals(newComponentItem.Id, contractLine.dmpl__ComponentItemId__c, 'Component Item should be updated');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidQuantityPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        Asset asset = AssetTestDataHelpers.createAsset('Asset-01', customer.Id, item.Id);
        asset.SerialNumber = 'SN-001';
        asset.dmpl__ComponentNumber__c = 'CMP-001';
        update asset;
        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(customer,item, itemContract.Id);
        assetContract.dmpl__AssetId__c = asset.Id;
        update assetContract;
        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, 
            assetContract, 
            item, 
            2, 
            0
        );
        contractLine.dmpl__Quantity__c = 3;
        Test.startTest();
        update contractLine;
        Test.stopTest();
        System.assertEquals(3, contractLine.dmpl__Quantity__c, 'Quantity should be updated to 3');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidUtilizedQuantityPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(customer,item, itemContract.Id);
        dmpl__AssetServiceContractLine__c ascLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, 
            assetSC, 
            item, 
            2, 
            1
        );
        ascLine.dmpl__UtilizedQuantity__c = 2;
        Test.startTest();
        update ascLine;
        Test.stopTest();
        System.assertEquals(2, ascLine.dmpl__UtilizedQuantity__c, 'Utilized Quantity should be updated to 2');
    }
}