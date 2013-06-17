class MoviesController < ApplicationController
  
  def index
    if defined?(ThinkingSphinx)
      if params[:q].present?
        @movies = Movie.search(params[:q])
      else
        @movies = Movie.order(:title, :episode)
      end
      @movies = @movies.page(params[:page]).per(Movie::PER_PAGE)
    elsif defined?(Tire)
      @movies = Movie.search(params[:q], :page => params[:page])
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end
  
end
