# frozen_string_literal: true

require 'swagger_helper'

describe 'Geocode Api' do
  path '/v1/geocode/forward' do
    before do
      sleep 1
    end

    get 'Gets lat and lon for location string' do
      let(:query) { 'Empire State Building' }
      let(:Authorization) { "Basic #{::Base64.strict_encode64('name:password')}" }

      security [ basic: [] ]
      tags 'Geocoding'
      produces 'application/json'
      parameter name: :query, in: :query, type: :string, required: true
      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'location found' do
        schema type: :object,
               properties: {
                 lat: { type: :string },
                 lon: { type: :string },
                 place_id: { type: :string }, # could be int
                 osm_type: { type: :string },
                 osm_id: { type: :string }, # could be int
                 boundingbox: { type: :array, items: :string },
                 display_name: { type: :string },
                 class: { type: :string }, 
                 type: { type: :string }, 
                 importance: {type: :number }, 
                 icon: { type: :string }, 
                 status: { type: :integer }, 
                 permanent_api_endpoint_location: { type: :string }
               },
               required: %w[lat lon]

        run_test!
      end

      response '400', 'must provide a query' do
        let(:query) { '' }
        run_test!
      end

      response '401', 'must pass basic auth' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('admin:admin')}" }
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
