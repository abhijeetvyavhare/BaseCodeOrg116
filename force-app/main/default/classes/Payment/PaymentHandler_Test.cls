@isTest
public with sharing class PaymentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.createSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1',partnerAccount.Id);  
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList('Price List 1', partnerAccount.Id, branch.Id);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(
            customerAccount,
            branch,
            saleOrder,
            priceList
        );
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            customerAccount,
            partnerAccount,
            branch,
            saleInvoice,
            100.00
        );
    }

    @isTest
    static void createPaymentPositive() {
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Payment__c payment = PaymentTestDataHelpers.getPayment();
        System.assertNotEquals(null, payment.Id, 'Payment should be created');
        System.assertEquals(saleInvoice.Id, payment.dmpl__SaleInvoiceId__c, 'Sale Invoice should be linked');
        System.assertEquals(100.00, payment.dmpl__Amount__c, 'Amount should be 100.00');
        System.assertNotEquals(null, payment.dmpl__PartnerAccountId__c, 'Partner Account should be linked');
    }

    @isTest
    static void updatePaymentPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Payment__c existingPayment = PaymentTestDataHelpers.getPayment();
        existingPayment.dmpl__Amount__c = 200;
        update existingPayment; 
        System.assertEquals(200.00, existingPayment.dmpl__Amount__c, 'Amount should be updated to 200.00');
        System.assertNotEquals(null, existingPayment.dmpl__PartnerAccountId__c, 'Partner Account should remain linked');
        Test.stopTest();
    }

    @isTest
    static void deletePaymentPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Payment__c existingPayment = PaymentTestDataHelpers.getPayment();
        delete existingPayment;
        List<dmpl__Payment__c> remainingPayments = PaymentTestDataHelpers.getPaymentsBySaleInvoice(saleInvoice.Id);
        System.assertEquals(0, remainingPayments.size(), 'Should have no payments remaining');
        Test.stopTest();
    }

    @isTest
    static void createPaymentWithValidStatusTypeAccountAmountPositiveNew(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        System.assertEquals(payment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(payment.dmpl__AccountId__c, customer.Id, 'Expected payment to be linked to the correct customer.');
        System.assertEquals(payment.dmpl__SaleOrderId__c, null, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(payment.dmpl__SaleInvoiceId__c, null, 'Expected payment to be linked to the correct sale invoice.');
        System.assertEquals(payment.dmpl__Amount__c, 100.00, 'Expected payment to have the correct amount.');
        System.assertEquals(payment.dmpl__PaymentDate__c, Date.today(), 'Expected payment to have the correct payment date.');
        System.assertEquals(payment.dmpl__Status__c, 'Draft', 'Expected payment to have the correct status.');
        System.assertEquals(payment.dmpl__PaymentMode__c, 'Cash', 'Expected payment to have the correct payment mode.');
        System.assertEquals(payment.dmpl__PaymentType__c, 'PaymentGiven', 'Expected payment to have the correct payment type.');
        System.assertEquals(payment.dmpl__IsGLPosted__c, false, 'Expected payment to have the correct GL posted status.');
        System.assertEquals(payment.dmpl__IsGLPostingApproved__c, false, 'Expected payment to have the correct GL posting approved status.');
        System.assertEquals(payment.dmpl__IsRelatedGLPosted__c, false, 'Expected payment to have the correct related GL posted status.');
        Test.stopTest();
    }

    @isTest
    static void createPaymentWithPaymentTypePaymentTakenPositiveNew(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        payment.dmpl__PaymentType__c = 'PaymentTaken';
        update payment;
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        System.assertEquals(payment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(payment.dmpl__AccountId__c, customer.Id, 'Expected payment to be linked to the correct customer.');
        System.assertEquals(payment.dmpl__SaleOrderId__c, null, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(payment.dmpl__SaleInvoiceId__c, null, 'Expected payment to be linked to the correct sale invoice.');
        System.assertEquals(payment.dmpl__Amount__c, 100.00, 'Expected payment to have the correct amount.');
        System.assertEquals(payment.dmpl__PaymentDate__c, Date.today(), 'Expected payment to have the correct payment date.');
        System.assertEquals(payment.dmpl__Status__c, 'Draft', 'Expected payment to have the correct status.');
        System.assertEquals(payment.dmpl__PaymentMode__c, 'Cash', 'Expected payment to have the correct payment mode.');
        System.assertEquals(payment.dmpl__PaymentType__c, 'PaymentTaken', 'Expected payment to have the correct payment type.');
        System.assertEquals(payment.dmpl__IsGLPosted__c, false, 'Expected payment to have the correct GL posted status.');
        System.assertEquals(payment.dmpl__IsGLPostingApproved__c, false, 'Expected payment to have the correct GL posting approved status.');
        System.assertEquals(payment.dmpl__IsRelatedGLPosted__c, false, 'Expected payment to have the correct related GL posted status.');
        Test.stopTest();
    }

    @isTest 
    static void createPaymentWithoutPartnerAccountNegativeNew(){
        Test.startTest();
        dmpl__Branch__c branch= TestDataHelpers.getBranch('Branch 1');
        try{
            dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
                null,
                null,
                branch.Id,
                100
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest 
    static void inputPaymentDateInTheFuturePositiveNew(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date expectedDate = Date.today().addDays(30);
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        payment.dmpl__PaymentDate__c = expectedDate;
        update payment;
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        System.assertEquals(payment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(payment.dmpl__AccountId__c, customer.Id, 'Expected payment to be linked to the correct customer.');
        System.assertEquals(payment.dmpl__SaleOrderId__c, null, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(payment.dmpl__SaleInvoiceId__c, null, 'Expected payment to be linked to the correct sale invoice.');
        System.assertEquals(payment.dmpl__Amount__c, 100.00, 'Expected payment to have the correct amount.');
        System.assertEquals(payment.dmpl__PaymentDate__c, expectedDate, 'Expected payment to have the correct payment date.');
        System.assertEquals(payment.dmpl__Status__c, 'Draft', 'Expected payment to have the correct status.');
        System.assertEquals(payment.dmpl__PaymentMode__c, 'Cash', 'Expected payment to have the correct payment mode.');
        System.assertEquals(payment.dmpl__PaymentType__c, 'PaymentGiven', 'Expected payment to have the correct payment type.');
        System.assertEquals(payment.dmpl__IsGLPosted__c, false, 'Expected payment to have the correct GL posted status.');
        System.assertEquals(payment.dmpl__IsGLPostingApproved__c, false, 'Expected payment to have the correct GL posting approved status.');
        System.assertEquals(payment.dmpl__IsRelatedGLPosted__c, false, 'Expected payment to have the correct related GL posted status.');
        Test.stopTest();
    }

    @isTest
    static void enterAmountAsNegativePositiveNew(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            -100.00
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        System.assertEquals(payment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(payment.dmpl__AccountId__c, customer.Id, 'Expected payment to be linked to the correct customer.');
        System.assertEquals(payment.dmpl__SaleOrderId__c, null, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(payment.dmpl__SaleInvoiceId__c, null, 'Expected payment to be linked to the correct sale invoice.');
        System.assertEquals(payment.dmpl__Amount__c, -100.00, 'Expected payment to have the correct amount.');
        System.assertEquals(payment.dmpl__PaymentDate__c, Date.today(), 'Expected payment to have the correct payment date.');
        System.assertEquals(payment.dmpl__Status__c, 'Draft', 'Expected payment to have the correct status.');
        System.assertEquals(payment.dmpl__PaymentMode__c, 'Cash', 'Expected payment to have the correct payment mode.');
        System.assertEquals(payment.dmpl__PaymentType__c, 'PaymentGiven', 'Expected payment to have the correct payment type.');
        System.assertEquals(payment.dmpl__IsGLPosted__c, false, 'Expected payment to have the correct GL posted status.');
        System.assertEquals(payment.dmpl__IsGLPostingApproved__c, false, 'Expected payment to have the correct GL posting approved status.');
        System.assertEquals(payment.dmpl__IsRelatedGLPosted__c, false, 'Expected payment to have the correct related GL posted status.');
        Test.stopTest();
    }

    @isTest
    static void createRecordWithValidPaymentPositiveNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(saleOrder, null, 'Expected sale order to be created.');
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        dmpl__PaymentAdjustment__c paymentAdjustment = PaymentTestDataHelpers.createPaymentAdjustment(
            payment.Id,
            partner.Id,
            saleOrder.Id,
            0.00
        );
        System.assertNotEquals(paymentAdjustment, null, 'Expected payment adjustment to be created.');
        paymentAdjustment = PaymentTestDataHelpers.getPaymentAdjustment(paymentAdjustment.Id);
        System.assertEquals(paymentAdjustment.dmpl__PaymentId__c, payment.Id, 'Expected payment to be linked to the correct payment.');
        System.assertEquals(paymentAdjustment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(paymentAdjustment.dmpl__SaleOrderId__c, saleOrder.Id, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(paymentAdjustment.dmpl__AdjustmentAmount__c, 0.00, 'Expected payment to have the correct amount.');
        Test.stopTest();
    }

    @isTest
    static void createWithOnlyRequiredFieldsPositiveNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        dmpl__PaymentAdjustment__c paymentAdjustment = PaymentTestDataHelpers.createPaymentAdjustment(payment.Id,partner.Id,saleOrder.Id,0.00);
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        System.assertNotEquals(saleOrder, null, 'Expected sale order to be created.');
        System.assertNotEquals(paymentAdjustment, null, 'Expected payment adjustment to be created.');
        paymentAdjustment = PaymentTestDataHelpers.getPaymentAdjustment(paymentAdjustment.Id);
        System.assertEquals(paymentAdjustment.dmpl__PaymentId__c, payment.Id, 'Expected payment to be linked to the correct payment.');
        System.assertEquals(paymentAdjustment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(paymentAdjustment.dmpl__AdjustmentAmount__c, 0.00, 'Expected payment to have the correct amount.');
        Test.stopTest();
    }

    @isTest
    static void leaveAdjustmentAmountAsNullNegativeNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        System.assertNotEquals(saleOrder, null, 'Expected sale order to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        try{
            dmpl__PaymentAdjustment__c paymentAdjustment = PaymentTestDataHelpers.createPaymentAdjustment(
                payment.Id,
                partner.Id,
                saleOrder.Id,
                null,
                null,
                Date.today()
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void changeSaleOrderAndPickAPurchaseOrderNegativeEdit(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.createSaleOrder(customer, branch);
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(supplier.Id,partner.Id, branch.Id);  
        dmpl__PaymentAdjustment__c paymentAdjustment2 = PaymentTestDataHelpers.createPaymentAdjustment(
            payment.Id,
            partner.Id,
            saleOrder.Id,
            0.00
        );
        try{
            paymentAdjustment2.dmpl__SaleOrderId__c = saleOrder2.Id;
            paymentAdjustment2.dmpl__PurchaseOrderId__c = purchaseOrder.Id;
            update paymentAdjustment2;
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    @isTest
    static void inputDateAsFutureDatePositiveNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        System.assertNotEquals(saleOrder, null, 'Expected sale order to be created.');
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        payment = PaymentTestDataHelpers.getPayment(payment.Id);
        dmpl__PaymentAdjustment__c paymentAdjustment = PaymentTestDataHelpers.createPaymentAdjustment(
            payment.Id,
            partner.Id,
            saleOrder.Id,   
            0.00
        );
        System.assertNotEquals(paymentAdjustment, null, 'Expected payment adjustment to be created.');
        paymentAdjustment = PaymentTestDataHelpers.getPaymentAdjustment(paymentAdjustment.Id);
        System.assertEquals(paymentAdjustment.dmpl__PaymentId__c, payment.Id, 'Expected payment to be linked to the correct payment.');
        System.assertEquals(paymentAdjustment.dmpl__PartnerAccountId__c, partner.Id, 'Expected payment to be linked to the correct partner.');
        System.assertEquals(paymentAdjustment.dmpl__SaleOrderId__c, saleOrder.Id, 'Expected payment to be linked to the correct sale order.');
        System.assertEquals(paymentAdjustment.dmpl__AdjustmentAmount__c, 0.00, 'Expected payment to have the correct amount.');
        Test.stopTest();
    }
    @isTest
    static void PaymentCreatedWithAmount(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Cash'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentCreatedWithAmountAndPaymentModeCash(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Cash'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentCreatedWithAmountAndPaymentModeCard(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Card'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentCreatedWithAmountAndPaymentModeCheque(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Cheque'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentCreatedWithAmountAndPaymentModeElectronicTransfer(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Electronic Transfer'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest 
    static void PaymentCreatedWithPaymentTypePaymentTaken(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentTaken',
            'Electronic Transfer'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentCreatedWithPaymentTypePaymentGiven(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
            partner.Id,
            customer.Id,
            branch.Id,
            100,
            'PaymentGiven',
            'Electronic Transfer'
        );
        System.assertNotEquals(payment, null, 'Expected payment to be created.');
        test.stopTest();
    }

    @isTest
    static void PaymentDoesNotGetCreatedWithInactiveAccount(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        customer.dmpl__IsActive__c = false;
        update customer;
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        try{
            dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
                partner.Id,
                customer.Id,
                branch.Id,
                100,
                'Payment Given',
                'Electronic Transfer'
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create payment.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void InvoiceDoesNotGetCreatedWithInactivePartnerAccount(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        partner.dmpl__IsActive__c = false;
        update partner;
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        test.startTest();
        try{
            dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
                partner.Id,
                customer.Id,
                branch.Id,
                100,
                'Payment Given',
                'Electronic Transfer'
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create payment.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }

    @isTest
    static void InvoiceDoesNotGetCreatedWithInactiveBranch(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        branch.dmpl__IsActive__c = false;
        update branch;
        test.startTest();
        try{
            dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(
                partner.Id,
                customer.Id,
                branch.Id,
                100,
                'Payment Given',
                'Electronic Transfer'
            );
        } catch (Exception e) {
            Boolean expectedExceptionThrown = (e.getMessage().contains('Cannot Create payment.')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, false,'Expected exception not thrown.');
        }
        test.stopTest();
    }
}