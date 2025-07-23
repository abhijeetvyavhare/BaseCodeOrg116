public with sharing class InsuranceTestDataHelper {
   public static dmpl__Insurer__c createInsuranceOrder(
        String name,
        dmpl__InsuranceScheme__c scheme,
        Account customerAccount,
        String description,
        dmpl__SaleOrder__c saleOrder
    ) {
        return (dmpl__Insurer__c) TestFactory.createSObject(
            new dmpl__Insurer__c(
                Name = name,
                dmpl__Insurance_Scheme__c = scheme != null ? scheme.Id : null,
                dmpl__AccountId__c = customerAccount != null ? customerAccount.Id : null,
                Description__c = description,
                dmpl__Sale_Order__c	 = saleOrder != null ? saleOrder.Id : null
            ),
            true
        );
    }

   public static dmpl__InsuranceOrderLine__c createInsuranceOrderLine(
        dmpl__Insurer__c insurer,
        Decimal insuranceAmount,
        String policyNumber,
        String remarks,
        dmpl__SaleOrderLine__c saleOrderLine
    ) {
        return (dmpl__InsuranceOrderLine__c) TestFactory.createSObject(
            new dmpl__InsuranceOrderLine__c(
                dmpl__InsurerId__c = insurer != null ? insurer.Id : null,
                dmpl__InsuranceAmount__c = insuranceAmount,
                dmpl__PolicyNumber__c = policyNumber,
                dmpl__Remarks__c = remarks,
                dmpl__SaleOrderLineId__c = saleOrderLine != null ? saleOrderLine.Id : null,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__ExpiryDate__c = Date.today().addDays(30),
                dmpl__InsuranceDate__c = Date.today(),
                dmpl__Status__c	= 'Requested'
            ),
            'InsuranceOrderLineDefaults',
            true
        );
    }
}