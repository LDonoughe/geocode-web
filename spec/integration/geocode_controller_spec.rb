# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require_relative '../../app/controllers/geocode_controller'

describe GeocodeController do
  describe '#index' do
    let(:credentials) { ActionController::HttpAuthentication::Basic.encode_credentials 'name', 'password' }

    before do
      sleep 1 # avoid 429s until we use webmock instead
    end

    it 'gets result for query' do
      get '/?query=Empire%20State%20Building', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 200
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 200
      expect(json['lat']).to eq '40.7484284'
      expect(json['lon']).to eq '-73.9856546198733'
    end

    it 'gets result for given example' do
      get '/?query=Checkpoint%20Charlie', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 200
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 200
      # These vary slightly from the pdf but I'm trusting LocationIQ here
      expect(json['lat']).to eq '52.5075075'
      expect(json['lon']).to eq '13.3903737'
    end

    it 'returns 400 without a query' do
      get '/', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 400
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 400
      expect(json['message']).to eq 'no query provided'
    end

    it 'returns 400 with empty query' do
      get '/?query=', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 400
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 400
      expect(json['message']).to eq 'no query provided'
    end
  end

  # TODO: tests for 500s, other 400s, and different 200 queries. Use Webmock
end
