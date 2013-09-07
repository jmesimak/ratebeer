class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new(params[:rating])
    if @rating.valid?
      @rating.save
      flash[:notice] = 'Rating successfully created'
      redirect_to ratings_path
    else
      flash[:error] = 'Check the beer id!'
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete
    redirect_to ratings_path
  end
end