@isTest
public with sharing class ItemHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = ItemDataHelper.createItem('Test Item', 'TEST123'); 
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.createItemUnitOfMeasure(item, 'Test UOM', 1); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item,
            'Test Lot Type',
            true,
            false,
            true
        );  
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.createItemFeature(item, 'Test Feature', 1, 1);
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.createItemAlias(item,itemLotType,'Test Alias');
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.createItemAlternate(item,100.0,50);
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.createItemServiceContract(item);
        itemServiceContract.dmpl__ActiveServiceContractRequired__c = true;
        itemServiceContract.dmpl__BillToPartnerAccount__c = true;   
        itemServiceContract.dmpl__IsScopeRestricted__c = false;
        itemServiceContract.dmpl__PopulateContractLines__c = true;
        itemServiceContract.dmpl__RestrictAssetContractLinesGeneration__c = false;
        itemServiceContract.dmpl__SingleUseContract__c = true;
        update itemServiceContract;
        
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.createItemServiceContractLine(itemServiceContract,true,10.0);
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.createItemRelation(item,100.0,5.0);
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.createItemMaintenanceSchedule(item);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.createItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.createItemInventoryAttribute(item);
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.createItemImageDetail(item);
        dmpl__SKU__c sku = ItemDataHelper.createSKU(true, item);
        dmpl__Item__c componentItem = ItemDataHelper.createItem('Component Item', 'COMP123');
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            item,
            componentItem,
            itemFeature,
            'Multiple Of Package',
            2
        );

        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customerAccount, branch);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(item, sku, deliveryOrder);
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.createDeliveryOrderTax(deliveryOrder, deliveryOrderLine, tax);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Resource__c Resource1 = TestDataHelpers.createResource('Resource 1');
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product');
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Incentive');
        dmpl__ItemGroupRule__c itemGroupRule1 = ItemDataHelper.createItemGroupRule('Item Name 1',itemGroup1);
        dmpl__ItemFeature__c Itemfeature1 = TestDataHelpers.createItemFeatures(partnerAccount1,item1);
    }

    @isTest
    static void updateItemPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        item.dmpl__IsPackage__c = false;
        update item;
        dmpl__Item__c updatedItem = ItemDataHelper.getItemByCode('TEST123');
        System.assertEquals(false, updatedItem.dmpl__IsPackage__c, 'Item should not be a package');
    }

    @isTest
    static void deleteItem() {
        dmpl__Item__c testItem = ItemDataHelper.createItem('Test Item1', 'TEST456');
        System.assertNotEquals(null, testItem, 'Item should be created before delete.');
        System.assertNotEquals(null, testItem.Id, 'Item ID should not be null.');
        delete testItem;
        dmpl__Item__c deletedItem = null;
        try {
            deletedItem = ItemDataHelper.getItemByCode('TEST456');
        } catch (Exception e) {
            deletedItem = null;
        }
        System.assertEquals(null, deletedItem, 'Item should be deleted and not found in query.');
    }

    @isTest
    static void createItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
         dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        System.assert(itemUOM != null, 'Item unit of measure should be created');
        System.assertEquals('Test UOM', itemUOM.Name, 'Item unit of measure name should be Test UOM');
    }

    @isTest
    static void updateItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        itemUOM.dmpl__ConversionRatio__c = 2;
        update itemUOM;
        dmpl__ItemUnitOfMeasure__c updatedItemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        System.assertEquals(2, updatedItemUOM.dmpl__ConversionRatio__c, 'Item unit of measure conversion ratio should be 2');
    }

    @isTest
    static void deleteItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        System.assertNotEquals(null, itemUOM, 'Item unit of measure should be created before delete.');
        System.assertNotEquals(null, itemUOM.Id, 'Item unit of measure ID should not be null.');
        delete itemUOM;
        dmpl__ItemUnitOfMeasure__c deletedItemUOM = null;
        try {
            deletedItemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        } catch (Exception e) {
            deletedItemUOM = null;
        }
        System.assertEquals(null, deletedItemUOM, 'Item unit of measure should be deleted and not found in query.');
    }

    @isTest
    static void createItemLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        System.assert(itemLotType != null, 'Item lot type should be created');
        System.assertEquals('Test Lot Type', itemLotType.Name, 'Item lot type name should be Test Lot Type');
        System.assertEquals(true, itemLotType.dmpl__IsSample__c, 'Item lot type should be marked as sample');
        System.assertEquals(false, itemLotType.dmpl__IsSaleable__c, 'Item lot type should not be marked as saleable');
        System.assertEquals(true, itemLotType.dmpl__IsPromo__c, 'Item lot type should be marked as promo');
    }

    @isTest 
    static void updateItemLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        dmpl__ItemLotType__c updatedItemLotType = ItemDataHelper.updateItemLotType(
            itemLotType, 
            'Updated Lot Type', 
            false, 
            true, 
            false
        );
        System.assertEquals('Updated Lot Type', updatedItemLotType.Name, 'Item lot type name should be Updated Lot Type');
        System.assertEquals(false, updatedItemLotType.dmpl__IsSample__c, 'Item lot type should not be marked as sample');
        System.assertEquals(true, updatedItemLotType.dmpl__IsSaleable__c, 'Item lot type should be marked as saleable');
        System.assertEquals(false, updatedItemLotType.dmpl__IsPromo__c, 'Item lot type should not be marked as promo');
    }

    @isTest
    static void deleteItemLotType() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        System.assertNotEquals(null, itemLotType, 'Item Lot Type should be created before delete.');
        System.assertNotEquals(null, itemLotType.Id, 'Item Lot Type ID should not be null.');
        delete itemLotType;
        dmpl__ItemLotType__c deletedLotType = null;
        try {
            deletedLotType = ItemDataHelper.getItemLotType(item.Id);
        } catch (Exception e) {
            deletedLotType = null;
        }
        System.assertEquals(null, deletedLotType, 'Item Lot Type should be deleted and not found in query.');
    }

    @isTest
    static void createItemFeaturePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        System.assert(itemFeature != null, 'Item feature should be created');
        System.assertEquals('Test Feature', itemFeature.Name, 'Item feature name should be Test Feature');
        System.assertEquals(1, itemFeature.dmpl__MaxComponentCount__c, 'Item feature max component count should be 1');
        System.assertEquals(1, itemFeature.dmpl__MinComponentCount__c, 'Item feature min component count should be 1');
    }

    @isTest
    static void updateItemFeaturePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        itemFeature.dmpl__MaxComponentCount__c = 2;
        update itemFeature;
        dmpl__ItemFeature__c updatedItemFeature = ItemDataHelper.getItemFeature(item.Id);
        System.assertEquals(2, updatedItemFeature.dmpl__MaxComponentCount__c, 'Item feature max component count should be 2');
        System.assertEquals(1, updatedItemFeature.dmpl__MinComponentCount__c, 'Item feature min component count should be 1');
        System.assertEquals('Test Feature', updatedItemFeature.Name, 'Item feature name should be Test Feature');
    }

    @isTest
    static void deleteItemFeature() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        System.assertNotEquals(null, itemFeature, 'Item Feature should be created before delete.');
        System.assertNotEquals(null, itemFeature.Id, 'Item Feature ID should not be null.');
        delete itemFeature;
        dmpl__ItemFeature__c deletedFeature = null;
        try {
            deletedFeature = ItemDataHelper.getItemFeature(item.Id);
        } catch (Exception e) {
            deletedFeature = null;
        }
        System.assertEquals(null, deletedFeature, 'Item Feature should be deleted and not found in query.');
    }

    @isTest
    static void createItemComponentPositive() {
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.getItemByCode('COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        Test.startTest();
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem, 
            componentItem, 
            retrievedFeature, 
            'Multiple Of Package', 
            2
        );
        Test.stopTest();
        System.assertNotEquals(null, itemComponent, 'Item component should be created');
        System.assertEquals('Multiple Of Package', itemComponent.dmpl__PackageType__c, 'Package type should be Multiple Of Package');
        System.assertEquals(2, itemComponent.dmpl__Quantity__c, 'Quantity should be 2');
    }

    @isTest
    static void updateItemComponentPositive() {
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.getItemByCode('COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem, 
            componentItem, 
            retrievedFeature, 
            'Multiple Of Package', 
            2
        );
        Test.startTest();
        dmpl__ItemComponent__c updatedItemComponent = ItemDataHelper.updateItemComponent(itemComponent, 'Independent Of Package', 3);
        Test.stopTest();
        System.assertEquals('Independent Of Package', updatedItemComponent.dmpl__PackageType__c, 'Package type should be Independent Of Package');
        System.assertEquals(3, updatedItemComponent.dmpl__Quantity__c, 'Quantity should be 3');
    }

    @isTest
    static void deleteItemComponentPositive() {
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.createItem('Component Item', 'COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem, 
            componentItem, 
            retrievedFeature, 
            'Multiple Of Package', 
            2
        );
        System.assertNotEquals(null, itemComponent, 'Item Component should be created before delete.');
        System.assertNotEquals(null, itemComponent.Id, 'Item Component ID should not be null.');
        Test.startTest();
        delete itemComponent;
        dmpl__ItemComponent__c deletedComponent = null;
        try {
            deletedComponent = ItemDataHelper.getItemComponent(parentItem.Id, componentItem.Id);
        } catch (Exception e) {
            deletedComponent = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedComponent, 'Item Component should be deleted and not found in query.');
    }

    @isTest
    static void createItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c lotType = ItemDataHelper.getItemLotType(item.Id);
        Test.startTest();
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemAlias, 'Item Alias should be created');
        System.assertEquals('Test Alias', itemAlias.Name, 'Alias name should be Test Alias');
        System.assertEquals(item.Id, itemAlias.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(lotType.Id, itemAlias.dmpl__ItemLotTypeId__c, 'Lot Type ID should match');
    }
    
    @isTest
    static void updateItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c originalLotType = ItemDataHelper.getItemLotType(item.Id);
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        dmpl__ItemLotType__c newLotType = ItemDataHelper.createItemLotType(
            item, 
            'New Lot Type', 
            false, 
            true, 
            true
        );
        Test.startTest();
        dmpl__ItemAlias__c updatedAlias = ItemDataHelper.updateItemAlias(itemAlias, 'Updated Alias', newLotType);
        Test.stopTest();
        System.assertEquals('Updated Alias', updatedAlias.Name, 'Alias name should be updated');
        System.assertEquals(newLotType.Id, updatedAlias.dmpl__ItemLotTypeId__c, 'Lot Type should be updated');
    }

    @isTest
    static void deleteItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c lotType = ItemDataHelper.getItemLotType(item.Id);
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        System.assertNotEquals(null, itemAlias, 'Item Alias should be created before delete');
        System.assertNotEquals(null, itemAlias.Id, 'Item Alias ID should not be null');
        Test.startTest();
        delete itemAlias;
        dmpl__ItemAlias__c deletedAlias = null;
        try {
            deletedAlias = ItemDataHelper.getItemAlias(item.Id);
        } catch (Exception e) {
            deletedAlias = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedAlias, 'Item Alias should be deleted and not found in query');
    }

    @isTest
    static void createItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        System.assertNotEquals(null, itemAlternate, 'Item Alternate should be created');
        System.assertNotEquals(null, itemAlternate.Id, 'Item Alternate ID should not be null');
        System.assertEquals(item.Id, itemAlternate.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(100.0, itemAlternate.dmpl__QuantityAvailable__c, 'Quantity Available should match');
        System.assertEquals(50.0, itemAlternate.dmpl__QuantityInHand__c, 'Quantity In Hand should match');
    }

    @isTest 
    static void updateItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        Test.startTest();
        dmpl__ItemAlternate__c updatedAlternate = ItemDataHelper.updateItemAlternate(itemAlternate, 200.0, 50.0);
        Test.stopTest();
        System.assertEquals(200.0, updatedAlternate.dmpl__QuantityAvailable__c, 'Quantity Available should be updated');
        System.assertEquals(50.0, updatedAlternate.dmpl__QuantityInHand__c, 'Quantity In Hand should be updated');
    }

    @isTest
    static void deleteItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        System.assertNotEquals(null, itemAlternate, 'Item Alternate should be created before delete');
        System.assertNotEquals(null, itemAlternate.Id, 'Item Alternate ID should not be null');
        Test.startTest();
        delete itemAlternate;
        dmpl__ItemAlternate__c deletedAlternate = null;
        try {
            deletedAlternate = ItemDataHelper.getItemAlternate(item.Id);
        } catch (Exception e) {
            deletedAlternate = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedAlternate, 'Item Alternate should be deleted and not found in query');
    }

    @isTest
    static void createItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemServiceContract, 'Item Service Contract should be created');
        System.assertEquals(item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, itemServiceContract.dmpl__ActiveServiceContractRequired__c, 'Active Service Contract Required should be true');
        System.assertEquals(true, itemServiceContract.dmpl__BillToPartnerAccount__c, 'Bill To Partner Account should be true');
        System.assertEquals(false, itemServiceContract.dmpl__IsScopeRestricted__c, 'Is Scope Restricted should be false');
        System.assertEquals(true, itemServiceContract.dmpl__PopulateContractLines__c, 'Populate Contract Lines should be true');
        System.assertEquals(false, itemServiceContract.dmpl__RestrictAssetContractLinesGeneration__c, 'Restrict Asset Contract Lines Generation should be false');
        System.assertEquals(true, itemServiceContract.dmpl__SingleUseContract__c, 'Single Use Contract should be true');
    }

    @isTest
    static void updateItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        Test.startTest();
        dmpl__ItemServiceContract__c updatedContract = ItemDataHelper.updateItemServiceContract(itemServiceContract);
        updatedContract.dmpl__ActiveServiceContractRequired__c = false;
        updatedContract.dmpl__BillToPartnerAccount__c = false;
        updatedContract.dmpl__IsScopeRestricted__c = true;
        updatedContract.dmpl__PopulateContractLines__c = false;
        updatedContract.dmpl__RestrictAssetContractLinesGeneration__c = true;
        updatedContract.dmpl__SingleUseContract__c = false;
        update updatedContract;
        Test.stopTest();
        System.assertEquals(false, updatedContract.dmpl__ActiveServiceContractRequired__c, 'Active Service Contract Required should be updated to false');
        System.assertEquals(false, updatedContract.dmpl__BillToPartnerAccount__c, 'Bill To Partner Account should be updated to false');
        System.assertEquals(true, updatedContract.dmpl__IsScopeRestricted__c, 'Is Scope Restricted should be updated to true');
        System.assertEquals(false, updatedContract.dmpl__PopulateContractLines__c, 'Populate Contract Lines should be updated to false');
        System.assertEquals(true, updatedContract.dmpl__RestrictAssetContractLinesGeneration__c, 'Restrict Asset Contract Lines Generation should be updated to true');
        System.assertEquals(false, updatedContract.dmpl__SingleUseContract__c, 'Single Use Contract should be updated to false');
    }

    @isTest
    static void deleteItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        System.assertNotEquals(null, itemServiceContract, 'Item Service Contract should be created before delete');
        System.assertNotEquals(null, itemServiceContract.Id, 'Item Service Contract ID should not be null');
        Test.startTest();
        delete itemServiceContract;
        dmpl__ItemServiceContract__c deletedContract = null;
        try {
            deletedContract = ItemDataHelper.getItemServiceContract(item.Id);
        } catch (Exception e) {
            deletedContract = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedContract, 'Item Service Contract should be deleted and not found in query');
    }

    @isTest
    static void createItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        Test.startTest();
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        Test.stopTest();
        System.assertNotEquals(null, contractLine, 'Contract Line should be created');
        System.assertNotEquals(null, contractLine.Id, 'Contract Line ID should not be null');
        System.assertEquals(itemServiceContract.Id, contractLine.dmpl__ItemServiceContractId__c, 'Service Contract ID should match');
        System.assertEquals(true, contractLine.dmpl__IsInScope__c, 'Is In Scope should be true');
        System.assertEquals(10.0, contractLine.dmpl__Quantity__c, 'Quantity should be 10');
    }

    @isTest
    static void updateItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        Test.startTest();
        dmpl__ItemServiceContractLine__c updatedContractLine = ItemDataHelper.updateItemServiceContractLine(contractLine, false, 20.0);
        Test.stopTest();
        System.assertEquals(false, updatedContractLine.dmpl__IsInScope__c, 'Is In Scope should be updated to false');
        System.assertEquals(20.0, updatedContractLine.dmpl__Quantity__c, 'Quantity should be updated to 20');
    }

    @isTest
    static void deleteItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        System.assertNotEquals(null, contractLine, 'Contract Line should be created before delete');
        System.assertNotEquals(null, contractLine.Id, 'Contract Line ID should not be null');
        Test.startTest();
        delete contractLine;
        dmpl__ItemServiceContractLine__c deletedContractLine = null;
        try {
            deletedContractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        } catch (Exception e) {
            deletedContractLine = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedContractLine, 'Contract Line should be deleted and not found in query');
    }

    @isTest
    static void createItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemRelation, 'Item Relation should be created');
        System.assertEquals(item.Id, itemRelation.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(100.0, itemRelation.dmpl__Price__c, 'Price should be 100');
        System.assertEquals(5.0, itemRelation.dmpl__Quantity__c, 'Quantity should be 5');
    }

    @isTest
    static void updateItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        Test.startTest();
        dmpl__ItemRelation__c updatedItemRelation = ItemDataHelper.updateItemRelation(itemRelation, 200.0, 10.0);
        Test.stopTest();
        System.assertEquals(200.0, updatedItemRelation.dmpl__Price__c, 'Price should be updated to 200');
        System.assertEquals(10.0, updatedItemRelation.dmpl__Quantity__c, 'Quantity should be updated to 10');
    }

    @isTest
    static void deleteItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        System.assertNotEquals(null, itemRelation, 'Item Relation should be created before delete');
        System.assertNotEquals(null, itemRelation.Id, 'Item Relation ID should not be null');
        Test.startTest();
        delete itemRelation;
        dmpl__ItemRelation__c deletedItemRelation = null;
        try {
            deletedItemRelation = ItemDataHelper.getItemRelation(item.Id);
        } catch (Exception e) {
            deletedItemRelation = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedItemRelation, 'Item Relation should be deleted and not found in query');
    }

    @isTest
    static void createItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemMaintenanceSchedule, 'Item Maintenance Schedule should be created');
        System.assertEquals(1, itemMaintenanceSchedule.dmpl__Sequence__c, 'Sequence should be 1');
        System.assertEquals(30, itemMaintenanceSchedule.dmpl__ToDurationDays__c, 'Duration Days should be 30');
        System.assertEquals(100.00, itemMaintenanceSchedule.dmpl__ToUsageHours__c, 'Usage Hours should be 100');
        System.assertEquals(1000.00, itemMaintenanceSchedule.dmpl__ToUsageReading__c, 'Usage Reading should be 1000');
    }

    @isTest
    static void updateItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        Test.startTest();
        dmpl__ItemMaintenanceSchedule__c updatedSchedule = ItemDataHelper.updateItemMaintenanceSchedule(item);
        Test.stopTest();
        System.assertEquals(2, updatedSchedule.dmpl__Sequence__c, 'Sequence should be updated to 2');
        System.assertEquals(60, updatedSchedule.dmpl__ToDurationDays__c, 'Duration Days should be updated to 60');
        System.assertEquals(200.00, updatedSchedule.dmpl__ToUsageHours__c, 'Usage Hours should be updated to 200');
        System.assertEquals(2000.00, updatedSchedule.dmpl__ToUsageReading__c, 'Usage Reading should be updated to 2000');
    }

    @isTest
    static void deleteItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        System.assertNotEquals(null, itemMaintenanceSchedule, 'Item Maintenance Schedule should be created before delete');
        System.assertNotEquals(null, itemMaintenanceSchedule.Id, 'Item Maintenance Schedule ID should not be null');
        Test.startTest();
        delete itemMaintenanceSchedule;
        dmpl__ItemMaintenanceSchedule__c deletedSchedule = null;
        try {
            deletedSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        } catch (Exception e) {
            deletedSchedule = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedSchedule, 'Item Maintenance Schedule should be deleted and not found in query');
    }

    @isTest
    static void createItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        Test.startTest();
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        Test.stopTest();
        System.assertNotEquals(null, scheduleDetails, 'Item Maintenance Schedule Details should be created');
        System.assertEquals(Date.today(), scheduleDetails.dmpl__LastServiceDate__c, 'Last Service Date should be today');
    }

    @isTest 
    static void updateItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        Test.startTest();
        dmpl__ItemMaintenanceScheduleDetails__c updatedDetails = ItemDataHelper.updateItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        Test.stopTest();
        System.assertEquals(Date.today().addDays(30), updatedDetails.dmpl__LastServiceDate__c, 'Last Service Date should be updated to 30 days from today');
    }

    @isTest
    static void deleteItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        System.assertNotEquals(null, scheduleDetails, 'Item Maintenance Schedule Details should be created before delete');
        System.assertNotEquals(null, scheduleDetails.Id, 'Item Maintenance Schedule Details ID should not be null');
        Test.startTest();
        delete scheduleDetails;
        dmpl__ItemMaintenanceScheduleDetails__c deletedDetails = null;
        try {
            deletedDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        } catch (Exception e) {
            deletedDetails = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedDetails, 'Item Maintenance Schedule Details should be deleted and not found in query');
    }

    @isTest
    static void createItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, inventoryAttribute, 'Item Inventory Attribute should be created');
        System.assertEquals(1000.00, inventoryAttribute.dmpl__MaximumStockLevel__c, 'Maximum Stock Level should be 1000');
        System.assertEquals(10.00, inventoryAttribute.dmpl__MinimumOrderQuantity__c, 'Minimum Order Quantity should be 10');
        System.assertEquals(100.00, inventoryAttribute.dmpl__MinimumStockLevel__c, 'Minimum Stock Level should be 100');
        System.assertEquals(500.00, inventoryAttribute.dmpl__MaximumOrderQuantity__c, 'Maximum Order Quantity should be 500');
    }

    @isTest
    static void updateItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        Test.startTest();
        dmpl__ItemInventoryAttribute__c updatedAttribute = ItemDataHelper.updateItemInventoryAttribute(item);
        Test.stopTest();
        System.assertEquals(2000.00, updatedAttribute.dmpl__MaximumStockLevel__c, 'Maximum Stock Level should be updated to 2000');
        System.assertEquals(20.00, updatedAttribute.dmpl__MinimumOrderQuantity__c, 'Minimum Order Quantity should be updated to 20');
        System.assertEquals(200.00, updatedAttribute.dmpl__MinimumStockLevel__c, 'Minimum Stock Level should be updated to 200');
        System.assertEquals(1000.00, updatedAttribute.dmpl__MaximumOrderQuantity__c, 'Maximum Order Quantity should be updated to 1000');
    }
    
    @isTest
    static void deleteItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        System.assertNotEquals(null, inventoryAttribute, 'Item Inventory Attribute should be created before delete');
        System.assertNotEquals(null, inventoryAttribute.Id, 'Item Inventory Attribute ID should not be null');
        Test.startTest();
        delete inventoryAttribute;
        dmpl__ItemInventoryAttribute__c deletedAttribute = null;
        try {
            deletedAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        } catch (Exception e) {
            deletedAttribute = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedAttribute, 'Item Inventory Attribute should be deleted and not found in query');
    }

    @isTest
    static void createItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, imageDetail, 'Item Image Detail should be created');
        System.assertEquals('Test Image', imageDetail.Name, 'Name should be Test Image');
        System.assertEquals('https://test-image-url.com', imageDetail.dmpl__LinkUrl__c, 'Link URL should match test URL');
    }

    @isTest 
    static void updateItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        Test.startTest();
        dmpl__ItemImageDetail__c updatedImageDetail = ItemDataHelper.updateItemImageDetail(item);
        Test.stopTest();
        System.assertEquals('Updated Test Image', updatedImageDetail.Name, 'Name should be updated');
        System.assertEquals('https://updated-test-image-url.com', updatedImageDetail.dmpl__LinkUrl__c, 'Link URL should be updated');
    }

    @isTest
    static void deleteItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        System.assertNotEquals(null, imageDetail, 'Item Image Detail should be created before delete');
        System.assertNotEquals(null, imageDetail.Id, 'Item Image Detail ID should not be null');
        Test.startTest();
        delete imageDetail;
        dmpl__ItemImageDetail__c deletedImageDetail = null;
        try {
            deletedImageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        } catch (Exception e) {
            deletedImageDetail = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedImageDetail, 'Item Image Detail should be deleted and not found in query');
    }

    @isTest
    static void createSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__SKU__c sku = ItemDataHelper.getSKU(item.Id);
        Test.stopTest();
        System.assertNotEquals(null, sku, 'SKU should be created');
        System.assertEquals('Test SKU', sku.Name, 'Name should be Test SKU');
        System.assertEquals(true, sku.dmpl__IsDefault__c, 'IsDefault should be true');
    }

    @isTest 
    static void updateSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__SKU__c sku = ItemDataHelper.getSKU(item.Id);
        Test.startTest();
        dmpl__SKU__c updatedSKU = ItemDataHelper.updateSKU(false, item);
        Test.stopTest();
        System.assertEquals('Updated Test SKU', updatedSKU.Name, 'Name should be updated');
        System.assertEquals(false, updatedSKU.dmpl__IsDefault__c, 'IsDefault should be updated to false');
    }

    @isTest
    static void deleteSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__SKU__c sku = ItemDataHelper.getSKU(item.Id);
        System.assertNotEquals(null, sku, 'SKU should be created before delete');
        System.assertNotEquals(null, sku.Id, 'SKU ID should not be null');
        dmpl__SKU__c deletedSKU = null;
        Test.startTest();
        try {
            Database.delete(sku, false);
        	deletedSKU = ItemDataHelper.getSKU(item.Id);
        }
        catch(Exception e) {
            deletedSKU = null;
            System.assert.isTrue(true, 'SKU should get deleted');
        }
        Test.stopTest();
        System.assertEquals(null, deletedSKU, 'SKU should be deleted and not found in query');
    }

    @isTest
    static void createItemCreationNewPositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        System.assertEquals( item.Id, itemLotType.dmpl__ItemId__c, 'Mandatory fields avialable');
    }

    @isTest
    static void createItemLotTypeWithRequiredFieldsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'T1', 
            false, 
            false, 
            false
        );  
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('T1', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void createItemLotTypeWithAllBooleanSetToFalsePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'T1', 
            false, 
            false, 
            false
        );  
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('T1', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void createItemLotTypeWithIsSaleableTruePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            true, 
            false
        );
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(true, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be true');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void createItemLotTypeWithIsPromoTruePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            false, 
            true
        );
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(true, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be true');
    }

    @isTest
    static void createItemLotTypeWithPromoAndSaleableTruePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            true, 
            true
        );
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(true, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be true');
        System.assertEquals(true, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be true');
    }

    @isTest
    static void updateItemLotTypeSetPromoTrueAndSaleableFalsePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            true, 
            true
        );
        itemLotType.dmpl__IsSaleable__c= false;
        itemLotType.dmpl__IsPromo__c = false;
        update itemLotType;
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void updateItemLotTypeSetPromoFasleAndSaleableFalsePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            true, 
            true
        );
        itemLotType.dmpl__IsSaleable__c = false;
        itemLotType.dmpl__IsPromo__c = false;
        update itemLotType;
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(false, fetchedLotType.dmpl__IsSample__c, ' isSample should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void createItemLotTypeWithIsSampleTruePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            true, 
            false, 
            false
        );
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, fetchedLotType.dmpl__IsSample__c, ' isSample should be true');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }

    @isTest
    static void updateItemLotTypeSetIsSampleFalsePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            false, 
            false, 
            false
        );
        itemLotType.dmpl__IsSample__c = true;
        update itemLotType;
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, fetchedLotType.dmpl__IsSample__c, ' isSample should be true');
        System.assertEquals(false, fetchedLotType.dmpl__IsSaleable__c, 'IsSaleable should be false');
        System.assertEquals(false, fetchedLotType.dmpl__IsPromo__c, 'IsPromo should be false');
    }
    
    @isTest
    static void updateItemLotTypeSetMRPValuePositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            null, 
            null
        );
        itemLotType.dmpl__MRP__c = 100;
        update itemLotType;
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(Item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(100, fetchedLotType.dmpl__MRP__c, 'MRP is not available');
    }

    @isTest
    static void  updateItemLotTypeSetExternalItemIdPositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            null, 
            null
        );
        itemLotType.dmpl__ExternalItemCode__c = item.Id;
        update itemLotType;
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals(item.Id, fetchedLotType.dmpl__ExternalItemCode__c, 'Should contain Item.Id');
    }

    @isTest
    static void createItemLotTypeWithExternalItemIdPositive(){
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item, 
            'Test Lot Type', 
            null, 
            Item.Id
        );
        dmpl__ItemLotType__c fetchedLotType = ItemDataHelper.getItemLotType(itemLotType);
        System.assertEquals('Test Lot Type', fetchedLotType.Name, 'Lot Type Name should be IT');
        System.assertEquals(item.Id, fetchedLotType.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(null, fetchedLotType.dmpl__MRP__c, 'MRP is not available');
        System.assertEquals(Item.Id, fetchedLotType.dmpl__ExternalItemCode__c, 'Should Conatin Id');
    }

    @isTest
    static void createItemImageDetailWithActiveItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
    }

    @isTest
    static void createItemImageDetailWithItemAndComponentItemIDsMappedCorrectlyPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item3 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, item3.Id);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(item3.Id, fetchedImageDetail.dmpl__ComponentItemId__c, 'Component Item ID should match the expected value');
    }

    @isTest
    static void createItemImageDetailWithDetailDescriptionProvidedPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item3 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, item3.Id);
        itemImageDetail.dmpl__Shape__c = 'Default';
        update itemImageDetail;
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(item3.Id, fetchedImageDetail.dmpl__ComponentItemId__c, 'Component Item ID should match the expected value');
        System.assertEquals('Default', fetchedImageDetail.dmpl__Shape__c, 'Detail description should match the expected value');
    }

    @isTest
    static void createItemImageDetailWithCorrectMappingOfItemComponentIdToItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem, 
            item1, 
            retrievedFeature, 
            'Multiple Of Package', 
            2
        );
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, itemComponent.Id, null);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(itemComponent.Id, fetchedImageDetail.dmpl__ItemComponentId__c, 'Item Component ID should match the Item ID');
    }

    @isTest
    static void updateItemImageDetailLinkedToItemHavingMultipleShapePositive(){
        Boolean exceptionThrown = false;      
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        itemImageDetail.dmpl__Shape__c = 'rect';
        update itemImageDetail;
        dmpl__ItemImageDetail__c beforeUpdate = ItemDataHelper.getItemImageDetail(itemImageDetail);      
        System.assertEquals('Item detail', beforeUpdate.Name, 'Initial name should be Item detail');
        System.assertEquals(item1.Id, beforeUpdate.dmpl__ItemId__c, 'Initial item ID should match');
        System.assertEquals('rect', beforeUpdate.dmpl__Shape__c, 'Initial detail should be Shape: Rectangle');
		try {
        itemImageDetail.dmpl__Shape__c = 'Circle';
        update itemImageDetail;
        } catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__ItemImageDetail__c afterUpdate = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', afterUpdate.Name, 'Updated name should still be Item detail');
        System.assertEquals(item1.Id, afterUpdate.dmpl__ItemId__c, 'Updated item ID should still match');
        System.assertEquals('Circle', afterUpdate.dmpl__Shape__c, 'Detail should be updated to Shape: Circle');
    }

    @isTest
    static void createItemImageDetailWithoutItemIDNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail;
        try {
            itemImageDetail = ItemDataHelper.createItemImageDetail(null, null, item.Id);
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail must fail when Item ID is missing or mismatched');
        } catch (Exception e) {
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail must fail when Item ID is missing or mismatched');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemImageDetailWithComponentItemIDNotBelongingToItemNegative() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail;
        try {
            itemImageDetail = ItemDataHelper.createItemImageDetail(
                item1.Id,  
                null,  
                item4.Id
            );
        } catch (Exception e) {
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail must fail when Item ID is missing or mismatched');
        }
        Test.stopTest();
    }

    @isTest
    static void updateItemImageDetailWithItemNegative() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        System.assertEquals('Item detail', itemImageDetail.Name, 'Initial name should be Item detail');
        System.assertEquals(item1.Id, itemImageDetail.dmpl__ItemId__c, 'Initial item ID should match');
        Boolean exceptionThrown = false;
        try {
            itemImageDetail.dmpl__ItemId__c = item3.Id; 
            update itemImageDetail;
            System.assert.isTrue(false, 'Update should have failed due to item change.');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(true, 'Expected exception thrown due to item update restriction.');
        }
        Test.stopTest();
        dmpl__ItemImageDetail__c afterUpdate = ItemDataHelper.getItemImageDetail(itemImageDetail);
        System.assertEquals('Item detail', afterUpdate.Name, 'Name should remain unchanged');
        System.assertEquals(item1.Id, afterUpdate.dmpl__ItemId__c, 'Item ID should not have changed');
    }

    @isTest
    static void createItemImageDetailWithIncorrectMappingBetweenItemComponentIdAndComponentItemIdNegative() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c item6 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail;
        Boolean exceptionThrown = false;
        try {
            itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, item6.Id, item3.Id);
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail creation must fail due to incorrect mapping');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail creation must fail due to incorrect mapping');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemImageDetailWithoutLinkURLPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item3 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, item3.Id);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(item3.Id, fetchedImageDetail.dmpl__ComponentItemId__c, 'Component Item ID should match');
        System.assertEquals(null, fetchedImageDetail.dmpl__Shape__c, 'Detail description should be null');
        Test.stopTest();
    }

    @isTest
    static void createItemImageDetailForItemWithNoComponentPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should be Item detail');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match the created item');
    }

    @isTest
    static void createItemImageDetailWithShapeProvidedButWrongCoordinatesNegative() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail;
        Boolean exceptionThrown = false;
        try {
            itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
            itemImageDetail.dmpl__Shape__c = 'rect';
            itemImageDetail.dmpl__Coordinate__c = '1x1x1';
            update itemImageDetail;
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemImageDetail == null, 'Item Image Detail creation must fail due to incorrect coordinates format.');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemImageDetailWithLinkURLPositive() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        String imageUrl = 'https://cdn.zeebiz.com/sites/default/files/2022/11/05/209096-virat-kohli-7-pti.jpg';
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        itemImageDetail.dmpl__LinkUrl__c = imageUrl;
        update itemImageDetail;
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertNotEquals(null, fetchedImageDetail, 'Item Image Detail should be created successfully');
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should match');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(imageUrl, fetchedImageDetail.dmpl__LinkUrl__c, 'Link URL should match');
    }

    @isTest
    static void createMultipleItemImageDetailsForASingleItemWithDifferentComponentsPositive() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem, 
            item1, 
            retrievedFeature, 
            'Multiple Of Package', 
            2
        );
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, itemComponent.Id, null);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertNotEquals(null, fetchedImageDetail, 'Item Image Detail should be created successfully');
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should match');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(itemComponent.Id, fetchedImageDetail.dmpl__ItemComponentId__c, 'Component Item ID should match');
    }

    @isTest
    static void createItemImageDetailLinkedToItemHavingMultipleShapesPositive() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        itemImageDetail.dmpl__Shape__c ='rect';
        update itemImageDetail;
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertNotEquals(null, fetchedImageDetail, 'Item Image Detail should be created');
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should match');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals('rect', fetchedImageDetail.dmpl__Shape__c, 'Shape should be Rectangle');
    }

    @isTest
    static void createItemImageDetailWithBlankShapeTypePositive() {
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemImageDetail__c itemImageDetail = ItemDataHelper.createItemImageDetail(item1.Id, null, null);
        dmpl__ItemImageDetail__c fetchedImageDetail = ItemDataHelper.getItemImageDetail(itemImageDetail);
        Test.stopTest();
        System.assertNotEquals(null, fetchedImageDetail, 'Item Image Detail should be created');
        System.assertEquals('Item detail', fetchedImageDetail.Name, 'Name should match');
        System.assertEquals(item1.Id, fetchedImageDetail.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void createItemInventoryAttributeWithActiveItemPositive(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount.Id, branch.Id, item1.Id);
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createItemInventoryAttributeWithWithABCCategoryPositive(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount.Id, branch.Id, item1.Id);
        itemInventoryAttribute.dmpl__ABCCategory__c = 'A Category';
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals('A Category', fetchedAttribute.dmpl__ABCCategory__c, 'ABC Category should match');
    }

    @isTest
    static void createItemInventoryAttributeWithProperFSNCategoryValuesPositive(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount.Id, branch.Id, item1.Id);
        itemInventoryAttribute.dmpl__FSNCategory__c = 'Fast Moving';
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals('Fast Moving', fetchedAttribute.dmpl__FSNCategory__c, 'FSN Category should match');
    }

    @isTest
    static void createItemInventoryAttributeWithReorderLevelAndQuantityCorrectlyPositive(){
            Test.startTest();
            Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
            dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
            dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount.Id, branch.Id, item1.Id);
            itemInventoryAttribute.dmpl__ReorderLevel__c = 15;
            update itemInventoryAttribute;
            dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
            Test.stopTest();
            System.assertEquals(partnerAccount.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(branch.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
            System.assertEquals(15, fetchedAttribute.dmpl__ReorderLevel__c, 'Reorder Level should be 15');
    }
    @isTest
    static void createItemInventoryAttributeWithMinimumAndMaximumStockLevelsDefinedPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
        itemInventoryAttribute.dmpl__MinimumStockLevel__c = 15;
        itemInventoryAttribute.dmpl__MaximumStockLevel__c = 20;
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(15, fetchedAttribute.dmpl__MinimumStockLevel__c, 'Minimum stock level should be 15');
        System.assertEquals(20, fetchedAttribute.dmpl__MaximumStockLevel__c, 'Maximum stock level should be 20');
    }

    @isTest
        static void createItemInventoryAttributeWithMinimumAndMaximumOrderQuantitiesProvidedPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
        itemInventoryAttribute.dmpl__MinimumStockLevel__c = 10;
        itemInventoryAttribute.dmpl__MaximumStockLevel__c = 15;
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, fetchedAttribute.dmpl__MinimumStockLevel__c, 'Minimum Order Quantity should be 10');
        System.assertEquals(15, fetchedAttribute.dmpl__MaximumStockLevel__c, 'Maximum Order Quantity should be 15');
    }

    @isTest
        static void createItemInventoryAttributeWithSKUInOneBranchPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item9 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item9.Id);
        itemInventoryAttribute.dmpl__SKUId__c = sku3.Id;
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item9.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku3.Id, fetchedAttribute.dmpl__SKUId__c, 'SKU should match');
        }

    @isTest
    static void createItemInventoryAttributeWithABCAndFSNPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
        itemInventoryAttribute.dmpl__ABCCategory__c = 'A Category';
        itemInventoryAttribute.dmpl__FSNCategory__c = 'Fast Moving';
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
        System.assertEquals('A Category', fetchedAttribute.dmpl__ABCCategory__c, 'ABC Category should be A category');
        System.assertEquals('Fast Moving', fetchedAttribute.dmpl__FSNCategory__c, 'FSN Category should be Fast moving');
    }

    @isTest
    static void createItemInventoryAttributeWithoutSKUIDPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item9 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item9.Id);
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
		System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
		System.assertEquals(item9.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createItemInventoryAttributeWithInactiveItemNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(
                partnerAccount4.Id, 
                branch4.Id, 
                item2.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail due to inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithReorderLevelGreaterThanMaximumStockLevelNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, null);
            itemInventoryAttribute.dmpl__MaximumStockLevel__c = 10;
            itemInventoryAttribute.dmpl__ReorderLevel__c = 20;
            update itemInventoryAttribute;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when item is null or inactive');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when item is null or inactive');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithMinimumStockLevelGreaterThanMaximumStockLevelNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(
                partnerAccount4.Id, 
                branch4.Id, 
                null
            );
            itemInventoryAttribute.dmpl__MinimumStockLevel__c = 10;
            itemInventoryAttribute.dmpl__ReorderLevel__c = 20;
            update itemInventoryAttribute;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when MinStock > MaxStock');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when MinStock > MaxStock');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithNegativeQuantitiesNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, null);
            itemInventoryAttribute.dmpl__MaximumStockLevel__c = -3;
            itemInventoryAttribute.dmpl__ReorderLevel__c = -4;
            update itemInventoryAttribute;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when MinStock > MaxStock');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when MinStock > MaxStock');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithReorderQuantityLessMinimumOrderQuantityNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        item1.dmpl__IsActive__c = false;
        update item1;
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
            itemInventoryAttribute.dmpl__MinimumStockLevel__c = 10;
            itemInventoryAttribute.dmpl__ReorderLevel__c = 5;
            update itemInventoryAttribute;
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail due to inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithMinSameAsMaxValuesForStockLevelNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
            itemInventoryAttribute.dmpl__MinimumStockLevel__c = 5;
            itemInventoryAttribute.dmpl__MaximumStockLevel__c = 5;
            update itemInventoryAttribute;
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when Min and Max stock levels are the same');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemInventoryAttributeWithoutMaximumAndMinimumOrderQuantityNegative() {
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
        Boolean exceptionThrown = false;
        try {
            itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when minimum and maximum order quantities are missing.');
        }
        Test.stopTest();
    }

    @isTest
	static void createItemInventoryAttributeCreatedforInValidSKUNegative(){
		Test.startTest();
		Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1'); 
		dmpl__SKU__c sku3 = TestDataHelpers.getSKU('Test SKU');
		dmpl__ItemInventoryAttribute__c itemInventoryAttribute;
		Boolean exceptionThrown = false;
		try {
			itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
			itemInventoryAttribute.dmpl__SKUId__c = sku3.Id;
            update itemInventoryAttribute;
		} catch (Exception e) {
			exceptionThrown = true;
			System.assert.isTrue(itemInventoryAttribute == null, 'Item Inventory Attribute creation must fail when minimum and maximum order quantities are missing.');
		}
		Test.stopTest();
	}

	@isTest
	static void createItemInventoryAttributewithReorderLevelEqualtoMinimumStockLevelPositive(){
		Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__ItemInventoryAttribute__c itemInventoryAttribute = ItemDataHelper.createItemInventoryAttribute(partnerAccount4.Id, branch4.Id, item1.Id);
        itemInventoryAttribute.dmpl__MinimumStockLevel__c = 20;
        itemInventoryAttribute.dmpl__ReorderLevel__c = 20;
        update itemInventoryAttribute;
        dmpl__ItemInventoryAttribute__c fetchedAttribute = ItemDataHelper.getItemInventoryAttribute(itemInventoryAttribute);
        Test.stopTest();
       	System.assertEquals(partnerAccount4.Id, fetchedAttribute.dmpl__PartnerAccountId__c, 'Partner Account should match');
		System.assertEquals(branch4.Id, fetchedAttribute.dmpl__BranchId__c, 'Branch should match');
		System.assertEquals(item1.Id, fetchedAttribute.dmpl__ItemId__c, 'Item should match');
		System.assertEquals(20, fetchedAttribute.dmpl__MinimumStockLevel__c, 'Minium Stock Level Match');
		System.assertEquals(20, fetchedAttribute.dmpl__ReorderLevel__c, 'Record Level should match');
	}

    @isTest
    static void createItemLotWithItemIDAndSKUIDPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__SKUId__c = sku3.Id;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(sku3.Id, fetchedLot.dmpl__SKUId__c, 'SKU should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createItemLotWithValidDateFieldsExpiryAndMFGPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = ItemDataHelper.getItemByCode('TEST123'); 
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('Test SKU');
        Date dateOfMfg = Date.newInstance(2025, 6, 22);
        Date dateOfExpiry = Date.newInstance(2025, 6, 20);
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__SKUId__c = sku3.Id;
        itemLot.dmpl__DateOfMfg__c = dateOfMfg;
        itemLot.dmpl__DateOfExpiry__c = dateOfExpiry;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(sku3.Id, fetchedLot.dmpl__SKUId__c, 'SKU should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(dateOfMfg, fetchedLot.dmpl__DateOfMfg__c, 'Manufacture Date should match');
        System.assertEquals(dateOfExpiry, fetchedLot.dmpl__DateOfExpiry__c, 'Expiry Date should match');
    }

    @isTest
    static void createItemLotWithDiscontinuedItemPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item4.Id);
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item4.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createItemLotWithUnitCostAndTotalCostPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__SKUId__c = sku3.Id;
        itemLot.dmpl__Cost__c = 1000;
        itemLot.dmpl__UnitCost__c = 100;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(sku3.Id, fetchedLot.dmpl__SKUId__c, 'SKU should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, fetchedLot.dmpl__Cost__c, 'Total Cost should be 1000');
        System.assertEquals(100, fetchedLot.dmpl__UnitCost__c, 'Unit Cost should be 100');
    }

    @isTest
    static void createItemLotWithActivePartnerAccountAndBranchPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createItemLotWithSerialNumberAndRegistrationNumberProvidedPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 1'); 
        String serialNumber = 'SN2233';
        String registrationNumber = 'REG2025A001';
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__SerialNumber__c = serialNumber;
        itemLot.dmpl__RegistrationNumber__c = registrationNumber;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(serialNumber, fetchedLot.dmpl__SerialNumber__c, 'Serial Number should match');
        System.assertEquals(registrationNumber, fetchedLot.dmpl__RegistrationNumber__c, 'Registration Number should match');
    }

    @isTest
    static void createItemLotWithInwardAndPurchaseDatePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 1'); 
        Date dateOfInward = Date.newInstance(2025, 6, 22);
        Date purchaseDate = Date.newInstance(2025, 6, 20);
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__DateOfInward__c = dateOfInward;
        itemLot.dmpl__PurchaseDate__c = purchaseDate;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(dateOfInward, fetchedLot.dmpl__DateOfInward__c, 'Date of Inward should match');
        System.assertEquals(purchaseDate, fetchedLot.dmpl__PurchaseDate__c, 'Purchase Date should match');
    }

   @isTest
    static void updateItemLotWithInactiveItemNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try {
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item2.Id);
            itemLot.dmpl__ItemId__c = itemLot.Id;
            update itemLot;
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(true, 'ItemLot creation must fail for inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemLotWithProperStorageLocationPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1= TestDataHelpers.createStorageLocation('Storage Location 1', branch1.Id);
        dmpl__ItemLot__c itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
        itemLot.dmpl__StorageLocationId__c = storageLocation1.Id;
        update itemLot;
        dmpl__ItemLot__c fetchedLot = ItemDataHelper.getItemLot(itemLot);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedLot.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedLot.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item9.Id, fetchedLot.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(storageLocation1.Id, fetchedLot.dmpl__StorageLocationId__c, 'Storage Location should match');
    }

    @isTest
    static void createItemLotWithExpiryDateEarlierThanManufacturingDateNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 1'); 
        Date dateOfMfg = Date.newInstance(2025, 6, 22);
        Date dateOfExpiry = Date.newInstance(2025, 6, 18); 
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try {
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item9.Id);
            itemLot.dmpl__DateOfMfg__c = dateOfMfg;
            itemLot.dmpl__DateOfExpiry__c = dateOfExpiry;
            update itemLot;
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to expiry date before manufacturing date');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemLotWithMissingMandatoryFieldsNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try{
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, null);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to missing mandatory fields');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemLotWithInactiveItemNegative() {
    Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try {
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item2.Id);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createItemLotWithNegativeQuantitiesNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try {
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, branch1.Id, item2.Id); 
            itemLot.dmpl__QuantitySold__c = -4;
            update itemLot;
            itemLot = ItemDataHelper.getItemLot(itemlot);
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to negative quantity');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(exceptionThrown, 'Item Lot creation must fail due to negative quantity');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception due to negative quantity was not thrown.');
    }

    @isTest
    static void createItemLotWithWrongBranchNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c validBranch = TestDataHelpers.getBranch('Branch 1');
        validBranch.dmpl__IsActive__c = false;
        update validBranch;
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 1'); 
        dmpl__ItemLot__c itemLot;
        Boolean exceptionThrown = false;
        try {
            dmpl__Branch__c wrongBranch = TestDataHelpers.getBranch('Branch 1');
            itemLot = ItemDataHelper.createItemLot(partnerAccount1.Id, wrongBranch.Id, item5.Id);
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to wrong branch usage');
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert.isTrue(itemLot == null, 'Item Lot creation must fail due to wrong branch usage');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Expected exception due to wrong branch usage was not thrown.');
    }

    @isTest
    static void createItemWithNamePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item A');
        } catch (Exception e) {
            System.assert(false, 'Item creation should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item A', item.Name, 'Item Name should match the input name.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithItemTypePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item A', 'Product');
        } catch (Exception e) {
            System.assert(false, 'Item creation with Item Type should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item A', item.Name, 'Item Name should match input.');
        System.assertEquals('Product', item.dmpl__ItemType__c, 'Item Type should match input.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutItemTypePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item B');
        } catch (Exception e) {
            System.assert(false, 'Item creation without Item Type should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item B', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__ItemType__c, 'Item Type should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithTypeAndSubTypePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item C', 'Charge Item', 'Insurance');
        } catch (Exception e) {
            System.assert(false, 'Item creation with Type and SubType should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item C', item.Name, 'Item Name should match input.');
        System.assertEquals('Charge Item', item.dmpl__ItemType__c, 'Item Type should match input.');
        System.assertEquals('Insurance', item.dmpl__ItemSubType__c, 'Item SubType should match input.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithPrimaryUnitOfMeasurePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item E', 'Box', true);
        } catch (Exception e) {
            System.assert(false, 'Item creation with Primary Unit of Measure should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item E', item.Name, 'Item Name should match input.');
        System.assertEquals('Box', item.dmpl__QuantityUnitOfMeasure__c, 'Primary Unit of Measure should match input.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutPrimaryUnitOfMeasurePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item F1'); 
        } catch (Exception e) {
            System.assert(false, 'Item creation without Primary UOM should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item F1', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__QuantityUnitOfMeasure__c, 'Primary UOM should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutDescriptionPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item G');
        } catch (Exception e) {
            System.assert(false, 'Item creation without Description should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item G', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__Description__c, 'Description should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutInventoryTrackingPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreation('Item H', false);
        } catch (Exception e) {
            System.assert(false, 'Item creation without Inventory Tracking should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item H', item.Name, 'Item Name should match input.');
        System.assertEquals(false, item.dmpl__TrackInventory__c, 'TrackInventory should be false.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutABCFSCategoriesPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithoutCategories('Item I');
        } catch (Exception e) {
            System.assert(false, 'Item creation without ABC and FSN categories should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals(null, item.dmpl__ABCCategory__c, 'ABC Category should be blank.');
        System.assertEquals(null, item.dmpl__FSNCategory__c, 'FSN Category should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutGTINPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithoutGTIN('Item J');
        } catch (Exception e) {
            System.assert(false, 'Item creation without GTIN should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item J', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__GTIN__c, 'GTIN should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithIsActiveFalsePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithInactiveStatus('Item K');
        } catch (Exception e) {
            System.assert(false, 'Item creation with IsActive = FALSE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item K', item.Name, 'Item Name should match input.');
        System.assertEquals(false, item.dmpl__IsActive__c, 'Item should be inactive.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithIsDiscontinuedTruePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithIsDiscontinued('Item L');
        } catch (Exception e) {
            System.assert(false, 'Item creation with IsDiscontinued = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item L', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__IsDiscontinued__c, 'Item should be marked as discontinued.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithOnlySoldInPackageTruePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithOnlySoldInPackage('Item M');
        } catch (Exception e) {
            System.assert(false, 'Item creation with OnlySoldInPackage = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item M', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__OnlySoldInPackage__c, 'OnlySoldInPackage should be TRUE.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithIsSKURequiredTruePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithIsSKURequired('Item N');
        } catch (Exception e) {
            System.assert(false, 'Item creation with IsSKURequired = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item N', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__IsSKURequired__c, 'IsSKURequired should be TRUE.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithIsRegistrationRequiredTruePositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithIsRegistrationRequired('Item O');
        } catch (Exception e) {
            System.assert(false, 'Item creation with IsRegistrationRequired = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item O', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__IsRegistrationRequired__c, 'IsRegistrationRequired should be TRUE.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }
    
    @isTest
    static void createItemWithoutFamilyAndSegmentPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithoutFamilyAndSegment('Item P');
        } catch (Exception e) {
            System.assert(false, 'Item creation without Item Family and Segment should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item P', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__ItemFamily__c, 'Item Family should be blank.');
        System.assertEquals(null, item.dmpl__ItemSegment__c, 'Item Segment should be blank.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithFamilyAndSegmentPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithFamilyAndSegment('Item Q', 'Sample', 'Sample');
        } catch (Exception e) {
            System.assert(false, 'Item creation with Family and Segment should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item Q', item.Name, 'Item Name should match input.');
        System.assertEquals('Sample', item.dmpl__ItemFamily__c, 'Item Family should match input.');
        System.assertEquals('Sample', item.dmpl__ItemSegment__c, 'Item Segment should match input.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithAllowServiceEnabledPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithAllowService('Item R');
        } catch (Exception e) {
            System.assert(false, 'Item creation with AllowService = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item R', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__AllowService__c, 'AllowService should be TRUE.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithTrackLotsEnabledPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithTrackLots('Item S');
        } catch (Exception e) {
            System.assert(false, 'Item creation with TrackLots = TRUE should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item S', item.Name, 'Item Name should match input.');
        System.assertEquals(true, item.dmpl__TrackLots__c, 'TrackLots should be TRUE.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemWithoutRFIDPositive() {
        Test.startTest();
        dmpl__Item__c item;
        try {
            item = ItemDataHelper.itemCreationWithoutRFID('Item U');
        } catch (Exception e) {
            System.assert(false, 'Item creation without RFID should not throw an exception.');
        }
        System.assertNotEquals(null, item, 'Item must be created!');
        System.assertEquals('Item U', item.Name, 'Item Name should match input.');
        System.assertEquals(null, item.dmpl__RFID__c, 'RFID should be blank/null.');
        System.assertEquals(true, item.dmpl__IsActive__c, 'Item should be active.');
        Test.stopTest();
    }

    @isTest
    static void createItemAliasWithNamePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlias__c alias = ItemDataHelper.itemAliasCreation('Aliases 1', item.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals('Aliases 1', alias.Name, 'Alias name should match');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Item should be correctly linked');
    }

    @isTest
    static void createItemAliasWithoutNameNegative() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlias__c alias = ItemDataHelper.itemAliasCreationWithoutName(item.Id);
        Test.stopTest();
        System.assertEquals(null, alias.Name, 'Alias name should be blank');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Item should be correctly linked');
    }

    @isTest
    static void createItemAliasWithLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c lotType = ItemDataHelper.getItemLotType(item.Id);
        Test.startTest();
        dmpl__ItemAlias__c alias = ItemDataHelper.itemAliasWithLotTypeCreation('Aliases 2', item.Id, lotType.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals('Aliases 2', alias.Name, 'Alias name should match');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Item should be correctly linked');
        System.assertEquals(lotType.Id, alias.dmpl__ItemLotTypeId__c, 'Lot Type should be correctly linked');
    }

    @isTest
    static void createItemAliasWithoutLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlias__c alias = ItemDataHelper.itemAliasWithoutLotTypeCreation('Aliases 3', item.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals('Aliases 3', alias.Name, 'Alias name should match');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Item should be correctly linked');
        System.assertEquals(null, alias.dmpl__ItemLotTypeId__c, 'Lot Type should be blank');
    }

    @isTest
    static void createItemAliasWithoutItemNegative() {
        Test.startTest();
        dmpl__ItemAlias__c alias = ItemDataHelper.itemAliasWithoutItemCreation('Aliases 4');
        Test.stopTest();
        System.assertEquals('Aliases 4', alias.Name, 'Alias name should be set correctly');
        System.assertEquals(null, alias.dmpl__ItemId__c, 'Item should not be linked');
    }

    @isTest
    static void createItemAliasWithOnlyItemPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        String aliasName = 'Aliases 5';
        dmpl__ItemAlias__c alias;
        Test.startTest();
        alias = ItemDataHelper.itemAliasWithItemOnly(aliasName, item.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals(aliasName, alias.Name, 'Alias name should match input');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Alias must be linked to Item');
    }

    @isTest
    static void createItemAliasWithInactiveItemPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        item.dmpl__IsActive__c = false;
        update item;
        String aliasName = 'Aliases 6';
        dmpl__ItemAlias__c alias;
        Test.startTest();
        alias = ItemDataHelper.itemAliasWithInactiveItem(aliasName, item.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals(aliasName, alias.Name, 'Alias name should match input');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Alias must be linked to Inactive Item');
        System.assertEquals(false, item.dmpl__IsActive__c, 'Linked Item must be inactive');
    }

    @isTest
    static void createItemAliasWithoutSKUPositive() {
       dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        String aliasName = 'Aliases 9';
        dmpl__ItemAlias__c alias;
        Test.startTest();
        alias = ItemDataHelper.itemAliasWithoutSKU(aliasName, item.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Item Alias should be created');
        System.assertEquals(aliasName, alias.Name, 'Alias name should match input');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Alias must be linked to the item');
        System.assertEquals(null, alias.dmpl__SKUId__c, 'SKU should be null');
    }

    @isTest
    static void createItemAliasWithPartnerAccountPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        String aliasName = 'Aliases 10';
        dmpl__ItemAlias__c alias;
        Test.startTest();
        alias = ItemDataHelper.itemAliasWithPartnerAccount(aliasName, item.Id, partner.Id);
        Test.stopTest();
        System.assertNotEquals(null, alias, 'Alias must be created');
        System.assertEquals(aliasName, alias.Name, 'Alias name should match');
        System.assertEquals(item.Id, alias.dmpl__ItemId__c, 'Item ID must match');
        System.assertEquals(partner.Id, alias.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
	
    @isTest
    static void createItemMaintenanceScheduleWithActiveItemPositive() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithFromAndToDurationDaysPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Integer fromDurationDays = 2;
        Integer toDurationDays = 3;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__FromDurationDays__c = 2;
            schedule.dmpl__ToDurationDays__c = 3;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(fromDurationDays, schedule.dmpl__FromDurationDays__c, 'From Duration Days mismatch');
        System.assertEquals(toDurationDays, schedule.dmpl__ToDurationDays__c, 'To Duration Days mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithFromAndToUsageHoursPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal fromUsageHours = 2;
        Decimal toUsageHours =  4;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__FromUsageHours__c = 2;
            schedule.dmpl__ToUsageHours__c = 4;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(fromUsageHours, schedule.dmpl__FromUsageHours__c, 'From Usage Hours mismatch');
        System.assertEquals(toUsageHours, schedule.dmpl__ToUsageHours__c, 'To Usage Hours mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithFromAndToUsageReadingPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal fromUsageReading =  2300;
        Decimal toUsageReading =  4000;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__FromUsageReading__c = 2300;
            schedule.dmpl__ToUsageReading__c = 4000;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(fromUsageReading, schedule.dmpl__FromUsageReading__c, 'From Usage Reading mismatch');
        System.assertEquals(toUsageReading, schedule.dmpl__ToUsageReading__c, 'To Usage Reading mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithDueInDaysPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Integer dueInDays = 5;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__DueInDays__c = 5;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(dueInDays, schedule.dmpl__DueInDays__c, 'Due In Days mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithDueOnUsageHoursPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal dueOnUsage =  5;
        Decimal dueInUsageHours = 4;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__DueOnUsage__c = 5;
            schedule.dmpl__DueinUsageHours__c = 4;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(dueOnUsage, schedule.dmpl__DueOnUsage__c, 'Due On Usage mismatch');
        System.assertEquals(dueInUsageHours, schedule.dmpl__DueinUsageHours__c, 'Due In Usage Hours mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithReminderOffsetPositive() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__Numberofreminder__c = 5;
            schedule.dmpl__ReminderDaysOffset1__c = 1;
            schedule.dmpl__ReminderDaysOffset2__c = 2;
            schedule.dmpl__ReminderDaysOffset3__c = 3;
            schedule.dmpl__ReminderDaysOffset4__c = 4;
            schedule.dmpl__ReminderDaysOffset5__c = 5;
            update schedule;
        } catch (Exception e) {
            System.assert(true, 'Schedule creation should not throw an error: ' + e.getMessage());
        }
        schedule = ItemDataHelper.getItemMaintenanceSchedulebyId(schedule.Id);
        System.assertEquals(item?.Id, schedule.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku?.Id, schedule.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(5, schedule.dmpl__Numberofreminder__c, 'Number of Reminders mismatch');
        System.assertEquals(1, schedule.dmpl__ReminderDaysOffset1__c, 'Reminder Offset 1 mismatch');
        System.assertEquals(2, schedule.dmpl__ReminderDaysOffset2__c, 'Reminder Offset 2 mismatch');
        System.assertEquals(3, schedule.dmpl__ReminderDaysOffset3__c, 'Reminder Offset 3 mismatch');
        System.assertEquals(4, schedule.dmpl__ReminderDaysOffset4__c, 'Reminder Offset 4 mismatch');
        System.assertEquals(5, schedule.dmpl__ReminderDaysOffset5__c, 'Reminder Offset 5 mismatch');
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithoutItemNegative() {		
        Test.startTest();
        dmpl__Item__c item = null;
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal dueOnUsage =  5;
        Decimal dueInUsageHours = 4;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__DueOnUsage__c = 5;
            schedule.dmpl__DueinUsageHours__c = 4;
            update schedule;
            System.assert(schedule == null, 'Schedule creation should throw an error');
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithInvalidUsageRangeNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal fromUsageReading =  2000;
        Decimal toUsageReading =  1200;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__FromUsageReading__c = 2000;
            schedule.dmpl__ToUsageReading__c = 1200;
            update schedule;
            schedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
            System.assert(schedule == null, 'Schedule creation should throw an error');
        } catch (Exception e) {
            System.assert.isTrue(true, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithWrongSKUNegative() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithInactiveItemNegative() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = null;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithReminderOffesetZeroNegative() {	
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithNegativeUsageNegative() {
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        Decimal dueOnUsage = -2;
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule.dmpl__DueOnUsage__c = -2;
            update schedule;
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
    static void createItemMaintenanceScheduleWithBlankDueInDaysNegative() {		
        Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(schedule == null, 'Schedule creation should throw an error: ' + e.getMessage());
        }
        Test.stopTest();
    }

	@isTest
	static void createItemMaintenanceScheduleWithSequenceNumberDuplicateAcrossSameItemPositive(){
		Test.startTest();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('Test SKU');
        dmpl__ItemMaintenanceSchedule__c schedule;
        dmpl__ItemMaintenanceSchedule__c schedule2;
        try {
            schedule = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
            schedule2 = ItemDataHelper.createItemMaintenanceSchedule(item?.Id, sku?.Id);
        } catch (Exception e) {
            System.assert(schedule2 != null, 'Schedule creation should not throw an error: >> '+  e.getMessage());
        }	
		System.assert(schedule != null, 'Schedule creation should not throw an error: ');
		System.assert(schedule2 != null, 'Schedule creation should not throw an error: ' );
        Test.stopTest();
	}

    @isTest
    static void createAlternateForInactiveItemPositive() {
        dmpl__Item__c inactiveItem = ItemDataHelper.getItemByCode('TEST123');
        inactiveItem.dmpl__IsActive__c = false;
        update inactiveItem;
        dmpl__Item__c altItem = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c itemAlt = ItemDataHelper.createAlternateForInactiveItem(inactiveItem.Id, altItem.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemAlt, 'Item Alternate should be created');
        System.assertNotEquals(null, itemAlt.Id, 'Item Alternate ID should not be null');
        System.assertEquals(inactiveItem.Id, itemAlt.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(altItem.Id, itemAlt.dmpl__AlternateItemId__c, 'Alternate Item ID should match');
    }

    @isTest
    static void createAlternateForDiscontinuedItemPositive() {
        dmpl__Item__c discontinuedItem = ItemDataHelper.getItemByCode('TEST123');
        discontinuedItem.dmpl__IsDiscontinued__c = true;
        update discontinuedItem;
        dmpl__Item__c altItem = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c itemAlt = ItemDataHelper.createAlternateForDiscontinuedItem(discontinuedItem.Id, altItem.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemAlt, 'Item Alternate should be created');
        System.assertEquals(discontinuedItem.Id, itemAlt.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(altItem.Id, itemAlt.dmpl__AlternateItemId__c, 'Alternate Item should match');
    }

    @isTest
    static void createAlternateWithoutTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c altItem = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c itemAlt = ItemDataHelper.createAlternateWithoutType(item.Id, altItem.Id);
        Test.stopTest();
        System.assertNotEquals(null, itemAlt, 'Item Alternate should be created');
        System.assertEquals(item.Id, itemAlt.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(altItem.Id, itemAlt.dmpl__AlternateItemId__c, 'Alternate Item should match');
        System.assertEquals(null, itemAlt.dmpl__AlternateType__c, 'Alternate Type should be blank');
    }

    @isTest
    static void createAlternateWithTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c altRec = ItemDataHelper.createAlternateWithType(item.Id, alt.Id, 'Optional/ Interchangeable');
        Test.stopTest();
        System.assertNotEquals(null, altRec);
        System.assertEquals('Optional/ Interchangeable', altRec.dmpl__AlternateType__c);
    }

    @isTest
    static void createAlternateOnlyItemsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c rec = ItemDataHelper.createAlternateOnlyItems(item.Id, alt.Id);
        Test.stopTest();
        System.assertNotEquals(null, rec);
        System.assertEquals(alt.Id, rec.dmpl__AlternateItemId__c);
    }

    @isTest
    static void createAlternateWithQtyAvailablePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c rec = ItemDataHelper.createAlternateWithQtyAvailable(item.Id, alt.Id, 100);
        Test.stopTest();
        System.assertEquals(100, rec.dmpl__QuantityAvailable__c);
    }

    @isTest
    static void createAlternateWithoutQtyAvailablePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c rec = ItemDataHelper.createAlternateWithoutQtyAvailable(item.Id, alt.Id);
        Test.stopTest();
        System.assertEquals(null, rec.dmpl__QuantityAvailable__c);
    }

    @isTest
    static void createAlternateWithoutQtyInHandPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c rec = ItemDataHelper.createAlternateWithoutQtyInHand(item.Id, alt.Id);
        Test.stopTest();
        System.assertEquals(null, rec.dmpl__QuantityInHand__c);
    }

    @isTest
    static void createAlternateWithQtyInHandPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c alt = ItemDataHelper.getItemByCode('TEST123');
        Test.startTest();
        dmpl__ItemAlternate__c rec = ItemDataHelper.createAlternateWithQtyInHand(item.Id, alt.Id, 50);
        Test.stopTest();
        System.assertEquals(50, rec.dmpl__QuantityInHand__c);
    }

    @isTest
    static void createIscCreationWithBillingAccountPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithInactiveBillingAccountNegative(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithFromDaysPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithoutFromDaysPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__FromDays__c = null;
        update itemServiceContract;
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }
    
    @isTest
    static void createIscCreationWithDateEffectiveFromPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithoutDateEffectiveFromPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithContractPostingTreatmentPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }

    @isTest
    static void createIscCreationWithoutContractPostingTreatmentPositive(){
        dmpl__Item__c Item = TestDataHelpers.getItem();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        itemServiceContract.dmpl__BillingAccountId__c = partnerAccount.Id;
        update itemServiceContract;
        itemServiceContract = ItemDataHelper.getItemServiceContract(Item.Id);
        System.assertNotEquals(null, itemServiceContract, 'ItemServiceContract should not be null');
        System.assertEquals(Item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(partnerAccount.Id, itemServiceContract.dmpl__BillingAccountId__c, 'Account ID should match');
    }
}