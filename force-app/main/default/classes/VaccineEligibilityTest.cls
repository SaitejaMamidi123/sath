@isTest
public class VaccineEligibilityTest {
    // test 1 - test citizens of age > 60
    @isTest
    public static void testforseniourcitizens()
    { 
        String output = VaccineEligibility.CheckVaccineEligibility(61,'Mumbai');
        system.Assert.areEqual('Congrats !! You are eligible for the BOOSTER Vaccine Dose', output, 'Test1 failed');
    }
    
    // test 2 -- test citizens of metro within age > 18 and age < 60
    @isTest
    public static void testforcitizensofmetro()
    {
        //VaccineEligibility obj = new VaccineEligibility();
        // string output = obj.CheckVaccineEligibility(17,'Varanasi');
        
        String output = VaccineEligibility.CheckVaccineEligibility(20 , 'Mumbai');
        system.Assert.areEqual('You are eligible for the Vaccine Dose', output, 'Test2 failed');
    } 
    
    // test 3 - test citizens of Non metro within age > 18 and age < 60
    @isTest
    public static void testforcitizensOfNonMetro()
    { 
        String output = VaccineEligibility.CheckVaccineEligibility(19,'Amritsar'); 
        system.Assert.areEqual('You are eligible for the Vaccine Dose', output, 'Test3 failed');
    }
    
    // 
    // test 4 - test citizens of Non metro with age< 18 
    @isTest
    public static void testforNonMetroMinorcitizens()
    { 
        String output = VaccineEligibility.CheckVaccineEligibility(16,'Madurai'); 
        system.Assert.areEqual('Sorry , You are Not eligible for the Vaccine Dose', output, 'Test4 failed');
    } 
}