@isTest
public with sharing class ContactDataHelper {
    public static Contact createContact(
        String phone,
        String homePhone,
        String lastName
    ){
        return (contact)TestFactory.createSObject(
            new Contact(
                Phone = phone,
                HomePhone = homePhone,
                LastName = lastName
            ),
            'ContactDefaults',
            true
        );
    }

    public static Contact createContactWithDefaults(){
        return createContact('9876543210', '9876556789', 'DefaultContactLastName');
    }

    public static List<Contact> getContacts(){
        List<Contact> results = [
            SELECT 
                Id,
                FirstName,
                LastName,
                Email
            FROM Contact
        ];
        return results.isEmpty() ? null : results;
    }

    public static Contact getContactByPhone(
        String phone
    ){
        List<Contact> results = [
            SELECT
                Id,
                FirstName,
                LastName,
                Email
            FROM Contact
            WHERE Phone = :phone
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static Contact getContactById(
        Id contactId
    ){
        List<Contact> results = [
            SELECT 
                Id,
                FirstName,
                LastName,
                Email
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ContactAddress__c createContactAddress(
        String contactAddressName
    ) {
        return (dmpl__ContactAddress__c)TestFactory.createSObject(
            new dmpl__ContactAddress__c(
                Name = contactAddressName
            ),
            'ContactAddressDefaults',
            true
        );
    }

    public static dmpl__ContactAddress__c getContactAddress() {
        List<dmpl__ContactAddress__c> results = [
            SELECT 
                Id,
                Name, 
                dmpl__City__c, 
                dmpl__Country__c,
                dmpl__AddressType__c,
                dmpl__Street__c,
                dmpl__IsDefault__c,
                dmpl__Region__c,
                dmpl__State__c,
                dmpl__AccountId__c
            FROM dmpl__ContactAddress__c
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ContactAddress__c getContactAddressById(
        Id id
    ) {
        return [
            SELECT 
                Id,
                Name, 
                dmpl__City__c, 
                dmpl__Country__c,
                dmpl__AddressType__c,
                dmpl__Street__c,
                dmpl__IsDefault__c,
                dmpl__Region__c,
                dmpl__State__c,
                dmpl__AccountId__c
            FROM dmpl__ContactAddress__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
}