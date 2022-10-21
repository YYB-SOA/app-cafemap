# frozen_string_literal: true

require 'yaml'
require 'json'
require 'net/http'
require 'http'

require_relative 'store'
require_relative 'reviews'

module CafeShop
  # Library for Place API
  class PlaceApi
    token_category = 'GOOGLE_MAP' # rubocop:disable Lint/UselessAssignment
    name_of_key = 'Place_api' # rubocop:disable Lint/UselessAssignment

    def initialize(token)
      @place_token = token
    end

    def reviews(address)
      data = call_placeapi_url(address).parse
      Reviews.new(data)
    end

    def store(store_yaml)
      Store.new(store_yaml)
    end

    # def store(username, project_name)
    #   project_response = Request.new(REPOS_PATH, @place_token)
    #                             .repo(username, project_name).parse
    #   Project.new(project_response, self)
    # end

    # Sends out HTTP requests to Google Place API
    class Request
      def initialize(token)
        @token = token
      end

      def get_placeapi_token(token_category, name_of_key)
        config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
        config_yaml[token_category][0][name_of_key]
      end

      def call_placeapi_url(input)
        token = get_placeapi_token
        result =
          HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")

        Response.new(result).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end

    # Decorates HTTP responses  with success/error reporting
    class Response < SimpleDelegator
      Unauthorized = Class.new(StandardError)
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        401 => Unauthorized,
        404 => NotFound
      }.freeze

      def successful?
        HTTP_ERROR.keys.none?(code)
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
