public without sharing class SchemeEngine {

    private  final String SCHEMTYPE_PER_SO = 'Per Sale Order';
    private  final String SCHEMTYPE_PER_PO = 'Per Purchase Order';
    private  final String SCHEMTYPE_PER_SI = 'Per Sale Invoice';
    private  final String SCHEMTYPE_PER_BILL = 'Per Bill';
    private  final String SCHEMTYPE_PER_SOSI = 'Per Sale Order And Invoice';
    private  final String SCHEMTYPE_PER_POBILL = 'Per Purchase Order And Bill';
    private  final String SCHEMTYPE_PER_RO = 'Per Repair Order';
    private  final String SCHEMTYPE_PER_ROSI = 'Per Repair Order And Invoice';
    private  final String SCHEMTYPE_PERPERIOD_SO = 'Per Period Sale Order';
    private  final String SCHEMTYPE_PERPERIOD_PO = 'Per Period Purchase Order';
    private  final String SCHEMTYPE_PERPERIOD_SI = 'Per Period Sale Invoice';
    private  final String SCHEMTYPE_PERPERIOD_BILL = 'Per Period Bill';
    private  final String SCHEMTYPE_PERPERIOD_RO = 'Per Period Repair Order';
    
    private  final String MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED = 'Apply All Fulfilled';
    private  final String MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED = 'Apply First Fulfilled';
    private  final String MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED = 'Apply Last Fulfilled';

    private  final String DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA = 'Always (No Criteria)';
    private  final String DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS = 'All Conditions Are Met';
    private  final String DEFINITION_FILTER_CRITERIA_ANY_CONDITION = 'Any Condition Is Met';
    private  final String DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC = 'Custom Logic Is Met';

    private  final String REWARD_APPLICABILITY_ALL_REWARDS = 'All Rewards';
    private  final String REWARD_APPLICABILITY_ANYONE_LOWESTVALUE = 'Any One With Lowest Value';
    private  final String REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE = 'Any One With Highest Value';
    private  final String REWARD_APPLICABILITY_CUSTOMLOGIC = 'Custom Logic';

    private  final String REWARD_TYPE_LL_DISCOUNT_PERCENT = 'Line Level Discount Percent';
    private  final String REWARD_TYPE_LL_DISCOUNT_AMOUNT = 'Line Level Discount Amount';
    private  final String REWARD_TYPE_DISCOUNTED_ITEM = 'Discounted Item';
    private  final String REWARD_TYPE_DISCOUNTED_ITEMGROUP = 'Discounted Item Group';
    private  final String REWARD_TYPE_REWARDPOINTS = 'Reward Points';

    private  final String CONDITION_TYPE_QUANTITY = 'Quantity';
    private  final String CONDITION_TYPE_VALUE = 'Value';
    private  final String CONDITION_TYPE_VALUE_WITHTAX = 'Value With Tax';
    private  final String CONDITION_TYPE_ITEM_QUANTITY = 'Item Quantity';
    private  final String CONDITION_TYPE_ITEM_VALUE = 'Item Value';
    private  final String CONDITION_TYPE_ITEM_VALUE_WITHTAX = 'Item Value With Tax';
    private  final String CONDITION_TYPE_ITEMGROUP_QUANTITY = 'Item Group Quantity';
    private  final String CONDITION_TYPE_ITEMGROUP_VALUE = 'Item Group Value';
    private  final String CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX = 'Item Group Value With Tax';

    private  final String CONDITION_OPERATOR_EQUALS = 'Equals';
    private  final String CONDITION_OPERATOR_DOSESNOT_EQUALS = 'Does Not Equal';
    private  final String CONDITION_OPERATOR_GREATER_THAN = 'Greater Than';
    private  final String CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS = 'Greater Than Or Equal';
    private  final String CONDITION_OPERATOR_LESS_THAN = 'Less Than';
    private  final String CONDITION_OPERATOR_LESSTHAN_OR_EQUALS = 'Less Than Or Equal';

    private  final String ROUNDOFFTYPE_CEIL = 'ceil';
    private  final String ROUNDOFFTYPE_FLOOR = 'floor';

    private  final String DISCOUNTED_ITEM_RANKING_DECENDING = 'High To Low';    
    private  final String STATUS_APPROVED = 'Approved';

    private  Boolean isAlreadyProcessing =false;
    
    private SObject document;
    private String schemeType;
    private String perPeriodSchemeType;

    private Date documentDate;
    private List<SObject> allLines;
    private List<SObject> insertedLines;
    private List<SObject> deletedLines;
    private Map<Id, SObject> updatedLines;
    private List<SchemeLine__c> activeSchemeLines;

    private List<dmpl__SchemeAccountBudget__c> accountBudgets;
    private List<AggregateResult> documentSummary;
    private List<dmpl__PerformanceKPI__c> periodSummary;

    private Id partnerAccountId;
    private Id accountId;
    private Id parentAccountId;
    private String transactionType;
    private List<Id> partnerAccountGroupIds;
    private List<Id> accountGroupIds;
    private List<Id> documentItemIds;
    private Map<Id, List<dmpl__ItemGroupMember__c>> itemGroups;

    private Boolean isQualifying;
    private Boolean isAutoApply;
    private Id applyBenefit;
    private Integer applyBenefitCustomIndex;
    private List<SourceObjectInfo> preferedItemList;
    List<String> fieldNames = new List<String>();

    private List<SchemeLine__c> qualifiedSchemeLines;
    private Id applySchemeLineId;

    public static void processSchemes(
        List<SObject> documents){
        for(SObject aObject : documents){
            SchemeEngine engine = new SchemeEngine(
                aObject,
                false,
                true);
            engine.process();
        }
    }
    
    public static Boolean applySchemeBenefit(
        SObject document,
        Id schemeLineId,
        Id benefitId,
        Integer benefitCustomIndex,
        List<SourceObjectInfo> selectedItemInfo){
        SchemeEngine engine = new SchemeEngine(
            document,
            schemeLineId,
            benefitId,
            benefitCustomIndex,
            selectedItemInfo);
        return engine.process();
    }

    public static Boolean resetSchemeBenefit(
        SObject document){
        SchemeEngine engine = new SchemeEngine(
            document,
            false,
            false);
        return engine.reset();
    }
    
    public static List<SchemeLine__c> getQualifiedSchemeLines(
        SObject document){
        SchemeEngine engine = new SchemeEngine(
            document,
            true,
            false);
        engine.process();
        return engine.qualifiedSchemeLines;
    }

    private SchemeEngine(
        SObject pDocument,
        Boolean pIsQualifying,
        Boolean pIsAutoApply){
        document = pDocument;
        isQualifying = pIsQualifying;
        isAutoApply = pIsAutoApply;
    }
    
    private SchemeEngine(
        SObject pDocument,
        Id schemeLineId,
        Id benefitId,
        Integer benefitCustomIndex,
        List<SourceObjectInfo> selectedItemInfo){
        isQualifying = false;
        isAutoApply = false;
        document = pDocument;
        applySchemeLineId = schemeLineId;
        applyBenefit = benefitId;
        applyBenefitCustomIndex = benefitCustomIndex;
        preferedItemList = selectedItemInfo;
    }

    private Boolean process(){
        if(isAlreadyProcessing 
            || document == null
            || (Boolean)document.get('dmpl__SkipScheme__c')){
            return false;
        }
        //
        isAlreadyProcessing = true;
        //        
        setDocumentDefaults();
        setDocumentSummary();
        setItemGroups();
        activeSchemeLines = getActiveSchemeLines(false);
        accountBudgets = getSchemeAccountBudgets();
        activeSchemeLines = filterActiveSchemeLines();
        periodSummary = getPeriodSummary();
        setPeriodItemGroups();
        Map<Id, SchemeLineResult> schemeLineResults = new Map<Id,SchemeLineResult>();
        for(SchemeLine__c  schemeLine : activeSchemeLines){
            if(isPerDocumentScheme(schemeLine)){
                schemeLineResults.put(
                    schemeLine.Id, 
                    evaluatePerDocumentSchemeLine(schemeLine));
            }else if(isPerPeriodScheme(schemeLine)){
                schemeLineResults.put(
                    schemeLine.Id, 
                    evaluatePerPeriodSchemeLine(
                        schemeLine));
            }
        }
        //
        List<Id> ignoredSchemeLines = getIgnoredSchemeLines(schemeLineResults);
        if(isQualifying){
            qualifiedSchemeLines = getQualifyingSchemeLines(
                schemeLineResults, 
                ignoredSchemeLines);
            isAlreadyProcessing = false;
            return true;
        }
        
        updatedLines = new Map<Id, sObject>();
        insertedLines = new List<sObject>();
        deletedLines = new List<sObject>();
        allLines = getDocumentLines();
        fieldNames = new List<String>(allLines.getSObjectType().getDescribe().fields.getMap().keySet());
        resetDocumentSchemeLine();
        for(SchemeLine__c  schemeLine : activeSchemeLines){
            if(ignoredSchemeLines.contains(schemeLine.Id)){
                System.debug('Ignoring' + schemeLine.Name);
                continue;
            }
            if(isPerDocumentScheme(schemeLine)
                || isPerPeriodScheme(schemeLine)){
                //        
                if(isSchemeApplicable(
                    schemeLineResults.get(schemeLine.Id),
                    schemeLine)){
                    applyPerDocumentSchemeLine(
                        schemeLine,
                        schemeLineResults.get(schemeLine.Id));    
                    }
                }
        }
        upsertLines();
        deleteLines();
        isAlreadyProcessing = false;
        return true;
    }

    private Boolean reset(){
        if(isAlreadyProcessing 
            || document == null
            || (Boolean)document.get('dmpl__SkipScheme__c')){
            return false;
        }
        //
        isAlreadyProcessing = true;
        //        
        deletedLines = new List<sObject>();
        setDocumentDefaults();
        setDocumentSummary();
        setItemGroups();
        activeSchemeLines = getActiveSchemeLines(false);
        activeSchemeLines = filterActiveSchemeLines();
        updatedLines = new Map<Id, sObject>();
        insertedLines = new List<sObject>();
        allLines = getDocumentLines();
        periodSummary = getPeriodSummary();
        setPeriodItemGroups();
        resetDocumentSchemeLine();
        upsertLines();
        deleteLines();
        isAlreadyProcessing = false;
        //
        return true;
    }

    private Boolean isPerDocumentScheme(
        SchemeLine__c  schemeLine){
        return schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_SO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_SI 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_PO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_RO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_BILL 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_SOSI 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_POBILL 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PER_ROSI;
    }

    private Boolean isPerPeriodScheme(
        SchemeLine__c  schemeLine){
        return  schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO 
                || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL;
    }

    private  Boolean isSchemeApplicable(
        SchemeLineResult result,
        SchemeLine__c schemeLine){
            if(result == null 
                || result.qualificationCount == null
                || result.qualificationCount <= 0){
                    return false;
                }
            if(schemeLine.dmpl__SchemeId__r.dmpl__Application__c == 'Auto Apply'){
                return applySchemeLineId == null;
            } else if(schemeLine.dmpl__SchemeId__r.dmpl__Application__c == 'Apply On Selection'){
                return applySchemeLineId == schemeLine.Id;
            }
            return false;
        }

    private List<dmpl__SchemeLine__c> getQualifyingSchemeLines(
        Map<Id, SchemeLineResult> results, 
        List<Id> ignoredSchemeLines){
        List<SchemeLine__c> qualifiedLines = new List<SchemeLine__c>();
        for(SchemeLine__c schemeLine : activeSchemeLines){
            if(results.containsKey(schemeLine.Id)
                && results.get(schemeLine.Id)?.qualificationCount > 0
                && !ignoredSchemeLines.contains(schemeLine.Id)){
                    qualifiedLines.add(schemeLine);
                }
        }
        return qualifiedLines;
    }

    private void setItemGroups(){
        documentItemIds = CollectionHelper.extractIds(
            documentSummary, 
            'dmpl__ItemId__c');
        itemGroups = (Map<Id, List<dmpl__ItemGroupMember__c>>)CollectionHelper.mapFromCollectionWithCollectionValues( 
            'dmpl__ItemGroupId__c',
            ItemGroupHelper.getCachedItemGroupIds(
                'Scheme', 
                documentItemIds));
    }

    private void setPeriodItemGroups(){
        documentItemIds.addAll(CollectionHelper.extractIds(
            periodSummary, 
            'dmpl__ItemId__c'));
        itemGroups = (Map<Id, List<dmpl__ItemGroupMember__c>>)CollectionHelper.mapFromCollectionWithCollectionValues( 
            'dmpl__ItemGroupId__c',
            ItemGroupHelper.getCachedItemGroupIds(
                'Scheme', 
                documentItemIds));
    }

    private void setDocumentDefaults(){
        if(document == null){
            return;
        }
        if(document.getSObjectType().getDescribe().name == 'dmpl__SaleOrder__c'){
            dmpl__SaleOrder__c saleOrder = (dmpl__SaleOrder__c)document;
            accountId = saleOrder.dmpl__AccountId__c;
            partnerAccountId = saleOrder.dmpl__PartnerAccountId__c;
            schemeType = SCHEMTYPE_PER_SO;
            perPeriodSchemeType = SCHEMTYPE_PERPERIOD_SO;
            documentDate = saleOrder.dmpl__DocumentDate__c;
            transactionType = saleOrder.dmpl__TransactionType__c;
        } else if(document.getSObjectType().getDescribe().name == 'dmpl__PurchaseOrder__c'){
            dmpl__PurchaseOrder__c purchaseOrder = (dmpl__PurchaseOrder__c)document;
            accountId = purchaseOrder.dmpl__SupplierAccountId__c;
            partnerAccountId = purchaseOrder.dmpl__PartnerAccountId__c;
            schemeType = SCHEMTYPE_PER_PO;
            perPeriodSchemeType = SCHEMTYPE_PERPERIOD_PO;
            documentDate = purchaseOrder.dmpl__DocumentDate__c;
            transactionType = purchaseOrder.dmpl__TransactionType__c;
        } else if(document.getSObjectType().getDescribe().name == 'dmpl__SaleInvoice__c'){
            dmpl__SaleInvoice__c saleInvoice = (dmpl__SaleInvoice__c)document;
            accountId = saleInvoice.dmpl__AccountId__c;
            partnerAccountId = saleInvoice.dmpl__PartnerAccountId__c;
            schemeType = SCHEMTYPE_PER_SI;
            perPeriodSchemeType = SCHEMTYPE_PERPERIOD_SI;
            documentDate = saleInvoice.dmpl__DocumentDate__c;
            transactionType = saleInvoice.dmpl__TransactionType__c;
        } else if(document.getSObjectType().getDescribe().name == 'dmpl__Bill__c'){
            dmpl__Bill__c bill = (dmpl__Bill__c)document;
            accountId = bill.dmpl__SupplierAccountId__c;
            partnerAccountId = bill.dmpl__PartnerAccountId__c;
            schemeType = SCHEMTYPE_PER_BILL;
            perPeriodSchemeType = SCHEMTYPE_PERPERIOD_BILL;
            documentDate = bill.dmpl__DocumentDate__c;
            transactionType = bill.dmpl__TransactionType__c;
        } else if(document.getSObjectType().getDescribe().name == 'dmpl__RepairOrder__c'){
            dmpl__RepairOrder__c repairOrder = (dmpl__RepairOrder__c)document;
            accountId = repairOrder.dmpl__AccountId__c;
            partnerAccountId = repairOrder.dmpl__PartnerAccountId__c;
            schemeType = SCHEMTYPE_PER_RO;
            perPeriodSchemeType = SCHEMTYPE_PERPERIOD_RO;
            documentDate = repairOrder.dmpl__DocumentDate__c;
            transactionType = repairOrder.dmpl__TransactionType__c;
        }
        accountGroupIds = AccountGroupHelper.getCachedAccountGroupIds(
            'Scheme',
            accountId);
        partnerAccountGroupIds = AccountGroupHelper.getCachedAccountGroupIds(
            'Scheme',
            partnerAccountId);
    }

    private List<dmpl__SchemeLine__c> filterActiveSchemeLines(){
        List<dmpl__SchemeLine__c> filteredSchemeLines = new List<dmpl__SchemeLine__c>();
        if(applySchemeLineId != null){
            filteredSchemeLines = DocumentHelper.getObjectsByFilter(
                activeSchemeLines, 
                'Id', 
                applySchemeLineId);
        }

        for(dmpl__SchemeLine__c schemeLine : activeSchemeLines){
            if(isSchemeLineBudgetAvailable(
                schemeLine,
                0)){
                filteredSchemeLines.add(schemeLine);
            }
        }
        return filteredSchemeLines;
    }

    private Boolean isSchemeLineBudgetAvailable(
        SchemeLine__c schemeLine, 
        Decimal schemeDiscountAmount){
        if(schemeDiscountAmount == null
            || schemeDiscountAmount <= 0){
            schemeDiscountAmount = 1;
        }
        return isSchemeLevelBudgetAvailable(schemeDiscountAmount)
            && (isAccountLevelBudgetAvailable(schemeDiscountAmount)
            || isAccountGroupLevelBudgetAvailable(schemeDiscountAmount));
    }

    private Boolean isSchemeLevelBudgetAvailable(Decimal schemeDiscountAmount){
        for(dmpl__SchemeAccountBudget__c accountBudget : accountBudgets){
            if(accountBudget.dmpl__PartnerAccountId__c == null 
                && accountBudget.dmpl__PartnerAccountGroupId__c == null){
                    return accountBudget.dmpl__BudgetAvailable__c >= schemeDiscountAmount;
            }
        }
        return false;
    }

    private Boolean isAccountLevelBudgetAvailable(Decimal schemeDiscountAmount){
        for(dmpl__SchemeAccountBudget__c accountBudget : accountBudgets){
            if(accountBudget.dmpl__PartnerAccountId__c == partnerAccountId 
                && accountBudget.dmpl__PartnerAccountGroupId__c == null){
                    return accountBudget.dmpl__BudgetAvailable__c >= schemeDiscountAmount;
            }
        }
        return false;
    }

    private Boolean isAccountGroupLevelBudgetAvailable(Decimal schemeDiscountAmount){
        for(dmpl__SchemeAccountBudget__c accountBudget : accountBudgets){
            if(accountBudget.dmpl__PartnerAccountId__c == null 
                && partnerAccountGroupIds.contains(accountBudget.dmpl__PartnerAccountGroupId__c)){
                    return accountBudget.dmpl__BudgetAvailable__c >= schemeDiscountAmount;
            }
        }
        return false;
    }

    private List<dmpl__SchemeLine__c> getActiveSchemeLines(
        Boolean getAllApplication){
        List<String> application = new List<String>();
        if(getAllApplication || isAutoApply){
            application.add('Auto Apply');
        }
        if(getAllApplication || !isAutoApply){
            application.add('Apply On Selection');
        }
        List<String> schemeTypes = new List<String>();
        schemeTypes.add(schemeType);
        schemeTypes.add(perPeriodSchemeType);
        if(schemeType == SCHEMTYPE_PER_SO 
            ||schemeType == SCHEMTYPE_PER_SI){
            schemeTypes.add(SCHEMTYPE_PER_SOSI);
        } else if (schemeType == SCHEMTYPE_PER_PO
            || schemeType == SCHEMTYPE_PER_BILL){
            schemeTypes.add(SCHEMTYPE_PER_POBILL);
        } else if (schemeType == SCHEMTYPE_PER_RO
            || schemeType == SCHEMTYPE_PER_SI){
            schemeTypes.add(SCHEMTYPE_PER_ROSI);

        } else if (perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SO){
            schemeTypes.add(SCHEMTYPE_PERPERIOD_SO);
        }  else if (perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SI){
            schemeTypes.add(SCHEMTYPE_PERPERIOD_SI);
        }  else if (perPeriodSchemeType == SCHEMTYPE_PERPERIOD_RO){
            schemeTypes.add(SCHEMTYPE_PERPERIOD_RO);
        }else if (perPeriodSchemeType == SCHEMTYPE_PERPERIOD_PO){
            schemeTypes.add(SCHEMTYPE_PERPERIOD_PO);
        }  else if (perPeriodSchemeType == SCHEMTYPE_PERPERIOD_BILL){
            schemeTypes.add(SCHEMTYPE_PERPERIOD_BILL);
        }

        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeType__c',
            'dmpl__PeriodType__c',
            'dmpl__SchemeBudget__c',
            'dmpl__UtilizedAmount__c',
            'dmpl__MultipleFulfilmentTreatment__c',
            'dmpl__IncludeChildAccountTransactions__c',
            'dmpl__IncludeRelatedAccountTransactions__c'
        }, 'dmpl__Scheme__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__DefinitionFilterCriteria__c',
                'dmpl__DefinitionCustomLogic__c',
                'dmpl__RewardApplicability__c'
            }, 'dmpl__SchemeLine__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__ConditionType__c',
                'dmpl__ConditionOperator__c',
                'dmpl__AccountId__c',
                'dmpl__AccountGroupId__c',
                'dmpl__ItemId__c',
                'dmpl__ItemGroupId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__ConditionQuantity__c',
                'dmpl__ConditionValue__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeCondition__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__DiscountAmount__c',
                'dmpl__DiscountPercent__c',
                'dmpl__DiscountedItemId__c',
                'dmpl__DiscountedItemLotTypeId__c',
                'dmpl__DiscountedItemSKUId__c',
                'dmpl__DiscountedItemGroupId__c',
                'dmpl__DiscountedItemQuantity__c',
                'dmpl__RewardPoints__c',
                'dmpl__RewardType__c',
                'dmpl__RepeatReward__c',
                'dmpl__ExcludeQualifyingItems__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeBenefit__c');
        List<dmpl__SchemeLine__c> schemeLines = [
            SELECT
            Id,
            Name,
            dmpl__Title__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__AbsoluteSequenceNumber__c,
            dmpl__UseLowerConditionRatio__c,
            dmpl__SchemeId__r.Id,
            dmpl__SchemeId__r.Name,
            dmpl__SchemeId__r.dmpl__RoundOffType__c,
            dmpl__SchemeId__r.dmpl__SchemeType__c,
            dmpl__SchemeId__r.dmpl__PeriodType__c,
            dmpl__SchemeId__r.dmpl__SchemeBudget__c,
            dmpl__SchemeId__r.dmpl__UtilizedAmount__c,
            dmpl__SchemeId__r.dmpl__MultipleFulfilmentTreatment__c,
            dmpl__SchemeId__r.dmpl__Application__c,
            dmpl__SchemeId__r.dmpl__ValidCount__c,
            dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c,
            dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c,
            dmpl__SchemeId__r.dmpl__IgnoreBudget__c,
            dmpl__SchemeId__r.dmpl__SequenceNumber__c,
            (
                SELECT 
                Id,
                Name,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemSKUId__c,
                dmpl__ItemSKUId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__ConditionQuantity__c,
                dmpl__ConditionValue__c,
                dmpl__RoundOffConditionQuantity__c
            FROM 
                dmpl__SchemeConditions__r
            WHERE 
                (dmpl__AccountId__c = NULL OR dmpl__AccountId__c =: accountId)
                AND (dmpl__AccountGroupId__c = NULL OR dmpl__AccountGroupId__c IN : accountGroupIds)
                AND (dmpl__ItemId__c = NULL OR dmpl__ItemId__c IN :documentItemIds OR dmpl__ItemGroupId__c IN : itemGroups.keySet())
                ORDER BY dmpl__SequenceNumber__c ASC
            ),
            (
                SELECT
                Id,
                dmpl__SchemeLineId__c,
                Name,
                dmpl__Title__c,
                dmpl__DiscountAmount__c,
                dmpl__DiscountPercent__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemLotTypeId__c,
                dmpl__DiscountedItemId__r.Name,
                dmpl__DiscountedItemSKUId__c,
                dmpl__DiscountedItemSKUId__r.Name,
                dmpl__DiscountedItemGroupId__c,
                dmpl__DiscountedItemGroupId__r.Name,
                dmpl__DiscountedItemQuantity__c,
                dmpl__RewardPoints__c,
                dmpl__RewardType__c,
                dmpl__RepeatReward__c,
                dmpl__RepeatRewardsInRatio__c,
                dmpl__ExcludeQualifyingItems__c,
                dmpl__DiscountedItemRanking__c,
                dmpl__LimitExpiryDays__c
                FROM 
                    dmpl__SchemeBenefits__r
                ORDER BY dmpl__SequenceNumber__c ASC
            )
            FROM 
                dmpl__SchemeLine__c
            WHERE
                dmpl__SchemeId__c IN 
                (SELECT
                    Id
                FROM 
                    dmpl__Scheme__c
                WHERE
                    (dmpl__PartnerAccountId__c = NULL OR dmpl__PartnerAccountId__c =: partnerAccountId)
                    AND (dmpl__PartnerAccountGroupId__c = NULL OR dmpl__PartnerAccountGroupId__c IN :partnerAccountGroupIds)
                    AND (dmpl__AccountId__c = NULL OR dmpl__AccountId__c =: accountId)
                    AND (dmpl__AccountGroupId__c = NULL OR dmpl__AccountGroupId__c IN :accountGroupIds)
                    AND (dmpl__ValidFrom__c <= : documentDate OR dmpl__ValidFrom__c = null)
                    AND (dmpl__ValidTo__c >= : documentDate OR dmpl__ValidTo__c = NULL)
                    AND dmpl__Status__c =: STATUS_APPROVED
                    AND (dmpl__ApplicableTransactionType__c = NULL OR dmpl__ApplicableTransactionType__c =: transactionType)
                    AND dmpl__Application__c  IN : application
                    AND dmpl__SchemeType__c IN : schemeTypes)
                
            ORDER BY 
                dmpl__AbsoluteSequenceNumber__c ASC,
                dmpl__SequenceNumber__c ASC
        ];
        return schemeLines;
    }

    private List<dmpl__SchemeAccountBudget__c> getSchemeAccountBudgets(){
        List<Id> schemeIds = DocumentHelper.extractIds(
            activeSchemeLines, 
            'dmpl__SchemeId__c');
        return [
            Select 
                dmpl__BudgetAmount__c,
                dmpl__UtilizedAmount__c,
                dmpl__BudgetAvailable__c,
                dmpl__UtilisedAmount__c,
                dmpl__PartnerAccountId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__SchemeId__c
            FROM
                dmpl__SchemeAccountBudget__c
            WHERE
                dmpl__SchemeId__c IN :schemeIds 
            AND 
                ((dmpl__PartnerAccountId__c = NULL AND dmpl__PartnerAccountGroupId__c = NULL)
                OR (dmpl__PartnerAccountId__c =: partnerAccountId)
                OR (dmpl__PartnerAccountGroupId__c IN: partnerAccountGroupIds))];
    }

    @testVisible
    private  List<AggregateResult> queryAppliedSchemes(List<Id> schemeIds){
        if(schemeType == SCHEMTYPE_PER_SO || schemeType == SCHEMTYPE_PERPERIOD_SO){
            return [
                SELECT 
                    dmpl__SchemeId__c SchemeId,
                    COUNT_DISTINCT(dmpl__SaleOrderId__c) ApplyCount
                FROM
                    dmpl__SchemeLedger__c
                WHERE 
                    dmpl__SchemeId__c IN :schemeIds
                    AND dmpl__AccountId__c = :accountId
                    AND dmpl__SaleOrderId__c != :document.Id
                GROUP By
                    dmpl__SchemeId__c
            ];
        } else if(schemeType == SCHEMTYPE_PER_PO){
            return [
                SELECT 
                    dmpl__SchemeId__c SchemeId,
                    COUNT_DISTINCT(dmpl__PurchaseOrderId__c) ApplyCount
                FROM
                    dmpl__SchemeLedger__c
                WHERE 
                    dmpl__SchemeId__c IN:schemeIds
                    AND dmpl__AccountId__c =:accountId
                    AND dmpl__PurchaseOrderId__c != :document.Id
                GROUP By
                    dmpl__SchemeId__c
            ];
        } else if(schemeType == SCHEMTYPE_PER_SI || schemeType == SCHEMTYPE_PERPERIOD_SI){
            return [
                SELECT 
                    dmpl__SchemeId__c SchemeId,
                    COUNT_DISTINCT(dmpl__SaleInvoiceId__c) ApplyCount
                FROM
                    dmpl__SchemeLedger__c
                WHERE 
                    dmpl__SchemeId__c IN:schemeIds
                    AND dmpl__AccountId__c =:accountId
                    AND dmpl__SaleInvoiceId__c != :document.Id
                GROUP By
                    dmpl__SchemeId__c
            ];
        } else if(schemeType == SCHEMTYPE_PER_BILL){
            return [
                SELECT 
                    dmpl__SchemeId__c SchemeId,
                    COUNT_DISTINCT(dmpl__BillId__c) ApplyCount
                FROM
                    dmpl__SchemeLedger__c
                WHERE 
                    dmpl__SchemeId__c IN:schemeIds
                    AND dmpl__AccountId__c =:accountId
                    AND dmpl__BillId__c != :document.Id
                GROUP By
                    dmpl__SchemeId__c
            ];
        } else if(schemeType == SCHEMTYPE_PER_RO){
            return [
                SELECT 
                    dmpl__SchemeId__c SchemeId,
                    COUNT_DISTINCT(dmpl__RepairOrderId__c) ApplyCount
                FROM
                    dmpl__SchemeLedger__c
                WHERE 
                    dmpl__SchemeId__c IN:schemeIds
                    AND dmpl__AccountId__c =:accountId
                    AND dmpl__RepairOrderId__c != :document.Id
                GROUP By
                    dmpl__SchemeId__c
            ];
        }
        return null;
    }

    private  List<Id> getIgnoredSchemeLines(
        Map<Id, SchemeLineResult> perDocumentResults){
        List<Id> ignoredSchemeLines = new List<Id>();
        Map<Id, SchemeLine__c> consolidatedSchemes = new Map<Id, SchemeLine__c>();
        List<Id> validCountSchemes = new List<Id>();
        for(SchemeLine__c schemeLine : activeSchemeLines){
            if(schemeLine == null){
                continue;
            }
            if(schemeLine.dmpl__SchemeId__r.dmpl__ValidCount__c>0){
                if(!validCountSchemes.contains(schemeLine.dmpl__SchemeId__r.Id)){
                    validCountSchemes.add(schemeLine.dmpl__SchemeId__r.Id);
                }
            }
            if((perDocumentResults.get(schemeLine.Id) != null 
                    && perDocumentResults.get(schemeLine.Id)?.qualificationCount ==0) 
                || schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED){
                continue;
            }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED){
                if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
                    ignoredSchemeLines.add(schemeLine.Id);
                }else {
                    consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                }
            }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED){
                if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
                    SchemeLine__c oldLine = consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                    ignoredSchemeLines.add(oldLine.Id);
                }else {
                    consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                }
            }
        }

        if(validCountSchemes.size()>0){
            List<AggregateResult> appliedSchemes = queryAppliedSchemes(validCountSchemes);
            System.debug('ValidCount' + appliedSchemes);
            if(appliedSchemes!=null){
                for(AggregateResult result : appliedSchemes){
                    for(SchemeLine__c  schemeLine : activeSchemeLines){
                        if(schemeLine.dmpl__SchemeId__r.Id == (Id)result.get('SchemeId')
                            && schemeLine.dmpl__SchemeId__r.dmpl__ValidCount__c >0
                            && Integer.valueOf(result.get('ApplyCount')) >= schemeLine.dmpl__SchemeId__r.dmpl__ValidCount__c
                            && !ignoredSchemeLines.contains(schemeLine.Id)){
                                ignoredSchemeLines.add(schemeLine.Id);
                                System.debug('Ignoring Valid Count' + schemeLine);
                            }
                    }
                }
            }
        }
        //
        return ignoredSchemeLines;
    }

    @testvisible
    private  SchemeLineResult evaluatePerDocumentSchemeLine(SchemeLine__c schemeLine){
        SchemeLineResult lineResult = new SchemeLineResult(schemeLine);
        if(schemeLine.DefinitionFilterCriteria__c == DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA){
            lineResult.qualificationCount = 1;
            lineResult.targetToAchivementRatio = 1;
            return lineResult;
        }
        //
        lineResult.conditionResults = new List<SchemeConditionResult>();
        for(SchemeCondition__c  condition : schemeLine.SchemeConditions__r){
            lineResult.conditionResults.add(
                evaluatePerDocumentCondition(condition, schemeLine));
        }
        //
       return evaluateConditions(
            lineResult,
            schemeLine.DefinitionFilterCriteria__c, 
            schemeLine.dmpl__DefinitionCustomLogic__c);
    }

    private  SchemeLineResult evaluatePerPeriodSchemeLine(SchemeLine__c schemeLine){
        SchemeLineResult lineResult = new SchemeLineResult(schemeLine);
        if(schemeLine.DefinitionFilterCriteria__c == DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA){
            lineResult.qualificationCount = 1;
            lineResult.targetToAchivementRatio = 1;
            return lineResult;
        }
        //
        lineResult.conditionResults = new List<SchemeConditionResult>();
        for(SchemeCondition__c  condition : schemeLine.SchemeConditions__r){
            lineResult.conditionResults.add(
                evaluatePerPeriodCondition(condition, schemeLine));
        }
        //
       return evaluateConditions(
            lineResult,
            schemeLine.DefinitionFilterCriteria__c, 
            schemeLine.dmpl__DefinitionCustomLogic__c);
    }
    
    @testVisible
    private  void applyPerDocumentSchemeLine(
        SchemeLine__c schemeLine, 
        SchemeLineResult lineResult)
    {
        string periodType = schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c;

        if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ALL_REWARDS){
            for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
                applyPerDocumentBenefit(
                    benefit, 
                    lineResult,
                    periodType);
            }
        } else if(applyBenefit !=null
            && (schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_LOWESTVALUE
                || schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE)){
            for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
                if(benefit.Id == applyBenefit){
                    applyPerDocumentBenefit(
                        benefit, 
                        lineResult,
                        periodType);    
                }
            }
        } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_LOWESTVALUE){
            applyPerDocumentBenefit(
                getMinimumBenefit(schemeLine), 
                lineResult,
                periodType);
        } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE){
            applyPerDocumentBenefit(
                getMaximumBenefit(schemeLine),
                lineResult,
                periodType);
        } else if(
            schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_CUSTOMLOGIC
            && applyBenefitCustomIndex > -1){
                List<SchemeBenefit__c> applicableBenefits= getCustomApplicableBenefits(
                    schemeLine);
                    if(applicableBenefits!=null){
                        for(SchemeBenefit__c  benefit : applicableBenefits){
                            applyPerDocumentBenefit(
                                benefit, 
                                lineResult,
                                periodType);    
                    }
                }
        }
    }

    @testVisible
    private  List<dmpl__SchemeBenefit__c> getCustomApplicableBenefits(
        SchemeLine__c schemeLine){
            Pattern p = Pattern.compile('\\{(.*?)\\}');
            string[] orCondtions = schemeLine.dmpl__RewardCustomLogic__c.split('OR');
            if(orCondtions.size()==0){
                orCondtions = new String[]{schemeLine.dmpl__RewardCustomLogic__c};
            }
            Integer groupIndex = -1;
            for(string orCondition : orCondtions){
                groupIndex +=1;
                string[] andCondtions = orCondition.split('AND');
                List<dmpl__SchemeBenefit__c> applicablebenefits = new List<dmpl__SchemeBenefit__c>();
                if(andCondtions.size()==0){
                    andCondtions = new String[]{orCondition};
                }
                for(String andCondtion : andCondtions){
                    Matcher m = p.matcher(andCondtion);
                    if(m.find()) {
                        Integer condIndex = Integer.valueOf(m.group(1));
                        if(condIndex > 0 && condIndex <= schemeLine.SchemeBenefits__r.size()){
                            applicablebenefits.add(schemeLine.SchemeBenefits__r[condIndex-1]);
                        }
                    }
                }
                if(applyBenefitCustomIndex == groupIndex){
                    return applicablebenefits;
                }
            }
        return null;
    }

    private void resetDocumentSchemeLine(){
        for(SObject line : allLines){
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c')){
                deletedLines.add(line);
            }else {
                line.put('dmpl__SchemeDiscount__c', null);
                line.put('dmpl__SchemeLineId__c', null);
                line.put('dmpl__SchemeRewardPoints__c', null);
                line.put('dmpl__SchemeDiscountAmount__c', null);
                line.put('dmpl__BenefitId__c', null);
                if(line.Id != null && !updatedLines.containsKey(line.Id)){
                    updatedLines.put(line.Id, line);
                }
            }
            line.put('dmpl__SchemeLineId__c', null);
        }
        for(SObject line : deletedLines){
            Integer lineIndex = allLines.indexOf(line);
            if(lineIndex > -1){
                allLines.remove(lineIndex);
            }
        }
    }

    @testVisible
    private  SchemeBenefit__c getMinimumBenefit(SchemeLine__c schemeLine){
        SchemeBenefit__c minBenefit = null;
        Decimal minBenefitValue = 0;
        for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
            if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
                if(benefit.DiscountAmount__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.DiscountAmount__c;
                    minBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
                if(benefit.DiscountPercent__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.DiscountPercent__c;
                    minBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
                if(benefit.dmpl__RewardPoints__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.dmpl__RewardPoints__c;
                    minBenefit = benefit;
                }
            }
        }
        If(minBenefit == null && schemeLine.SchemeBenefits__r.size()>0){
            minBenefit = schemeLine.SchemeBenefits__r[0];
        }
        return minBenefit;
    }

    @testVisible
    private  SchemeBenefit__c getMaximumBenefit(SchemeLine__c schemeLine){
        SchemeBenefit__c maxBenefit = null;
        Decimal maxBenefitValue = 0;
        for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
            if(benefit.RewardType__c ==  REWARD_TYPE_LL_DISCOUNT_AMOUNT){
                if(benefit.DiscountAmount__c > maxBenefitValue){
                    maxBenefitValue = benefit.DiscountAmount__c;
                    maxBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
                if(benefit.DiscountPercent__c > maxBenefitValue){
                    maxBenefitValue = benefit.DiscountPercent__c;
                    maxBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
                if(benefit.dmpl__RewardPoints__c > maxBenefitValue){
                    maxBenefitValue = benefit.dmpl__RewardPoints__c;
                    maxBenefit = benefit;
                }
            }
        }
        If(maxBenefit == null && schemeLine.SchemeBenefits__r.size()>0){
            maxBenefit = schemeLine.SchemeBenefits__r[schemeLine.SchemeBenefits__r.size()-1];
        }
        return maxBenefit;
    }

    @testVisible
    private  SchemeConditionResult evaluatePerDocumentCondition(
        SchemeCondition__c condition, 
        dmpl__SchemeLine__c schemeLine){
        SchemeConditionResult conditionResult = new SchemeConditionResult(condition);
        if(condition.ConditionType__c == CONDITION_TYPE_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getTotalQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalValue(condition, schemeLine, false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalValue(condition, schemeLine, true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getTotalItemQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalItemValue(
                    condition, 
                    schemeLine,
                    false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalItemValue(
                    condition,
                    schemeLine,
                    true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getTotalItemGroupQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalItemGroupValue(
                    condition,
                    schemeLine,
                    false),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getTotalItemGroupValue(
                    condition,
                    schemeLine,
                    true),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        return conditionResult;
    }

    @testVisible
    private  SchemeConditionResult evaluatePerPeriodCondition(
        SchemeCondition__c condition,
        SchemeLine__c schemeLine){
        SchemeConditionResult conditionResult = new SchemeConditionResult(condition);
        if(condition.ConditionType__c == CONDITION_TYPE_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getPerPeriodTotalQuantity(condition, schemeLine), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalValue(condition, schemeLine, false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalValue(condition, schemeLine, true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getPerPeriodTotalItemQuantity(condition, schemeLine), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalItemValue(
                    condition, 
                    schemeLine,
                    false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalItemValue(
                    condition,
                    schemeLine,
                    true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_QUANTITY){
            return evaluateNumberOperator(
                conditionResult,
                getPerPeriodTotalItemGroupQuantity(condition, schemeLine), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalItemGroupValue(
                    condition,
                    schemeLine,
                    false),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                conditionResult,
                getPerPeriodTotalItemGroupValue(
                    condition,
                    schemeLine,
                    true),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        return conditionResult;
    }
    
	@TestVisible
    private  Double getTotalQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        for(AggregateResult result : documentSummary){
            if((condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                totalQuantity += Double.valueOf(result.get('TotalQuantity'));
            }
        }
        return totalQuantity;
    }

    @TestVisible
    private  Double getTotalItemQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        for(AggregateResult result : documentSummary){
            if((condition.dmpl__ItemId__c == (Id)result.get('dmpl__ItemId__c')) && (condition.dmpl__ItemSKUId__c == null || condition.dmpl__ItemSKUId__c == (Id)result.get('dmpl__SKUId__c')) && (condition.dmpl__ItemLotTypeId__c == null || condition.dmpl__ItemLotTypeId__c == (Id)result.get('dmpl__ItemLotTypeId__c')) && (condition.dmpl__AccountId__c == null || condition.dmpl__AccountId__c == accountId) && (condition.dmpl__AccountGroupId__c == null || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                        totalQuantity += Double.valueOf(result.get('TotalQuantity'));
            }
        }
        return totalQuantity;
    }

    @TestVisible
    private  Double getTotalItemGroupQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        for(AggregateResult result : documentSummary){
            if(doesItemGroupContains(condition.dmpl__ItemGroupId__c,  (Id)result.get('dmpl__ItemId__c'), (Id)result.get('dmpl__SKUId__c'), (Id)result.get('dmpl__ItemLotTypeId__c')) && (condition.dmpl__AccountId__c == null || condition.dmpl__AccountId__c == accountId) && (condition.dmpl__AccountGroupId__c == null || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalQuantity += Double.valueOf(result.get('TotalQuantity'));
                }
        }
        return totalQuantity;
    }

    @TestVisible
    private  Decimal getTotalValue(
        SchemeCondition__c condition, 
        dmpl__SchemeLine__c schemeLine,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(AggregateResult result : documentSummary){
            if((condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                        totalValue += Double.valueOf(result.get('TotalAmount'));
                        if(includeTax){
                            totalValue += result.get('TaxAmount') == null ? 0 : Double.valueOf(result.get('TaxAmount'));            
                    }
            }    
        }
        
        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else 
            return totalValue;
    }

    @TestVisible
    private  Decimal getTotalItemValue(
        SchemeCondition__c condition,
        dmpl__SchemeLine__c schemeLine,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(AggregateResult result : documentSummary){
            if((condition.dmpl__ItemId__c == (Id)result.get('dmpl__ItemId__c'))
                && (condition.dmpl__ItemSKUId__c == null
                    || condition.dmpl__ItemSKUId__c == (Id)result.get('dmpl__SKUId__c'))
                && (condition.dmpl__ItemLotTypeId__c == null
                    || condition.dmpl__ItemLotTypeId__c == (Id)result.get('dmpl__ItemLotTypeId__c'))
                && (condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalValue += Double.valueOf(result.get('TotalAmount'));
                    if(includeTax){
                        totalValue += Double.valueOf(result.get('TaxAmount'));
                }    
            }
        }

        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else 
            return totalValue;
    }

    @TestVisible
    private  Decimal getTotalItemGroupValue(
        SchemeCondition__c condition,
        dmpl__SchemeLine__c schemeLine,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(AggregateResult result : documentSummary){
            if(doesItemGroupContains(
                condition.dmpl__ItemGroupId__c, 
                (Id)result.get('dmpl__ItemId__c'),
                (Id)result.get('dmpl__SKUId__c'),
                (Id)result.get('dmpl__ItemLotTypeId__c'))
                && (condition.dmpl__AccountId__c == null || condition.dmpl__AccountId__c == accountId) && (condition.dmpl__AccountGroupId__c == null || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalValue += Double.valueOf(result.get('TotalAmount'));
                    if(includeTax){
                        totalValue += Double.valueOf(result.get('TaxAmount')) == null ? 0 : Double.valueOf(result.get('TaxAmount'));
                    }    
            }
        }
        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else 
            return totalValue;
    }

    @TestVisible
    private  Double getPerPeriodTotalQuantity(SchemeCondition__c condition, SchemeLine__c schemeLine)
    {
        Double totalQuantity =0;
        for(dmpl__PerformanceKPI__c result : periodSummary){
            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c  && ((result.dmpl__AccountId__c == accountId  || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){

            if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                totalQuantity += Double.valueOf(result.dmpl__TotalSaleOrderQuantity__c);
            else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                totalQuantity += Double.valueOf(result.dmpl__TotalSaleInvoiceQuantity__c);
            else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                totalQuantity += Double.valueOf(result.dmpl__TotalPurchaseOrderQuantity__c);
            else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                totalQuantity += Double.valueOf(result.dmpl__TotalBillQuantity__c);
            else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                totalQuantity += Double.valueOf(result.dmpl__TotalRepairOrderQuantity__c);

            }
        }
        totalQuantity += getTotalQuantity(condition);
        return totalQuantity;
    }

    @TestVisible
    private  Decimal getPerPeriodTotalValue(
        SchemeCondition__c condition,
        SchemeLine__c schemeLine, 
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(dmpl__PerformanceKPI__c result : periodSummary){

            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c && ((result.dmpl__AccountId__c == accountId  || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){

                    if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                        totalValue += Double.valueOf(result.dmpl__TotalSaleOrderAmount__c);
                    else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                        totalValue += Double.valueOf(result.dmpl__TotalSaleInvoiceAmount__c);
                    else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                        totalValue += Double.valueOf(result.dmpl__TotalPurchaseOrderAmount__c);
                    else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                        totalValue += Double.valueOf(result.dmpl__TotalBillAmount__c);
                    else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                        totalValue += Double.valueOf(result.dmpl__TotalRepairOrderAmount__c);

                    if(includeTax){
                        totalValue += result.dmpl__TotalTaxAmount__c == null ? 0 : Double.valueOf(result.dmpl__TotalTaxAmount__c);            
                    }
            }    
        }
        totalValue += getTotalValue(condition, schemeLine, includeTax);

        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else return totalValue;
    }

    @TestVisible
    private  Double getPerPeriodTotalItemQuantity(SchemeCondition__c condition, SchemeLine__c schemeLine)
    {
        Double totalQuantity =0;
        for(dmpl__PerformanceKPI__c result : periodSummary){

            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c  && (condition.dmpl__ItemId__c == (Id)result.get('dmpl__ItemId__c'))
            // && (condition.dmpl__ItemLotTypeId__c == null
            //     || condition.dmpl__ItemLotTypeId__c == (Id)result.get('dmpl__ItemLotTypeId__c'))
            && ((result.dmpl__AccountId__c == accountId  || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){


                if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalSaleOrderQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                    totalQuantity += Double.valueOf(result.dmpl__TotalSaleInvoiceQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalPurchaseOrderQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                    totalQuantity += Double.valueOf(result.dmpl__TotalBillQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalRepairOrderQuantity__c);
            }
        }
        totalQuantity += getTotalItemQuantity(condition);
        return totalQuantity;
    }

    @TestVisible
    private  Decimal getPerPeriodTotalItemValue(
        SchemeCondition__c condition,
        SchemeLine__c schemeLine,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(dmpl__PerformanceKPI__c result : periodSummary){
            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c && (condition.dmpl__ItemId__c == (Id)result.get('dmpl__ItemId__c')) && ((result.dmpl__AccountId__c == accountId  || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){

                if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                    totalValue += Double.valueOf(result.dmpl__TotalSaleOrderAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                    totalValue += Double.valueOf(result.dmpl__TotalSaleInvoiceAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                    totalValue += Double.valueOf(result.dmpl__TotalPurchaseOrderAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                    totalValue += Double.valueOf(result.dmpl__TotalBillAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                    totalValue += Double.valueOf(result.dmpl__TotalRepairOrderAmount__c);
    
                if(includeTax){
                    totalValue += result.dmpl__TotalTaxAmount__c == null ? 0 : Double.valueOf(result.dmpl__TotalTaxAmount__c);        
                }    
            }
        }
        itemGroups = null;
        totalValue += getTotalItemValue(condition, schemeLine, includeTax);

        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else return totalValue;
    }

    @TestVisible
    private  Double getPerPeriodTotalItemGroupQuantity(SchemeCondition__c condition, SchemeLine__c schemeLine)
    {
        Double totalQuantity =0;
        itemGroups = null;
        for(dmpl__PerformanceKPI__c result : periodSummary){
            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c && doesItemGroupContains(condition.dmpl__ItemGroupId__c, result.dmpl__ItemId__c, null, null) && ((result.dmpl__AccountId__c == accountId || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){
    
                if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalSaleOrderQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                    totalQuantity += Double.valueOf(result.dmpl__TotalSaleInvoiceQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalPurchaseOrderQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                    totalQuantity += Double.valueOf(result.dmpl__TotalBillQuantity__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                    totalQuantity += Double.valueOf(result.dmpl__TotalRepairOrderQuantity__c);
                }
        }

        itemGroups = null;
        totalQuantity += getTotalItemGroupQuantity(condition);

        return totalQuantity;
    }

    @TestVisible
    private  Decimal getPerPeriodTotalItemGroupValue(
        SchemeCondition__c condition,
        SchemeLine__c schemeLine,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        itemGroups = null;
        for(dmpl__PerformanceKPI__c result : periodSummary){
            if(schemeLine.dmpl__SchemeId__c == result.dmpl__SchemeId__c && doesItemGroupContains(condition.dmpl__ItemGroupId__c,  result.dmpl__ItemId__c, null, null) && ((result.dmpl__AccountId__c == accountId  || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c && result.dmpl__AccountId__r.ParentId == accountId ) || (schemeLine.dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c && result.dmpl__AccountId__r.ParentId == parentAccountId)) || (condition.dmpl__AccountGroupId__c != null && (accountGroupIds.contains(condition.dmpl__AccountGroupId__c))))){
            
                if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO)
                    totalValue += Double.valueOf(result.dmpl__TotalSaleOrderAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI)
                    totalValue += Double.valueOf(result.dmpl__TotalSaleInvoiceAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO)
                    totalValue += Double.valueOf(result.dmpl__TotalPurchaseOrderAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                    totalValue += Double.valueOf(result.dmpl__TotalBillAmount__c);
                else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO)
                    totalValue += Double.valueOf(result.dmpl__TotalRepairOrderAmount__c);

                if(includeTax){
                    totalValue += result.dmpl__TotalTaxAmount__c == null ? 0 : Double.valueOf(result.dmpl__TotalTaxAmount__c);    
                }    
            }
        }
        itemGroups = null;
        totalValue += getTotalItemGroupValue(condition, schemeLine, includeTax);

        if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_CEIL)
            return Math.ceil(totalValue);
        else if(schemeLine.dmpl__SchemeId__r.dmpl__RoundOffType__c == ROUNDOFFTYPE_FLOOR)
            return Math.floor(totalValue);
        else return totalValue;
    }

    @testVisible
    private  void applyPerDocumentBenefit(
        SchemeBenefit__c benefit, 
        SchemeLineResult lineResult,
        String periodType){
        if(benefit == null)
            return;
        //
        if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
            applyDocumentDiscountPercent(
                benefit);
        }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
            applyDocumentDiscountAmount(
                benefit,
                lineResult);
        }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEM){
            applyDocumentDiscountedItem(
                benefit,
                lineResult,
                false,
                periodType);
        }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEMGROUP){
            applyDocumentDiscountedItem(
                benefit, 
                lineResult,
                true,
                periodType);
        }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
            applyDocumentRewardPoints(
                benefit);
        }
    }

    @testVisible
    private  void applyDocumentDiscountPercent(
        SchemeBenefit__c benefit){
        for(SObject line : allLines) {
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c') 
                || line.get('dmpl__SchemeLineId__c') != null){
                continue;
            }
            line.put('dmpl__SchemeDiscount__c', benefit.dmpl__DiscountPercent__c);
            line.put('dmpl__SchemeDiscountAmount__c', null);
            line.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
            line.put('dmpl__BenefitId__c', benefit.Id);
            if(line.Id != null && !updatedLines.containsKey(line.Id))
                updatedLines.put(line.Id, line);
        }
    }

    @TestVisible
    private  void applyDocumentDiscountAmount(
        SchemeBenefit__c benefit,
        SchemeLineResult lineResult){
        Decimal qualifyingCount = benefit.dmpl__RepeatReward__c ? lineResult.qualificationCount : lineResult.qualificationCount > 0 ? 1 : 0;
        if(benefit.dmpl__RepeatRewardsInRatio__c){
            qualifyingCount = lineResult.targetToAchivementRatio;
        }
        Decimal totalAmount = 0;
        for(SObject line : allLines) {
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c')  || line.get('dmpl__SchemeLineId__c')!= null){
                continue;
            }
            totalAmount += (Decimal)line.get('dmpl__BaseAmount__c');
        }
        if(totalAmount == 0){
            return;
        }
        for(SObject line : allLines) {
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c') || line.get('dmpl__SchemeLineId__c')!= null){
                continue;
            }
            Decimal lineAmount = qualifyingCount * (benefit.dmpl__DiscountAmount__c * ((Decimal)line.get('dmpl__BaseAmount__c')/totalAmount));
            line.put('dmpl__SchemeDiscountAmount__c', lineAmount.setScale(2));
            line.put('dmpl__SchemeDiscount__c', null);
            line.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
            line.put('dmpl__BenefitId__c', benefit.Id);
            if(line.Id != null && !updatedLines.containsKey(line.Id))
                updatedLines.put(line.Id, line);
        }
    }

    @TestVisible
    private  void applyDocumentRewardPoints(
        SchemeBenefit__c benefit){
        for(SObject line : allLines) {
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c')){
                continue;
            }
            line.put('dmpl__SchemeRewardPoints__c', benefit.dmpl__RewardPoints__c);
            line.put('SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
            line.put('dmpl__BenefitId__c', benefit.Id);
            if(line.Id != null && !updatedLines.containsKey(line.Id))
                updatedLines.put(line.Id, line);
        }
    }

    @TestVisible
    private  void applyDocumentDiscountedItem(
        SchemeBenefit__c benefit, 
        SchemeLineResult lineResult,
        Boolean isItemGroup,
        String periodType){

        Decimal quantityToDiscount = benefit.dmpl__DiscountedItemQuantity__c == null 
            ? 1 : benefit.dmpl__DiscountedItemQuantity__c;
        
        Decimal qualificationCount = 0;
        if(benefit.dmpl__RepeatRewardsInRatio__c){
            qualificationCount = lineResult.targetToAchivementRatio;
        }else{
            qualificationCount = (benefit.dmpl__RepeatReward__c 
                ? lineResult.qualificationCount : (lineResult.qualificationCount > 0 
                    ? 1 : 0));
        }
        //
        quantityToDiscount = quantityToDiscount * qualificationCount;
        quantityToDiscount = discountExistingItem(
            quantityToDiscount,
            qualificationCount,
            benefit, 
            isItemGroup
        );
        //
        if(quantityToDiscount >0 
            && !isOverridingScemeApplied(benefit, lineResult)){
                if(isItemGroup){
                    quantityToDiscount = discountNewItemGroup(
                        quantityToDiscount, 
                        benefit);
                }else {
                    quantityToDiscount = discountNewItem(
                        quantityToDiscount, 
                        benefit);
                }
        }
    }

    private Decimal discountExistingItem(
        Decimal quantityToDiscount,
        Decimal qualificationCount,
        SchemeBenefit__c benefit, 
        Boolean isItemGroup){
        List<LineWrapper> sortedLines = new List<LineWrapper>();
        for(SObject line : allLines){
            sortedLines.add(
                new LineWrapper(
                    line, 
                    benefit.dmpl__DiscountedItemRanking__c == DISCOUNTED_ITEM_RANKING_DECENDING, 
                    fieldNames));
        }
        sortedLines.sort();
        Decimal totalAmount = getDiscountedItemTotalAmount(
            benefit, 
            isItemGroup);
        for(LineWrapper lineWrapper : sortedLines) {
            SObject line = (SObject)lineWrapper.source;
            if(quantityToDiscount <=0){
                return quantityToDiscount;
            }
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c')  
                || line.get('dmpl__SchemeLineId__c')!= null){
                continue;
            }
            Decimal itemQtyToDiscount = 0;
            if(isItemGroup){
                if(preferedItemList!=null){
                    itemQtyToDiscount = SourceObjectInfo.getRequestedQuantity(
                        preferedItemList, 
                        (Id)line.get('dmpl__ItemId__c'),
                        benefit.dmpl__DiscountedItemGroupId__c);
                    if(itemQtyToDiscount == 0){
                        continue;
                    }
                } else if(!doesItemGroupContains(
                    benefit.dmpl__DiscountedItemGroupId__c, 
                    (Id)line.get('dmpl__ItemId__c'), 
                    (Id)line.get('dmpl__SKUId__c'), 
                    (Id)line.get('dmpl__ItemLotTypeId__c'))){
                        //continue;
                }
            }else {
                if((Id)line.get('dmpl__ItemId__c') != benefit.dmpl__DiscountedItemId__c){
                    continue;
                }   
            }
            System.debug('itemQtyToDiscount' + itemQtyToDiscount);
            System.debug('quantityToDiscount' + quantityToDiscount);
            if(!benefit.dmpl__ExcludeQualifyingItems__c 
                && (itemQtyToDiscount > 0 && (Double)line.get('dmpl__Quantity__c') <= itemQtyToDiscount 
                    || itemQtyToDiscount == 0 && (Double)line.get('dmpl__Quantity__c') <= quantityToDiscount
                    || itemQtyToDiscount == 0 && benefit.dmpl__DiscountAmount__c > 0)){ //Added Discount AMount Check so that Irrespective of discounted item qty this condition is satisfied.
                itemQtyToDiscount = discountExistingItemWithQuantity(
                    line,
                    itemQtyToDiscount,
                    qualificationCount,
                    benefit, 
                    isItemGroup,
                    totalAmount);
                quantityToDiscount -= (Double)line.get('dmpl__Quantity__c');
            } else {
                if(itemQtyToDiscount <= 0){
                    itemQtyToDiscount = quantityToDiscount;
                }
                itemQtyToDiscount = discountExistingItemWithClone(
                    line,
                    itemQtyToDiscount,
                    benefit, 
                    isItemGroup,
                    totalAmount);
                quantityToDiscount -= itemQtyToDiscount;
            }
        }
        return quantityToDiscount;
    }

    private decimal discountExistingItemWithQuantity(
        SObject line,
        Decimal itemQtyToDiscount,
        Decimal qualificationCount,
        SchemeBenefit__c benefit, 
        Boolean isItemGroup,
        Decimal totalAmount){
        if(itemQtyToDiscount > 0){
            itemQtyToDiscount -= (Double)line.get('dmpl__Quantity__c');
            SourceObjectInfo.reduceRequestedQuantity(
                preferedItemList, 
                (Id)line.get('dmpl__ItemId__c'),
                benefit.dmpl__DiscountedItemGroupId__c,
                (Double)line.get('dmpl__Quantity__c'));
        }
        if(isItemGroup && doesItemGroupContains(
                benefit.dmpl__DiscountedItemGroupId__c, 
                (Id)line.get('dmpl__ItemId__c'), 
                (Id)line.get('dmpl__SKUId__c'), 
                (Id)line.get('dmpl__ItemLotTypeId__c')) 
            || !isItemGroup && (Id)line.get('dmpl__ItemId__c') == benefit.dmpl__DiscountedItemId__c){
                if(benefit.dmpl__DiscountPercent__c >0){
                    line.put('dmpl__SchemeDiscountAmount__c', 0);
                    line.put('dmpl__SchemeDiscount__c', benefit.dmpl__DiscountPercent__c);
                }else if(benefit.dmpl__DiscountAmount__c >0){
                    if(totalAmount > 0){    //Modified in sync with app -- no need to split
                        Decimal lineAmount = qualificationCount * (benefit.dmpl__DiscountAmount__c * ((Decimal)line.get('dmpl__BaseAmount__c')/totalAmount));
                        line.put('dmpl__SchemeDiscountAmount__c', lineAmount.setScale(2));
                        line.put('dmpl__SchemeDiscount__c', 0);
                    }
                }
                //Scheme Rework 9th July removed following from else condition    
                line.put('SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
                
                if(fieldNames.contains('dmpl__LimitExpiryDays__c')){
                    line.put('dmpl__LimitExpiryDays__c', benefit.dmpl__LimitExpiryDays__c);
                }
                line.put('dmpl__BenefitId__c', benefit.Id);
                if(line.Id != null && !updatedLines.containsKey(line.Id)){
                    updatedLines.put(line.Id, line);
                }
            }
        return itemQtyToDiscount;
    }

    private decimal discountExistingItemWithClone(
        SObject line,
        Decimal itemQtyToDiscount,
        SchemeBenefit__c benefit, 
        Boolean isItemGroup,
        Decimal totalAmount){
        SObject newLine = line.clone(false, true, true, false);
        if(!benefit.dmpl__ExcludeQualifyingItems__c){
            line.put(
                'dmpl__Quantity__c', 
                (Double)line.get('dmpl__Quantity__c') - itemQtyToDiscount);
        }
        //Scheme Rework 9th July Commented Following Line as it is not required
        //line.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);

        newLine.put('dmpl__Quantity__c', itemQtyToDiscount);
        SourceObjectInfo.reduceRequestedQuantity(preferedItemList, 
            (Id)line.get('dmpl__ItemId__c'), 
            benefit.dmpl__DiscountedItemGroupId__c, 
            itemQtyToDiscount);
                    
        if(line.Id != null && !updatedLines.containsKey(line.Id)){
            updatedLines.put(line.Id, line);
        }

        if(benefit.dmpl__DiscountPercent__c > 0){
            newLine.put('dmpl__SchemeDiscountAmount__c', 0);
            newLine.put('dmpl__SchemeDiscount__c', benefit.dmpl__DiscountPercent__c);
        }else if(benefit.dmpl__DiscountAmount__c >0){
            newLine.put('dmpl__SchemeDiscountAmount__c', benefit.dmpl__DiscountAmount__c);
            newLine.put('dmpl__SchemeDiscount__c', 0);
        }
        
        newLine.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
        newLine.put('dmpl__ItemLotTypeId__c', benefit.dmpl__DiscountedItemLotTypeId__c);
        newLine.put('dmpl__IsSchemeGenerated__c', true);

        if(fieldNames.contains('dmpl__UnitPrice__c')){
            newLine.put('dmpl__UnitPrice__c', null);
        }else if(fieldNames.contains('dmpl__UnitCost__c')){
            newLine.put('dmpl__UnitCost__c', null);
        }

        if(fieldNames.contains('dmpl__LimitExpiryDays__c')){
            newLine.put('dmpl__LimitExpiryDays__c', benefit.dmpl__LimitExpiryDays__c);
        }

        if(line.Id != null && !updatedLines.containsKey(line.Id)){
            updatedLines.put(line.Id, line);
        }
        newLine.put('dmpl__BenefitId__c', benefit.Id);
        allLines.add(newLine);
        insertedLines.add(newLine);
        return itemQtyToDiscount;
    }

    private Decimal discountNewItemGroup(
        Decimal quantityToDiscount,
        SchemeBenefit__c benefit){
        if(preferedItemList ==null || preferedItemList.size() == 0){
            //not item selected ignoring!!!!
            return quantityToDiscount;
        }
        for(SourceObjectInfo info : preferedItemList){
            if(info.objectGroupId != benefit.dmpl__DiscountedItemGroupId__c){
                continue;
            }
            if(quantityToDiscount<= 0){
                break;
            }
            Decimal lineQty = info.quantity;
            if(lineQty >quantityToDiscount ){
                lineQty = quantityToDiscount;
            }
            if(lineQty<=0){
                continue;
            }
            SObject newLine = allLines[0].clone(false, true, true, false);
            newLine.put('dmpl__ItemId__c', info.objectId);
            newLine.put('dmpl__Quantity__c', lineQty);
            newLine.put('dmpl__IsSchemeGenerated__c', true);
            if(fieldNames.contains('dmpl__UnitPrice__c'))
                newLine.put('dmpl__UnitPrice__c', null);
            else if(fieldNames.contains('dmpl__UnitCost__c'))
                newLine.put('dmpl__UnitCost__c', null);
            if(fieldNames.contains('dmpl__unitprice__c'))
                newLine.put('dmpl__UnitPrice__c', null);
            else if(fieldNames.contains('dmpl__unitcost__c'))
                newLine.put('dmpl__UnitCost__c', null);
            quantityToDiscount -=lineQty;
            if(benefit.dmpl__DiscountPercent__c > 0){
                newLine.put('dmpl__SchemeDiscountAmount__c', 0);
                newLine.put('dmpl__SchemeDiscount__c', benefit.dmpl__DiscountPercent__c);
            }else if(benefit.dmpl__DiscountAmount__c >0){
                newLine.put('dmpl__SchemeDiscountAmount__c', benefit.dmpl__DiscountAmount__c);
                newLine.put('dmpl__SchemeDiscount__c', 0);
            }
            newLine.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
            newLine.put('dmpl__ItemLotTypeId__c', benefit.dmpl__DiscountedItemLotTypeId__c);
            if(fieldNames.contains('dmpl__LimitExpiryDays__c'))
                newLine.put('dmpl__LimitExpiryDays__c', benefit.dmpl__LimitExpiryDays__c);

            newLine.put('dmpl__BenefitId__c', benefit.Id);
            insertedLines.add(newLine);
        }
        return quantityToDiscount;
    }

    private Decimal discountNewItem(
        Decimal quantityToDiscount,
        SchemeBenefit__c benefit){    
        if(benefit.dmpl__RewardType__c == REWARD_TYPE_DISCOUNTED_ITEM 
            && benefit.dmpl__DiscountedItemId__c !=null  
            && (benefit.dmpl__DiscountPercent__c == 100)){
            SObject newLine = allLines[0].clone(false, true, true, false);
            newLine.put('dmpl__ItemId__c', benefit.dmpl__DiscountedItemId__c);
            newLine.put('dmpl__ItemLotTypeId__c', benefit.dmpl__DiscountedItemLotTypeId__c);
            newLine.put('dmpl__Quantity__c', quantityToDiscount); 
            newLine.put('dmpl__IsSchemeGenerated__c', true); 
            if(fieldNames.contains('dmpl__UnitPrice__c')){
                newLine.put('dmpl__UnitPrice__c', null);
            } else if(fieldNames.contains('dmpl__UnitCost__c')){
                newLine.put('dmpl__UnitCost__c', null);
            }
            if(fieldNames.contains('dmpl__unitprice__c')){
                newLine.put('dmpl__UnitPrice__c', null);
            }else if(fieldNames.contains('dmpl__unitcost__c')){
                newLine.put('dmpl__UnitCost__c', null);
            }
            if(benefit.dmpl__DiscountPercent__c > 0){
                newLine.put('dmpl__SchemeDiscountAmount__c', 0);
                newLine.put('dmpl__SchemeDiscount__c', benefit.dmpl__DiscountPercent__c);
            }else if(benefit.dmpl__DiscountAmount__c >0){
                newLine.put('dmpl__SchemeDiscountAmount__c', benefit.dmpl__DiscountAmount__c);
                newLine.put('dmpl__SchemeDiscount__c', 0);
            }
            newLine.put('dmpl__SchemeLineId__c', benefit.dmpl__SchemeLineId__c);
            if(fieldNames.contains('dmpl__LimitExpiryDays__c'))
                newLine.put('dmpl__LimitExpiryDays__c', benefit.dmpl__LimitExpiryDays__c);

            newLine.put('dmpl__BenefitId__c', benefit.Id);
            insertedLines.add(newLine);
        }
        return 0;
    }

    private Decimal getDiscountedItemTotalAmount(
        SchemeBenefit__c benefit, 
        Boolean isItemGroup){
        Decimal totalAmount = 0;
        for(SObject line : allLines) {
            if((Boolean)line.get('dmpl__IsSchemeGenerated__c')  
                || line.get('dmpl__SchemeLineId__c')!= null){
                continue;
            }
            if(isItemGroup && doesItemGroupContains(
                    benefit.dmpl__DiscountedItemGroupId__c, 
                    (Id)line.get('dmpl__ItemId__c'), 
                    (Id)line.get('dmpl__SKUId__c'), 
                    (Id)line.get('dmpl__ItemLotTypeId__c')) 
                || !isItemGroup && (Id)line.get('dmpl__ItemId__c') == benefit.dmpl__DiscountedItemId__c){
                        totalAmount += (Decimal)line.get('dmpl__BaseAmount__c');
                    }
        }
        return totalAmount;
    }

    private  Boolean isOverridingScemeApplied(
        SchemeBenefit__c benefit, 
        SchemeLineResult lineResult){
            decimal sourceLineSeq = lineResult.schemeLine?.dmpl__SchemeId__r?.dmpl__SequenceNumber__c;
            if(sourceLineSeq == null){
                return false;        
            }
            for(SObject line : allLines){
                if(line.get('dmpl__SchemeLineId__c') ==null){
                    continue;
                }
                dmpl__SchemeLine__c appliedScheme = (dmpl__SchemeLine__c) CollectionHelper.getObject(
                    activeSchemeLines, 
                    (Id)line.get('dmpl__SchemeLineId__c'));
                if(appliedScheme == null){
                    continue;
                }
                Decimal appliedSeq = appliedScheme.dmpl__SchemeId__r.dmpl__SequenceNumber__c;
                if(appliedSeq == null || sourceLineSeq <= appliedSeq){
                    continue;
                }
                for(dmpl__SchemeCondition__c condition : appliedScheme.dmpl__SchemeConditions__r){
                    for(dmpl__SchemeCondition__c condition2 : lineResult.schemeLine.dmpl__SchemeConditions__r){
                        if((condition.dmpl__ItemId__c!= null && condition.dmpl__ItemId__c == condition2.dmpl__ItemId__c)
                            || (condition.dmpl__ItemGroupId__c!= null && (
                                condition.dmpl__ItemGroupId__c == condition2.dmpl__ItemGroupId__c || 
                                doesItemGroupContains(condition.dmpl__ItemGroupId__c, condition2.dmpl__ItemId__c, null, null)
                            ))){
                            return true;
                        }
                    }
                }
            }
        return false;
    }

    @testVisible
    private  SchemeConditionResult evaluateNumberOperator(
        SchemeConditionResult conditionResult,
        Double reachedValue, 
        string operator, 
        Decimal conditionValue){
        conditionResult.reachedValue = reachedValue; 
        conditionResult.conditionValue = conditionValue;
        conditionResult.targetToAchivementRatio = conditionValue > 0 ? reachedValue/conditionValue : 0;
        if(conditionResult.condition.dmpl__RoundOffConditionQuantity__c){
            conditionResult.targetToAchivementRatio = conditionValue > 0 ? (Math.floor(reachedValue)/conditionValue) : 0;
        }
        if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS){
            conditionResult.qualificationCount = (reachedValue >= conditionValue) && (conditionValue>0) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        }else if(operator == CONDITION_OPERATOR_GREATER_THAN){
            conditionResult.qualificationCount = (reachedValue > conditionValue) && (conditionValue>0) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        }else if(operator == CONDITION_OPERATOR_EQUALS){
            conditionResult.qualificationCount = (reachedValue == conditionValue)? 1 : 0;
        }else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS){
            conditionResult.qualificationCount = (reachedValue <= conditionValue)? 1:0;
        }else if(operator == CONDITION_OPERATOR_LESS_THAN){
            conditionResult.qualificationCount = (reachedValue < conditionValue) ? 1:0;
        }else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS){
            conditionResult.qualificationCount = (reachedValue != conditionValue)?1:0;
        }else{
            conditionResult.qualificationCount = 0;
        }
        return conditionResult;
    }

    @testVisible
    private  SchemeConditionResult evaluateCurrencyOperator(
        SchemeConditionResult conditionResult,
        Decimal reachedValue, 
        string operator, 
        Decimal conditionValue){
        conditionResult.reachedValue = reachedValue; 
        conditionResult.conditionValue = conditionValue;
        conditionResult.targetToAchivementRatio = conditionValue > 0 ? reachedValue/conditionValue : 0;
        if(conditionResult.condition.dmpl__RoundOffConditionQuantity__c){
            conditionResult.targetToAchivementRatio = conditionValue > 0 ? (Math.floor(reachedValue))/conditionValue : 0;
        }
        if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS){
            conditionResult.qualificationCount =  (reachedValue >= conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        }else if(operator == CONDITION_OPERATOR_GREATER_THAN){
            conditionResult.qualificationCount =  (reachedValue > conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        }else if(operator == CONDITION_OPERATOR_EQUALS){
            conditionResult.qualificationCount =  (reachedValue == conditionValue) ? 1 : 0;
        }else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS){
            conditionResult.qualificationCount =  (reachedValue <= conditionValue) ? 1 : 0;
        }else if(operator == CONDITION_OPERATOR_LESS_THAN){
            conditionResult.qualificationCount =  (reachedValue < conditionValue) ? 1 : 0;
        }else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS){
            conditionResult.qualificationCount =  (reachedValue != conditionValue) ? 1 : 0;
        }else{
            conditionResult.qualificationCount =  0;
        }
        return conditionResult;
    }

    @testvisible
    private  SchemeLineResult evaluateConditions(
        SchemeLineResult lineResult,
        string filterCriteria, 
        string customLogic){
        Integer maxValue = 0;
        Decimal maxRatio = 0;
        Integer minValue = 0;
        Decimal minRatio = 0;
        if(filterCriteria == DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS){    
            for(SchemeConditionResult conditionResult : lineResult.conditionResults){
                if(conditionResult.qualificationCount == 0){
                    return lineResult;
                }
                if(conditionResult.qualificationCount > maxValue
                    || (conditionResult.qualificationCount == maxValue
                        && conditionResult.targetToAchivementRatio > maxRatio)){
                    maxValue = conditionResult.qualificationCount;
                    maxRatio = conditionResult.targetToAchivementRatio;
                }
                if(conditionResult.qualificationCount < minValue){
                    minValue = conditionResult.qualificationCount;
                    minRatio = conditionResult.targetToAchivementRatio;
                }
            }
        }
        else if(filterCriteria == DEFINITION_FILTER_CRITERIA_ANY_CONDITION){
            for(SchemeConditionResult conditionResult : lineResult.conditionResults){
                if(conditionResult.qualificationCount > 0){
                    if(conditionResult.qualificationCount > maxValue 
                        ||(conditionResult.qualificationCount == maxValue 
                            && conditionResult.targetToAchivementRatio > maxRatio)){
                        maxValue  = conditionResult.qualificationCount;
                        maxRatio = conditionResult.targetToAchivementRatio;
                    }
                    if(conditionResult.qualificationCount < minValue){
                        minValue = conditionResult.qualificationCount;
                        minRatio = conditionResult.targetToAchivementRatio;
                    }
                }
            }
        } else if(filterCriteria == DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC)
        {
            System.debug('Start custom' + customLogic);
            Pattern p = Pattern.compile('\\{(.*?)\\}');
            string[] orCondtions = customLogic.split('OR');
            if(orCondtions.size()==0){
                orCondtions = new String[]{customLogic};
            }
            Integer orMaxValue = -1;
            Decimal orMaxRatio = 0;
            Integer orMinValue = -1;
            Decimal orMinRatio = 0;
            for(string orCondition : orCondtions){
                System.debug('or condition' + orCondition);
                string[] andCondtions = orCondition.split('AND');
                if(andCondtions.size()==0){
                    andCondtions = new String[]{orCondition};
                }
                Integer andMaxValue = -1;
                Decimal andMaxRatio = 0;
                Integer andMinValue = -1;
                Decimal andMinRatio = 0;
                for(String andCondtion : andCondtions){
                    System.debug('and condition' + andCondtion);
                    Integer result = 0;
                    Decimal ratio = 0;
                    Matcher m = p.matcher(andCondtion);
                    if(m.find()) {
                        Integer condIndex = Integer.valueOf(m.group(1));
                        if(condIndex > 0 && condIndex <= lineResult.conditionResults.size()){
                            result = lineResult.conditionResults[condIndex-1]?.qualificationCount;
                            ratio = lineResult.conditionResults[condIndex-1]?.targetToAchivementRatio;
                        }
                        System.debug('Matched' + condIndex + ' ' + result);
                    }else {
                         System.debug('No Match');
                        return lineResult;
                    }
                    if(andMaxValue == -1){
                        andMaxValue  = result;
                        andMaxRatio = ratio;
                    }else if(result > andMaxValue || (result == andMaxValue && ratio > andMaxRatio)){
                        andMaxValue  = result;
                        andMaxRatio = ratio;
                    }
                    if(andMinValue == -1){
                        andMinValue  = result;
                        andMinRatio = ratio;
                    }else if(result < andMinValue){
                        andMinValue  = result;
                        andMinRatio = ratio;
                    }
                    System.debug('and Max Value' + andMaxValue);
                }
                if(orMaxValue == -1){
                    orMaxValue  = andMaxValue;
                    orMaxRatio = andMaxRatio;
                }else if(andMaxValue > orMaxValue || (andMaxValue == orMaxValue && andMaxRatio > orMaxRatio)){
                    orMaxValue  = andMaxValue;
                    orMaxRatio = andMaxRatio;
                }
                if(orMinValue == -1){
                    orMinValue  = andMinValue;
                    orMinRatio = andMinRatio;
                }else if(andMinValue < orMinValue){
                    orMinValue  = andMinValue;
                    orMinRatio = andMinRatio;
                }    
                System.debug('or Max Value' + orMaxValue);
            }
            maxValue = orMaxValue;
            maxRatio = orMaxRatio;
            minValue = orMinValue;
            minRatio = orMinRatio;
            System.debug('Final Max Value' + maxValue);
        }
        if(lineResult.schemeLine.dmpl__UseLowerConditionRatio__c){
            lineResult.qualificationCount = minValue;
            lineResult.targetToAchivementRatio = minRatio;
        }else {
            lineResult.qualificationCount = maxValue;
            lineResult.targetToAchivementRatio = maxRatio;
        }
        
        return lineResult;
    }

    @testVisible
    private  Boolean doesItemGroupContains(
        Id lookupItemGroupId, 
        Id itemId, 
        Id sKUId, 
        Id itemLotTypeId){
            if(!itemGroups.containsKey(lookupItemGroupId)){
                return false;
            }
            List<dmpl__ItemGroupMember__c> igMembers = itemGroups.get(lookupItemGroupId);
            for(dmpl__ItemGroupMember__c igMember : igMembers){
                if(igMember.dmpl__ItemId__c == itemId && (igMember.dmpl__SKUId__c == null || igMember.dmpl__SKUId__c == sKUId) && (igMember.dmpl__LotTypeId__c == null || igMember.dmpl__LotTypeId__c == itemLotTypeId)){
                        return true;
                    }
            }
        return false;
    }
    /*************************************************************************/
    /* Scheme Result Posting */
    /*************************************************************************/
        private void upsertLines(){
            List<SObject> linesToUpsert = new List<SObject>();
            for(sObject aObject : deletedLines){
                updatedLines.remove(aObject.Id);
            }
            linesToUpsert.addAll(updatedLines.values());
            linesToUpsert.addAll(insertedLines);
            if(linesToUpsert.size() > 0){
                upsert linesToUpsert;
            }
            allLines.addAll(insertedLines);
        }    

        private  void deleteLines(){
            if(deletedLines.size()>0){
                delete deletedLines;
            }
        }

    /*************************************************************************/
    /* Scheme Summary Calculator */
    /*************************************************************************/
    
        private  List<dmpl__PerformanceKPI__c> getPeriodSummary(){
            List<Id> schemeLineIds = getPerPeriodSchemeLinesIds();
            List<Id> relatedAccountIds = new List<Id>();
            if(schemeLineIds.size() > 0){
                List<Account> parentAccount = AccountHelper.getCachedAccounts(
                    new List<Id>{ accountId });
                if(parentAccount.size()> 0){
                    parentAccountId = parentAccount[0].ParentId;
                }
                if(parentAccountId == null){
                    parentAccountId = accountId;
                }
                //
                relatedAccountIds =  DocumentHelper.extractIds(
                    [SELECT Id FROM Account WHERE ParentId =: parentAccountId]);
            }
                
            List<string> fieldList = new List<string>{
                'dmpl__AccountId__c',
                'dmpl__AccountId__r.ParentId',
                'dmpl__BranchId__c',
                'dmpl__IncentivePeriodId__c',
                'dmpl__IncentivePlanId__c',
                'dmpl__IncentiveTargetId__c',
                'dmpl__ItemId__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__ResourceId__c',
                'dmpl__SchemeId__c',
                'dmpl__SchemePeriodId__c',
                'dmpl__SupplierAccountId__c',
                'dmpl__TotalAmount__c',
                'dmpl__TotalQuantity__c',
                'dmpl__TotalTaxAmount__c'
            }; 

            if(perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SO){
                fieldList.add('dmpl__NumberOfOrders__c');
                fieldList.add('dmpl__TotalSaleOrderAmount__c');
                fieldList.add('dmpl__TotalSaleOrderQuantity__c');
            }else if(perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SI){
                fieldList.add('dmpl__NumberOfInvoices__c');
                fieldList.add('dmpl__TotalSaleInvoiceAmount__c');
                fieldList.add('dmpl__TotalSaleInvoiceQuantity__c');
            }else if(perPeriodSchemeType == SCHEMTYPE_PERPERIOD_PO){
                fieldList.add('dmpl__NumberOfPurchaseOrders__c');
                fieldList.add('dmpl__TotalPurchaseOrderAmount__c');
                fieldList.add('dmpl__TotalPurchaseOrderQuantity__c');
            }else if(perPeriodSchemeType == SCHEMTYPE_PERPERIOD_RO){
                fieldList.add('dmpl__NumberOfRepairOrders__c');
                fieldList.add('dmpl__TotalRepairOrderAmount__c');
                fieldList.add('dmpl__TotalRepairOrderQuantity__c');
            }else if(perPeriodSchemeType == SCHEMTYPE_PERPERIOD_BILL){
                fieldList.add('dmpl__NumberOfBills__c');
                fieldList.add('dmpl__TotalBillAmount__c');
                fieldList.add('dmpl__TotalBillQuantity__c');
            }
            
            SecurityHelper.ensureCanReadFields(fieldList, 'dmpl__PerformanceKPI__c');
            String whereClause = 'Where dmpl__SchemeId__c IN: schemeLineIds AND (dmpl__PartnerAccountId__c =: partnerAccountId)'
                                   + ' AND (dmpl__AccountId__c =: accountId OR dmpl__SupplierAccountId__c =: accountId '
                                   + 'OR dmpl__AccountId__c IN: relatedAccountIds)'
                                   + ' AND (dmpl__SchemePeriodId__r.dmpl__DateFrom__c <= : documentDate OR dmpl__SchemePeriodId__r.dmpl__DateFrom__c = null)'
                                   + ' AND (dmpl__SchemePeriodId__r.dmpl__DateTo__c >= : documentDate OR dmpl__SchemePeriodId__r.dmpl__DateTo__c = null)';

            String query = 'SELECT Id,'+ String.join(fieldList , ',') +' FROM dmpl__PerformanceKPI__c ' + whereClause;
            return Database.query(query);
        }

        private List<Id> getPerPeriodSchemeLinesIds(){
            List<Id> perPeriodSchemeLinesIds = new List<Id>();
            for(dmpl__SchemeLine__c schemeLine : activeSchemeLines){
                if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SO
                    || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_SI
                    || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_PO
                    || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_RO
                    || schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_PERPERIOD_BILL)
                perPeriodSchemeLinesIds.add(schemeLine.Id);
            }
            return perPeriodSchemeLinesIds;
        }

        private void setDocumentSummary(){
            if(schemeType == SCHEMTYPE_PER_SO){
                documentSummary = getSOSummary();
            } else if(schemeType == SCHEMTYPE_PER_PO){
                documentSummary = getPOSummary();
            } else if(schemeType == SCHEMTYPE_PER_SI){
                documentSummary = getSISummary();
            } else if(schemeType == SCHEMTYPE_PER_BILL){
                documentSummary = getBillSummary();
            } else if(schemeType == SCHEMTYPE_PER_RO){
                documentSummary = getROSummary();
            }
        }
    
        @testVisible
        private List<AggregateResult> getSOSummary(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__AccountId__c'
            }, 'dmpl__SaleOrder__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__BaseAmount__c',
                'dmpl__TaxAmount__c',
                'dmpl__ItemId__c',
                'dmpl__Quantity__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__SaleOrderId__c'
            }, 'dmpl__SaleOrderLine__c');
            return 
            [
                SELECT
                    dmpl__ItemId__c dmpl__ItemId__c,
                    dmpl__SKUId__c dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__BaseAmount__c) TotalAmount,
                    SUM(dmpl__TaxAmount__c) TaxAmount
                FROM
                    dmpl__SaleOrderLine__c
                WHERE
                    dmpl__SaleOrderId__c =: document.Id
                    AND dmpl__IsSchemeGenerated__c = false
                GROUP BY
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c
            ];
        }
    
        @testVisible
        private List<AggregateResult> getSISummary(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__AccountId__c'
            }, 'dmpl__SaleInvoice__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__BaseAmount__c',
                'dmpl__TaxAmount__c',
                'dmpl__ItemId__c',
                'dmpl__Quantity__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__SaleInvoiceId__c'
            }, 'dmpl__SaleInvoiceLine__c');
            return 
            [
                SELECT
                    dmpl__ItemId__c dmpl__ItemId__c,
                    dmpl__SKUId__c dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__BaseAmount__c) TotalAmount,
                    SUM(dmpl__TaxAmount__c) TaxAmount
                FROM
                    dmpl__SaleInvoiceLine__c
                WHERE
                    dmpl__SaleInvoiceId__c =: document.Id
                    AND dmpl__IsSchemeGenerated__c = false
                GROUP BY
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c
            ];
        }
    
        @testVisible
        private List<AggregateResult> getPOSummary(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SupplierAccountId__c'
            }, 'dmpl__PurchaseOrder__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__BaseAmount__c',
                'dmpl__TaxAmount__c',
                'dmpl__ItemId__c',
                'dmpl__Quantity__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__PurchaseOrderId__c'
            }, 'dmpl__PurchaseOrderLine__c');
            return 
            [
                SELECT
                    dmpl__ItemId__c dmpl__ItemId__c,
                    dmpl__SKUId__c dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__BaseAmount__c) TotalAmount,
                    SUM(dmpl__TaxAmount__c) TaxAmount
                FROM
                    dmpl__PurchaseOrderLine__c
                WHERE
                    dmpl__PurchaseOrderId__c =: document.Id
                    AND dmpl__IsSchemeGenerated__c = false
                GROUP BY
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c
            ];
        }
    
        @testVisible
        private List<AggregateResult> getROSummary(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__AccountId__c'
            }, 'dmpl__RepairOrder__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__BaseAmount__c',
                'dmpl__TaxAmount__c',
                'dmpl__ItemId__c',
                'dmpl__Quantity__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__RepairOrderId__c'
            }, 'dmpl__RepairOrderLine__c');
            return 
            [
                SELECT
                    dmpl__ItemId__c dmpl__ItemId__c,
                    dmpl__SKUId__c dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__BaseAmount__c) TotalAmount,
                    SUM(dmpl__TaxAmount__c) TaxAmount
                FROM
                    dmpl__RepairOrderLine__c
                WHERE
                    dmpl__RepairOrderId__c =: document.Id
                    AND dmpl__IsSchemeGenerated__c = false
                GROUP BY
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c
            ];
        }
    
        @testVisible
        private List<AggregateResult> getBillSummary()
        {
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SupplierAccountId__c'
            }, 'dmpl__Bill__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__BaseAmount__c',
                'dmpl__TaxAmount__c',
                'dmpl__ItemId__c',
                'dmpl__Quantity__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__PurchaseInvoiceId__c'
            }, 'dmpl__BillLine__c');
            return 
            [
                SELECT
                    dmpl__ItemId__c dmpl__ItemId__c,
                    dmpl__SKUId__c dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__BaseAmount__c) TotalAmount,
                    SUM(dmpl__TaxAmount__c) TaxAmount
                FROM
                    dmpl__BillLine__c
                WHERE
                    dmpl__PurchaseInvoiceId__c =: document.Id
                    AND dmpl__IsSchemeGenerated__c = false
                GROUP BY
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c
            ];
        }
    
        private List<SObject> getDocumentLines(){
            if(schemeType == SCHEMTYPE_PER_SO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SO){
                return getSOLines();
            } else if(schemeType == SCHEMTYPE_PER_PO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_PO){
                return getPOLines();
            } else if(schemeType == SCHEMTYPE_PER_SI || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SI){
                return getSILines();
            } else if(schemeType == SCHEMTYPE_PER_BILL || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_BILL){
                return getBillLines();
            } else if(schemeType == SCHEMTYPE_PER_RO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_RO){
                return getROLines();
            }
            return null;
        }
    
    	@testVisible
        private List<dmpl__SaleOrderLine__c> getSOLines(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__NetSchemeDiscount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__UnitPrice__c',
                'dmpl__SchemeRewardPoints__c'
            }, 'dmpl__SaleOrderLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__BenefitId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__NetSchemeDiscount__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitPrice__c,
                    dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
                    dmpl__SaleOrderId__r.dmpl__TransactionType__c,
                    dmpl__SaleOrderId__r.dmpl__BranchId__c,
                    dmpl__SchemeRewardPoints__c,
                    dmpl__LimitExpiryDays__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__SaleOrderLine__c
                WHERE
                    dmpl__SaleOrderId__c =: document.Id
            ];
        }
    
        @testVisible
        private List<dmpl__PurchaseOrderLine__c> getPOLines(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__NetSchemeDiscount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__SchemeRewardPoints__c ',
                'dmpl__UnitCost__c'
            }, 'dmpl__PurchaseOrderLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__NetSchemeDiscount__c,
                    dmpl__BenefitId__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitCost__c,
                    dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
                    dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
                    dmpl__PurchaseOrderId__r.dmpl__TransactionType__c,
                    dmpl__SchemeRewardPoints__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__PurchaseOrderLine__c
                WHERE
                    dmpl__PurchaseOrderId__c =: document.Id
            ];
        }
        
        @testVisible
        private List<dmpl__SaleInvoiceLine__c> getSILines(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__NetSchemeDiscount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__UnitPrice__c',
                'dmpl__SchemeRewardPoints__c'
            }, 'dmpl__SaleInvoiceLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__NetSchemeDiscount__c,
                    dmpl__BenefitId__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitPrice__c,
                    dmpl__SaleInvoiceId__r.dmpl__TransactionType__c,
                    dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
                    dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
                    dmpl__SchemeRewardPoints__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__SaleInvoiceLine__c
                WHERE
                    dmpl__SaleInvoiceId__c =: document.Id
            ];
        }
    
        @testVisible
        private List<dmpl__BillLine__c> getBillLines(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__NetSchemeDiscount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__UnitCost__c'
            }, 'dmpl__BillLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__NetSchemeDiscount__c,
                    dmpl__BenefitId__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitCost__c,
                    dmpl__PurchaseInvoiceId__r.dmpl__PartnerAccountId__c,
                    dmpl__PurchaseInvoiceId__r.dmpl__BranchId__c,
                    dmpl__PurchaseInvoiceId__r.dmpl__TransactionType__c,
                    dmpl__SchemeRewardPoints__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__BillLine__c
                WHERE
                    dmpl__PurchaseInvoiceId__c =: document.Id
            ];
        }
    
        @testVisible
        private List<dmpl__RepairOrderLine__c> getROLines(){
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__NetSchemeDiscount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__UnitPrice__c'
            }, 'dmpl__RepairOrderLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__NetSchemeDiscount__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitPrice__c,
                    dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
                    dmpl__RepairOrderId__r.dmpl__TransactionType__c,
                    dmpl__RepairOrderId__r.dmpl__BranchId__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__RepairOrderLine__c
                WHERE
                    dmpl__RepairOrderId__c =: document.Id
            ];
        }

        @testVisible
        private List<dmpl__SaleReturnLine__c> getSaleReturnLines(List<Id> saleReturnIds)
        {
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__SchemeDiscount__c',
                'dmpl__SchemeDiscountAmount__c',
                'dmpl__BaseAmount__c',
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__Quantity__c',
                'dmpl__UnitPrice__c',
                'dmpl__SchemeRewardPoints__c'
            }, 'dmpl__SaleReturnLine__c');
            return 
            [
                SELECT
                    Id,
                    dmpl__SchemeLineId__c,
                    dmpl__SchemeLineId__r.dmpl__SchemeId__c,
                    dmpl__SchemeDiscount__c,
                    dmpl__SchemeDiscountAmount__c,
                    dmpl__BenefitId__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__SKUId__c,
                    dmpl__ItemLotTypeId__c,
                    dmpl__Quantity__c,
                    dmpl__UnitPrice__c,
                    dmpl__SaleReturnId__r.dmpl__PartnerAccountId__c,
                    dmpl__SaleReturnId__r.dmpl__BranchId__c,
                    dmpl__SaleReturnId__r.dmpl__TransactionType__c,
                    dmpl__SchemeRewardPoints__c,
                    dmpl__IsSchemeGenerated__c
                FROM
                    dmpl__SaleReturnLine__c
                WHERE
                    dmpl__SaleReturnId__c IN: saleReturnIds
            ];
        }

    public class SchemeLineResult {
        public Integer qualificationCount;
        public Decimal targetToAchivementRatio;
        public dmpl__SchemeLine__c schemeLine;
        public List<SchemeConditionResult> conditionResults = new List<SchemeConditionResult>();

        public SchemeLineResult(dmpl__SchemeLine__c line){
            qualificationCount = 0;
            targetToAchivementRatio = 0;
            schemeLine = line;
        }
        
        public SchemeLineResult(
            Integer count, 
            Decimal ratio, 
            dmpl__SchemeLine__c line){
            qualificationCount = count;
            targetToAchivementRatio = ratio;
            schemeLine = line;
        }
    }

    public class SchemeConditionResult {
        public Decimal conditionValue;
        public Decimal reachedValue;

        public Integer qualificationCount;
        public Decimal targetToAchivementRatio;
        public dmpl__SchemeCondition__c condition;

        public SchemeConditionResult(dmpl__SchemeCondition__c condition){
            conditionValue = 0;
            reachedValue = 0;
            qualificationCount = 0;
            targetToAchivementRatio = 0;
            this.condition = condition;
        }
        public SchemeConditionResult(
            Integer count, 
            Decimal ratio, 
            dmpl__SchemeCondition__c condition){
            conditionValue = 0;
            reachedValue = 0;
            qualificationCount = count;
            targetToAchivementRatio = ratio;
            this.condition = condition;
        }
    }

    public class LineWrapper implements Comparable {
        public SObject source;
        public Boolean descending;
        public List<String> sourceFieldNames;
        public LineWrapper(SObject sourceObject, Boolean isDescending, List<String> fieldNames) {
            source = sourceObject;
            descending = isDescending;
            sourceFieldNames = fieldNames;
        }
    
        public Integer compareTo(Object compareTo) {
            LineWrapper compareToLine = (LineWrapper)compareTo;
            Integer returnValue = 0;
            if(sourceFieldNames.contains('dmpl__UnitPrice__c')){
                if ((Decimal)(source.get('dmpl__UnitPrice__c')) > (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
                    returnValue = descending?-1:1;
                } else if ((Decimal)(source.get('dmpl__UnitPrice__c')) < (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
                    returnValue = descending?1:-1;
                }
            }else if(sourceFieldNames.contains('dmpl__UnitCost__c')){
                if ((Decimal)(source.get('dmpl__UnitCost__c')) > (Decimal)(compareToLine.source.get('dmpl__UnitCost__c'))) {
                    returnValue = descending?-1:1;
                } else if ((Decimal)(source.get('dmpl__UnitCost__c')) < (Decimal)(compareToLine.source.get('dmpl__UnitCost__c'))) {
                    returnValue = descending?1:-1;
                }
            }    
            return returnValue;
        }
    }
}