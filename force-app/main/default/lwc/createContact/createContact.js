import { LightningElement } from 'lwc';
import createAccount from '@salesforce/apex/accountController.createAccount'
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {NavigationMixin} from 'lightning/navigation';

export default class CreateAccountComponent extends NavigationMixin(LightningElement) {

accountName= ' ';
phone=' ';
website=' ';
industry= ' ';

//Industry Options for the Combobox
get industryOptions(){
    return[
            {label:'Agriculture', value: 'Agriculture'},
            {label:'Banking', value: 'Banking'},
            {label:'Consulting', value: 'Consulting'},
            {label:'Education', value: 'Education'},
            {label:'Tech', value: 'Technology'},
            {label:'Salesforce', value: 'Salesforce'}
    ];
}
// Hanlde Input Field Changes
handleInputChange(event){
    const field= event.target.dataset.id;
    if(field=== 'accountName'){
        this.accountName= event.target.value;

    }else if(field=== 'phone'){
        this.phone= event.target.value;
    }else if(field=== 'website')
    {
        this.website= event.target.value;
    }else if(field=== 'industry')
    {
        this.industry= event.target.value;
    }
}

    // Create Account and Navigate to the newly Created account Page
    createAccount(){
        createAccount({
            accountName: this.accountName,
            phone: this.phone,
            industry: this.industry,
            website: this.website
        })

          .then(result=>{
            this.displayToast('Account Created Successfully', 'Your Customer Account data is being Saved', 'warning');

            // navigate to the Newly Created account record page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes:{
                    recordId:result,
                    objectApiName:'Account',
                    actionName:'view'
                }
            });
          })
            .catch(error=>{
                this.displayToast('Error Happened', ' error in creating Account :'+error.body.message, 'error');
            });
    }

    //Show Toast Notification
    displayToast(title, message, variant){
        const evt= new ShowToastEvent({
            title : title,
            message : message,
            variant : 'success',
        });
        this.dispatchEvent(evt);
    }



}