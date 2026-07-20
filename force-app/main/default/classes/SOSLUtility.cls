public class SOSLUtility {
    public List<List<sObject>> getRecordsMatchingName(String name){
    return [Find 'test' IN Name Fields Returning Contact(firstname,lastname,id),

    Lead(FirstName,LastName), Opportunity(Name), Account(Name)];
}
}