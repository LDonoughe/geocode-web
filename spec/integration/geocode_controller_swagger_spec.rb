# frozen_string_literal: true

require 'swagger_helper'

describe 'Geocode Api' do
  path '/v1/geocode/forward' do
    before do
      sleep 2
    end

    get 'Gets lat and lon for location string' do
      let(:query) { 'Empire State Building' }
      let(:Authorization) { "Basic #{::Base64.strict_encode64('name:password')}" }

      security [ basic: [] ]
      tags 'Geocoding'
      produces 'application/json'
      parameter name: :query, in: :query, type: :string
      parameter name: :Authorization, in: :header, type: :string

      # { "place_id": '91421092', "osm_type": 'way', "osm_id": '34633854', "boundingbox": ['40.7479226', '40.7489422', '-73.9864855', '-73.9848259'], "lat": '40.7484284', "lon": '-73.9856546198733', "display_name": 'Empire State Building, 350, 5th Avenue, Korea Town, Manhattan, New York, New York County, New York, 10001, USA', "class": 'tourism', "type": 'attraction', "importance": 0.85158684668746, "icon": 'https://locationiq.org/static/images/mapicons/poi_point_of_interest.p.20.png', "status": 200, "permanent_api_endpoint_location": 'v1/geocode/forward' }

      response '200', 'location found' do
        schema type: :object,
               properties: {
                 lat: { type: :string },
                 lon: { type: :string },
                 place_id: { type: :string }, # could be int
                 osm_type: { type: :string },
                 osm_id: { type: :string }, # could be int
                 boundingbox: { type: :array, items: :string },
                 display_name: { type: :string }
                 # need to finish providing properties
               },
               required: %w[lat lon]

        run_test!
      end

      # see if this is possible
      response '400', 'must provide a query' do
        let(:query) { '' }
        run_test!
      end

      # I don't care what people ask for, I'm giving them JSON
      response '200', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end

      # so swagger shows a reasonable message
      response '200', 'success' do
        run_test!
      end
    end
  end
end
