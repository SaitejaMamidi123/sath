import { LightningElement } from 'lwc';

export default class HelloConditionalRendering extends LightningElement {

    isVisible = false;
    name

    renderHandler() {
        this.isVisible = true
    }
    handleChange(event) {
        this.name = event.target.value.trim().toLowerCase()
    }

    get Hello() {
        return this.name === 'hello'
    }

}