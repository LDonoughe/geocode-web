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
    assert_equal json['coordinates'], ['40.7484284', '-73.9856546198733']
  end

  test 'returns 400 without a query' do
    get '/'
    assert_response 400
    json = JSON.parse(response.body)
    assert_equal json['status'].to_i, 400
    assert_equal json['message'], 'no query provided'
  end

  # TODO: tests for 500s, other 400s, and different 200 queries. Use Webmock
end
