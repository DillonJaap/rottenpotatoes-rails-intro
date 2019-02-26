class MoviesController < ApplicationController
	helper_method :hilite_class

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def hilite_class
	  if param[:sort] == @sorting_by
		  "hilite"
	  else
		 "nothilite" 
	  end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.ratings

	if params[:sort].nil?
		@sorting_by = "title"
	else
		@sorting_by = params[:sort] || session[:sort]
	end

	session[:ratings] = session[:ratings] || @all_ratings

	if params[:ratings].nil?
		@ratings_keys = @all_ratings.keys
	else
		@ratings_keys = params[:ratings] || session[:ratings]
	end


	session[:sort] = @sorting_by
	session[:ratings] = @ratings_keys
	@movies = Movie.where(rating: @ratings_keys).order("#{@sorting_by} ASC")

	if (params[:sort].nil? && !(session[:sort].nil?) ||
			params[:ratings].nil? && !(session[:ratings].nil?))
		flash.keep
		redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
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

end
