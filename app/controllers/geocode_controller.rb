# frozen_string_literal: true

require_relative '../../lib/locationiq/geocode'

class GeocodeController < ApplicationController
  # could be more RESTful
  def index
    query = filtered_params['query']
    if query.present?
      response = Geocode.forward(query)
      if response
        render json: { status: 200, coordinates: response }
      else
        # Error handling should probably go in /lib
        { status: 500, message: 'no response from api' }
      end
    else
      render json: { status: 400, message: 'no query provided' }, status: 400
    end
  end

  def filtered_params
    params.permit(:query)
  end
end
