# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/locationiq/geocode.rb'

Rspec.describe Geocode do
  describe '#forward' do
    it 'gets geocode for query' do
      sleep 2
      expect Geocode.forward('Empire State Building')['lat'].to eq '40.7484284'
      expect Geocode.forward('Empire State Building')['lon'].to eq '-73.9856546198733'
    end

    # TODO: tests for 400s and 500s, different 200 queries. Use Webmock
  end
end
