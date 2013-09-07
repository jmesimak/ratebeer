class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
  end

  def create
    #debugger
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
end