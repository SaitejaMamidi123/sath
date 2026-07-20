public with sharing class ProducerSearchController {
    
    @AuraEnabled(cacheable=true)
    public static List<Producer__c> searchProducers(String searchTerm) {
        String likePattern = '%' + searchTerm + '%';
        return [
            SELECT Id, Name
            FROM Producer__c
            WHERE Name LIKE :likePattern
            LIMIT 10
        ];
    }
}