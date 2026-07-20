import { LightningElement,api } from 'lwc';

export default class MyAccountComponent extends LightningElement {
    @api recordId='';
    @api objectApiName;
    fields=["Name","Rating","AnnualRevenue","Phone" ];

}