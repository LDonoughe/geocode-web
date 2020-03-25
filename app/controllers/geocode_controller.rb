# frozen_string_literal: true

require_relative '../../lib/locationiq/geocode'

class GeocodeController < ApplicationController
  # could be more RESTful?
  def index
    query = filtered_params['query']
    if query.present?
      response = Geocode.forward(query)
      if response
        render json: { status: 200,
                       coordinates: response,
                       permanent_api_endpoint_location: 'v1/geocode/forward' }
      else
        # Error handling should go in /lib
        render json: { status: 500,
                       message: response.message,
                       permanent_api_endpoint_location: 'v1/geocode/forward' },
               status: 500
      end
    else
      render json: { status: 400,
                     message: 'no query provided',
                     permanent_api_endpoint_location: 'v1/geocode/forward' },
             status: 400
    end
  end

  def filtered_params
    params.permit(:query)
  end
end
