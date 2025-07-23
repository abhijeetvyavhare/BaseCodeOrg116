@isTest
public with sharing class BranchPostalCodeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Place__c parentPlace = BranchTestDataHelper.createParentPlace();
        dmpl__Place__c place = BranchTestDataHelper.createPlace(parentPlace);
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode(place);
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount,branch,postalCode);
    }
    
    @isTest
    static void createBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        if(branchPostalCode != null){
            System.assertNotEquals(branchPostalCode, null, 'Expected branchPostalCode to be created.');
        }
        System.assertNotEquals(branchPostalCode.dmpl__PostalCodeId__c, null, 'Expected dmpl__PostalCodeId__c to be set');
        System.assertNotEquals(branchPostalCode.dmpl__PartnerAccountId__c, null, 'Expected dmpl__AccountId__c to be set');
        System.assertNotEquals(branchPostalCode.dmpl__BranchId__c, null, 'Expected dmpl__BranchId__c to be set');
        System.assertEquals('Sale', branchPostalCode.dmpl__CoverageType__c, 'Coverage type must be sale');
        System.assertNotEquals(branchPostalCode.Name, null, 'Name cant be null');
        
    }
    
    @isTest
    static void updateBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        System.assertNotEquals(branchPostalCode, null, 'BranchPostalCode should exist before update.');
        branchPostalCode.dmpl__CoverageType__c = 'Service';
        update branchPostalCode;
        dmpl__BranchPostalCode__c updatedPostalCode = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        System.assertEquals('Service', updatedPostalCode.dmpl__CoverageType__c, 'Expected CoverageType to be updated to Service');
    }
    
    @isTest
    static void deleteBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        System.assertNotEquals(branchPostalCode, null, 'BranchPostalCode should exist before delete.');
        delete branchPostalCode;
        dmpl__BranchPostalCode__c deletedPostalCode = null;
        try {
            deletedPostalCode = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        } catch (Exception e) {
            deletedPostalCode = null;
        }
        
        System.assertEquals(null, deletedPostalCode, 'BranchPostalCode should be deleted and not found in query.');
    }
    
    
    @isTest
    static void createPostalCodeWithPostalCodeNamePositive(){
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('Pune');
        dmpl__PostalCode__c fetchedPostalCode = BranchTestDataHelper.getPostalCode(postalCode.Id);
        System.assertEquals('Pune', fetchedPostalCode.Name, 'Postal code Name should be Pune');
    }
    
    
    @isTest
    static void updatePostalCodeWithPostalCodeNamePositive(){
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('Pune');
        dmpl__PostalCode__c fetchedPostalCode = BranchTestDataHelper.getPostalCode(postalCode.Id);
        
        fetchedPostalCode.Name = 'T1';
        Update fetchedPostalCode;
        
        dmpl__PostalCode__c updatedPostalCode = BranchTestDataHelper.getPostalCode(fetchedPostalCode.Id);
        
        System.assertEquals('T1', updatedPostalCode.Name, 'Postal code Name should be Pune');
    }

    
    @isTest
    static void createPostalCodeWithPostalCodeNameNegative(){
        Boolean exceptionThrown = false;
        
        try {
            dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode(''); 
            postalCode.Name = '';
            insert postalCode; 
        }
        catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using empty postal code name');
        
    }

      
    
     @isTest
    Static void CreateBranchPostalCodeWithallRequiredFieldsBranchAndPartnerAccountPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode1 = BranchTestDataHelper.getPostalCode();
        
       dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode1,null);
    
       dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id,  fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode1.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
       
    } 
    
    
    @isTest
    static void updateBranchPostalCodeChangePartnerAccountPositive() {
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();

        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
            partnerAccount, branch, postalCode, null
        );

        branchPostalCode.dmpl__PartnerAccountId__c=partnerAccount2.Id;
        update branchPostalCode;

        dmpl__BranchPostalCode__c updatedbranchPostalCode = BranchTestDataHelper.getBranchPostalcode(branchPostalCode.Id);
       
    }
   
    
    @isTest
    Static void createPostalCodeWithOneSelectedCoverageTypePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode,'Sale');
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
        System.assertEquals('Sale',fetchedBranchPostalCode.dmpl__CoverageType__c,'Coverage type Shpuld be Sale');
    } 
    
   
    @isTest
    Static void createRecordWithoutSelectingPartnerAccountIfOptionalPositive(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(null,branch1,null,null);
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(null, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should be null');
        System.assertEquals(branch1.Id,  fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match'); 
        System.assertEquals(null, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should be null');
       
    } 
     
    
    @isTest
    static void createBranchPostalCodeWithPostalCodeDetailsPositive() {
   
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode(); 

        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
            partnerAccount  ,
            branch,
            postalCode,
            'Sale'
        );

        dmpl__BranchPostalCode__c fetchedBPC = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        System.assertEquals(branch.Id, fetchedBPC.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(partnerAccount.Id, fetchedBPC.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(postalCode.Id, fetchedBPC.dmpl__PostalCodeId__c, 'Postal Code ID should match');
        System.assertEquals('Sale', fetchedBPC.dmpl__CoverageType__c, 'Coverage Type should be set to sales');
   }
   
   
   @isTest
   static void createBranchPostalCodeWithNoCoverageTypePositive() {
    Account partnerAccount = TestDataHelpers.getPartnerAccount();
    dmpl__Branch__c branch = TestDataHelpers.getBranch();
    dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
    dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
        partnerAccount,
        branch,
        postalCode,
        null
    );

    dmpl__BranchPostalCode__c fetchedBPC = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
    System.assertNotEquals(null, fetchedBPC, 'BranchPostalCode record should be created');
    System.assertEquals(partnerAccount.Id, fetchedBPC.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch.Id, fetchedBPC.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(postalCode.Id, fetchedBPC.dmpl__PostalCodeId__c, 'Postal Code should match');
    System.assertEquals(null, fetchedBPC.dmpl__CoverageType__c, 'Coverage Type should be null');
   }

    
    @isTest
    static void createBranchPostalCodeWithoutBranchNameNegative() {
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        try {
            dmpl__BranchPostalCode__c invalidBPC = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount,
                null, 
                postalCode,
                null
            );
            
        } catch (Exception e) {
        exceptionThrown= true;
        System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null branch name');
    }

    
    @isTest
    static void createBranchPostalCodeWithAllCoverageTypesPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode,'All');
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
        System.assertEquals('All',fetchedBranchPostalCode.dmpl__CoverageType__c,'Coverage type Shpuld be All');
    }




  
    
    @isTest
    static void createPartnerAccountDoesNotMatchSelectedBranchNegative() {
        
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        try {
             dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount1,
                branch,
                postalCode,  
                null
            );
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
       }
       
    }
     
    
    @isTest 
    static void createBranchPostalCodeWithInvalidPostalCodeFormatNegative() {
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        try {
             dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount1,
                branch,
                postalCode,    
                null
            );
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
       }
       
    
    }
}