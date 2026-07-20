import { LightningElement, wire, track } from 'lwc';
import searchMovies from '@salesforce/apex/MovieSearchController.searchMovies';

export default class SearchMovies extends LightningElement {

    @track searchKey = '';  // Stores the input search key
    @track movies = [];  // Stores the search results
    @track error;  // For error handling

    // Watch for changes to the search key
    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;

        // Only search if the search key has a value
        if (this.searchKey) {
            this.searchMovies();
        } else {
            // Clear search results when the search key is empty
            this.movies = [];
        }
    }
    handleSearch() {
        // Only search if the search key has a value
        if (this.searchKey) {
            this.searchMovie();
        } else {
            // Clear search results when the search key is empty
            this.movies = [];
        }
    }

    // Call Apex method to fetch movie records based on the search key
        searchMovie() {
            searchMovies({ searchKey: this.searchKey })
               .then(result => {
                this.movies = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.movies = [];
            });
        }
    



}