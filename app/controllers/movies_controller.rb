class MoviesController < ApplicationController
	helper_method :hilite_class

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def hilite_class
	  if param[:sort] == @sort
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

		@sort = params[:sort] || session[:sort]

	session[:ratings] = session[:ratings] || {'G'=>'','PG'=>'','PG-13'=>'','R'=>''}

	@t_param = params[:ratings] || session[:ratings]


	session[:sort] = @sort
	session[:ratings] = @t_param
	@movies = Movie.where(rating: session[:ratings].keys).order("#{@sort} ASC")

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
