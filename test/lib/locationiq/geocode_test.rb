# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../../lib/locationiq/geocode.rb'

class TestGeocode < MiniTest::Test
  describe '#forward' do
    it 'gets geocode for query' do
      assert_equal Geocode.forward('Empire State Building'), ['40.7484284', '-73.9856546198733']
    end

    # TODO: tests for 400s and 500s, different 200 queries. Use Webmock
  end
end