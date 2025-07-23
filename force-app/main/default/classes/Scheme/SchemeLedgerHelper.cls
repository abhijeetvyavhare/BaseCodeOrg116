public class SchemeLedgerHelper {
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries){
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }        
        }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries){
        try{
            if(isDelete){
                SchemeAccountBudgetHelper.deleteAccountBudgetUtilisation(
                    newEntries);
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries){
            if(isInsert){
                SchemeAccountBudgetHelper.upsertAccountBudgetUtilisation(newEntries);
            }else if(isUpdate){
                List<dmpl__SchemeLedger__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        'dmpl__Discount__c',
                        'dmpl__DiscountAmount__c',
                        'dmpl__LineAmount__c',
                        'dmpl__NetSchemeDiscount2__c'
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size() > 0)
                    SchemeAccountBudgetHelper.upsertAccountBudgetUtilisation(
                        modifiedObjects);
            }
    }

    public static void createLedger(
        List<dmpl__SaleInvoiceLine__c> invoiceLines){
        if(invoiceLines == null || invoiceLines.size() == 0){
            return;
        }
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'Name',
            'dmpl__BranchId__c',
            'dmpl__Discount__c',
            'dmpl__DiscountAmount__c',
            'dmpl__RewardPoints__c',
            'dmpl__LineAmount__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleInvoiceLineId__c',
            'dmpl__SchemeLineId__c',
            'dmpl__SchemeId__c',
            'dmpl__SchemeBenefitId__c',
            'dmpl__AccountId__c'
        }, 'dmpl__SchemeLedger__c');

        List<dmpl__SchemeLedger__c> allLedgers = [
            SELECT 
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__NetSchemeDiscount2__c,
            dmpl__RewardPoints__c,
            dmpl__LineAmount__c,
            dmpl__PartnerAccountId__c,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceLineId__c,
            dmpl__SchemeLineId__c,
            dmpl__SchemeId__c,
            dmpl__SchemeBenefitId__c,
            dmpl__AccountId__c
            FROM 
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__SaleInvoiceLineId__c IN: CollectionHelper.extractIds(invoiceLines)];

        List<dmpl__SchemeLedger__c> deleteLedgers = new List<dmpl__SchemeLedger__c>();
        for(dmpl__SaleInvoiceLine__c siLine : invoiceLines){
            dmpl__SchemeLedger__c ledger = (dmpl__SchemeLedger__c)CollectionHelper.getObject(
                allLedgers, 
                'dmpl__SaleInvoiceLineId__c', 
                siLine.Id);
            if(siLine.dmpl__SchemeLineId__c == null
                || siLine.dmpl__NetSchemeDiscount__c == 0){
                    if(ledger != null){
                        deleteLedgers.add(ledger);
                    }
                continue;
            }else if(ledger == null){
                ledger = new dmpl__SchemeLedger__c();
                allLedgers.add(ledger);
            }

            ledger.dmpl__BranchId__c = Id.valueOf(siLine.dmpl__BranchId__c);
            ledger.dmpl__AccountId__c = Id.valueOf(siLine.dmpl__AccountId__c);
            ledger.dmpl__Discount__c = siLine.dmpl__SchemeDiscount__c;
            ledger.dmpl__DiscountAmount__c = siLine.dmpl__SchemeDiscountAmount__c;
            ledger.dmpl__RewardPoints__c = siLine.dmpl__SchemeRewardPoints__c;
            ledger.dmpl__LineAmount__c = siLine.dmpl__BaseAmount__c;
            ledger.dmpl__PartnerAccountId__c = Id.valueOf(siLine.dmpl__PartnerAccountId__c);
            ledger.dmpl__SaleInvoiceId__c = siLine.dmpl__SaleInvoiceId__c;
            ledger.dmpl__SaleInvoiceLineId__c= siLine.Id;
            ledger.dmpl__SchemeLineId__c = siLine.dmpl__SchemeLineId__c;
            ledger.dmpl__NetSchemeDiscount2__c = siLine.dmpl__NetSchemeDiscount__c;
            ledger.dmpl__SchemeBenefitId__c = siLine.dmpl__BenefitId__c;
        }
        if(allLedgers.size() > 0){
            Database.UpsertResult[] results = Database.upsert(
                allLedgers,
                false);
            List<dmpl__SchemeLedger__c> errorLedgers = new List<dmpl__SchemeLedger__c>();
            for (Database.UpsertResult result : results) {
                if (!result.isSuccess()) {
                    for (Database.Error err : result.getErrors()) {
                        System.debug('Error: ' + err.getMessage());
                    }
                    dmpl__SchemeLedger__c ledger = allLedgers[results.indexOf(result)];
                    if(ledger != null){
                        errorLedgers.add(ledger);
                    }
                }
            }
            if(errorLedgers.size() > 0){
                resetErrorLedgers(errorLedgers);
            }
        }
        if(deleteLedgers.size() > 0){
            delete deleteLedgers;
        }
    }

    public static void deleteLedger(
        List<dmpl__SaleInvoiceLine__c> invoiceLines){
        List<dmpl__SchemeLedger__c> allLedgers = [
            SELECT 
                Id
            FROM 
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__SaleInvoiceLineId__c IN: CollectionHelper.extractIds(invoiceLines)];
        delete allLedgers;
    }

    private static void resetErrorLedgers(
        List<dmpl__SchemeLedger__c> errorLedgers){
        List<dmpl__SaleInvoiceLine__c> invoiceLines = [
            SELECT 
                Id,
                dmpl__SchemeLineId__c,
                dmpl__BenefitId__c,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c
            FROM 
                dmpl__SaleInvoiceLine__c 
            WHERE Id IN :CollectionHelper.extractIds(
                errorLedgers, 
                'dmpl__SaleInvoiceLineId__c')];

        for(dmpl__SaleInvoiceLine__c line : invoiceLines){
            line.dmpl__SchemeLineId__c = null;
            line.dmpl__BenefitId__c = null;
            line.dmpl__SchemeDiscount__c = null;
            line.dmpl__SchemeDiscountAmount__c = null;
        }
        update invoiceLines;
    }
}