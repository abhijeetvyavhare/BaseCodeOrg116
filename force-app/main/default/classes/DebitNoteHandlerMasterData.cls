public with sharing class DebitNoteHandlerMasterData {
    public static void createGLAccount(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.createGLAccount('HDFC Bank', 'Bank', true, partnerAccount1.Id, branch1.Id);
    }
}