class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings].nil? && params[:sort].nil? && session[:ratings].nil? && session[:sort].nil?
      redirect_to movies_path('ratings' => Hash[Movie.with_ratings(@all_ratings.map{|rating|[rating,1]}.to_h).order(session[:sort])])
      return
    end
    
    if params[:ratings].nil?
      if session[:ratings].nil?
        @ratings_to_show = Array.new
      else
        @ratings_to_show = session[:ratings]
      end
    else
      @ratings_to_show = params[:ratings].keys
    end

    session[:ratings] = @ratings_to_show
    @all_ratings = Movie.all_ratings

    if params[:sort].nil?
      @sort = session[:sort]
      #redirect 
     else
      @sort = params[:sort]
    end
    session[:sort] = @sort
      
    if @sort === 'title'
      @css_title = 'hilite'
    elsif @sort === 'release_date'
      @css_rating = 'hilite'
    end
    
    @ratings_sorted = @ratings_to_show.map{|rating|[rating,1]}.to_h
    
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
    
    if params[:sort].nil?
      redirect_to movies_path('ratings' => Hash[@ratings_sorted], 'sort' => @sort)
      return
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
