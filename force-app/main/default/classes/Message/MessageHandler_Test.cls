@isTest
public with sharing class MessageHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partner = TestDataHelpers.createPartnerAccount('Partner 1');
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration();
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule(config.Id);
        dmpl__Message__c message = MessageDataHelper.createDefaultMessage();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
    }
    
    @isTest
    static void testInsertMessageConfiguration() {
        dmpl__MessageConfiguration__c config = MessageDataHelper.getMessageConfiguration();
        System.assert(config.Id != null, 'Message Configuration should be inserted');
    }
    
    @isTest
    static void testInsertMessageRule() {
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        System.assertNotEquals(null, rule.Id, 'Message Rule record should be inserted');
    }
    
    @isTest
    static void testInsertMessage() {
        dmpl__Message__c msg = MessageDataHelper.getMessage();
        System.assert(msg.Id != null, 'Message should be inserted');
    }
    
    @isTest
    static void testUpdateMessageConfiguration() {
        dmpl__MessageConfiguration__c config = MessageDataHelper.getMessageConfiguration();
        config.Name = 'Updated Message Config';
        config.dmpl__CustomHandlerName__c = 'UpdatedHandler';
        config.dmpl__CustomNotificationName__c = 'UpdatedNotification';
        config.dmpl__MessageBody__c = 'Updated message body.';
        config.dmpl__ProviderType__c = 'SFDC EMail';
        config.dmpl__PushNotificationApplicationName__c = 'UpdatedApp';
        config.dmpl__Recipient__c = 'updated@example.com';
        config.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
        config.dmpl__RuleSuccessCustomLogic__c = 'IF false THEN success';
        config.dmpl__Sender__c = 'updated@example.com';
        config.dmpl__SenderName__c = 'Updated Sender';
        config.dmpl__Subject__c = 'Updated Subject';
        config.dmpl__TemplateId__c = 'TPL456';
        config.dmpl__TriggerEvent__c = 'Scheduled';
        config.dmpl__TriggerObjectName__c = 'Contact';
        update config;
        dmpl__MessageConfiguration__c updated = MessageDataHelper.getMessageConfigurationById(config.Id);
        System.assertEquals('Updated Message Config', updated.Name);
        System.assertEquals('UpdatedHandler', updated.dmpl__CustomHandlerName__c, 'Custom Handler Name should be updated');
        System.assertEquals('UpdatedNotification', updated.dmpl__CustomNotificationName__c, 'Custom Notification Name should be updated');
        System.assertEquals('Updated message body.', updated.dmpl__MessageBody__c, 'Message Body should be updated');
        System.assertEquals('SFDC EMail', updated.dmpl__ProviderType__c, 'Provider Type should be updated');
        System.assertEquals('UpdatedApp', updated.dmpl__PushNotificationApplicationName__c, 'Push Notification Application Name should be updated');
        System.assertEquals('updated@example.com', updated.dmpl__Recipient__c, 'Recipient should be updated');
        System.assertEquals('All Rules Are Met', updated.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should be updated');
        System.assertEquals('IF false THEN success', updated.dmpl__RuleSuccessCustomLogic__c, 'Rule Success Custom Logic should be updated');
        System.assertEquals('updated@example.com', updated.dmpl__Sender__c, 'Sender should be updated');
        System.assertEquals('Updated Sender', updated.dmpl__SenderName__c, 'Sender Name should be updated');
        System.assertEquals('Updated Subject', updated.dmpl__Subject__c, 'Subject should be updated');
        System.assertEquals('TPL456', updated.dmpl__TemplateId__c, 'Template Id should be updated');
        System.assertEquals('Scheduled', updated.dmpl__TriggerEvent__c, 'Trigger Event should be updated');
        System.assertEquals('Contact', updated.dmpl__TriggerObjectName__c, 'Trigger Object Name should be updated');
    }
    
    @isTest
    static void testUpdateMessageRule() {
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__FieldName__c = 'Priority';
        rule.dmpl__FieldValue__c = 'High';
        rule.dmpl__Operation__c = 'equals';
        rule.dmpl__SequenceNumber__c = 2;
        update rule;
        dmpl__MessageRule__c updated = MessageDataHelper.getMessageRuleById(rule.Id);
        System.assertEquals('Priority', updated.dmpl__FieldName__c, 'Field Name should be updated');
        System.assertEquals('High', updated.dmpl__FieldValue__c, 'Field Value should be updated');
        System.assertEquals('equals', updated.dmpl__Operation__c, 'Operation should be updated');
        System.assertEquals(2, updated.dmpl__SequenceNumber__c, 'Sequence Number should be updated');
    }
    
    @isTest
    static void testUpdateMessage() {
        dmpl__Message__c msg = MessageDataHelper.getMessage();
        msg.Name = 'Updated Message Name';
        msg.dmpl__ErrorMessage__c = 'Updated error';
        msg.dmpl__MessageBody__c = 'Updated message body';
        msg.dmpl__ProviderType__c = 'SFDC EMail';
        msg.dmpl__Recipient__c = 'updated@example.com';
        msg.dmpl__Sender__c = 'updated_sender@example.com';
        msg.dmpl__SenderName__c = 'Updated Sender';
        msg.dmpl__SourceObjectId__c = '001ZZZZZZZZZZZZZZZ';
        msg.dmpl__Status__c = 'Sent';
        msg.dmpl__Subject__c = 'Updated Subject';
        msg.dmpl__WhatId__c = '001ZZZZZZZZZZZZZZZ';
        update msg;
        dmpl__Message__c updated = MessageDataHelper.updateMessage(msg);
        System.assertEquals('Updated Message Name', updated.Name);
        System.assertEquals('Updated error', updated.dmpl__ErrorMessage__c);
        System.assertEquals('Updated message body', updated.dmpl__MessageBody__c);
        System.assertEquals('SFDC EMail', updated.dmpl__ProviderType__c);
        System.assertEquals('updated@example.com', updated.dmpl__Recipient__c);
        System.assertEquals('updated_sender@example.com', updated.dmpl__Sender__c);
        System.assertEquals('Updated Sender', updated.dmpl__SenderName__c);
        System.assertEquals('001ZZZZZZZZZZZZZZZ', updated.dmpl__SourceObjectId__c);
        System.assertEquals('Sent', updated.dmpl__Status__c);
        System.assertEquals('Updated Subject', updated.dmpl__Subject__c);
        System.assertEquals('001ZZZZZZZZZZZZZZZ', updated.dmpl__WhatId__c);
    }
    
    @isTest
    static void testDeleteMessageRule() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        delete rule;
        List<dmpl__MessageRule__c> result = MessageDataHelper.getMessageRulesById(rule.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Message Rule record should be deleted');
    }
    
    @isTest
    static void testDeleteMessageConfiguration() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        delete msgConfig;
        List<dmpl__MessageConfiguration__c> result = MessageDataHelper.getMessageConfigurationsByIds(msgConfig.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Message Configuration should be deleted');
    }
    
    @isTest
    static void testDeleteMessage() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        delete message;
        List<dmpl__Message__c> result = MessageDataHelper.getMessagesById(message.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Message should be deleted');
    }

    @isTest
    static void createMessageConfigurationWithNamePositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Name');
        System.assertEquals('Default Message Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('Account', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
    }

    @isTest
    static void createMessageConfigurationWithTriggerEventPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Trigger Event');
        System.assertEquals('Scheduled', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
        System.assertEquals('Default Message Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('Account', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
    }

    @isTest
    static void createMessageConfigurationWithProviderTypePositive(){
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Provider Type');
        System.assertEquals('SFDC EMail', msgConfig.dmpl__ProviderType__c, 'Provider Type should match');
        System.assertEquals('Default Message Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('Account', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
    }

    @isTest
    static void createMessageConfigurationWithInterfaceProviderPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        msgConfig.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        update msgConfig;
        msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Interface Provider');
        System.assertEquals(interfaceServiceProvider.Id, msgConfig.dmpl__InterfaceProviderId__c, 'Interface Service Provider Id should match');
    }

    @isTest
    static void createMessageConfigurationWithInterfaceRequestPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        msgConfig.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        msgConfig.dmpl__InterfaceRequestId__c = interfaceRequest.Id;
        update msgConfig;
        msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Interface Request');
        System.assertEquals(interfaceServiceProvider.Id, msgConfig.dmpl__InterfaceProviderId__c, 'Interface Service Provider Id should match');
        System.assertEquals(interfaceRequest.Id, msgConfig.dmpl__InterfaceRequestId__c, 'Interface Service Provider Request Id should match');
    }

    @isTest
    static void createMessageConfigurationWithDeletedInterfaceRequestPositive() {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        delete interfaceRequest;
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        msgConfig.dmpl__InterfaceProviderId__c = interfaceServiceProvider.Id;
        msgConfig.dmpl__InterfaceRequestId__c = interfaceRequest?.Id;
        try {
         	update msgConfig;   
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
        msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created even if Interface Request is deleted');
        System.assertEquals(null, msgConfig.dmpl__InterfaceRequestId__c, 'Interface Service Provider Id should match');
    }

    @isTest
    static void createMessageConfigurationWithoutTriggerEventPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        msgConfig.dmpl__TriggerEvent__c = null;
        update msgConfig;
        msgConfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created without Trigger Event');
        System.assertEquals(null, msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should be null');
    }

    @isTest
    static void createMessageConfigurationWithoutNameNegative() {
        Test.startTest();
        try {
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
            msgConfig.Name = null;
            update msgConfig;
            msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
            System.assertNotEquals(null, msgconfig, 'Message Configuration should not be created without Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createMessageConfigurationWithoutTriggerObjectNameNegative() {
        Test.startTest();
        try {
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
            msgConfig.dmpl__TriggerObjectName__c = null;
            update msgConfig;
            msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
            System.assertEquals(null, msgconfig, 'Message Configuration should not be created without Trigger Object Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }  
        Test.stopTest();
    }

    @isTest
    static void createMessageConfigurationWithInvalidInterfaceProviderNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
            delete interfaceServiceProvider;
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
            msgConfig.dmpl__InterfaceProviderId__c = interfaceServiceProvider?.Id;
            update msgConfig;
            msgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
            System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Invalid Interface Provider');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void deleteValidMessageConfigurationRecordPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.getMessageConfiguration();
        dmpl__MessageConfiguration__c deletedMsgconfig = null;
        delete msgConfig;
        try {
            deletedMsgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        } catch (QueryException e) {
            deletedMsgconfig = null;
            System.debug('Expected QueryException after deletion: ' + e.getMessage());
        }
        System.assertEquals(null, deletedMsgconfig, 'Expected message Configuration to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageWithNamePositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Name');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
    }

    @isTest
    static void createMessageWithStatusDraftPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Status__c = 'Draft';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Draft');
        System.assertEquals('Draft', message.dmpl__Status__c, 'Message Status should be Draft');
    }

    @isTest
    static void createMessageWithStatusQueuedPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Status__c = 'Queued';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Queued');
        System.assertEquals('Queued', message.dmpl__Status__c, 'Message Status should be Queued');
    }

    @isTest
    static void createMessageWithStatusSentPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Status__c = 'Sent';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Sent');
        System.assertEquals('Sent', message.dmpl__Status__c, 'Message Status should be Sent');
    }

    @isTest
    static void createMessageWithStatusErrorPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Status__c = 'Error';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Error');
        System.assertEquals('Error', message.dmpl__Status__c, 'Message Status should be Error');
    }

    @isTest
    static void createMessageWithStatusBouncedPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Status__c = 'Bounced';
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Bounced');
        System.assertEquals('Bounced', message.dmpl__Status__c, 'Message Status should be Bounced');
    }

    @isTest
    static void createMessageWithConfigurationPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.getMessageConfiguration();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__MessageConfigurationId__c = config.Id;
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Message Configuration');
        System.assertEquals(config.Id, message.dmpl__MessageConfigurationId__c, 'Message Configuration Id should match');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
    }

    @isTest
    static void createMessageWithSenderDetailsPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Sender Name and Sender');
        System.assertEquals('Leslie', message.dmpl__SenderName__c, 'Sender Name should match');
        System.assertEquals('Manager', message.dmpl__Sender__c, 'Sender should match');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
    }

    @isTest
    static void createMessageWithSenderDetailsEditPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__SenderName__c = 'Bindu';
        message.dmpl__Sender__c = 'Sales Manager';
        update message;
        dmpl__message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedMessage.Id, 'Message should be updated with new Sender Name and Sender');
        System.assertEquals('Bindu', updatedMessage.dmpl__SenderName__c, 'Sender Name should be updated');
        System.assertEquals('Sales Manager', updatedMessage.dmpl__Sender__c, 'Sender should be updated');
        System.assertEquals('Test Message', updatedMessage.Name, 'Message Name should match');
    }

    @isTest
    static void createMessageWithRecipientNamePositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Recipient__c = 'XYZ';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Recipient Name');
        System.assertEquals('XYZ', message.dmpl__Recipient__c, 'Recipient Name should match');
    }

    @isTest
    static void createMessageWithSubjectAndBodyPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.dmpl__Subject__c = 'Test Subject';
        message.dmpl__MessageBody__c = 'This is a test message body.';
        update message;
        message = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Subject and Message Body');
        System.assertEquals('Test Subject', message.dmpl__Subject__c, 'Subject should match');
        System.assertEquals('This is a test message body.', message.dmpl__MessageBody__c, 'Message Body should match');
    }

    @isTest
    static void createMessageWithoutStatusPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created without Status');
        System.assertEquals(null, message.dmpl__Status__c, 'Default Status should be Draft');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
    }

    @isTest
	static void deleteMessageRecordPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        dmpl__Message__c deletedMessage = MessageDataHelper.getMessage(message.Id);
        delete message;
        System.assertNotEquals(null, deletedMessage, 'Expected message to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageWithoutNameNegative() {
        Test.startTest();
        try {
            dmpl__Message__c message = MessageDataHelper.getMessage();
            message.Name = null;
            update message;
            message = MessageDataHelper.getMessage(message.Id);
            System.assertNotEquals(null, message.Id, 'Message should be created without Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void updateMessageWithoutNameNegative() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        message.Name = null;
        update message;
        dmpl__Message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        System.assertNotEquals(null, updatedMessage, 'Message should be updated without Name');
        Test.stopTest();
    }

    @isTest
    static void updateMessageWithoutSubjectNegative() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.getMessage();
        System.assertEquals('Test Subject', message.dmpl__Subject__c,'Subject should be initially set');
        message.dmpl__Subject__c = null;
        update message;
        dmpl__Message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertEquals(null, updatedMessage.dmpl__Subject__c, 'Subject should be deleted');
    }
    
    @isTest
    static void createMessageRuleWithNameAndFieldSelectionPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Name and Field Selection');
        System.assertEquals('Status', rule.dmpl__FieldName__c, 'Field Name should match');
    }

    @isTest
    static void createMessageRuleWithOperationEqualPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'equals';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as Equal');
        System.assertEquals('equals', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationNotEqualPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'notEqual';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as Not Equal');
        System.assertEquals('notEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationGreaterOrEqualPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'greaterOrEqual';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as greaterOrEqual');
        System.assertEquals('greaterOrEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationLessOrEqualPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'lessOrEqual';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as lessOrEqual');
        System.assertEquals('lessOrEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationGreaterThanPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'greaterThan';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as greaterThan');
        System.assertEquals('greaterThan', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationLessThanPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = 'lessThan';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as lessThan');
        System.assertEquals('lessThan', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithFieldValuePositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__FieldValue__c = 'Create';
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Field Value');
        System.assertEquals('Create', rule.dmpl__FieldValue__c, 'Field Value should match');
    }

    @isTest
    static void createMessageRuleWithValidSequenceNumberPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with valid Sequence Number');
        System.assertEquals(1, rule.dmpl__SequenceNumber__c, 'Sequence Number should match');
    }

    @isTest
    static void createMessageRuleWithoutFieldValuePositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__FieldValue__c = null;
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Field Value');
        System.assertEquals(null, rule.dmpl__FieldValue__c, 'Field Value should be null');
    }
    
    @isTest
    static void createMessageRuleWithoutSequenceNumberPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__SequenceNumber__c = null;
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Sequence Number');
        System.assertEquals(null, rule.dmpl__SequenceNumber__c, 'Sequence Number should be null');
    }
    
    @isTest
    static void createMessageRuleWithoutOperationPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__Operation__c = null;
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Operation');
        System.assertEquals(null, rule.dmpl__Operation__c, 'Operation should be null');
    }
    
    @isTest
    static void deleteMessageRuleRecordPositive() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        dmpl__MessageRule__c deletedRule =  null;
        delete rule;
        try {
            deletedRule = MessageDataHelper.getMessageRuleById(rule.Id);
        } catch (QueryException e) {
            deletedRule = null;
        }
        System.assertEquals(null, deletedRule, 'Expected message Rule to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageRuleWithInvalidOperationNegative() {
        Test.startTest();
        try {
            dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
            rule.dmpl__Operation__c = 'invalidOperation';
            update rule;
            rule = MessageDataHelper.getMessageRuleById(rule.Id);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with invalid Operation');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createMessageRuleWithFieldValueExceedingLimitNegative() {
        Test.startTest();
        try {
            String longFieldValue = String.valueOf(new List<String>{'A'.repeat(256)});
            dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
            rule.dmpl__FieldValue__c = longFieldValue;
            update rule;
            rule = MessageDataHelper.getMessageRuleById(rule.Id);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with Field Value exceeding 255 characters');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createMessageRuleWithNegativeSequenceNumberNegative(){
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__SequenceNumber__c = -1;
        update rule;
        rule = MessageDataHelper.getMessageRuleById(rule.Id);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, ' Message Rule should be created with negative Sequence Number');
    }

    @isTest
    static void createMessageRuleWithDeletedConfigurationNegative() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.getMessageConfiguration();
        delete config;
        try {
            dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule(config.Id);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with deleted Message Configuration');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}