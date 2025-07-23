public class ItemConsumptionTestDataHelper {
    public static dmpl__ItemConsumptionSchedule__c createItemConsumptionSchedule(
        String name, 
        Id itemId
    ) {
        return (dmpl__ItemConsumptionSchedule__c) TestFactory.createSObject(
            new dmpl__ItemConsumptionSchedule__c(
                Name = name,
                dmpl__ItemId__c = itemId
            ),
            'ItemConsumptionScheduleDefaults',
            true
        );
    }

    public static dmpl__ItemConsumptionSchedule__c getItemConsumptionSchedule(
        String name
    ) {
        return [
            SELECT 
                Id, 
                Name 
            FROM dmpl__ItemConsumptionSchedule__c 
            WHERE Name = :name 
            LIMIT 1
        ];
    }

    public static dmpl__ItemConsumptionRate__c createItemConsumptionRate(
        String rateName, 
        dmpl__ItemConsumptionSchedule__c schedule
    ) {
        return (dmpl__ItemConsumptionRate__c) TestFactory.createSObject(
            new dmpl__ItemConsumptionRate__c(
                Name = rateName,
                dmpl__ItemConsumptionSchedule__c = schedule.Id
            ),
            'ItemConsumptionRateDefaults',
            true
        );
    }
}