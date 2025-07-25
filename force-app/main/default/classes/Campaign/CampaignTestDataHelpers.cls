@isTest
public class CampaignTestDataHelpers {
    public static dmpl__ServiceCampaign__c CreateServiceCompaign(
        dmpl__ItemServiceContract__c contract,
        dmpl__ServiceLead__c lead,
        dmpl__Item__c items
    )
    {   
            return (dmpl__ServiceCampaign__c)TestFactory.createSObject(
                new dmpl__ServiceCampaign__c(
                    dmpl__ItemServiceContractId__c = contract.Id,
                    dmpl__ServiceLeadId__c = lead.Id,
                    dmpl__ServiceContractItemId__c = items.Id
                ),
                true
            );
    }

    public static dmpl__ServiceCampaign__c getServiceCompaign(){
        return [
            SELECT 
                dmpl__ApexJobId__c,
                dmpl__BranchId__c,
                Name,
                CreatedById,
                dmpl__CronExpression__c,
                dmpl__DynamicMemberObject__c,
                dmpl__DynamicMemberType__c,
                dmpl__EndDate__c,
                dmpl__FromChassisSeries__c,
                dmpl__FromEngineSeries__c,
                dmpl__FromManufacturingDate__c,
                dmpl__FromSaleDate__c,
                dmpl__IsActive__c,
                dmpl__IsRecurring__c,
                dmpl__ItemMaintenanceScheduleId__c,
                LastModifiedById,
                OwnerId,
                dmpl__ParentServiceCampaignId__c,
                dmpl__PartnerAccountId__c,
                dmpl__RecurringType__c,
                dmpl__ReminderDaysOffset1__c,
                dmpl__ReminderDaysOffset2__c,
                dmpl__ReminderDaysOffset3__c,
                dmpl__ReportId__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__ServiceLeadId__c,
                dmpl__StartDate__c,
                dmpl__Status__c,
                dmpl__ToChassisSeries__c,
                dmpl__ToEngineSeries__c,
                dmpl__ToManufacturingDate__c,
                dmpl__ToSaleDate__c,
                dmpl__Type__c
            FROM 
                dmpl__ServiceCampaign__c
            LIMIT 1];
    }

    public static dmpl__ServiceCampaign__c createServiceCampaign(
        String name,
        String dynamicMemberTypeValue,
        Id parentServiceCampaignId,
        Id itemServiceContractId,
        String RuleCriteria,
        String Type,
        Date startDate,
        Date endDate
    ) {
        return (dmpl__ServiceCampaign__c) TestFactory.createSObject(
            new dmpl__ServiceCampaign__c(
                Name = name,
                dmpl__DynamicMemberType__c = dynamicMemberTypeValue,
                dmpl__ParentServiceCampaignId__c = parentServiceCampaignId,
                dmpl__ItemServiceContractId__c = itemServiceContractId,
                dmpl__RuleSuccessCriteria__c= RuleCriteria,
                dmpl__Type__c=Type,
                dmpl__StartDate__c=startDate,
                dmpl__EndDate__c=endDate
            ),
            'ServiceCampaignDefaults',
            true
        );
    }

    public static dmpl__ServiceCampaign__c getServiceCampaignById(Id recordId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DynamicMemberType__c, 
                dmpl__ParentServiceCampaignId__c,
                dmpl__ItemServiceContractId__c, 
                dmpl__StartDate__c, 
                dmpl__EndDate__c, 
                dmpl__Type__c, 
                dmpl__RuleSuccessCriteria__c
            FROM dmpl__ServiceCampaign__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}