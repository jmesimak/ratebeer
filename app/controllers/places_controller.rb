class PlacesController < ApplicationController
  def index
  end

  def search
    api_key = "693d14c1fb4ca1c2c7823571a697c5f3"
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"
    response = HTTParty.get "#{url}#{params[:city].gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    if places.is_a?(Hash) and places['id'].nil?
      redirect_to places_path, :notice => "No places in #{params[:city]}"
    else
      places = [places] if places.is_a?(Hash)
      @places = places.inject([]) do | set, location|
        set << Place.new(location)
      end
      render :index
    end
  end

end