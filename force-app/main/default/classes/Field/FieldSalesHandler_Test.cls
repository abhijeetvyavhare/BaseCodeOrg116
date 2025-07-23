@isTest
public class FieldSalesHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        Account partner4 = TestDataHelpers.createPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4', partner4.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__ContactAddress__c address = TestDataHelpers.createContactAddress('Address 1', customer.Id);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partner.Id, branch.Id);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList.Id, item.Id, 1500);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup('GST 28', partner.Id, branch.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroup.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroup.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item.Id, taxGroup.Id);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__Resource__c resource = TestDataHelpers.createResource('Resource 1');
        resource.dmpl__IsActive__c = true;
        update resource;
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 1', item.Id, true);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1', branch.Id);
        storageLocation.dmpl__LocationType__c = 'VAN';
        update storageLocation;
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku);
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(partner, resource);
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.CreateVisitPlan(partner, route, taskTemplate);
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.createFieldSales(partner, branch, resource);
        dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(fieldSales, item, sku);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer.Id, partner.Id, branch.Id);
        dmpl__FieldSalesInvoice__c fieldSalesInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSales.Id, customer.Id, saleInvoice.Id);
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        System.assertNotEquals(fieldSales, null, 'Expected field sales to be created');
        System.assertEquals('Draft', fieldSales.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(System.today(), fieldSales.dmpl__DocumentDate__c, 'Document date should be' + System.today() + '.');
        System.assertNotEquals(null, fieldSales.dmpl__ResourceId__c, 'Resource ID should not be null');
    }
    
    @isTest
    static void createFieldSalesLinePositive() {
        Test.startTest();
        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine();
        Test.stopTest();
        System.assertNotEquals(null, retrievedLine, 'Expected field sales line to be created');
        System.assertEquals(1, retrievedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertNotEquals(null, retrievedLine.dmpl__ItemId__c, 'Item ID should not be null');
    }
    
    @isTest
    static void createFieldSalesInvoicePositive() {
        Test.startTest();
        dmpl__FieldSalesInvoice__c invoice = FieldSalesDataHelper.getFieldSalesInvoice();
        Test.stopTest();
        System.assertNotEquals(null, invoice, 'Field Sales Invoice should not be null');
        System.assertNotEquals(null, invoice.dmpl__FieldSalesId__c, 'Field Sales ID should not be null');
        System.assertEquals(100.00, invoice.dmpl__CollectedAmount__c, 'Collected amount should be 100');
        System.assertEquals(100.00, invoice.dmpl__InvoiceAmount__c, 'Invoice amount should be 100');
    }
    
    @isTest
    static void updateFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        fieldSales.dmpl__DocumentDate__c = System.today() + 1;
        fieldSales.dmpl__Status__c = 'Loaded';
        update fieldSales;
        dmpl__FieldSales__c updatedFieldSales = FieldSalesDataHelper.getFieldSales(fieldSales.Id);
        System.assertNotEquals(fieldSales, null, 'Field Sales not updated');
        System.assertEquals('Loaded', updatedFieldSales.dmpl__Status__c, 'Status should be Loaded');
        System.assertEquals(System.today()+1, updatedFieldSales.dmpl__DocumentDate__c, 'Document date should be ' + System.today()+1 + '.');
    }
    
    @isTest
    static void updateFieldSalesLinePositive() {
        dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        existingLine.dmpl__Quantity__c = 2;
        existingLine.dmpl__DamagedQuantity__c = 0;
        existingLine.dmpl__SoldQuantity__c = 1;
        existingLine.dmpl__ReceivedQuantity__c = 2;
        update existingLine;
        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine(existingLine.dmpl__FieldSalesId__c);
        System.assertNotEquals(null, retrievedLine, 'Field Sales Line should not be null after update');
        System.assertEquals(2, retrievedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
        System.assertEquals(0, retrievedLine.dmpl__DamagedQuantity__c, 'Damaged quantity should be 0');
        System.assertEquals(1, retrievedLine.dmpl__SoldQuantity__c, 'Sold quantity should be 1');
        System.assertEquals(2, retrievedLine.dmpl__ReceivedQuantity__c, 'Received quantity should be 2');
    }
    
    @isTest
    static void updateFieldSalesInvoicePositive() {
        dmpl__FieldSalesInvoice__c existingInvoice = FieldSalesDataHelper.getFieldSalesInvoice();
        Test.startTest();
        existingInvoice.dmpl__CollectedAmount__c = 200.00;
        existingInvoice.dmpl__InvoiceAmount__c = 200.00;
        update existingInvoice;
        Test.stopTest();
        dmpl__FieldSalesInvoice__c retrievedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(existingInvoice.Id);
        System.assertNotEquals(null, retrievedInvoice, 'Field Sales Invoice should not be null after update');
        System.assertEquals(200.00, retrievedInvoice.dmpl__CollectedAmount__c, 'Collected amount should be updated to 200');
        System.assertEquals(200.00, retrievedInvoice.dmpl__InvoiceAmount__c, 'Invoice amount should be updated to 200');
    }
    
    @isTest
    static void deleteFieldSalesInvoicePositive() {
        dmpl__FieldSalesInvoice__c invoice = FieldSalesDataHelper.getFieldSalesInvoice();
        System.assertNotEquals(null, invoice, 'Field Sales Invoice should not be null');
        Test.startTest();
        try {
            delete invoice;
        } catch (DmlException e) {
            System.assert(false, 'Failed to delete FieldSales: ' + e.getMessage());
        }
        Test.stopTest();
        try {
            dmpl__FieldSalesInvoice__c deletedInvoices = FieldSalesDataHelper.getFieldSalesInvoice();
            System.assertEquals(null, deletedInvoices.Id, 'FieldSales should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Record was successfully deleted');
        }
    }
    
    @isTest
    static void deleteFieldSalesLine() {
        dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        System.assertNotEquals(null, existingLine, 'FieldSalesLine record should not be null');        
        Test.startTest();
        try {
            delete existingLine;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 'Expected DML exception due to trigger error');
            return;
        }
        Test.stopTest();        
        System.assert(false, 'Expected DML exception was not thrown');
    }
    
    @isTest
    static void deleteFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        System.assertNotEquals(null, fieldSales, 'FieldSales record should not be null');        
        Test.startTest();
        try {
            delete fieldSales;
        } catch (DmlException e) {
            System.assert(false, 'Failed to delete FieldSales: ' + e.getMessage());
        }
        Test.stopTest();        
        try {
            dmpl__FieldSales__c deletedSales = FieldSalesDataHelper.getFieldSales();
            System.assertEquals(null, deletedSales.Id, 'FieldSales should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Record was successfully deleted');
        }
    }
    
    @isTest
    static void createFieldSalesWithActivePartnerAccountPositive() {        
        Test.startTest();        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithActiveBranchPositive() {        
        Test.startTest();        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithActiveResourcePositive() {       
        Test.startTest();   
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
        fieldsale.dmpl__ResourceId__c = resource.Id;
        update fieldsale;    
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithVisitPlanReferencePositive() {        
        Test.startTest();      
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__VisitPlan__c plans = VisitPlanTestDataHelpers.getVisitPlan();        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
        fieldsale.dmpl__ResourceId__c = resource.Id;    
        fieldsale.dmpl__VisitPlanId__c = plans.Id;
        update fieldsale;
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals(plans.Id, fetched.dmpl__VisitPlanId__c, 'Visit plans should be correctly set');
    }
    
    @isTest
    static void createFieldSalesWithStorageLocationMappedCorrectlyToBranchPositive() {        
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch .Id);
        fieldsale.dmpl__ResourceId__c = resource.Id;    
        fieldsale.dmpl__StorageLocationId__c = storageLocation.Id;
        update fieldsale;
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch .Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(storageLocation.Id, fetched.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithInactiveResourceIDNegative() {    
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch  = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();        
        resource.dmpl__IsActive__c = false;
        update resource;        
        System.assertEquals(false, resource.dmpl__IsActive__c, 'Resource should be inactive for this negative test');        
        Boolean didThrowException = false;        
        Test.startTest();
        try {            
            dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch .Id);
            fieldsale.dmpl__ResourceId__c = resource.Id;
            update fieldsale;            
        } catch (Exception e) {
            didThrowException = true;
        }
        Test.stopTest();        
        System.assert(didThrowException, 'Expected an exception due to inactive Resource, but none was thrown.');
    }
    
    @isTest
    static void createFieldSalesWithInactivePartnerAccountNegative() {  
        Account partner = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id);
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__Resource__c resource = TestDataHelpers.getResource();        
        resource.dmpl__IsActive__c = false;
        update resource;        
        System.assertEquals(false, resource.dmpl__IsActive__c, 'Resource should be inactive for this negative test');        
        Boolean didThrowException = false;        
        Test.startTest();
        try {            
            dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
            fieldsale.dmpl__ResourceId__c = resource.Id;
            update fieldsale;            
        } catch (Exception e) {
            didThrowException = true;
        }
        Test.stopTest();        
        System.assert(didThrowException, 'Expected an exception due to inactive Resource, but none was thrown.');
    }
    
    @isTest
    static void createFieldSaleInvoiceCreationWithReferenceOfFieldSalesPositive() {        
        Test.startTest();       
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(partner.Id, branch.Id);
        fieldsale.dmpl__ResourceId__c = resource.Id;    
        fieldsale.dmpl__StorageLocationId__c = storageLocation.Id;
        update fieldsale;
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(storageLocation.Id, fetched.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithReferenceOfFieldSalesPositive() {        
        Test.startTest();        
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        Test.stopTest();       
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');        
    } 

    @isTest
    static void createFieldSaleInvoiceWithCollectedAmountEqualToInvoiceAmountPositive() {        
        Test.startTest();        
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id, saleInvoice.Id);
        fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
        fieldSaleInvoice.dmpl__CollectedAmount__c = 5000;
        fieldSaleInvoice.dmpl__InvoiceAmount__c = 5000;
        update fieldSaleInvoice;
        Test.stopTest();        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');        
        System.assertEquals(5000, fetchedInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(5000, fetchedInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
    }
    
    @isTest
    static void createFieldSaleInvoiceLinkedToActiveAccountPositive() {        
        Test.startTest();        
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        Test.stopTest();        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');        
    }
    
    @isTest
    static void createFieldSaleInvoiceWithZeroCollectionPositive() {        
        Test.startTest();    
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
        fieldSaleInvoice.dmpl__CollectedAmount__c = 0;
        fieldSaleInvoice.dmpl__InvoiceAmount__c = 5000;
        update fieldSaleInvoice;
        Test.stopTest();        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');        
        System.assertEquals(5000, fetchedInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(0, fetchedInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithMissingFieldSalesIDNegative() {
        Boolean exceptionThrown = false;        
        Test.startTest();
        try {
            Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();            
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(null, customer.Id);            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();        
        System.assert.isTrue(exceptionThrown, 'Expected exception due to missing FieldSalesId was not thrown.');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithInvoiceIDNotFoundPositive() {
        Boolean exceptionThrown = false;        
        Test.startTest();        
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
            fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
            fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
            update fieldSaleInvoice;
            System.assertEquals(null, fieldSaleInvoice.Name, 'Invoice Name should be generated');            
        } catch (DmlException e) {
            exceptionThrown = true;            
        }
        System.assertEquals(false,exceptionThrown,'exception caught');        
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSaleInvoiceWithCollectedAmountGreaterThanInvoiceAmountNegative() {
        Boolean exceptionThrown = false;        
        Test.startTest();  
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );        
        Decimal collectedAmount = 6000;
        Decimal invoiceAmount = 5000;        
        try {
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
        fieldSaleInvoice.dmpl__CollectedAmount__c = collectedAmount;
        fieldSaleInvoice.dmpl__InvoiceAmount__c = invoiceAmount;
        update fieldSaleInvoice;           
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSaleInvoiceWithNegativeAmountsPositive() {
        Boolean exceptionThrown = false;        
        Test.startTest();       
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        Decimal collectedAmount = -2000;
        Decimal invoiceAmount = 5000;        
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
        fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        fieldSaleInvoice.dmpl__CollectedAmount__c = collectedAmount;
        fieldSaleInvoice.dmpl__InvoiceAmount__c = invoiceAmount;
        update fieldSaleInvoice;
        } catch (DmlException e) {
            exceptionThrown = true;
        }        
        System.assertEquals(fieldSale?.Id, fieldSaleInvoice?.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertEquals(5000, fieldSaleInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(-2000, fieldSaleInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
        Test.stopTest();        
    }
        
    @isTest
    static void createFieldSaleInvoiceWithMissingInvoiceAmountPositive() {
        Boolean exceptionThrown = false;        
        Test.startTest();        
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );        
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
            fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
            fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
            update fieldSaleInvoice;
            System.assertEquals(null, fieldSaleInvoice.Name, 'Invoice Name should be generated');            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(false,exceptionThrown,'Exception thrown');
        Test.stopTest();
    }
        
    @isTest
    static void updateFieldSaleInvoicePositive() {        
        Test.startTest();
        Boolean exceptionThrown = false;    
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer5 = TestDataHelpers.createCustomerAccount('Customer 5');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partner.Id,
            branch.Id,
            resource.Id,
            storageLocation.Id,
            null
        );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSale.Id, customer.Id);
        fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
        update fieldSaleInvoice;        
        try{
            fieldSaleInvoice.dmpl__AccountId__c = customer5.Id;
            update fieldSaleInvoice;
        }catch(Exception e){
            exceptionThrown = true;
        }        
        System.assertEquals(fieldSale.Id, fieldSaleInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        Test.stopTest();        
    }
    
    @isTest
    static void createFieldSaleInvoiceWithMissingFieldSalesNegative() {
        Boolean exceptionThrown = false;        
        Test.startTest();
        try {
            Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();            
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(null, customer.Id);
            fieldSaleInvoice.dmpl__InvoiceId__c = saleInvoice.Id;
            fieldSaleInvoice.dmpl__CollectedAmount__c = 6000;
            fieldSaleInvoice.dmpl__InvoiceAmount__c = 5000;
            update fieldSaleInvoice;            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();        
        System.assert.isTrue(exceptionThrown, 'Expected exception due to missing FieldSalesId was not thrown.');
    }
    
    @isTest
    static void createFieldSalesLineWithoutItemSKUPositive() {        
        Test.startTest();        
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;
        Account partner = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partner);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partner, branch);        
        dmpl__FieldSales__c fieldSales1 = FieldSalesDataHelper.createFieldSales(partner, branch, resource);
        System.assertNotEquals(null, fieldSales1, 'FieldSales record should have been created.');
        Boolean exceptionCaught = false;
        try{
            dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(fieldSales1, item, null);            
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true,exceptionCaught,'expected exception');
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSalesLineWithItemSKUMappedCorrectlyPositive(){        
        Test.startTest();        
        dmpl__Item__c  item = TestDataHelpers.createItem('Item 9', 'Product');
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU 3', item.Id, false);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);        
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.createFieldSales(partnerAccount, branch, resource);        
        dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(fieldSales, item, sku);
        Test.stopTest();        
        System.assertEquals(item.Id, fieldSalesLine.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(sku.Id, fieldSalesLine.dmpl__SKUId__c, 'SKU should match the created SKU');
        System.assertEquals(1, fieldSalesLine.dmpl__Quantity__c, 'Quantity should be 1');
    }
    
    @isTest
    static void createFieldSalesLineWithInactiveItemIDNegative(){        
        Test.startTest();       
        dmpl__Item__c item = TestDataHelpers.createItem('Item 2', 'Product');
        item.dmpl__IsActive__c = false;
        update item;   
        dmpl__FieldSalesLine__c fieldSalesLine;
        try{
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(item.Id, null, 2);
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }catch(Exception e){
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }        
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSalesLineWithQuantityNegative(){        
        Test.startTest();        
        dmpl__Item__c  item = TestDataHelpers.getItem('Item 1');
        dmpl__FieldSalesLine__c fieldSalesLine;
        try{
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(item.Id, null, 0);
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }catch(Exception e){
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }        
        Test.stopTest();
    }
        
    @isTest
    static void createFieldSalesLineWithMismatchedSKUAndItemIDNegative() {        
        Test.startTest();        
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__FieldSalesLine__c fieldSalesLine;
        try {
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(item.Id, sku.Id, 2);
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to mismatched Item and SKU');
        } catch (Exception e) {
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to mismatched Item and SKU');
        }
        Test.stopTest();
    }
        
    @isTest
    static void createFieldSalesLineWithQuantityPopulatedNegative() {        
        Test.startTest();        
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__FieldSalesLine__c fieldSalesLine;        
        try {
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(item.Id, sku.Id, null);
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to null quantity');
        } catch (Exception e) {
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to null quantity');
        }
        Test.stopTest();
    } 
}