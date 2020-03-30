# frozen_string_literal: true

require 'swagger_helper'
require_relative '../lib/locationiq/webmocks'

describe 'Geocode Api' do
  path '/v1/geocode/forward' do
    before do
      Webmocks.geocode_forward
    end

    # This currently generates invalid swagger config,
    # I'm having trouble debugging rswag so currently cleaning it manually
    get 'Gets lat and lon for location string' do
      let(:query) { 'Empire State Building' }
      let(:Authorization) { "Basic #{::Base64.strict_encode64("#{ENV['BASIC_AUTH_NAME']}:#{ENV['BASIC_AUTH_PASSWORD']}")}" }

      security [basic: []]
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
                 importance: { type: :number },
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

      response '404', 'can not find nonsense queries' do
        let(:query) { 'kajhfkajshdfkadshf' }
        run_test!
      end

      # I don't care what people ask for, I'm giving them JSON
      # We can utilize rails respond_to in the future
      #   if we want to be better web citizens
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
