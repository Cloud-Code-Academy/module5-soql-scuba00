/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Conrad Monreal
*/

public with sharing class SOQL {

    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}    

    /**
     * Question 1 Completed
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {

        // Check for Lead read permissions
        if (!Schema.sObjectType.Lead.isAccessible()){
                throw new OtherException('Current user does not have permission to read Lead records.');
        }   

        List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        return allLeads;
    }

    /**
     * Question 2 Completed
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String firstName) {

        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
    }   

        List<Contact> contacts = [SELECT Id, FirstName, LastName, Name FROM Contact WHERE FirstName = :firstName];
        return contacts;
    }

    /**
     * Question 3 Completed
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName(List<String> lastNames) {
        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
    }   

        List<Contact> contactList = [SELECT Id, LastName FROM Contact WHERE LastName IN :lastNames];
        
        List<Id> contactIds = new List<Id>();
        for (Contact contact : contactList) {
            contactIds.add(contact.Id);
        }

        return contactIds;
    }

    /**
     * Question 4 Completed
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
        // Check for Opportunity read permissions
        if (!Schema.sObjectType.Opportunity.isAccessible()){
            throw new OtherException('Current user does not have permission to read Opportunity  records.');
        }   

        String stageNameClosedWon = 'Closed Won';

        List<Opportunity> opportunityList = ([SELECT Id, Name, StageName, CloseDate, AccountId, Amount FROM Opportunity WHERE AccountId = :accountId AND StageName = :stageNameClosedWon]);

        return opportunityList;
    }

    /**
     * Question 5 Completed
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }   
        
        Integer accountCount = [SELECT COUNT() FROM Account];

        return accountCount;
    }

    /**
     * Question 6 Completed
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek() {
        // Check for Task read permissions
        if (!Schema.sObjectType.Task.isAccessible()){
            throw new OtherException('Current user does not have permission to read Task records.');
        }   

        //List<Task> taskList = [SELECT OwnerId FROM Task];
        List<Task> taskList = [SELECT
                                 Id,
                                 OwnerId, 
                                 CreatedById, 
                                 ActivityDate, 
                                 WhoId, 
                                 Status, 
                                 Subject, 
                                 Type, 
                                 TaskSubtype 
                              FROM 
                                 Task 
                              WHERE
                                 ActivityDate >= :Date.today() 
                              AND 
                                 ActivityDate <= :Date.today().addDays(7)];
        Map<Id,Task> taskMap = new Map<Id,Task>(taskList);
        return taskMap;
    }

    /**
     * Question 7 Completed
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain(String emailDomain) {
        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
        }   
        
        emailDomain = emailDomain.trim();
        emailDomain = '%'+ emailDomain + '%';
        List<Contact> contacts = 
            [SELECT 
                Id, 
                FirstName, 
                LastName, 
                Name, 
                Email 
            FROM 
                Contact 
            WHERE 
                Email LIKE :emailDomain];

        return contacts;

            }

    /**
     * Question 8 Completed
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        If(keyword == null){
            return new List<Opportunity>();            
        }


        // Check for Opportunity read permissions
        if (!Schema.sObjectType.Opportunity.isAccessible()){
            throw new OtherException('Current user does not have permission to read Opportunity records.');
        }   
        
        keyword = keyword.trim();
        keyword = '%'+ keyword + '%';

        List<Opportunity> opportunityList = 
        [SELECT 
            Id, 
            Name 
        FROM 
            Opportunity 
        WHERE 
            Name LIKE :keyword];
        
        return opportunityList == null ? new List<Opportunity>() : opportunityList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9 Completed
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        // Check for Case read permissions
        if (!Schema.sObjectType.Case.isAccessible()){
            throw new OtherException('Current user does not have permission to read Case records.');
        }   

        String originPhone = 'Phone';

        List<Case> caseList = [SELECT Id, AccountId, CaseNumber, Status, Subject, Type, Origin FROM Case WHERE Origin = :originPhone];

        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10 Completed
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String searchKeyword) {
        // Check for Lead read permissions
        if (!Schema.sObjectType.Lead.isAccessible()){
            throw new OtherException('Current user does not have permission to read Lead records.');
        }   

        String holdSearchKeyword = searchKeyword.trim();
        holdSearchKeyword = '%'+ holdSearchKeyword + '%';

        List<Lead> leadList = 
            [SELECT 
                Id, 
                LastName, 
                Company, 
                Phone,
                Email,
                LeadSource, 
                Title
            FROM 
                Lead 
            WHERE 
                (LeadSource = :leadSource) 
            OR
                (Title LIKE :holdSearchKeyword)];

        return leadList; // Replace null with the variable you used to store the result

    }    

    /**
     * Question 11 Completed
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
        }   

        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();

        // Query the Contacts
        // Loop through each Contact and add the LastName to the list
        for (Contact contact : [SELECT LastName FROM Contact WHERE AccountId = :accountId]) {
            contactLastNames.add(contact.LastName);
        }

        // Return the list of Contact LastNames
        return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12 Completed
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Check for Opportunity read permissions
        if (!Schema.sObjectType.Opportunity.isAccessible()){
            throw new OtherException('Current user does not have permission to read Opportunity records.');
        }   

        Decimal amountCriteria = 10000;
        // Use AggregateQuery to get the total revenue
        List<AggregateResult> aggregateResults = [SELECT SUM(Amount) TotalRevenue FROM Opportunity WHERE (StageName = :stage) OR (Amount > :amountCriteria)];
        
        Decimal totalRevenue = null;
        if (aggregateResults.size() > 0) {
            totalRevenue = (Decimal) aggregateResults.get(0).get('TotalRevenue');
        }
        // Return the total revenue
        return totalRevenue; // Replace null with the variable you used to store the result
    }

    /**
     * Question 13 Completed
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }   

        List<Account> accountList = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
        
        return accountList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14 Completed
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        // Check for Opportunity read permissions
        if (!Schema.sObjectType.Opportunity.isAccessible()){
            throw new OtherException('Current user does not have permission to read Opportunity records.');
        }   

        List<Opportunity> opportunityList = [
            SELECT
                Id,
                Name,
                AccountId,
                CloseDate,
                StageName,
                Amount
            FROM
                Opportunity
            WHERE
                Amount > 100000
            ORDER BY
                CloseDate
            LIMIT
                5
        ];

        return opportunityList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15 Completed
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
        }

            List<Contact> contactList = [
            SELECT
                Id,
                LastName,
                Birthdate
            FROM
                Contact
            ORDER BY
                Birthdate DESC
            LIMIT
                3
        ];

        return contactList; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16 Completed
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        // Check for Case read permissions
        if (!Schema.sObjectType.Case.isAccessible()){
            throw new OtherException('Current user does not have permission to read Case records.');
        }

        List<Case> caseList = [
            SELECT
                Id,
                Subject,
                Status,
                CreatedDate
            FROM
                Case
            WHERE
                Status = 'Open'
            ORDER BY
                CreatedDate
            LIMIT
                10
            OFFSET
                5
        ];

        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17 Completed
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Check for Case read permissions
        if (!Schema.sObjectType.Case.isAccessible()){
            throw new OtherException('Current user does not have permission to read Case records.');
        }

        Set<Id> caseIdSet = new Set<Id>();

        // Create a set to hold the Case Ids
        List<Case> caseList = [
            SELECT
                Id,
                AccountId,
                Subject,
                Status
            FROM
                Case
            WHERE
                AccountId = :accountId
        ];

        // Query the Cases
        // Loop through each Case and add the Id to the set
        for ( Case caseIdRecord : caseList) {
            caseIdSet.add(caseIdRecord.Id);
        }

        return caseIdSet; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18 Completed
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }

        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        List<Account> accountList = [
            SELECT
                Id,
                Name,
                BillingCountry
            FROM
                Account
            WHERE
                BillingCountry != :country
        ];
        // Query the Accounts
        // Loop through each Account and add the Id and Name to the map
        for(Account accountRecord : accountList){
            accountIdsToNames.put(accountRecord.Id, accountRecord.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19 Completed
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }

        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
        }
        
        Contact contactRecord = [
            SELECT
                Account.Name
            FROM
                Contact
            WHERE
                Id = :contactId
        ];

        return contactRecord.Account.Name; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20 Completed
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }

        // Check for Opportunity read permissions
        if (!Schema.sObjectType.Opportunity.isAccessible()){
            throw new OtherException('Current user does not have permission to read Opportunity records.');
        }        
                
        Account accountRecord = [
            SELECT
                Id,
                Name,
                (SELECT Id, Name FROM Opportunities)
            FROM
                Account
        ];

        return accountRecord; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21 Completed
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }

        // Check for Contact read permissions
        if (!Schema.sObjectType.Contact.isAccessible()){
            throw new OtherException('Current user does not have permission to read Contact records.');
        }        

        // Query the Account
        List<Account> accountList = [
            SELECT
                Id,
                BillingState
            FROM
                Account
            WHERE
                Id = :accountId
        ];
        // Store the Account's BillingState
        String holdBillingState = accountList[0].BillingState;
        
        // Query the Contacts
        
        List<Contact> contactList = [
            SELECT
                Id,
                AccountId,
                Name,
                MailingState
            FROM
                Contact
            WHERE
                MailingState = :holdBillingState
        ];
        return contactList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22 Completed
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Check for Account read permissions
        if (!Schema.sObjectType.Account.isAccessible()){
            throw new OtherException('Current user does not have permission to read Account records.');
        }

        // Check for Lead read permissions
        if (!Schema.sObjectType.Lead.isAccessible()){
            throw new OtherException('Current user does not have permission to read Lead records.');
        }              
        // Query the Leads
        List<Lead> leads = [
            SELECT
                Email
            FROM
                Lead
            WHERE
                Id IN :leadIds
        ];
        
        // Create a set of email domains from the leads
        Set<String> emailDomains = new Set<String>();
        // Loop through each Lead
            // Get the email from the Lead
            // Check if the email is not null
            // Add the email domain to the set
        for(Lead leadRecord : leads) {
            //if(leadRecord.Email != null && leadRecord.Email.split('@').size() > 1){
            if(leadRecord.Email != null){
                emailDomains.add('www.' + leadRecord.Email.split('@')[1]);
            }
        }

        // Query the Accounts
        List<Account> accountList = [
            SELECT
                Id,
                Name,
                Website
            FROM
                Account
            WHERE
                Website in :emailDomains
        ];

        return accountList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23 Completed
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Check for OpportunityLineItem read permissions
        if (!Schema.sObjectType.OpportunityLineItem.isAccessible()){
            throw new OtherException('Current user does not have permission to read OpportunityLineItem records.');
        }

        // Query the original Opportunity Line Items
        List<OpportunityLineItem> oliList = [
            SELECT
                Id,
                OpportunityId,
                Quantity,
                PricebookEntryId,
                UnitPrice
            FROM
                OpportunityLineItem
            WHERE
                OpportunityId = :origOppId
        ];
        // Create a list to hold the new line items
        List<OpportunityLineItem> cloneOliList = new List<OpportunityLineItem>();
        // Generate a random number between 1 and 3
        Integer randomQuantity = 1 + (Integer)(Math.random() * 3);

        // Loop through each cloned Opportunity Id
        for(Id cloneOppId : cloneOppIds){
            // Loop through each original line item
            for(OpportunityLineItem oli : oliList){
                // Clone the original line item and add the random number to the quantity
                OpportunityLineItem cloneOli = oli.clone(false, false, false, false);
                cloneOli.OpportunityId = cloneOppId;
                cloneOli.Quantity += randomQuantity;
                cloneOliList.add(cloneOli);
            }
        }
        // Insert the new line items
        insert cloneOliList;
    }
    
    /**
     * Question 24 Completed
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {    
        
        List<Opportunity> opportunityList = [
            SELECT
                Id,
                Name,
                Account.Name,
                StageName,
                Owner.Name,
                Primary_Contact__c
            FROM
                Opportunity
            WHERE
                StageName = 'Closed Won'
        ];

        return opportunityList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25 Completed
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {

        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opportunityList = getOpportunityDetailsForClosedWon();
        
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIdSet = new Set<Id>();
        
        // Loop through the Opportunity List and add the Account Id to the set
        for(Opportunity opp : opportunityList){
            accountIdSet.add(opp.AccountId);
        }
        
        // Query the Contacts
        List<Contact> contactList = [
            SELECT
                Id,
                AccountId,
                Name
            FROM
                Contact
            WHERE
                AccountId IN :accountIdSet
        ];

        // Loop through each Contact and add the Account Id and Contact to the map
        Map<Id,Id> accountToContactMap = new Map<Id,Id>();
        for(Contact contactRecord : contactList){
            accountToContactMap.put(contactRecord.AccountId, contactRecord.Id);
        }
        // Loop through each Opportunity
        for(Opportunity opportunityRecord : opportunityList){
            // Update the Opportunity primary contact from accountToContactMap
            opportunityRecord.Primary_Contact__c = accountToContactMap.get(opportunityRecord.AccountId);
        }

        // Update the Opportunities
        update opportunityList;
    }
}