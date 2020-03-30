# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/locationiq/geocode.rb'
require_relative 'webmocks'

RSpec.describe Geocode do
  describe '#forward' do
    before do
      Webmocks.geocode_forward
    end

    it 'gets geocode for query' do
      response = Geocode.forward('Empire State Building')
      expect(response['lat']).to eq '40.7484284'
      expect(response['lon']).to eq '-73.9856546198733'
    end

    it 'gets geocode for stated query' do
      response = Geocode.forward('Checkpoint Charlie')
      expect(response['lat']).to eq '52.5075075'
      expect(response['lon']).to eq '13.3903737'
    end

    it 'handles 500s' do
      response = Geocode.forward('500')
      expect(response[:status]).to eq 500
    end

    it 'handles 429s' do
      response = Geocode.forward('429')
      expect(response[:status]).to eq 429
      expect(response[:message]).to eq 'Too Many Requests'
    end
  end
end
