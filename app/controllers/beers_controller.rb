class BeersController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index, :show, :list]
  # GET /beers
  # GET /beers.json
  def index
    @beers = Beer.all
    @order = params[:order] || 'name'

    @beers = Beer.all(:include => [:brewery, :style]).sort_by{ |b| b.send(@order) }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @beers, :methods => [ :brewery, :style ] }
    end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @beer = Beer.find(params[:id])
    @rating = Rating.new
    @rating.beer = @beer

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beer }
    end
  end

  # GET /beers/new
  # GET /beers/new.json
  def new
    @beer = Beer.new
    @breweries = Brewery.all
    @styles = Style.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beer }
    end
  end

  def list

  end

  # GET /beers/1/edit
  def edit
    @beer = Beer.find(params[:id])
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(params[:beer])
    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }

      if @beer.save
        redirect_to beers_path
      else
        format.html { render action: "new" }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
  end

  # PUT /beers/1
  # PUT /beers/1.json
  def update
    @beer = Beer.find(params[:id])
    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }
    respond_to do |format|
      if @beer.update_attributes(params[:beer])
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer = Beer.find(params[:id])
    @beer.destroy

    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }
  end
end
