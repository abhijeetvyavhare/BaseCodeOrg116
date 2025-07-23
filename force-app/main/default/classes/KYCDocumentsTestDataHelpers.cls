public with sharing class KYCDocumentsTestDataHelpers {
    public static dmpl__KYCDocument__c createKYCDocuments(
        dmpl__SaleOrder__c saleOrder
    ) {
        return (dmpl__KYCDocument__c) TestFactory.createSObject(
            new dmpl__KYCDocument__c(
            dmpl__SaleOrderId__c = saleOrder.Id
            ),
        'KYCDocumentDefaults',
        true
            );
    }
    
   public static dmpl__KYCDocument__c createKYCDocumentCustom(
    dmpl__SaleOrder__c saleOrder,
    dmpl__Branch__c branch,
    String documentType,
    String kycType,
    String documentNumber
) {
    return (dmpl__KYCDocument__c) TestFactory.createSObject(
        new dmpl__KYCDocument__c(
            dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__DocumentType__c = documentType,
            dmpl__KYCType__c = kycType,
            dmpl__DocumentNumber__c = documentNumber
        ),
        'KYCDocumentDefaults',
        true
    );
}

public static dmpl__KYCDocument__c createKYCDocumentCustom(
    dmpl__SaleOrder__c saleOrder,
    dmpl__FinanceCase__c financeCase,
    String documentType,
    String kycType,
    String documentNumber
) {
    return (dmpl__KYCDocument__c) TestFactory.createSObject(
        new dmpl__KYCDocument__c(
            dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__FinanceCaseId__c = financeCase.Id,
            dmpl__DocumentType__c = documentType,
            dmpl__KYCType__c = kycType,
            dmpl__DocumentNumber__c = documentNumber
        ),
        'KYCDocumentDefaults',
        true
    );
}

public static dmpl__KYCDocument__c createKYCDocumentCustom(
    dmpl__SaleOrder__c saleOrder,
    String documentType,
    String kycType,
    String documentNumber
) {
    return (dmpl__KYCDocument__c) TestFactory.createSObject(
        new dmpl__KYCDocument__c(
            dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__DocumentType__c = documentType,
            dmpl__KYCType__c = kycType,
            dmpl__DocumentNumber__c = documentNumber
        ),
        'KYCDocumentDefaults',
        true
    );
}
    
    public static dmpl__KYCDocument__c getKYCDocument() {
        return [
            SELECT Id, dmpl__DocumentNumber__c
            FROM dmpl__KYCDocument__c
            LIMIT 1
        ];
    }
    
    public static dmpl__KYCDocument__c getKYCDocument(Id id) {
        return [
            SELECT Id, dmpl__DocumentNumber__c,dmpl__DocumentType__c,dmpl__KYCType__c,
                   dmpl__SaleOrderId__c,dmpl__SaleOrderLineId__c,dmpl__IsVerified__c,dmpl__FinanceCaseId__c
            FROM dmpl__KYCDocument__c
            WHERE Id = : id
            LIMIT 1
        ];
    }
}