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
      current_user.ratings << @rating
      flash[:notice] = 'Rating successfully created'
      session[:last_rating] = "#{Beer.find(params[:rating][:beer_id])} #{params[:rating][:score]} points"
      redirect_to user_path current_user
    else
      flash[:error] = 'Check the beer id!'
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete
    redirect_to :back
  end
end