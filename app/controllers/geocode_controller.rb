# frozen_string_literal: true

require_relative '../../lib/locationiq/geocode'

class GeocodeController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: ENV['BASIC_AUTH_NAME'], password: ENV['BASIC_AUTH_PASSWORD']

  # could be more RESTful?
  def index
    query = filtered_params['query']
    if query.present?
      response = Geocode.forward(query)
      if response && !response[:message]
        response.delete('license')
        response['status'] = 200
        response['permanent_api_endpoint_location'] = 'v1/geocode/forward'
        render json: response
      else
        # Error messages are parsed from the response object in lib/locationiq/geocode.rb
        message = get_message(response)
        render json: { status: 500,
                       message: message,
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

  private

  def get_message(response)
    if response.respond_to? :message
      response.message
    elsif response[:message]
      response[:message]
    elsif response[:error]
      response[:error]
    elsif response.respond_to? :error
      response.error
    elsif response.respond_to? :body
      response.body
    else
      'unknown error'
    end
  end

  def filtered_params
    params.permit(:query)
  end
end
