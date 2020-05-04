# frozen_string_literal: true

# Abstracting the locationiq logic here.
# If we decide to switch to a different provider, we can implement the same
#   method with that provider and keep our controller the same.
class Geocode
  def self.forward(query)
    response = HTTP.get(url(query))
    body = JSON.parse(response.body.to_s)
    if body.is_a?(Hash) && body['error']
      return { status: 404, message: 'No Results Found' }
    end

    body = body[0]
    if body && body['lat']
      body
    else
      { status: response.status, message: response.reason }
    end
  rescue JSON::ParserError
    { status: 500, message: 'Could not parse response' }
  rescue StandardError => e
    status = e.message == 'Too Many Requests' ? 429 : 500
    { status: status, message: e.message }
  end

  private

  def self.url(query)
    "https://us1.locationiq.com/v1/search.php?key=#{ENV['LOCATIONIQ_KEY']}&q=#{query}&format=json"
  end
end
