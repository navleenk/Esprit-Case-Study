/**
 * Test Data Factory to aid in test data creation for Apex unit tests
 *
 * @author Navleen Kaur
 * @created Aug 2023
 */
@IsTest
public class TestDataFactory {
    /**
     * Create a list of test opportunities
     *
     * @param count  The number of opportunities that need to te created
     * @param stageName  The opportunity stage that needs to be set while creating an opportunity
     *
     * @return  List of test opportunities
     */
    public static List<Opportunity> createOpportunities(Integer count, String stageName) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 1; i <= count; i++) {
            opportunities.add(
                new Opportunity(
                    Name = 'Opportunity ' + i,
                    CloseDate = Date.today().addDays(1),
                    StageName = stageName
                )
            );
        }

        return opportunities;
    }
}
