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

  def self.key
    "693d14c1fb4ca1c2c7823571a697c5f3"
  end
end