/**
 * Test class for OpportunityTriggerHandler
 *
 * @author Navleen Kaur
 * @created Aug 2023
 */
@IsTest
private class OpportunityTrigger_TEST {
    /**
     * Scenario: Test if a Task record is created when opportunities move to Closed Won stage
     */
    @IsTest
    private static void testTaskCreatedForClosedWonOpportunity() {
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(1, 'Qualification');
        insert opportunities;

        opportunities[0].StageName = 'Closed Won';

        Test.startTest();
        update opportunities;
        Test.stopTest();

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM Task
                WHERE
                    Subject = :OpportunityTriggerHandler.TASK_SUBJECT
                    AND WhatId = :opportunities[0].Id
            ],
            'Task should be created'
        );
    }

    /**
     * Scenario: Test if a Task record is not created when opportunities move to a stage except Closed Won stage
     */
    @IsTest
    private static void testNoTaskCreatedOnOpportunityUpdate() {
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(1, 'Qualification');
        insert opportunities;

        opportunities[0].StageName = 'Needs Analysis';

        Test.startTest();
        update opportunities;
        Test.stopTest();

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Task
                WHERE
                    Subject = :OpportunityTriggerHandler.TASK_SUBJECT
                    AND WhatId = :opportunities[0].Id
            ],
            'No Task should be created'
        );
    }
}
