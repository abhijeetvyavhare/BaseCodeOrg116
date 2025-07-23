public class MessageDefaults implements TestFactory.FieldDefaults{
	public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Message',
            'dmpl__Sender__c' => 'Manager',
            'dmpl__SenderName__c' => 'Leslie',
            'dmpl__Subject__c' => 'Test Subject'
        };
    }
}