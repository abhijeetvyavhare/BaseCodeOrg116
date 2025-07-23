public with sharing class IncentivePlanMasterData {
    Public static void createScheme(){
        dmpl__Item__c item = TestDataHelpers.createItem('Item 12', 'Product');
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch =TestDataHelpers.createBranch('Branch 1',partner.Id);
        dmpl__Scheme__c scheme = TestDataHelpers.createScheme(
            'Scheme 10',
            partner.Id,
            null,
            branch.Id
        );
        dmpl__SchemeLine__c schemeLine = TestDataHelpers.createSchemeLine(scheme.Id, 'FREE OF COST');
        dmpl__SchemeCondition__c schemeCondition = TestDataHelpers.createSchemeCondition(
            schemeLine.Id,
            scheme.Id,
            'Greater Than Or Equal',
            item.Id,
            15
        );
    }
}