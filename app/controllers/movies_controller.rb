class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if !params[:sort].nil? 
      session[:sort] = params[:sort]
    end
      
    if !params[:ratings].nil? 
      session[:ratings] = params[:ratings]
    end
    
    if (!session[:sort].nil? && params[:sort].nil?) || (!session[:ratings].nil? && params[:ratings].nil?)
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
      return
    end
    
    if params[:ratings].nil?
      @ratings_to_show = @all_ratings
    else
      @ratings_to_show = params[:ratings].keys
      @ratings_sorted = @ratings_to_show.to_h{|rating| [rating, 1]}
    end
      
    @movies = Movie.with_ratings(@ratings_to_show)
      
    if !params[:sort].nil?
      @movies = @movies.order(params[:sort])
      if params[:sort] === 'title'
        @css_title = 'hilite'
      elsif params[:sort] === 'release_date'
        @css_rating = 'hilite'
      end
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
