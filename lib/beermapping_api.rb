class BeermappingAPI
  def self.places_in city
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"

    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    return places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    Rails.cache.fetch("#{url}#{city.gsub(' ', '%20')}", :expires_in => 1.hour) do
      response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    end

    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.key
    Settings.beermapping_apikey
  end
end