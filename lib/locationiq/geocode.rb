# frozen_string_literal: true

class Geocode
  def self.forward(query)
    url = "https://us1.locationiq.com/v1/search.php?key=#{ENV['LOCATIONIQ_KEY']}&q=#{query}&format=json"
    response = HTTP.get(url)
    body = JSON.parse(response.to_s)[0]
    [body['lat'], body['lon']]
  end
end
