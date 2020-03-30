# frozen_string_literal: true

require 'spec_helper'

class Webmocks
  def self.geocode_forward
    WebMock.stub_request(:get, "https://us1.locationiq.com/v1/search.php?format=json&key=#{ENV['LOCATIONIQ_KEY']}&q=Empire%20State%20Building")
           .to_return(status: 200, body: ' [{ "lat":"40.7484284","lon":"-73.9856546198733" }]', headers: {})
    WebMock.stub_request(:get, "https://us1.locationiq.com/v1/search.php?format=json&key=#{ENV['LOCATIONIQ_KEY']}&q=Checkpoint%20Charlie")
           .to_return(status: 200, body: ' [{ "lat":"52.5075075","lon":"13.3903737" }]', headers: {})
    WebMock.stub_request(:get, "https://us1.locationiq.com/v1/search.php?format=json&key=#{ENV['LOCATIONIQ_KEY']}&q=no%20parse")
           .to_return(status: 500, body: 'unparsable response', headers: {})
    WebMock.stub_request(:get, "https://us1.locationiq.com/v1/search.php?format=json&key=#{ENV['LOCATIONIQ_KEY']}&q=500")
           .to_return(status: 500, body: '[{"error": "error"}]', headers: {})
    WebMock.stub_request(:get, "https://us1.locationiq.com/v1/search.php?format=json&key=#{ENV['LOCATIONIQ_KEY']}&q=429")
           .to_return(status: 429, exception: 'Too Many Requests', headers: {})
  end
end
