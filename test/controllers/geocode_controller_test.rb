# frozen_string_literal: true

require 'test_helper'
require 'minitest/autorun'

class GeocodeControllerTest < ActionDispatch::IntegrationTest
  # GeocodeController#index
  test 'gets result for query' do
    get '/?query=Empire%20State%20Building'
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal json['status'].to_i, 200
    assert_equal json['lat'], '40.7484284'
    assert_equal json['lon'], '-73.9856546198733'
  end

  test 'gets result for given example' do
    sleep 2 # avoid 429s
    get '/?query=Checkpoint%20Charlie'
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal json['status'].to_i, 200
    # These vary slightly from the pdf but I'm trusting LocationIQ here
    assert_equal json['lat'], '52.5075075'
    assert_equal json['lon'], '13.3903737'
  end

  test 'returns 400 without a query' do
    sleep 2 # avoid 429s
    get '/'
    assert_response 400
    json = JSON.parse(response.body)
    assert_equal json['status'].to_i, 400
    assert_equal json['message'], 'no query provided'
  end

  test 'returns 400 with empty query' do
    sleep 2 # avoid 429s
    get '/?query='
    assert_response 400
    json = JSON.parse(response.body)
    assert_equal json['status'].to_i, 400
    assert_equal json['message'], 'no query provided'
  end

  # TODO: tests for 500s, other 400s, and different 200 queries. Use Webmock
end
