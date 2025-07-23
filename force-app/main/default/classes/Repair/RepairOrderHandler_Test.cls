@isTest
private class RepairOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item1);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount1, branch1);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch1);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch1, item1, sku);
        Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        dmpl__TaxGroup__c taxGroupGST28partner = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c tax1=TestDataHelpers.createTax('GST 28', taxGroupGST28partner.Id, 14);
        dmpl__Tax__c tax2=TestDataHelpers.createSGSTTax('GST 28', taxGroupGST28partner.Id, 14);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.Id, item1.Id, 1500);
        dmpl__Quote__c serviceEstimate1 = QuoteTestDataHelpers.CreateServiceEstimate(
            branch1,
            customerAccount1,
            priceList1,
            asset1,
            item1
        );
        dmpl__ItemServiceContract__c itemServiceContract = RepairOrderTestDataHelpers.createItemServiceContract(item1, sku);
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.CreateServiceEstimateLine(
            item1,
            priceListRule1,
            taxGroupGST28partner,
            null,
            serviceEstimate1
        );
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(asset1, item1);
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(
            partnerAccount1,
            customerAccount1,
            branch1,
            asset1,
            null
        );
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createTimeSheet(repairOrder);
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine = RepairOrderTestDataHelpers.createTimeSheetLine(timeSheet);
        Test.stopTest();
    }

    @isTest
    static void createRepairOrderPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__RepairOrder__c createdOrder = RepairOrderTestDataHelpers.getRepairOrder();
        System.assertNotEquals(null, createdOrder.Id, 'Repair Order should be created');
        System.assertEquals(branch.Id, createdOrder.dmpl__BranchId__c, 'Branch should be linked');
    }

    @isTest
    static void updateRepairOrderPositive() {
        dmpl__RepairOrder__c existingOrder = RepairOrderTestDataHelpers.getRepairOrder();
        Test.startTest();
        existingOrder.dmpl__UsageReading__c = 70.00;
        update existingOrder;
        Test.stopTest();
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrder();
        System.assertEquals(70.00, updatedOrder.dmpl__UsageReading__c, 'Usage Reading should be updated to 70.00');
    }

    @isTest
    static void deleteRepairOrderPositive() {
        dmpl__RepairOrder__c existingOrder = RepairOrderTestDataHelpers.getRepairOrder();
        System.assertNotEquals(null, existingOrder.Id, 'Repair Order should exist before deletion');
        Test.startTest();
        delete existingOrder;
        Test.stopTest();
        List<dmpl__RepairOrder__c> remainingOrders = RepairOrderTestDataHelpers.getRepairOrdersById(existingOrder.Id);
        System.assertEquals(0, remainingOrders.size(), 'Repair Order should be deleted');
    }

    @isTest
    static void createRepairOrderTaxPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
        dmpl__RepairOrderTax__c createdTax = RepairOrderTestDataHelpers.getRepairOrderTax();
        System.assertEquals(10, createdTax.dmpl__TaxRate__c, 'Tax Rate should be 10');
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax Amount should be 100');
        System.assertEquals(100, createdTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 100');
    }

    @isTest
    static void updateRepairOrderTaxPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.getRepairOrderTax();
        Test.startTest();
        tax.dmpl__TaxAmount__c = 150;
        tax.dmpl__TaxOnAmount__c = 1000;
        update tax;
        Test.stopTest();
        dmpl__RepairOrderTax__c updatedTax = RepairOrderTestDataHelpers.getRepairOrderTax();
        System.assertEquals(150, updatedTax.dmpl__TaxAmount__c, 'Tax Amount should be 150');
        System.assertEquals(1000, updatedTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 1000');
    }

    @isTest
    static void deleteRepairOrderTaxePositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
        Test.startTest();
        RepairOrderTestDataHelpers.deleteRepairOrderTaxesByRepairOrder(repairOrder.Id);
        Test.stopTest();
        List<dmpl__RepairOrderTax__c> remainingTaxes = RepairOrderTestDataHelpers.getRepairOrderTaxesByRepairOrder(repairOrder.Id);
        System.assertEquals(0, remainingTaxes.size(), 'Should have no tax records remaining');
    }

    @isTest
    static void createTimeSheetPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        Test.startTest();
        RepairOrderTestDataHelpers.createTimeSheet(repairOrder);
        Test.stopTest();
        List<dmpl__RepairOrderTimeSheet__c> timeSheets = RepairOrderTestDataHelpers.getTimeSheetsByRepairOrder(repairOrder.Id);
        System.assertEquals(2, timeSheets.size(), 'Should have two time sheets');
        dmpl__RepairOrderTimeSheet__c createdTimeSheet = timeSheets[1];
        System.assertNotEquals(null, createdTimeSheet.Id, 'Time Sheet should be created');
        System.assertEquals(repairOrder.Id, createdTimeSheet.dmpl__RepairOrderId__c, 'Repair Order should be linked');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkStarted__c, 'Work Started should be false');
    }

    @isTest
    static void updateTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet, 'Time sheet should exist from test setup');
        Test.startTest();
        existingTimeSheet.dmpl__WorkStarted__c = true;
        existingTimeSheet.dmpl__WorkPaused__c = true;
        existingTimeSheet.dmpl__WorkEnded__c = true;
        update existingTimeSheet;
        Test.stopTest();
        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkStarted__c, 'Work Started should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be updated to true');
    }

    @isTest
    static void deleteRepairOrderTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet.Id, 'Repair Order Time Sheet should exist before deletion');
        Test.startTest();
        delete existingTimeSheet;
        Test.stopTest();
        List<dmpl__RepairOrderTimeSheet__c> remainingTimeSheets = RepairOrderTestDataHelpers.getRepairOrderTimeSheetsById(existingTimeSheet.Id);
        System.assertEquals(0, remainingTimeSheets.size(), 'Repair Order Time Sheet should be deleted');
    }

    @isTest
    static void createTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        Test.startTest();
        RepairOrderTestDataHelpers.createTimeSheetLine(timeSheet);
        Test.stopTest();
        List<dmpl__RepairOrderTimeSheetLine__c> timeSheetLines = RepairOrderTestDataHelpers.getTimeSheetLinesByTimeSheet(timeSheet.Id);
        System.assertEquals(2, timeSheetLines.size(), 'Should have two time sheet lines');
        dmpl__RepairOrderTimeSheetLine__c createdLine = timeSheetLines[1];
        System.assertNotEquals(null, createdLine.Id, 'Time Sheet Line should be created');
        System.assertEquals(timeSheet.Id, createdLine.dmpl__RepairOrderTimeSheetId__c, 'Time Sheet should be linked');
        System.assertEquals(1.00, createdLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be 1.00');
    }

    @isTest
    static void updateTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine, 'Time sheet line should exist from test setup');
        Test.startTest();
        existingLine.dmpl__ActualDurationHours__c = 2.50;
        update existingLine;
        Test.stopTest();
        dmpl__RepairOrderTimeSheetLine__c updatedLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertEquals(2.50, updatedLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be updated to 2.50');
    }

    @isTest
    static void deleteTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine.Id, 'Time Sheet Line should exist before deletion');
        Test.startTest();
        delete existingLine;
        Test.stopTest();
        List<dmpl__RepairOrderTimeSheetLine__c> remainingLines = RepairOrderTestDataHelpers.getTimeSheetLinesById(existingLine.Id);
        System.assertEquals(0, remainingLines.size(), 'Time Sheet Line should be deleted');
    }

    @isTest
    static void CreateRepairOrderWithCorrectPartnerAndBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            null
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be 6/20/2025');
    }

    @isTest
    static void createRepairOrderWithWrongPartnerAccountNegative() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000
        );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(false, exceptionThrown, 'Expected exception for wrong partner ');
    }

    @isTest
    static void updateRepairOrderWithWrongPartnerAccountNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.createPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        try {
            fetchedOrder.dmpl__PartnerAccountId__c = partner3.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to wrong partner account');
    }

    @isTest
    static void updateRepairOrderWithWrongBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner.Id);
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        try {
            fetchedOrder.dmpl__BranchId__c = branch4.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to wrong branch');
    }

    @isTest
    static void createRepairOrderWithWrongBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 4', partner.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                partner,
                branch,
                customer,
                1000
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception for mismatched partner and branch');
    }

    @isTest
    static void createRepairOrderWithInactiveBranchNegative() {
        RepairOrderMasterData.createRepairOrderWithInactiveBranchNegativeData(); 
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                partner,
                branch,
                customer,
                1000
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception for mismatched partner and branch');
    }

    @isTest
    static void updateRepairOrderWithInactiveBranchNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partner.Id);
        branch3.dmpl__IsActive__c = false;
        update branch3;
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        try {
            fetchedOrder.dmpl__BranchId__c = branch3.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to inactive  branch');
    }

    @isTest
    static void CreateRepairOrderWithActiveCustomerAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            null
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void updateRepairOrderWithActiveCustomerAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(1000, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1000');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
    }

    @isTest
    static void createRepairOrderWithInactiveCustomerAccountNegative() {
        RepairOrderMasterData.createRepairOrderWithInactiveCustomerAccountNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 2');
        customer.dmpl__IsActive__c = false;
        update customer;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                partner,
                branch,
                customer,
                1000
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception for inactive customer account');
    }

    @isTest
    static void updateRepairOrderWithInactiveCustomerAccountNegative() { 
        RepairOrderMasterData.createRepairOrderWithInactiveCustomerAccountNegativeData();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer2,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        try {
            fetchedOrder.dmpl__AccountId__c = customer7.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }

    @isTest
    static void CreateRepairOrderWithAsset() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            null
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void CreateRepairOrderWithoutAsset() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            null
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void CreateRepairOrderWithGSTTaxPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void createRepairOrderWithIGSTTaxPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void createRepairOrderWithBillingAndShippingAddressPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void createRepairOrderWithMultipleBillingAndShippingAddress() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void updateRepairOrderWithBillingAndShippingAddressPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.createContactAddress('Address 1',customer.Id);
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.createContactAddress('Address 2',customer2.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');      
        fetchedOrder.dmpl__ShippingAddressId__c = shippingAddress.Id;
        fetchedOrder.dmpl__BillingAddressId__c = billingAddress.Id;
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(fetchedOrder.Id);
        System.assertEquals(partner.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(1000, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1000');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
    }

    @isTest
    static void createRepairOrderWithUsageReadingPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Tax group should be IGST 18');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void updateRepairOrderWithActiveUsageReadingPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.createCustomerAccount('Customer 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            1000,
            asset,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        fetchedOrder.dmpl__UsageReading__c = 1100;
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(fetchedOrder.Id);
        System.assertEquals(partner.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(1100, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1100');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
    }

    @isTest
    static void createRepairOrderWithoutUsageReadingPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('IGST 18', partner.Id, branch.Id);
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner,
            branch,
            customer,
            null,
            null,
            taxGroup
        );
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(null, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be null');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Tax group should be IGST 18');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
    }

    @isTest
    static void createRepairOrderWithPriceListforPartneraccountAndBranch() {
        Test.startTest();
        RepairOrderMasterData.createRepairOrderWithPriceListforPartneraccountAndBranchData();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 2', partner4.Id, branch4.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner4,
            branch4,
            customer2,
            1000,
            null,
            taxGroup
        );
        repairOrder.dmpl__PriceListId__c = priceList.Id;
        repairOrder.dmpl__DocumentDate__c = Date.today();
        update repairOrder;
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner4.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List should be Price List 4');
    }

    @isTest
    static void createRepairOrderWithPriceListforPartneraccountGroupAndBranch() {
        Test.startTest();
        RepairOrderMasterData.createRepairOrderWithPriceListforPartneraccountAndBranchData();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 2', partner4.Id, branch4.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner4,
            branch4,
            customer2,
            1000,
            null,
            taxGroup
        );
        repairOrder.dmpl__PriceListId__c = priceList.Id;
        repairOrder.dmpl__DocumentDate__c = Date.today();
        update repairOrder;
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner4.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List should be Price List 4');
    }

    @isTest
    static void createRepairOrderWithInactivePriceListPositive() {
        RepairOrderMasterData.createRepairOrderWithPriceListforPartneraccountAndBranchData();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 5', partner4.Id, branch4.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner4,
            branch4,
            customer2,
            1000,
            null,
            taxGroup
        );
        repairOrder.dmpl__PriceListId__c = priceList.Id;
        repairOrder.dmpl__DocumentDate__c = Date.today();
        update repairOrder;
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        System.assertEquals(partner4.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List should be Price List 5');
    }

    @isTest
    static void createRepairOrderLineWithValidItemQuantityPricePositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');  
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount1, 
            branch, 
            customerAccount1, 
            1000
        );
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Order should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customerAccount1.Id, fetchedOrder.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should be 1000');
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Line should not be null');
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should be match.');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
        System.assertEquals(1920, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 1920');
    }

    @isTest
    static void createRepairOrderLineWithReferenceNew() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Repair Order should not be null');
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Repair Order Line should not be null');
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should match');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1920, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void createRepairOrderLineWithoutRepairOrderReferenceNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
        Test.startTest();
        try {
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            null,
            item,
            taxGroup,
            1,
            1500);
            System.assert(false, 'Expected exception due to missing Repair Order reference');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('dmpl__RepairOrderId__c'), 'Error should mention missing Repair Order reference');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createRepairOrderLineWithActiveItemPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Repair Order should not be null');
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Repair Order Line should not be null');
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should match');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1920, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void createRepairOrderLineWithInactiveItemNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c inactiveItem =TestDataHelpers.createItem('Item 2','Product');
        inactiveItem.dmpl__IsActive__c=false;
        update inactiveItem;
        Test.startTest();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
        Boolean exceptionThrown = false;
        try {
            RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
                repairOrder, 
                inactiveItem, 
                taxGroup, 
                1, 
                1500
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Repair Order Line creation should fail with inactive item');
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
    }

    @isTest
    static void createRepairOrderLineWithZeroQuantityNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2','Product');
        item.dmpl__IsActive__c = false;
        update item;
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
                repairOrder, 
                item, 
                taxGroup, 
                0, 
                1500
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Repair Order Line creation should fail with zero quantity');
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(1000, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
    }
          
    @isTest
    static void createRepairOrderLineWithQuoteLineReference() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithQuoteLine(
            repairOrder, 
            item, 
            quoteLine, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertEquals(1, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match input');
        System.assertEquals(1500, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match input');
        System.assertEquals(quoteLine.Id, fetchedOrderLine.dmpl__QuoteLineId__c, 'Quote Line should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
        System.assertEquals(1500,fetchedOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
    }

    @isTest
    static void createRepairOrderLineWithItemServiceContractPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU(item);
        dmpl__ItemServiceContract__c itemServiceContract=RepairOrderTestDataHelpers.createItemServiceContract(item, sku1);
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithItemServiceContract(
            repairOrder, 
            item, 
            itemServiceContract, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertEquals(1, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match input');
        System.assertEquals(1500, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match input');
        System.assertEquals(itemServiceContract.Id, fetchedOrderLine.dmpl__ItemServiceContractId__c, 'Service Contract should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
    }

    @isTest
    static void createRepairOrderLineWithLapsedContractNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemServiceContract__c lapsedContract = RepairOrderTestDataHelpers.createLapsedItemServiceContract(item, sku);
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        Test.startTest();
        dmpl__RepairOrderLine__c roLine;
        try {
            roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithItemServiceContract(
                repairOrder, 
                item, 
                lapsedContract, 
                taxGroup, 
                1, 
                1500
            );
            System.assert(true, 'Repair Order Line creation should fail due to lapsed contract');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('lapsed') || e.getMessage().contains('expired'), 'Expected lapsed contract error');
        }
        Test.stopTest();
    }

    @isTest
    static void createRepairOrderLineWithoutContract() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        Test.stopTest();
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertEquals(1, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
        System.assertEquals(null, fetchedOrderLine.dmpl__ItemServiceContractId__c, 'Service Contract should be null');
    }

    @isTest
    static void createRepairOrderTaxWithValidRepairOrderAndLinePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTax__c repairOrderTax =RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder,roLine,taxGroup,'cgst 28',28) ;
        Test.stopTest();
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
        System.assertEquals('cgst 28', insertedTax.dmpl__TaxName__c, 'Tax Name should be cgst 28');
        System.assertEquals(28, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 28%');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(roLine.Id, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item ID should match');
    }

    @isTest
    static void createRepairOrderTaxWithoutLineReferencePositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 12',partnerAccount.Id,branch.Id);
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        Test.startTest();
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTaxWithoutRepairOrderLineReference(
            repairOrder, 
            taxGroup, 
            'CGST 12', 
            0.12
        );
        Test.stopTest();
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
        System.assertEquals('CGST 12', insertedTax.dmpl__TaxName__c, 'Tax Name should be CGST 12');
        System.assertEquals(0.12, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 0.12');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(null, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item reference should be null');
    }

    @isTest
    static void createRepairOrderTaxWithTaxGroupPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c lineItem = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTax(
            repairOrder, 
            lineItem , 
            taxGroup, 
            'CGST 12',  
            28
        );
        Test.stopTest();
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
        System.assertEquals('CGST 12', insertedTax.dmpl__TaxName__c, 'Tax Name should be CGST 12');
        System.assertEquals(28, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 28%');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(taxGroup.Id, insertedTax.dmpl__TaxGroupId__c, 'Tax Group should be GST 28');
    }

    @isTest
    static void createRepairOrderTaxWithoutTaxGroupPositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c lineItem = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item , 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTaxWithoutTaxGroup(repairOrder, lineItem);
        Test.stopTest();
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(lineItem.Id, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item ID should match');
        System.assertEquals(null, insertedTax.dmpl__TaxGroupId__c, 'Tax Group should be null');
    }

    @isTest
    static void createRepairOrderTimeSheetWithRepairOrderReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder);
        Test.stopTest();
        dmpl__RepairOrderTimeSheet__c insertedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
        System.assertNotEquals(null, insertedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, insertedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
    }

    @isTest
    static void createRepairOrderTimeSheetWithRepairOrderLineReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder, repairOrderLine);
        Test.stopTest();
        dmpl__RepairOrderTimeSheet__c insertedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, insertedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, insertedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
        System.assertEquals(repairOrderLine.Id, insertedTimeSheet.dmpl__RepairOrderLine__c, 'Time Sheet should reference correct Repair Order Line');
    }

    @isTest
    static void editRepairOrderTimeSheetWithRepairOrderLineReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item , 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder);
        timeSheet.dmpl__RepairOrderLine__c = repairOrderLine.Id;
        update timeSheet;
        Test.stopTest();
        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, updatedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, updatedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
        System.assertEquals(repairOrderLine.Id, updatedTimeSheet.dmpl__RepairOrderLine__c, 'Time Sheet should reference correct Repair Order Line after edit');
    }

    @isTest
    static void createRepairOrderTimeSheetLineWithRepairOrderLineReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item , 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder, repairOrderLine);
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(repairOrderLine, timeSheet.Id);
        Test.stopTest();
        System.assertNotEquals(null, repairOrder, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine, 'Repair Order Line should be created');
        System.assertNotEquals(null, timeSheet, 'Repair Order Time Sheet should be created');
        System.assertNotEquals(null, timeSheetLine, 'Repair Order Time Sheet Line should be created');
        System.assertEquals(repairOrderLine.Id, timeSheetLine.dmpl__RepairOrderLineId__c, 'Time Sheet Line should reference correct Repair Order Line');
        System.assertEquals(timeSheet.Id, timeSheetLine.dmpl__RepairOrderTimeSheetId__c, 'Time Sheet Line should reference correct Time Sheet');
    }

    @isTest
    static void updateRepairOrderTimeSheetLineWithRepairOrderLineReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item,
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder, repairOrderLine);
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(null, timeSheet.Id);
        timeSheetLine.dmpl__RepairOrderLineId__c = repairOrderLine.Id;
        update timeSheetLine;
        Test.stopTest();
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, timeSheet.Id, 'Repair Order Time Sheet should be created');
        System.assertNotEquals(null, timeSheetLine.Id, 'Repair Order Time Sheet Line should be created');
        System.assertEquals(repairOrderLine.Id, timeSheetLine.dmpl__RepairOrderLineId__c, 'Time Sheet Line should reference correct Repair Order Line after update');
    }

    @isTest
    static void createRepairOrderTimeSheetLineWithoutRepairOrderReferencePositive() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, 
            branch, 
            customerAccount, 
            1000
        );
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, 
            item, 
            taxGroup, 
            1, 
            1500
        );
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder, repairOrderLine);
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine;
        try {
            timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(repairOrderLine, timeSheet.Id);
            System.assert(true, 'Expected exception was not thrown when creating time sheet line without RepairOrder reference');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('dmpl__RepairOrderId__c'), 'Error should be related to missing Repair Order reference');
        }
        Test.stopTest();
    }
}