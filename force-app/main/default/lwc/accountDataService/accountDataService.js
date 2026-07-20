import { LightningElement, api, wire } from 'lwc';
import {getRecord, updateRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// Define fields that We Want to Fetched from Account
const FIELDS=['Account.Name', 'Account.Industry'];
export default class AccountDataService extends LightningElement {

    @api recordId;// This Will Hold the Account Id to be Passed from the Parent Component

    accountName;
    accountIndustry;

    // We are using Wire Service to Get the Account Data
    @wire(getRecord,{recordId:'$recordId', fields: FIELDS})
    account;


    //Handle Change in the Account Name Input
    handlenameChange(event){
        this.accountName= event.target.value;
    }

    //handle Change in the account Industry
    handleIndustryChange(event){
        this.accountIndustry= event.target.value;
    }

    //Saving the Changes Using LDS
    saveAccount(){
        //prepare the fields to update
        const fields={
            Id : this.recordId,
            Name: this.accountName || this.account.data.fields.Name.value,
            Industry: this.accountIndustry || this.account.data.fields.Industry.value,
        };
        const recordInput={fields};

        //calling the LDS to update the record
        updateRecord(recordInput)
            .then(()=>{
                // To Show the Success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Success',
                        message:' Account Updated Successful',
                        variant: 'error',
                    })
                );
            })
            .catch(error=>{
                //handle Error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Error Updating Accounts',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }
}