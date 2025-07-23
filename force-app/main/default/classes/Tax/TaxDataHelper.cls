public with sharing class TaxDataHelper {
    public static dmpl__TaxGroupRule__c createTaxGroupRule(
        dmpl__Item__c item,
        dmpl__SKU__c SKU,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ItemGroup__c ItemGroup
    ) {
        return (dmpl__TaxGroupRule__c) TestFactory.createSObject(
            new dmpl__TaxGroupRule__c(
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__SKUId__c = SKU.Id,
                dmpl__ItemId__c = Item.Id,
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 15,
                dmpl__PlaceOfSupplyType__c = 'Within State',
                dmpl__ItemGroupId__c = ItemGroup.Id
            ),
            true
        );
    }

    public static dmpl__TaxGroupRule__c createTaxGroupRule(
        Id taxGroupId,
        Id itemId,
        Id itemGroupId,
        String supplyType,
        Date effectiveFromDate,
        Date effectiveTillDate
    ) {
        return (dmpl__TaxGroupRule__c) TestFactory.createSObject(
            new dmpl__TaxGroupRule__c(
                dmpl__TaxGroupId__c = taxGroupId,
                dmpl__ItemId__c = itemId,
                dmpl__ItemGroupId__c = itemGroupId,
                dmpl__TaxSupplyType__c = supplyType,
                dmpl__DateEffectiveFrom__c = effectiveFromDate,
                dmpl__DateEffectiveTill__c = effectiveTillDate
            ),
            true
        );
    }
    
    public static dmpl__TaxGroupRule__c getTaxGroupRule() {
        return [
            SELECT 
                Id, 
                dmpl__PlaceOfSupplyType__c, 
                dmpl__DateEffectiveFrom__c, 
                dmpl__DateEffectiveTill__c, 
                dmpl__TaxGroupId__c, 
                dmpl__SKUId__c, 
                dmpl__ItemId__c, 
                dmpl__ItemGroupId__c, 
                dmpl__TaxSupplyType__c
            FROM dmpl__TaxGroupRule__c 
            LIMIT 1
        ];
    }

    public static dmpl__TaxGroupRule__c getTaxGroupRule(
        Id id
    ) {
        return [
            SELECT 
                Id, 
                dmpl__PlaceOfSupplyType__c, 
                dmpl__DateEffectiveFrom__c, 
                dmpl__DateEffectiveTill__c, 
                dmpl__TaxGroupId__c, 
                dmpl__SKUId__c, 
                dmpl__ItemId__c, 
                dmpl__ItemGroupId__c, 
                dmpl__TaxSupplyType__c
            FROM dmpl__TaxGroupRule__c 
            WHERE Id = :id
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemGroup__c createItemGroup() {
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = 'Item Group Test',
                dmpl__ItemGroupType__c = 'Tax'
            ),
            'ItemGroupDefaults',
            true
        );
    }

    public static dmpl__ItemGroup__c getItemGroup() {
        return [
            SELECT
                Id,
                Name 
            FROM dmpl__ItemGroup__c 
            LIMIT 1
        ];
    }
}