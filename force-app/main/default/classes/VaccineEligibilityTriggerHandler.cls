public class VaccineEligibilityTriggerHandler {
    public static void insertVaccineEligibilityStatus(List<CovidVaccineEligibility__c> VaccineRec)
 {
 for(CovidVaccineEligibility__c tempRec : VaccineRec )
 {
 if (tempRec.age__c > 60 && tempRec.City__c != null)
 {
 tempRec.Eligibility_Status__c = 'Congrats !! You are eligible for the BOOSTER Vaccine Dose';
 } 
 else if (tempRec.age__c <= 60 && tempRec.City__c != null) {
 
 if ((tempRec.City__c == 'Mumbai' || tempRec.City__c == 'Delhi' || tempRec.City__c 
== 'Kolkata' || tempRec.City__c == 'Chennai') && (tempRec.age__c > 12 && tempRec.age__c<=60))
 {
 tempRec.Eligibility_Status__c = 'You are eligible for the Vaccine Dose'; 
 
 }
 
 else if (tempRec.City__c != 'Mumbai' || tempRec.City__c != 'Delhi' || tempRec.City__c 
!= 'Kolkata' || tempRec.City__c != 'Chennai')
 { 
 if(tempRec.age__c < 18 ){
 tempRec.Eligibility_Status__c = 'Sorry , You are Not eligible for the Vaccine Dose';
 }
 else if (tempRec.age__c > 18){
 tempRec.Eligibility_Status__c = 'You are eligible for the Vaccine Dose'; 
 }
 }
 
 }
 }
 }
 
 public static void updateVaccineEligibilityStatus(List<CovidVaccineEligibility__c> 
VaccineRec,map<id, CovidVaccineEligibility__c> oldRec )
 {
 for(CovidVaccineEligibility__c tempRec : VaccineRec )
 {
 if (tempRec.age__c > 60 && tempRec.City__c != null)
 {
 tempRec.Eligibility_Status__c = 'Congrats !! You are eligible for the BOOSTER Vaccine Dose';
 } 
 else if (tempRec.age__c <= 60 && tempRec.City__c != null) {
 
 if ((tempRec.City__c == 'Mumbai' || tempRec.City__c == 'Delhi' || tempRec.City__c 
== 'Kolkata' || tempRec.City__c == 'Chennai') && (tempRec.age__c > 12 && tempRec.age__c <=60))
 {
 tempRec.Eligibility_Status__c = 'You are eligible for the Vaccine Dose'; 
 
 }
 
 else if (tempRec.City__c != 'Mumbai' || tempRec.City__c != 'Delhi' || tempRec.City__c != 'Kolkata' || tempRec.City__c != 'Chennai')
 { 
 if(tempRec.age__c < 18 )
     tempRec.Eligibility_Status__c = 'Sorry , You are Not eligible for the Vaccine Dose';
 }
 else if (tempRec.age__c > 18){
 tempRec.Eligibility_Status__c = 'You are eligible for the Vaccine Dose'; 
 }
 }
 
 }
 }
 }