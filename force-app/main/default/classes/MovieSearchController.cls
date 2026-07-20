public with sharing class MovieSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMovies(String searchTerm) {
        if (String.isBlank(searchTerm)) {
            return new List<Movie__c>();
        }

        return [
            SELECT Id, Name
            FROM Movie__c
            WHERE Name LIKE :('%' + searchTerm + '%')
            LIMIT 10];
    }
}