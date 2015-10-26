class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  
  def self.find_in_tmdb(search_terms)
    movie_results = Tmdb::Movie.find(search_terms)

    movies=[]
    movie_results.each do |movie|
      movies << {:tmdb_id => movie.id ,:title =>  movie.title,
        :rating => "PG-13",:release_date => movie.release_date }
    end
    return movies
    #rescue NoMethodError => tmdb_gem_exception
     # if Tmdb::Api.response['code']=='401'
      #  raise Movie::InvalidKeyError,'Invalid Api Key'
    #  else
     #   raise tmdb_gem_exception
     # end
  end
  
  def self.create_from_tmdb(id)
    movie_search=Tmdb::Movie.detail(id)
    selected_movie={:title => movie_search["title"], :rating => "PG-13", :description => movie_search["overview"], :release_date => movie_search["release_date"]}
    Movie.create!(selected_movie)
  end  

end
