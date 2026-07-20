import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from'@salesforce/schema/Movie__c.Name';
import RELEASE_DATE_FIELD from'@salesforce/schema/Movie__c.Release_Date__c';
import DIRECTOR_EMAIL_FIELD from'@salesforce/schema/Movie__c.Director_Email__c';
import RELEASED_IN_THEATRES_FIELD from'@salesforce/schema/Movie__c.Released_In_Theatres__c';
import AVAILABLE_ON_OTT_FIELD from '@salesforce/schema/Movie__c.Available_on_OTT__c';
import PREQUEL_FIELD from '@salesforce/schema/Movie__c.Prequel__c';
import PREQUEL_NAME_FIELD from '@salesforce/schema/Movie__c.Prequel__r.Name';
import PRODUCER_FIELD from '@salesforce/schema/Movie__c.Producer__c';
import PRODUCER_NAME_FIELD from '@salesforce/schema/Movie__c.Producer__r.Name';
import searchMovies from '@salesforce/apex/MovieSearchController.searchMovies';
import searchProducers from '@salesforce/apex/ProducerSearchController.searchProducers';
import MovieName from '@salesforce/label/c.Movie_Name';
import ReleaseDate from '@salesforce/label/c.Release_Date';
import DirectorEmail from '@salesforce/label/c.Director_Email';
import ReleasedInTheatres from '@salesforce/label/c.Movie_Name';
import AvailableOnOTT from '@salesforce/label/c.Released_In_Theatres';
import SearchPrequel from '@salesforce/label/c.Search_Prequel';



const FIELDS = [
    NAME_FIELD,
    RELEASE_DATE_FIELD,
    DIRECTOR_EMAIL_FIELD,
    RELEASED_IN_THEATRES_FIELD,
    AVAILABLE_ON_OTT_FIELD,
    PREQUEL_FIELD,
    PREQUEL_NAME_FIELD,
    PRODUCER_FIELD,
    PRODUCER_NAME_FIELD
];

export default class UpdateMovies extends LightningElement {
    @api recordId;
   @track Name;
   @track Release_Date;
   @track Director_Email;
   @track Released_In_Theatres;
   @track isAvailable;
   @track prequelId; // Selected Prequel ID
    @track prequelName; // Selected Prequel Name
    @track searchResults = []; // Search results for Prequel lookup
    @track searchTerm = ''; // Current search term
    @track isSearching = false; // Tracks whether a search is in progress
        @track producerId; // Selected Producer ID
        @track producerName; // Selected Producer Name
        @track producerSearchResults = []; // Search results for Producer lookup
        @track producerSearchTerm = ''; // Current producer search term
        @track isProducerSearching = false; // Tracks whether producer search is in progress
   @track recordData = null;

//Custom labels from salesforce
   @track movielabel = MovieName ;
   @track realeaseDate = ReleaseDate;
   @track directorEmail = DirectorEmail;
   @track releasedInTheatres = ReleasedInTheatres;
   @track availableOnOTT = AvailableOnOTT;
   @track prequel = SearchPrequel;
    @track producerLabel = 'Search Producer';
   
   
   


    
        @wire(getRecord, { recordId:'$recordId', fields: FIELDS })
        wiredRecord({ error, data}){

        if(data){         
            this.recordData = data;   
            this.Name = getFieldValue(data, NAME_FIELD);
            this.Release_Date = getFieldValue(data, RELEASE_DATE_FIELD);
            this.Director_Email = getFieldValue(data, DIRECTOR_EMAIL_FIELD);
            this.Released_In_Theatres = getFieldValue(data, RELEASED_IN_THEATRES_FIELD);
            this.prequelId = getFieldValue(data, PREQUEL_FIELD);
            this.prequelName = getFieldValue(data, PREQUEL_NAME_FIELD) || '';
            this.producerId = getFieldValue(data, PRODUCER_FIELD);
            this.producerName = getFieldValue(data, PRODUCER_NAME_FIELD) || '';
            this.isAvailable = getFieldValue(data, AVAILABLE_ON_OTT_FIELD);
            
            
            
                }
        
        
         else if(error) {
            
            console.error('Error fetching record:', error);
            this.recordData = null;

           
        }

    }
    
    
    
    handleMovieName(event){
        this.Name = event.target.value;
    }
    handleReleaseDate(event){
        this.Release_Date = event.target.value;
    }
    handleEmail(event){
        this.Director_Email = event.target.value;
    }
    handleReleasedInTheatres(event){
        this.Released_In_Theatres = event.target.checked;
    }
    handleToggle(event){
        this.isAvailable = event.target.checked;
    }
     // Search Prequel Movies
     handleSearch(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length > 0) {
            this.isSearching = true;
            
            searchMovies({ searchTerm: this.searchTerm })
                .then((results) => {
                    this.searchResults = results.map((record) => ({
                        label: record.Name,
                        value: record.Id
                    }));
                    this.isSearching = false;
                })
                .catch((error) => {
                    console.error('Error searching movies:', error);
                    this.isSearching = false;
                    
                });
        } else {
            this.searchResults = [];
        
        }
    }

    get hasPrequelSearchResults() {
        return this.searchResults.length > 0;
    }

    // Handle Prequel Selection
    handlePrequelSelect(event) {
        

        
        const selectedId = event.currentTarget.dataset.id;
        const selectedName = event.currentTarget.dataset.name;

        this.prequelId = selectedId;
        this.prequelName = selectedName;
        this.searchTerm = selectedName;
        this.searchResults = [];
        
   }

   handleRemovePrequel() {
        this.prequelId = null;
        this.prequelName = '';
        this.searchTerm = '';
        this.searchResults = [];
    }

    // Search Producers
    handleProducerSearch(event) {
        this.producerSearchTerm = event.target.value;
        if (this.producerSearchTerm.length > 0) {
            this.isProducerSearching = true;

            searchProducers({ searchTerm: this.producerSearchTerm })
                .then((results) => {
                    this.producerSearchResults = results.map((record) => ({
                        label: record.Name,
                        value: record.Id
                    }));
                    this.isProducerSearching = false;
                })
                .catch((error) => {
                    console.error('Error searching producers:', error);
                    this.isProducerSearching = false;
                });
        } else {
            this.producerSearchResults = [];
        }
    }

    get hasProducerSearchResults() {
        return this.producerSearchResults.length > 0;
    }

    // Handle Producer Selection
    handleProducerSelect(event) {
        const selectedId = event.currentTarget.dataset.id;
        const selectedName = event.currentTarget.dataset.name;

        this.producerId = selectedId;
        this.producerName = selectedName;
        this.producerSearchTerm = selectedName;
        this.producerSearchResults = [];
    }

    handleRemoveProducer() {
        this.producerId = null;
        this.producerName = '';
        this.producerSearchTerm = '';
        this.producerSearchResults = [];
    }


    handleSubmit(){
        const fields = {
            Id: this.recordId, 
            Name: this.Name, 
            Release_Date__c:this.Release_Date,
            Director_Email__c:this.Director_Email,
            Released_In_Theatres__c:this.Released_In_Theatres,
            Prequel__c: this.prequelId,
            Producer__c: this.producerId,
            Available_on_OTT__c: this.isAvailable

        };
    updateRecord({fields})
    .then(() => {
        // Show success toast
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated successfully!',
                variant: 'success'
            })
        );
    })
    .catch(error => {
        // Show error toast
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating record',
                message: error.body.message,
                variant: 'error'
            })
        );
    });

    }
}