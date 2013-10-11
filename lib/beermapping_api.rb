class BeermappingAPI
  include Enumerable
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

    Rails.cache.fetch("#{city.gsub(' ', '%20')}", :expires_in => 1.hour) do
      response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    end

    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_place(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    second_url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response_score = HTTParty.get second_url
    place_score = response_score.parsed_response["bmp_locations"]["location"]
    return Place.new(name: place["name"], blogmap: place["blogmap"], zip: place["zip"], city: place["city"], street: place["street"], overall: place_score["overall"], selection: place_score["selection"], service: place_score["service"], atmosphere: place_score["atmosphere"], food: place_score["food"], reviewcount: place_score["reviewcount"], fbscore: place_score["fscore"], fbcount: place_score["fbcount"])
  end

  def self.key
    Settings.beermapping_apikey
  end
end