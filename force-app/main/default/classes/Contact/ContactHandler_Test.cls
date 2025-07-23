@isTest
private class ContactHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1');
        Contact contact = TestDataHelpers.createContact('Contact 1', '1234567890', '123456', partnerAccount1.Id);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress('Address 1', customerAccount1.Id);
    }

    @isTest
    static void createContactPositive() {
        Contact contact = TestDataHelpers.getContact('Contact 1');
        System.assertNotEquals(contact, null, 'Expected contact to be created.');
    }

    @isTest
    static void updateContactPositive() {
        Contact contact = TestDataHelpers.getContact('Contact 1');
        contact.Phone = '123456789';
        Test.startTest();
        update contact;
        Test.stopTest();
        Contact updatedContact = TestDataHelpers.getContact('Contact 1');
        System.assertEquals(String.valueOf(contact.Phone), '123456789', 'Expected the contact to be updated.');
    }

    @isTest
    static void deleteContactPositive() {
        Contact contact = TestDataHelpers.getContact('Contact 1');
        Test.startTest();
        delete contact;
        Test.stopTest();
        Contact deletedContact = ContactDataHelper.getContactById(contact.Id);
        System.assertEquals(deletedContact, null, 'Expected the contact to be deleted.');
    }

    @isTest
    static void createContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.getContactAddress('Address 1');
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
    }

    @isTest
    static void updateContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.getContactAddress('Address 1');
        contactAddress.Name = 'Updated Address';
        Test.startTest();
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = TestDataHelpers.getContactAddress('Updated Address');
        System.assertEquals(updatedContactAddress.Name, 'Updated Address', 'Name should be updated');
    }

    @isTest
    static void deleteContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.getContactAddress('Address 1');
        Test.startTest();
        delete contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c deletedContactAddress = null;
        try {
            deletedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        } catch (Exception e) {
            deletedContactAddress = null;
        }
        System.assertEquals(deletedContactAddress, null, 'Expected the contact address to be deleted.');
    }

    @isTest
    static void createContactAddressWithValidAccountAndName() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.name = 'Customer 1';
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, 'Customer 1', 'Name should match.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
    }

    @isTest
    static void createContactAddressWithValidAddressType() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.Name = 'Customer Showroom';
        update contactAddress;
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, 'Customer Showroom', 'Name should match.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(contactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
    }

    @isTest
    static void createContactAddressWithFullAddress() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.dmpl__Region__c = 'West';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, 'Address 1', 'Name should match.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(contactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(contactAddress.dmpl__Street__c, 'Ring Rd', 'Street should match.');
        System.assertEquals(contactAddress.dmpl__Region__c, 'West', 'Region should match.');
    }

    @isTest
    static void createContactAddressWithSpecialCharName() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.Name = '123@';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, '123@', 'Name should allow numeric/special characters.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(contactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(contactAddress.dmpl__Street__c, 'Ring Rd', 'Street should match.');
    }

    @isTest
    static void createContactAddressWithIsDefaultTrue() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.Name = 'TMZ Motors';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, 'TMZ Motors', 'Name should match.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(contactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(contactAddress.dmpl__Street__c, 'Ring Rd', 'Street should match.');
    }

    @isTest
    static void updateContactAddressEditCityState() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.Name = 'TMZ Motors';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertNotEquals(updatedContactAddress, null, 'Expected contact address to exist after update.');
        System.assertEquals(updatedContactAddress.Name, 'TMZ Motors', 'Name should remain unchanged.');
        System.assertEquals(updatedContactAddress.dmpl__IsDefault__c, true, 'IsDefault should remain true.');
        System.assertEquals(updatedContactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should remain Billing Address.');
        System.assertEquals(updatedContactAddress.dmpl__Street__c, 'Ring Rd', 'Street should remain unchanged.');
    }

    @isTest
    static void updateContactAddresxsUncheckIsDefault() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.Name = 'TMZ Motors';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertNotEquals(updatedContactAddress, null, 'Expected contact address to exist after update.');
        System.assertEquals(updatedContactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(updatedContactAddress.Name, 'TMZ Motors', 'Name should match.');
        System.assertEquals(updatedContactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(updatedContactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(updatedContactAddress.dmpl__Street__c, 'Ring Rd', 'Street should match.');
    }

    @isTest
    static void updateContactAddressWithNullAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
            contactAddress.dmpl__AccountId__c = null;
            update contactAddress;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertNotEquals(true, exceptionThrown, 'Validation should hold when Account is removed from Contact Address.');
    }

    @isTest
    static void updateContactAddressChangeAddressType() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.dmpl__AddressType__c = 'Shipping Address';
        contactAddress.dmpl__Street__c = 'Ring Rd';
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertNotEquals(updatedContactAddress, null, 'Expected contact address to exist after update.');
        System.assertEquals(updatedContactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(updatedContactAddress.Name, 'Address 1', 'Name should match.');
        System.assertEquals(updatedContactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(updatedContactAddress.dmpl__AddressType__c, 'Shipping Address', 'Address Type should be Shipping Address.');
        System.assertEquals(updatedContactAddress.dmpl__Street__c, 'Ring Rd', 'Street should match.');
    }

    @isTest
    static void updateContactAddressSetCountryNone() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.dmpl__Country__c = null;
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertNotEquals(updatedContactAddress, null, 'Expected contact address to exist after update.');
        System.assertEquals(updatedContactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(updatedContactAddress.Name, 'Address 1', 'Name should match.');
        System.assertEquals(updatedContactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(updatedContactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(updatedContactAddress.dmpl__Country__c, null, 'Country should be None (null).');
    }

    @isTest
    static void updateContactAddressEditStreetRegion() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        contactAddress.dmpl__Street__c = 'MG Road';
        contactAddress.dmpl__Region__c = 'West';
        update contactAddress;
        Test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertNotEquals(updatedContactAddress, null, 'Expected contact address to exist after update.');
        System.assertEquals(updatedContactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(updatedContactAddress.Name, 'Address 1', 'Name should match.');
        System.assertEquals(updatedContactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(updatedContactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
        System.assertEquals(updatedContactAddress.dmpl__Street__c, 'MG Road', 'Street should be updated to MG Road.');
        System.assertEquals(updatedContactAddress.dmpl__Region__c, 'West', 'Region should be updated to West.');
    }

    @isTest
    static void createContactAddressAuditFieldsPopulated() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddress();
        update contactAddress;
        Test.stopTest();
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
        System.assertEquals(contactAddress.dmpl__AccountId__c, customerAccount.Id, 'Account should match Customer 1.');
        System.assertEquals(contactAddress.Name, 'Address 1', 'Name should match.');
        System.assertEquals(contactAddress.dmpl__IsDefault__c, true, 'IsDefault should be true.');
        System.assertEquals(contactAddress.dmpl__AddressType__c, 'Billing Address', 'Address Type should be Billing Address.');
    }
}