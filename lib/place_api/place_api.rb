# frozen_string_literal: true

require 'yaml'
# require 'httparty'
require 'json'
require 'net/http'
# require 'uri'
require 'http'

require_relative 'store'
require_relative 'comment'

module CafeShop
  # Client Library for Github Web API
  class PlaceApi
    token_category = 'GOOGLE_MAP'
    name_of_key = "Place_api"

    def initialize(token)
      @place_token = token
    end

    def store(username, project_name)
      project_response = Request.new(REPOS_PATH, @place_token)
                                .repo(username, project_name).parse
      Project.new(project_response, self)
    end

    def contributors(contributors_url)
      contributors_data = Request.new(REPOS_PATH, @place_token)
                                 .get(contributors_url).parse
      contributors_data.map { |account_data| Contributor.new(account_data) }
    end

    # Sends out HTTP requests to Github
    class Request
      def initialize(resource_root, token)
        @resource_root = resource_root
        @token = token
      end

      def repo(username, project_name)
        get(@resource_root + [username, project_name].join('/'))
      end
      
      def call_placeapi_url(input)
        token = get_placeapi_token()
        HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")
     end
      
      def get(token_category,name_of_key)
        token = get_placeapi_token()
        HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")

        http_response = HTTP.headers(
          'Accept' => 'application/vnd.github.v3+json',
          'Authorization' => "token #{@token}"
        ).get(url)

        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end


    end

    # Decorates HTTP responses from Github with success/error reporting
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