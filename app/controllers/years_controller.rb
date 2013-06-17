class YearsController < ApplicationController
  
  def index
    @years = Movie.search(nil).facets['years']
  end
  
  def show
    @movies = Movie.search(params[:q], :year => params[:id], :page => params[:page])
  end

end
