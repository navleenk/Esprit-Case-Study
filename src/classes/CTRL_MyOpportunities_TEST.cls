/**
 * Test class for CTRL_MyOpportunities
 *
 * @author Navleen Kaur
 * @created Aug 2023
 */
@IsTest
public with sharing class CTRL_MyOpportunities_TEST {
    /**
     * Scenario: Test if all opportunities created by a running user are retrieved
     * Method: getOpportunities
     */
    @IsTest
    private static void getOpportunitiesTest() {
        List<Opportunity> opportunitiesCreated = TestDataFactory.createOpportunities(
            2,
            'Qualification'
        );
        insert opportunitiesCreated;

        Test.startTest();
        List<Opportunity> opportunities = CTRL_MyOpportunities.getOpportunities();
        Test.stopTest();

        Assert.areEqual(2, opportunities.size(), 'Number of Opportunities queried should be two');
        Assert.areEqual('Opportunity 1', opportunities[0].Name);
        Assert.areEqual(opportunitiesCreated[1].StageName, opportunities[1].StageName);
    }

    /**
     * Scenario: Test if Stage for a list of selected opportunities will be updated to a Selected Stage value
     * Method: updateMyOpportunities
     */
    @IsTest
    private static void updateOpportunitiesTest() {
        List<Opportunity> opportunitiesCreated = TestDataFactory.createOpportunities(
            2,
            'Qualification'
        );
        insert opportunitiesCreated;

        List<Opportunity> listOfOpportunities = [
            SELECT Name, StageName
            FROM Opportunity
        ];

        Test.startTest();
        List<Opportunity> opportunities = CTRL_MyOpportunities.updateOpportunities(
            listOfOpportunities,
            'Prospecting'
        );
        Test.stopTest();

        Assert.areEqual(listOfOpportunities.size(), opportunities.size());
        Assert.areEqual(
            'Prospecting',
            opportunities[0].StageName,
            'Opportunity stage should be updated'
        );
    }
}
