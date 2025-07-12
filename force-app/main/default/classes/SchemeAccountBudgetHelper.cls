public class SchemeAccountBudgetHelper {

    public static void upsertAccountBudgetUtilisation(
        List<dmpl__SchemeLedger__c> newEntries){
        List<Id> schemeIds = CollectionHelper.extractIds(
            newEntries, 
            'dmpl__SchemeId__c');
        List<Id> partnerAccountIds = CollectionHelper.extractIds(
            newEntries, 
            'dmpl__PartnerAccountId__c');
        List<dmpl__AccountGroupMember__c> agMemebers = querySchemeAccountGroupMembers(
            partnerAccountIds);
        List<dmpl__SchemeAccountBudget__c> budgets = querySchemeAccountBudgets(
            newEntries,
            partnerAccountIds,
            schemeIds);
        List<dmpl__SchemeAccountBudgetUtilisation__c> utlisations = new List<dmpl__SchemeAccountBudgetUtilisation__c>();
        for(dmpl__SchemeLedger__c ledger : newEntries){
            for(dmpl__SchemeAccountBudget__c budget : budgets){
                if((budget.dmpl__PartnerAccountId__c == null 
                        || budget.dmpl__PartnerAccountId__c == ledger.dmpl__PartnerAccountId__c)
                    && (budget.dmpl__PartnerAccountGroupId__c == null 
                        || doesPartnerAccountGroupExist(
                            agMemebers,
                            ledger.dmpl__PartnerAccountId__c,
                            budget.dmpl__PartnerAccountGroupId__c))){
                    utlisations.add(
                        getUtilisation(
                            ledger,
                            budget)); 
                }
            }
        }
        if(utlisations.size() > 0){
            upsert utlisations;
        }
    }

    public static void deleteAccountBudgetUtilisation(
        List<dmpl__SchemeLedger__c> entries){
        List<dmpl__SchemeAccountBudgetUtilisation__c> utlisations = querySchemeAccountBudgetUtilizations(
            entries);
            if(utlisations.size() > 0){
                delete utlisations;
            }
    }

    private static Boolean doesPartnerAccountGroupExist(
        List<dmpl__AccountGroupMember__c> agMembers,
        Id partnerAccountId,
        Id partnerAccountGroupId){
        for(dmpl__AccountGroupMember__c memeber : agMembers){
            if(memeber.dmpl__AccountId__c == partnerAccountId
                && memeber.dmpl__AccountGroupId__c == partnerAccountGroupId){
                return true;
            }
        }
        return false;
    }

    private static dmpl__SchemeAccountBudgetUtilisation__c getUtilisation(
        dmpl__SchemeLedger__c ledger,
        dmpl__SchemeAccountBudget__c budget){
        dmpl__SchemeAccountBudgetUtilisation__c utilisation = (dmpl__SchemeAccountBudgetUtilisation__c)CollectionHelper.getObject(
            budget.dmpl__SchemeAccountBudgetUtilisations__r, 
            'dmpl__SaleInvoiceLineId__c', 
            ledger.dmpl__SaleInvoiceLineId__c);

        if(utilisation == null){
            utilisation = new dmpl__SchemeAccountBudgetUtilisation__c();
            utilisation.dmpl__SchemeAccountBudgetId__c = budget.Id;
        }
        utilisation.dmpl__SchemeId__c = budget.dmpl__SchemeId__c;
        utilisation.dmpl__SaleInvoiceId__c = ledger.dmpl__SaleInvoiceId__c;
        utilisation.dmpl__SaleInvoiceLineId__c = ledger.dmpl__SaleInvoiceLineId__c;
        utilisation.dmpl__SchemeLedgerId__c = ledger.Id;
        utilisation.dmpl__Amount__c = ledger.dmpl__NetSchemeDiscount2__c;
        return utilisation;
    }

    private static List<dmpl__AccountGroupMember__c> querySchemeAccountGroupMembers(
        List<ID> partnerAccountIds){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__AccountGroupType__c'
        },'dmpl__AccountGroup__c');

        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__AccountId__c',
            'dmpl__AccountGroupId__c'
        },'dmpl__AccountGroupMember__c');

        return [SELECT 
            dmpl__AccountGroupId__c,
            dmpl__AccountId__c
        FROM 
            dmpl__AccountGroupMember__c
        WHERE 
            dmpl__AccountId__c IN : partnerAccountIds
            AND dmpl__AccountGroupId__r.dmpl__AccountGroupType__c = 'Scheme'];
    }    

    private static List<dmpl__SchemeAccountBudgetUtilisation__c> querySchemeAccountBudgetUtilizations(
        List<dmpl__SchemeLedger__c> entries){
            return [SELECT dmpl__SchemeAccountBudgetId__c
            FROM dmpl__SchemeAccountBudgetUtilisation__c
            WHERE 
                dmpl__SchemeLedgerId__c IN : CollectionHelper.extractIds(
                    entries,
                    'dmpl__SchemeLedgerId__c')];
        }

    private static List<dmpl__SchemeAccountBudget__c> querySchemeAccountBudgets(
        List<dmpl__SchemeLedger__c> entries,
        List<Id> partnerAccountIds,
        List<Id> schemeIds){
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__BudgetAmount__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PartnerAccountGroupId__c',
            'dmpl__SchemeId__c',
            'dmpl__BudgetAvailable__c',
            'dmpl__UtilisedAmount__c'
        },'dmpl__SchemeAccountBudget__c');

        return [SELECT ID, 
            dmpl__BudgetAmount__c,
            dmpl__PartnerAccountId__c,
            dmpl__PartnerAccountGroupId__c,
            dmpl__SchemeId__c,
            dmpl__BudgetAvailable__c,
            dmpl__UtilisedAmount__c,
            (SELECT dmpl__SchemeAccountBudgetId__c,
                dmpl__SchemeId__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c,
                dmpl__Amount__c
            FROM dmpl__SchemeAccountBudgetUtilisations__r
            WHERE dmpl__SaleInvoiceLineId__c IN : CollectionHelper.extractIds(
                entries,
                'dmpl__SaleInvoiceLineId__c'))
        FROM dmpl__SchemeAccountBudget__c
        WHERE 
            dmpl__SchemeId__c IN (SELECT dmpl__SchemeId__c FROM dmpl__SchemeLine__c WHERE Id IN : CollectionHelper.extractIds(
                entries,
                'dmpl__SchemeLineId__c'))
            AND (dmpl__PartnerAccountId__c = null 
                OR dmpl__PartnerAccountId__c IN : partnerAccountIds
                OR dmpl__PartnerAccountGroupId__c = null 
                OR dmpl__PartnerAccountGroupId__c IN : partnerAccountIds)];
    }
}