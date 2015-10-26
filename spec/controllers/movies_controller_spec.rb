require 'spec_helper'
require 'rails_helper'

describe MoviesController do
    describe 'searching TMDb' do
        it 'should call the model method that performs TMDb search' do
            fake_results=[double('movie1'), double('movie2')]
            expect(Movie).to receive(:find_in_tmdb).with('Ted').
                and_return(fake_results)
            post :search_tmdb, {:search_terms => 'Ted'}
        end
        it 'should select the Search Results template for rendering' do
            fake_results = [double('Movie'), double('Movie')]
            allow(Movie).to.receive(:find_in_tmdb).and_return(fake_results)
            post :search_tmdb, {:search_terms => 'Ted'}
            expect(response).to render_template('search_tmdb')
        end
        it 'should make the TMDb search results available to that template' do
            fake_results = [double('Movie'), double('Movie')]
            allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
            post :search_tmdb, {:search_terms => 'hardware'}
            # look for controller method to assign @movies
            expect(assigns(:movies)).to eq fake_results
        end
        it 'should return to the main screen if no results are found' do
            fake_results = [double('Movie'), double('Movie')]
            post :search_tmdb, {:search_terms => 'fefe'}
            expect(response).to render_template('movies')
        end
        it 'should return to the main screen if nothing is entered into the search' do
            fake_results = [double('Movie'), double('Movie')]
            post :search_tmdb, {:search_terms => ' '}
            expect(response).to render_template('movies')
        end
    end
end