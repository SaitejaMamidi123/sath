import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    fullname = 'Zero to Hero';
    title = 'LWC';
    @ track address = {
        city: 'Hyderabad',
        state: 'Telangana',
        country: 'India'
    }

    handleChange(event){
        this.title = event.target.value
    }
    trackHandler(event){
        this.address.city = event.target.value
    } 
    
    users = [ "john", "jane", "jack", "jill" ]
    num1 = 2
    num2 = 3

    get firstUser(){
        return this.users[0].toUpperCase()
    }

    get multiply(){
        return this.num1 * this.num2
    }

    userHandler(event){
        this.users = [event.target.value, ...this.users.slice(1)]
    }
}