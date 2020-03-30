# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require_relative '../../app/controllers/geocode_controller'
require_relative '../lib/locationiq/webmocks'

describe GeocodeController do
  describe '#index' do
    let(:credentials) { ActionController::HttpAuthentication::Basic.encode_credentials ENV['BASIC_AUTH_NAME'], ENV['BASIC_AUTH_PASSWORD'] }

    before do
      Webmocks.geocode_forward
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

    it 'returns 404 with nonsense query' do
      get '/?query=kajhfkajshdfkadshf', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 404
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 404
      expect(json['message']).to eq 'No Results Found'
    end

    context 'when authorization is invalid' do
      let(:credentials) { ActionController::HttpAuthentication::Basic.encode_credentials 'admin', 'admin' }

      it 'returns 401 without valid authorization' do
        get '/?query=', headers: { 'HTTP_AUTHORIZATION': credentials }
        assert_response 401
        expect(response.body =~ /HTTP Basic: Access denied./).to_not eq false
      end
    end

    it 'returns 500 when 500' do
      get '/?query=500', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 500
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 500
      expect(json['message']).to eq 'Internal Server Error'
    end

    it 'returns 500 when we can not parse response' do
      get '/?query=no%20parse', headers: { 'HTTP_AUTHORIZATION': credentials }
      assert_response 500
      json = JSON.parse(response.body)
      expect(json['status'].to_i).to eq 500
      expect(json['message']).to eq 'Could not parse response'
    end
  end
end
