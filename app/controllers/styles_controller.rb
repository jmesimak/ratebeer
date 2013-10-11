class StylesController < ApplicationController

  def index
    @styles = Style.all
  end

  def show
    @style = Style.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @style }
    end
  end
end

