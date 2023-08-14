/**
 * Trigger on Opportunity. Creates Task when stage is updated to 'Closed Won'
 * 
 * @author Navleen Kaur
 * @created Aug 2023
 */
trigger OpportunityTrigger on Opportunity(after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.createTask(Trigger.oldMap, Trigger.newMap);
        }
    }
}
