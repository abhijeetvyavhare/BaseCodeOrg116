@isTest
public with sharing class BranchHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partner.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(null, branch);
    }

    @isTest
    static void createBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Expected branch to be created.');
        System.assertEquals('Branch 1', branch.Name, 'Name not matched.');
        System.assertNotEquals(branch.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccountId__c to be set.');
    }

    @isTest
    static void updateBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before update.');
        branch.Name = 'UpdatedBranch';
        update branch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch();
        System.assertEquals('UpdatedBranch', updatedBranch.Name, 'Expected Name to be updated to UpdatedBranch.');
    }

    @isTest
    static void deleteBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before delete.');
        delete branch;
        dmpl__Branch__c deletedBranch;
        try {
            deletedBranch = TestDataHelpers.getBranch();
        } catch (Exception e) {
            deletedBranch = null;
        }
        System.assertEquals(null, deletedBranch, 'Expected Branch to be deleted and not found.');
    }


     @isTest
    static void  CreateBranchWithAllRequiredfieldsPartnerAccountAndBranchNamePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False ,False);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 4');

     }

    @isTest
    static void  createEditBranchTochangeIsActivePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False ,False);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 4');

     }

    @isTest
    static void  createEditBranchAndenableAllowServicePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, True, False ,False ,False, False, False);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(true , fetchedBranch.dmpl__AllowService__c,'Expected true for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');

     }

    @isTest
    static void  createBranchCreationWithIsActiveFalseHomeDeliveryFalsePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,True,False ,False,False, False);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected true for field 2');
        System.assertEquals(true, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  true field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }

    @isTest
    static void  createBranchCreationWithAllBooleanFieldsAtDefaultvaluesPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False,False ,False,False, False);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }
    

    @isTest
    static void  createBranchcreationWithoutPartnerAccountNegative(){
        Test.startTest();
        Boolean exceptionThrown= false;  
        dmpl__Branch__c branch;
        try {
        branch = TestDataHelpers.createBranch('Branch Name',null, True, False ,False,False ,False,False, False);
        } catch (Exception e) {
           exceptionThrown = true;
        }
         Test.stopTest();
     }


    @isTest
    static void  createBranchCreationWithoutBranchNameNegative(){
        Boolean exceptionThrown=false;
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        try {
             dmpl__Branch__c branch = TestDataHelpers.createBranch(null,partnerAccount1.Id, True, False ,False,False ,False,False, False);
        } catch (Exception e) {
                exceptionThrown = true;
                System.debug('Expected exception caught: ' + e.getMessage());
            }
          Test.stopTest();
    }

    @isTest
    static void  createBranchCreationWithNullValueInIsActiveFieldPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false,false ,false,false, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }

    @isTest
    static void  createSaveWithMissingValuesInMandatoryDropdownBranchNameNegative(){
        Boolean exceptionThrown = false;
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        Test.stopTest();
        try {
            dmpl__Branch__c branch = TestDataHelpers.createBranch(
                null, 
                partnerAccount1.Id,
                true, false, false, false, false, false, false
            );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
    }


    @isTest
    static void createUseInvalidPartnerAccountThatIsInactiveOrDeletedNegative() {
       
        Boolean exceptionThrown = false;
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        Test.startTest();
        try {
        dmpl__Branch__c branch = TestDataHelpers.createBranch(
            'Branch Name',
            partnerAccount2.Id,
            true, false, false, false, false, false, false
        );
            insert branch;
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive/deleted partner account.');
    }

    @isTest
    static void  updateEditBranchToEnablePickupDropTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);
        branch.dmpl__IsPickupDropAvailable__c = true;
        update branch;
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(true, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }     


     
    @isTest
    static void UpdateBranchToEnableTheAllowSalesTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__AllowSales__c = true;
        update fetchedBranch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }  
    
    @isTest
    static void updateEditBranchToEnableTheAllowPurchaseTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__AllowPurchase__c=true;
        update fetchedBranch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(true, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }   
     
    @isTest
    static void createBranchCreationWithAllowSalesTrueAndAllowPurchaseTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false,false ,true,true, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(true, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }    

    @isTest
    static void createBranchCreationWithIsActiveFalseAndHomeDeliveryTRUE(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,true ,false ,false,true, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(true, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }  

    @isTest
    static void updateEditBranchToEnableAllowInventoryTrueAndHomeDeliveryTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false ,false ,false ,false, false);
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__IsHomeDeliveryAvailable__c= true;
        fetchedBranch.dmpl__AllowInventory__c = true;
        update fetchedBranch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(true, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(true, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }  

    
    @isTest
    static void createBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        if(branchTimeSlot != null) {
            System.assertNotEquals(branchTimeSlot, null, 'Expected branchTimeSlot to be created.');
        }
        System.assertEquals('Delivery', branchTimeSlot.dmpl__TransactionType__c, 'Transaction type must Delivery');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'Name should be Test - branchTimeSlot');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__MondayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__TuesdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__WednesdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__ThursdayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__SundayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__FridayCapacity__c, 'Capacity must be 12');
        System.assertEquals(12, branchTimeSlot.dmpl__SaturdayCapacity__c, 'Capacity must be 12');
        System.assertNotEquals(branchTimeSlot.dmpl__BranchId__c, null, 'Expected dmpl__BranchId__c to be created.');
    }
    
    @isTest
    static void updateBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        System.assertNotEquals(branchTimeSlot, null, 'BranchTimeSlot should exist before update.');
        branchTimeSlot.dmpl__TransactionType__c = 'Product Demo';
        branchTimeSlot.Name = 'Updated - branchTimeSlot';
        branchTimeSlot.dmpl__MaximumCapacity__c = 25;
        branchTimeSlot.dmpl__MondayCapacity__c = 15;
        branchTimeSlot.dmpl__TuesdayCapacity__c = 14;
        branchTimeSlot.dmpl__WednesdayCapacity__c = 13;
        branchTimeSlot.dmpl__ThursdayCapacity__c = 12;
        branchTimeSlot.dmpl__FridayCapacity__c = 11;
        branchTimeSlot.dmpl__SaturdayCapacity__c = 10;
        branchTimeSlot.dmpl__SundayCapacity__c = 9;
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c updatedBranchTimeSlot = BranchTestDataHelper.getBranchTimeSlot(branchTimeSlot.Id);
        System.assertEquals('Product Demo', updatedBranchTimeSlot.dmpl__TransactionType__c, 'Expected TransactionType to be updated to Product Demo');
        System.assertEquals('Updated - branchTimeSlot', updatedBranchTimeSlot.Name, 'Expected Name to be updated');
        System.assertEquals(25, updatedBranchTimeSlot.dmpl__MaximumCapacity__c, 'Expected MaximumCapacity to be 25');
        System.assertEquals(15, updatedBranchTimeSlot.dmpl__MondayCapacity__c, 'Expected MondayCapacity to be 15');
        System.assertEquals(14, updatedBranchTimeSlot.dmpl__TuesdayCapacity__c, 'Expected TuesdayCapacity to be 14');
        System.assertEquals(13, updatedBranchTimeSlot.dmpl__WednesdayCapacity__c, 'Expected WednesdayCapacity to be 13');
        System.assertEquals(12, updatedBranchTimeSlot.dmpl__ThursdayCapacity__c, 'Expected ThursdayCapacity to be 12');
        System.assertEquals(11, updatedBranchTimeSlot.dmpl__FridayCapacity__c, 'Expected FridayCapacity to be 11');
        System.assertEquals(10, updatedBranchTimeSlot.dmpl__SaturdayCapacity__c, 'Expected SaturdayCapacity to be 10');
        System.assertEquals(9, updatedBranchTimeSlot.dmpl__SundayCapacity__c, 'Expected SundayCapacity to be 9');
    }
    
    @isTest
    static void deleteBranchTimeSlotPositive() {
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        System.assertNotEquals(branchTimeSlot, null, 'BranchTimeSlot should exist before delete.');
        delete branchTimeSlot;
        dmpl__BranchTimeSlot__c deletedBranchTimeSlot = null;
        try {
            deletedBranchTimeSlot = BranchTestDataHelper.getBranchTimeSlot(branchTimeSlot.Id);
        } catch (Exception e) {
            deletedBranchTimeSlot = null;
        }
        System.assertEquals(null, deletedBranchTimeSlot, 'BranchTimeSlot should be deleted and not found in query.');
    }
    
    @isTest
    static void createBranchTimeSlotWithTimeSlotNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithTimeSlotNamePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.name = 'T10';
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('T10', fetchTimeSlot.Name, 'TimeSlot name should be "T10"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }    

    @isTest
    static void updateBranchTimeSlotWithTimeSlotStartTimePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 15, 0, 0);
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(8, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(branchTimeSlot.dmpl__MaximumCapacity__c, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithTimeSlotEndTimePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__EndTime__c = Time.newInstance(11, 15, 0, 0);
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(11, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void createBranchTimeSlotWithStartTimeAfterEndTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__Branch__c branch = TestDataHelpers.getbranch();
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(10, 30, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(10, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithEndTimeBeforeStartTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 30, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(8, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithEndTimeSameAsStartTimeNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            branchTimeSlot.dmpl__StartTime__c = Time.newInstance(8, 15, 0, 0);
            branchTimeSlot.dmpl__EndTime__c = Time.newInstance(8, 15, 0, 0);
            update branchTimeSlot;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Start time Should be less than end time');
    }
    
    @isTest
    static void createBranchTimeSlotWithoutBranchTagNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(
                null, 
                'T1', 
                Time.newInstance(8, 15, 0, 0), 
                Time.newInstance(8, 15, 0, 0), 
                12
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown for missing Branch');
    }
    
    @isTest
    static void createBranchTimeSlotWithoutMaximumCapacityNegative() {
        Boolean exceptionThrown = false;
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(
                branch, 
                'T1', 
                Time.newInstance(8, 15, 0, 0), 
                Time.newInstance(8, 15, 0, 0), 
                null
            );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown for missing Maximum capacity');
    }
    
    @isTest
    static void createBranchTimeSlotWithMaximumCapacityPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void updateBranchTimeSlotWithMaximumCapacityPositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__MaximumCapacity__c = 17;
        update branchTimeSlot;
        dmpl__BranchTimeSlot__c fetchTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, fetchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', fetchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), fetchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), fetchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(17, fetchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
    }
    
    @isTest
    static void createBranchTimeSlotWithIsActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        Test.stopTest();
        System.assertNotEquals(null, branchTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, branchTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', branchTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), branchTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), branchTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, branchTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
        System.assertEquals(true, branchTimeSlot.dmpl__IsActive__c, 'Time Slot should be active');
    }
    
    @isTest
    static void updateBranchTimeSlotWithIsActivePositive() {
        Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getbranch();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        branchTimeSlot.dmpl__IsActive__c = false;
        Update branchTimeSlot;
        dmpl__BranchTimeSlot__c updatedTimeSlot = BranchTestDataHelper.getbranchTimeSlot(branchTimeSlot.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedTimeSlot, 'BranchTimeSlot should not be null');
        System.assertEquals(branch.Id, updatedTimeSlot.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals('Test - branchTimeSlot', updatedTimeSlot.Name, 'TimeSlot name should be "Test - branchTimeSlot"');
        System.assertEquals(Time.newInstance(7, 15, 0, 0), updatedTimeSlot.dmpl__StartTime__c, 'Start Time should match');
        System.assertEquals(Time.newInstance(10, 15, 0, 0), updatedTimeSlot.dmpl__EndTime__c, 'End Time should match');
        System.assertEquals(12, updatedTimeSlot.dmpl__MaximumCapacity__c, 'Maximum Capacity should be 12');
        System.assertEquals(false, updatedTimeSlot.dmpl__IsActive__c, 'Time Slot should be active');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithNamePositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithCapacityPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void updateBranchTimeSlotBookingWithCapacityPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        fetchedBranchTimeSlotBooking.dmpl__Capacity__c = 120;
        Update fetchedBranchTimeSlotBooking;
        dmpl__BranchTimeSlotBooking__c updatedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(120, updatedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 120');
        System.assertEquals(branchTimeSlot.Id, updatedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithBranchTimeSlotPositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        dmpl__BranchTimeSlotBooking__c fetchedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, fetchedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, fetchedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutCapacityNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
            dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.id, 'T3', null);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when capacity is missing');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutNamePositive() {
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, '', 12);
        dmpl__BranchTimeSlotBooking__c updatedBranchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedBranchTimeSlotBooking, 'Booking record should not be null');
        System.assertEquals(12, updatedBranchTimeSlotBooking.dmpl__Capacity__c, 'Capacity should be 12');
        System.assertEquals(branchTimeSlot.Id, updatedBranchTimeSlotBooking.dmpl__BranchTimeSlotId__c, 'Branch Time Slot ID should match');
    }
    
    @isTest
    static void createBranchTimeSlotBookingWithoutbranchTimeSlotNegative() {
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(null, 'T3', 12);
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when Branch Time Slot is missing');
    }
    
    @isTest
    static void createBranchDateSlotResultWithNamePositive() {
        Test.startTest();
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.createBranchDateSlotResult('T4');
        dmpl__BranchDateSlotResult__c fetchedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedbranchDateSlotResult, 'Fetched BranchDateSlotResult should not be null');
        System.assertEquals('T4', fetchedbranchDateSlotResult.Name, 'Name should be "T4"');
        System.assertEquals(branchDateSlotResult.Id, fetchedbranchDateSlotResult.Id, 'Fetched record Id should match original');
    }
    
    @isTest
    static void updateBranchDateSlotResultWithNamePositive() {
        Test.startTest();
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.createBranchDateSlotResult('T4');
        dmpl__BranchDateSlotResult__c fetchedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        fetchedbranchDateSlotResult.Name = 'T5';
        update fetchedbranchDateSlotResult;
        dmpl__BranchDateSlotResult__c updatedbranchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult(fetchedbranchDateSlotResult.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedbranchDateSlotResult, 'Fetched BranchDateSlotResult should not be null');
        System.assertEquals('T5', updatedbranchDateSlotResult.Name, 'Name should be "T4"');
        System.assertEquals(branchDateSlotResult.Id, updatedbranchDateSlotResult.Id, 'Fetched record Id should match original');
    }

    @isTest
    static void queryBranchDateAndBranchTimeSlots(){
        Test.startTest();
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.getbranchTimeSlot();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        branchTimeSlot.dmpl__ApplicableToItem__c = item.Id;
        branchTimeSlot.dmpl__ServiceJobType__c = 'None';
        branchTimeSlot.dmpl__ServiceType__c = 'Paid Repairs';
        update branchTimeSlot;
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot.Id, 'T3', 12);
        List<BranchDateSlotResult> result = BranchHelper.getBranchDateSlots(
            'Delivery',
            branch.Id,
            item.Id,
            'Paid Repairs',
            'None',
            3
        );
        List<dmpl__BranchTimeSlot__c> result1 = BranchHelper.getBranchTimeSlots(
            'Delivery',
            branch.Id,
            item.Id,
            'Paid Repairs',
            'None',
            Date.today()
        );
        List<dmpl__Branch__c> branchList = BranchHelper.getNearbyBranches('', '', 2);
        Test.stopTest();
    }
}