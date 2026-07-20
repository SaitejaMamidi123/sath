import { LightningElement, track} from 'lwc';

export default class GrandParentComponent extends LightningElement {
    @track messageFromChild;

    handleButtonClick(event){
        this.messageFromChild= event.detail;
    }
    
}