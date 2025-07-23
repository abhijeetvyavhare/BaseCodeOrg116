@isTest
public with sharing class PerformanceKPIHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 1', partnerAccount.Id);
        dmpl__Item__c item = TestDataHelpers.createItem('Item 1', 'Product');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch, item);
    }

    @isTest
    static void createPerformanceKPIPositive() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        System.assertNotEquals(null, kpi, 'Performance KPI should be created.');
        System.assertEquals(5, kpi.dmpl__NumberOfBills__c, 'NumberOfBills should be 5');
        System.assertEquals(1000, kpi.dmpl__TotalAmount__c, 'TotalAmount should be 1000');
    }

    @isTest
    static void updatePerformanceKPIPositive() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        dmpl__PerformanceKPI__c updated = PerformanceKPIDataHelper.updatePerformanceKPI(kpi, 99);
        System.assertEquals(99, updated.dmpl__NumberOfBills__c, 'NumberOfBills should be updated.');
    }

    @isTest
    static void deletePerformanceKPI() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        Integer count = PerformanceKPIDataHelper.deletePerformanceKPI(kpi);
        System.assertEquals(0, count, 'Performance KPI should be deleted.');
    }

    @isTest
    static void createKPIWithRequiredFieldsPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
    }

    @isTest
    static void createKPIWithValidPartnerAccountAndBranchPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(100, fetchedKpi.dmpl__NumberOfServiceRequests__c, 'Target Value should match');
    }
    
    @isTest
    static void createKPIWithOnlyRequiredFieldsPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(100, fetchedKpi.dmpl__NumberOfServiceRequests__c, 'Target Value should match');
    }
   
    @isTest
    static void createKPIWithMinimumAllowedNumericValuesPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1, fetchedKpi.dmpl__NumberOfServiceRequests__c, 'Target Value should match');
    }
    
    @isTest
    static void createKPIWithoutPartnerAccountNegative(){
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(null, branch ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null as Partner Account');
    }
    
    @isTest
    static void createKPIWithoutBranchNegative(){
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, null ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    @isTest
    static void createKPIWithInactivePartnerAccountNegative(){
        Boolean exceptionThrown=false;
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
        }
    }

    @isTest
    static void createKPIWithInactiveBranchNegative(){
        Boolean exceptionThrown=false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id);
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        } catch (Exception e) {
            exceptionThrown= true;
        }
    }
    
    @isTest
    static void updateKPIWithBranchRemovedNegative(){
        Boolean exceptionThrown=false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        try {
            PerformanceKpi.dmpl__BranchId__c= null;
            update PerformanceKpi;
        } catch (Exception e) {
            exceptionThrown= true;
        }
    }

    @isTest
    static void updateKPIWithPartnerAccountRemovedNegative(){
        Boolean exceptionThrown=false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        try {
            PerformanceKpi.dmpl__AccountId__c= null;
            update PerformanceKpi;
        } catch (Exception e) {
            exceptionThrown= true;
        }
    }

    @isTest
    static void updateKPIAddTotalAmountPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 1);
        PerformanceKpi.dmpl__TotalAmount__c= 100;
        update PerformanceKpi;
        dmpl__PerformanceKPI__c fetchedPerformanceKpi= PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.Assert.areEqual(100, fetchedPerformanceKpi.dmpl__TotalAmount__c, 'Total Amount did not match');
    }
   
    @isTest
    static void createKPIWithoutEnteringTotalAmountPositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(20, fetchedKpi.dmpl__TotalQuantity__c, 'Target Value should match');
    }

    @isTest
    static void createKPIWithoutTotalQuantity(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi = PerformanceKPIDataHelper.createPerformanceKPI(partnerAccount, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(partnerAccount.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(20, fetchedKpi.dmpl__TotalQuantity__c, 'Target Value should match');
    }
}