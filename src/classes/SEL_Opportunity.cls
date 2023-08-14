/**
 * Selector class for Opportunity sObject
 *
 * @author  Navleen Kaur
 * @created Aug 2023
 */
public inherited sharing class SEL_Opportunity {
    /**
     * Query Opportunities to a max of 50k
     *
     * @return queried Opportunities
     */
    public List<Opportunity> getAllOpportunities() {
        return [SELECT Id, Name, StageName FROM Opportunity ORDER BY StageName, Name LIMIT 50000];
    }
}
