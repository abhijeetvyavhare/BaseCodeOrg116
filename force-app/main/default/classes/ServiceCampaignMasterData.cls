public with sharing class ServiceCampaignMasterData {
    public static void updateServiceCampaignItemWithDiscontinuedItemPositiveData() {
        dmpl__Item__c discontinuedItem = TestDataHelpers.createItem('Item 4', 'Product'); 
        discontinuedItem.dmpl__IsDiscontinued__c = true;
        update discontinuedItem;
    }

    public static void updateServiceCampaignItemWithInactiveItemPositiveData() {
        dmpl__Item__c inactiveItem = TestDataHelpers.createItem('Item 2','Product');
        inactiveItem.dmpl__IsActive__c = false;
        update inactiveItem;
    }

    public static void updateServiceCampaignMemberWithActiveItemPositiveData() {
        dmpl__Item__c activeItem3 = TestDataHelpers.createItem('Item 3', 'Charge Item');
        activeItem3.dmpl__IsDiscontinued__c = false;
        update activeItem3;
    }
}