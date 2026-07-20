public class SchedulableApex implements Schedulable{
    public void execute(SchedulableContext sc){
        
        delete [select id, stagename from opportunity where stagename='Closed Lost'];
    }

}