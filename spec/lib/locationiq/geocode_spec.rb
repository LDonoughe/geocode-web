# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/locationiq/geocode.rb'

RSpec.describe Geocode do
  describe '#forward' do
    it 'gets geocode for query' do
      sleep 2
      # binding.pry
      response = Geocode.forward('Empire State Building')
      expect(response['lat']).to eq '40.7484284'
      expect(response['lon']).to eq '-73.9856546198733'
    end

    # TODO: tests for 400s and 500s, different 200 queries. Use Webmock
  end
end
