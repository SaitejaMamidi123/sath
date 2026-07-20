import { LightningElement ,api } from 'lwc';
export default class HelloQuickActionHeadless extends
LightningElement {
@api invoke()
{
console.log('Hi, I’m Headless action ');
}
}