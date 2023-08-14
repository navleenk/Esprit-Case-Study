/**
 * Controller class to display & update opportunities
 *
 * @author Navleen Kaur
 * @created Aug 2023
 */
public with sharing class CTRL_MyOpportunities {
    /**
     * Get all Opportunities accessible by the running user
     *
     * @return  A list of opportunities
     */
    @AuraEnabled(Cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return new SEL_Opportunity().getAllOpportunities();
    }

    /**
     * Method to update the selected opportunities for a user
     *
     * @param opportunities List of opportunities for which Stage needs to be changed by value selected
     * @param stageName     The selected Stage Name to which these opportunities are updated
     *
     * @return Updated opportunities
     */
    @AuraEnabled
    public static List<Opportunity> updateOpportunities(
        List<Opportunity> opportunities,
        String stageName
    ) {
        List<Opportunity> opportunitiesToBeUpdated = new List<Opportunity>();
        for (Opportunity opp : opportunities) {
            opp.StageName = stageName;
            opportunitiesToBeUpdated.add(opp);
        }
        if (!opportunitiesToBeUpdated.isEmpty()) {
            update opportunitiesToBeUpdated;
        }

        return getOpportunities();
    }
}
