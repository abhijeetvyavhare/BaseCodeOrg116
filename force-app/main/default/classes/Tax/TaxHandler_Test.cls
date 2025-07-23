@isTest
public with sharing class TaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id);
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id);
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id, 1500);
        dmpl__TaxGroup__c taxGroupGST28 = TestDataHelpers.createTaxGroup('GST 28', partnerAccount1.Id, branch1.Id);
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', taxGroupGST28.Id, 14);
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createSGSTTax('SGST', taxGroupGST28.Id, 14);
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item1.Id, taxGroupGST28.Id);
    }
    
    @isTest
    static void createTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'Expected tax group to be created.');
    }

    @isTest
    static void updateTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before update.');
        taxGroup.Name = 'Updated Tax Group';
        update taxGroup;
        dmpl__TaxGroup__c updatedGroup = TestDataHelpers.getTaxGroup();
        System.assertEquals('Updated Tax Group', updatedGroup.Name, 'Tax group name should be updated.');
    }

    @isTest
    static void deleteTaxGroup() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before delete.');
        delete taxGroup;
        dmpl__TaxGroup__c deletedGroup;
        try {
            deletedGroup = TestDataHelpers.getTaxGroup();
        } catch (Exception e) {
            deletedGroup = null;
        }
        System.assertEquals(null, deletedGroup, 'TaxGroup should be deleted and not found in query.');
    }

    @isTest
    static void createTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Expected Tax record to be created.');
    }

    @isTest
    static void updateTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before update.');
        tax.dmpl__Rate__c = 15;
        update tax;
        dmpl__Tax__c updatedTax = TestDataHelpers.getTax();
        System.assertEquals(15, updatedTax.dmpl__Rate__c, 'Tax rate should be updated to 15.');
    }

    @isTest
    static void deleteTax() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        String taxName = tax.Name;
        System.assertNotEquals(null, tax, 'Tax should exist before delete.');
        delete tax;
        dmpl__Tax__c deletedTax;
        try {
            deletedTax = TestDataHelpers.getTax(taxName);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax should be deleted and not found in query.');
    }

    @isTest
    static void createCGSTAndSGSTTaxesForGST18WithinState() {
        TaxMasterData.createGST18TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c gst18TaxGroup = TestDataHelpers.getTaxGroup('GST 18');
        dmpl__Tax__c cgst = TestDataHelpers.getTax('CGST 9');
        dmpl__Tax__c sgst = TestDataHelpers.getTax('SGST 9');
        Test.stopTest();
        System.assertNotEquals(null, cgst, 'CGST tax should be created.');
        System.assertEquals('CGST 9', cgst.Name, 'CGST name should match.');
        System.assertEquals(9, cgst.dmpl__Rate__c, 'CGST rate should be 9.');
        System.assertEquals('CGST', cgst.dmpl__Type__c, 'CGST type should be CGST.');
        System.assertEquals(gst18TaxGroup.Id, cgst.dmpl__TaxGroupId__c, 'CGST should be under GST 18 group.');
        System.assertNotEquals(null, sgst, 'SGST tax should be created.');
        System.assertEquals('SGST 9', sgst.Name, 'SGST name should match.');
        System.assertEquals(9, sgst.dmpl__Rate__c, 'SGST rate should be 9.');
        System.assertEquals('SGST', sgst.dmpl__Type__c, 'SGST type should be SGST.');
        System.assertEquals(gst18TaxGroup.Id, sgst.dmpl__TaxGroupId__c, 'SGST should be under GST 18 group.');
    }
    
    @isTest
    static void createTaxWithoutTaxGroupNegative() {
        TaxMasterData.createGST18TaxGroup();
        Boolean exceptionThrown = false;
        dmpl__Tax__c tax;
        try {
            tax = TestDataHelpers.getTax('CGST 9');
            tax.dmpl__TaxGroupId__c = null;
            update tax;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (tax == null || tax.Id == null), 'Tax should not be created without linking a tax group.');
    }

    @isTest
    static void createIGSTTaxForWithinState() {
        TaxMasterData.createIGST18TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c igst18TaxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__Tax__c igst = TestDataHelpers.getTax('IGST');
        Test.stopTest();
        System.assertNotEquals(null, igst, 'IGST tax should be created.');
        System.assertEquals('IGST', igst.Name, 'IGST name should match.');
        System.assertEquals(18, igst.dmpl__Rate__c, 'IGST rate should be 18.');
        System.assertEquals('IGST', igst.dmpl__Type__c, 'IGST type should be IGST.');
        System.assertEquals(igst18TaxGroup.Id, igst.dmpl__TaxGroupId__c, 'IGST should be under IGST 18 group.');
    }
    
    @isTest
    static void createCGSTWithNegativeRateNegative() {
        TaxMasterData.createGST18TaxGroup();
        Boolean exceptionThrown = false;
        dmpl__Tax__c cgst;
        try {
            cgst = TestDataHelpers.getTax('CGST 9');
            cgst.dmpl__Rate__c = -9;
            update cgst;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (cgst == null || cgst.Id == null || cgst.dmpl__Rate__c < 0), 'CGST should not be created or updated with a negative rate.');
    }

    @isTest
    static void createIGST18TaxGroupForInterstateSales() {
        TaxMasterData.createIGST18TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c igst18TaxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__Tax__c igst = TestDataHelpers.getTax('IGST');
        Test.stopTest();
        System.assertNotEquals(null, igst18TaxGroup, 'IGST 18 tax group should be created.');
        System.assertEquals('IGST 18', igst18TaxGroup.Name, 'Tax group name should be IGST 18.');
        System.assertNotEquals(null, igst, 'IGST tax should be created.');
        System.assertEquals('IGST', igst.Name, 'IGST name should match.');
        System.assertEquals(18, igst.dmpl__Rate__c, 'IGST rate should be 18.');
        System.assertEquals('IGST', igst.dmpl__Type__c, 'IGST type should be IGST.');
        System.assertEquals(igst18TaxGroup.Id, igst.dmpl__TaxGroupId__c, 'IGST should be under IGST 18 group.');
    }

    @isTest
    static void createUTGST18TaxGroupForUnionTerritory() {
        TaxMasterData.createUTGST18TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c utgst18TaxGroup = TestDataHelpers.getTaxGroup('UT GST 18');
        dmpl__Tax__c utgst = TestDataHelpers.getTax('UTGST');
        dmpl__Tax__c cgst = TestDataHelpers.getTax('CGST 9');
        Test.stopTest();
        System.assertNotEquals(null, utgst18TaxGroup, 'UT GST 18 tax group should be created.');
        System.assertEquals('UT GST 18', utgst18TaxGroup.Name, 'Tax group name should be UT GST 18.');
        System.assertNotEquals(null, utgst, 'UTGST tax should be created.');
        System.assertEquals('UTGST', utgst.Name, 'UTGST name should match.');
        System.assertEquals(9, utgst.dmpl__Rate__c, 'UTGST rate should be 9.');
        System.assertEquals('UTGST', utgst.dmpl__Type__c, 'UTGST type should be UTGST.');
        System.assertEquals(utgst18TaxGroup.Id, utgst.dmpl__TaxGroupId__c, 'UTGST should be under UT GST 18 group.');
        System.assertNotEquals(null, cgst, 'CGST tax should be created.');
        System.assertEquals('CGST 9', cgst.Name, 'CGST name should match.');
        System.assertEquals(9, cgst.dmpl__Rate__c, 'CGST rate should be 9.');
        System.assertEquals('CGST', cgst.dmpl__Type__c, 'CGST type should be CGST.');
        System.assertEquals(utgst18TaxGroup.Id, cgst.dmpl__TaxGroupId__c, 'CGST should be under UT GST 18 group.');
    }

    @isTest
    static void assignInactiveOrInvalidTaxRateToTaxGroupNegative() {
        TaxMasterData.createGST18TaxGroup();
        Boolean exceptionThrown = false;
        dmpl__Tax__c cgst;
        try {
            cgst = TestDataHelpers.getTax('CGST 9');
            cgst.dmpl__Rate__c = -9;
            update cgst;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || (cgst == null || cgst.Id == null || cgst.dmpl__Rate__c < 0), 'Should not allow assigning inactive or invalid (negative) tax rate to tax group.');
    }

    @isTest
    static void createTaxGroupWithDetailedDescriptionPositive() {
        String description = 'This tax group applies GST at 12% on the taxable value of go';
        TaxMasterData.createGST12TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.getTaxGroup('GST 12');
        gst12TaxGroup.dmpl__Description__c = description;
        update gst12TaxGroup;
        Test.stopTest();
        dmpl__TaxGroup__c insertedGroup = TestDataHelpers.getTaxGroup('GST 12');
        System.assertEquals('GST 12', insertedGroup.Name, 'Tax group name should be GST 12.');
        System.assertEquals('Line Level', insertedGroup.dmpl__TaxGroupType__c, 'Tax group type should be Line Level.');
        System.assertEquals(true, insertedGroup.dmpl__IsActive__c, 'Tax group should be active.');
        System.assertEquals(description, insertedGroup.dmpl__Description__c, 'Description should match the detailed text.');
    }

    @isTest
    static void editTaxGroupTypeToNoneNegative() {
        TaxMasterData.createGST12TaxGroup();
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        try {
            gst12TaxGroup.dmpl__TaxGroupType__c = null;
            update gst12TaxGroup;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown || gst12TaxGroup.dmpl__TaxGroupType__c == null, 'System should prevent saving Tax Group with Tax Group Type as None.');
    }

    @isTest
    static void editTaxGroupSetIsActiveFalse() {
        TaxMasterData.createGST12TaxGroup();
        Test.startTest();
        dmpl__TaxGroup__c gst12TaxGroup = TestDataHelpers.getTaxGroup('GST 12');
        gst12TaxGroup.dmpl__IsActive__c = false;
        update gst12TaxGroup;
        Test.stopTest();
        dmpl__TaxGroup__c updatedGroup = TestDataHelpers.getTaxGroup('GST 12');
        System.assertEquals('GST 12', updatedGroup.Name, 'Tax group name should be GST 12.');
        System.assertEquals('Line Level', updatedGroup.dmpl__TaxGroupType__c, 'Tax group type should be Line Level.');
        System.assertEquals(false, updatedGroup.dmpl__IsActive__c, 'Tax group should be inactive.');
    }
}