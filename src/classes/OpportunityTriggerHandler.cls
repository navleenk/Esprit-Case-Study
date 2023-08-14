/**
 * TriggerHandler for Opportunity.Creates a Task when an opportunity stage changes to 'Closed Won'
 *
 * @author Navleen Kaur
 * @created Aug 2023
 */
public without sharing class OpportunityTriggerHandler {
    public static final String TASK_SUBJECT = 'Your Opportunity has been converted';

    /**
     * Creates a Task Record when an Opportunity Stage changes to 'Closed Won'
     *
     * @param oldOpportunityMap Trigger.oldMap of Opportunity
     * @param newOpportunityMap Trigger.newMap of Opportunity
     */
    public static void createTask(
        Map<Id, Opportunity> oldOpportunityMap,
        Map<Id, Opportunity> newOpportunityMap
    ) {
        List<Task> tasksToCreate = new List<Task>();
        for (String opportunityId : newOpportunityMap.keySet()) {
            Opportunity updatedOpportunity = newOpportunityMap.get(opportunityId);

            //If the Stage changes and the new Stage is Closed Won
            if (
                !oldOpportunityMap.get(opportunityId)
                    .StageName.equals(updatedOpportunity.StageName) &&
                updatedOpportunity.StageName.equals(Constants.OPPORTUNITY_STAGE_CLOSED_WON)
            ) {
                tasksToCreate.add(
                    new Task(
                        OwnerId = updatedOpportunity.OwnerId,
                        WhatId = opportunityId,
                        Subject = TASK_SUBJECT,
                        ActivityDate = Date.today().addDays(1),
                        Priority = Constants.TASK_PRIORITY_NORMAL,
                        Status = Constants.TASK_STATUS_IN_PROGRESS,
                        IsReminderSet = true,
                        ReminderDateTime = Datetime.now().addMinutes(1)
                    )
                );
            }
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}
