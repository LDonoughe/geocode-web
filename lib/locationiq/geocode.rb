# frozen_string_literal: true

class Geocode
  def self.forward(query)
    url = "https://us1.locationiq.com/v1/search.php?key=#{ENV['LOCATIONIQ_KEY']}&q=#{query}&format=json"
    # these try blocks could be combined but the errors arise from different lines of code
    begin
      response = HTTP.get(url)
    rescue StandardError => e
      status = e.message == 'Too Many Requests' ? 429 : 500
      return { status: status, message: e.message }
    end
    begin
      body = JSON.parse(response.to_s)[0]
    rescue JSON::ParserError
      return { status: 500, message: 'Could not parse response' }
    end
    if body && body['lat']
      body
    else
      { status: response.status, message: response.reason }
    end
  end
end
