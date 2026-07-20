import { LightningElement } from 'lwc';

export default class Looping extends LightningElement {

    carList = [ "Ford", "Chevrolet", "Toyota", "Honda", "Nissan" ]
    ceoList = [
        { id: 1, name: "Elon Musk", company: "Tesla" },
        { id: 2, name: "Tim Cook", company: "Apple" },
        { id: 3, name: "Satya Nadella", company: "Microsoft" },
        { id: 4, name: "Sundar Pichai", company: "Google" }
    ]
}