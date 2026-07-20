@isTest
private class AccountHandlerTest {
    
     @isTest
    Private static void activateNewAccountsTest(){
         List<Account> accList = new List<Account>{
            new Account(Name = 'Test Account 1', Industry = 'Energy'),
            new Account(Name = 'Test Account 2', Industry = 'Agriculture'),
            new Account(Name = 'Test Account 3', Industry = 'Chemicals')
        };
            insert accList;
        List<Account> insertedAccs = [SELECT Id, Active__c, BillingCountry, rating, Industry FROM Account WHERE Id IN :accList];
         for (Account acc1 : insertedAccs) {
            System.assertEquals('Yes', acc1.Active__c, 'Active__c should be Yes');
            System.assertEquals('India', acc1.BillingCountry, 'BillingCountry should be India');
             if(acc1.Industry == 'Energy'){
                 System.assertEquals('Hot', acc1.Rating, 'Rating should be Hot');
             }else if(acc1.Industry == 'Agriculture'){
                 System.assertEquals('Warm', acc1.Rating, 'Rating should be Warm');
             }else{
                 System.assertEquals('Cold', acc1.Rating, 'Rating should be Cold');
             }
        }
    }
    @isTest
    Private static void getAccountRecords(){
        Account accList = new Account();
            accList.Name = 'Test Account 1';
        	accList.Industry = 'Energy';
        	accList.Phone = '1234';
            insert accList;
                
        Account a = AccountHandler.getAccountRecords();
        System.assertEquals(accList.id, a.Id, 'Failed to get records');
        accList.Phone = '12675';
        update accList;
        Account b = [Select id, Phone, Description from Account where id =:accList.id];
        System.assertEquals('Phone number updated', b.Description, 'Failed to update records');
        
    }
}