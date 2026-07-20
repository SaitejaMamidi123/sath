import { LightningElement } from 'lwc';

export default class QuizApp extends LightningElement {

    selected={} // for storing answers
    correctAnswers = 0 //to show the number of correct answers
    isSubmitted = false // use to show the result
    myQuestions=[
        {
            id:"Question1",
            question:"Which feature grants extra user permissions without changing the profile?",
            answers:{
                a:"Role Hierarchy",
                b:"Permission Set",
                c:"Sharing Rule"
            },
            correctAnswer:"b"
        },
        {
            id:"Question2",
            question:"Which setting defines baseline record access for each object?",
            answers:{
                a:"Organization-Wide Defaults (OWD)",
                b:"Manual Sharing",
                c:"Apex Sharing"
            },
            correctAnswer:"a"
        },
        {
            id:"Question3",
            question:"Which statement about role hierarchy is correct?",
            answers:{
                a:"It grants object-level permissions",
                b:"It controls page layout assignments",
                c:"It can grant access to records owned by users below"
            },
            correctAnswer:"c"
        },
        {
            id:"Question4",
            question:"Which tool is best for granting record access based on record criteria?",
            answers:{
                a:"Sharing Rule",
                b:"Permission Set",
                c:"Field-Level Security"
            },
            correctAnswer:"a"
        },
        {
            id:"Question5",
            question:"Field-level security controls what?",
            answers:{
                a:"Whether users can view/edit a field",
                b:"Which records users own",
                c:"API version of the org"
            },
            correctAnswer:"a"
        },
        {
            id:"Question6",
            question:"What is the primary purpose of profiles in security?",
            answers:{
                a:"Define baseline object and app permissions",
                b:"Share records by criteria",
                c:"Assign queue members"
            },
            correctAnswer:"a"
        },
        {
            id:"Question7",
            question:"Which feature can give a user temporary record-level access to a single record?",
            answers:{
                a:"Manual Sharing",
                b:"Object Permission",
                c:"Profile Login Hours"
            },
            correctAnswer:"a"
        },
        {
            id:"Question8",
            question:"What does 'View All Data' allow a user to do?",
            answers:{
                a:"View all records in the org",
                b:"Edit all setup metadata",
                c:"Bypass MFA"
            },
            correctAnswer:"a"
        },
        {
            id:"Question9",
            question:"When should an admin use 'Modify All' object permission?",
            answers:{
                a:"For least-privilege access to a few fields",
                b:"Only when broad edit/delete access is required",
                c:"To grant access to one specific record only"
            },
            correctAnswer:"b"
        },
        {
            id:"Question10",
            question:"Which setting controls whether a user can read, create, edit, or delete records for an object?",
            answers:{
                a:"Object-level permissions",
                b:"Record Type",
                c:"Compact Layout"
            },
            correctAnswer:"a"
        }
    ]

    //used for disabling the sumbmit button
    get allNotSelected(){
        return !(Object.keys(this.selected).length === this.myQuestions.length)
    }

    // for applying dynamic styling to our result
    get isScoredFull(){
        return `slds-text-heading_large ${this.myQuestions.length === this.correctAnswers?
            'slds-text-color_success':'slds-text-color_error'}`
    }
    // changeHandler get's called on every click on the options
    changeHandler(event){
        const {name, value} = event.target 
        this.selected={...this.selected, [name]:value}
    }
    //form submit handler
    submitHandler(event){
        event.preventDefault()
        let correct = this.myQuestions.filter(item=>this.selected[item.id] === item.correctAnswer)
        this.correctAnswers = correct.length
        this.isSubmitted = true
    }
    //form reset handler
    resetHandler(){
        this.selected ={}
        this.correctAnswers=0
        this.isSubmitted = false
    }
}