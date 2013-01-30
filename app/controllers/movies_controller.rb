class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings # ['G','PG','PG-13','R']

		if params[:sort].nil? and session[:sort].nil?
	    @sort = "title"
	  elsif params[:sort].nil?
	    @sort = session[:sort]
		else
			@sort = params[:sort]
			session[:sort] = params[:sort]
		end

		if params[:ratings].nil? and session[:ratings].nil?
			@movies = Movie.all(:order => @sort)
		elsif params[:ratings].nil?
		  @movies = Movie.where(:rating => session[:ratings].keys).order(@sort)
		else
			@movies = Movie.where(:rating => params[:ratings].keys).order(@sort)
			session[:ratings] = params[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    session[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    session[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    session[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
