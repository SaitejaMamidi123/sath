public class VaccineEligibility {
    public static String CheckVaccineEligibility(integer age, String City)
    { 
        String isEligible = 'Sorry , You are Not eligible for the Vaccine Dose';
        
        if (age > 60 && City != null)
        {
            isEligible = 'Congrats !! You are eligible for the BOOSTER Vaccine Dose';
        } 
        else if (age <= 60 && City != null) {
            
            if ((city == 'Mumbai' || city == 'Delhi' || city == 'Kolkata' || city == 'Chennai') && (age > 12 && age<=60))
                
            {
                isEligible = 'You are eligible for the Vaccine Dose'; 
            }
            else if (city != 'Mumbai' || city != 'Delhi' || city != 'Kolkata' || city != 'Chennai')
            {
                if(age < 18 ){
                    isEligible = 'Sorry , You are Not eligible for the Vaccine Dose';
                }
                else if (age > 18){
                    isEligible = 'You are eligible for the Vaccine Dose'; 
                }
            }
        }
        return isEligible;
    }   
    
}