import { LightningElement, track } from 'lwc';

export default class ChildComponent extends LightningElement {

        @track message = "child component";
    handleClick(){
        const event = new CustomEvent("buttonclick", {
            bubbles:true,
            composed:true,
            detail : this.message
                   
        });
        this.dispatchEvent(event);
        
    }
}