# frozen_string_literal: true

require 'yaml'
require 'http'
require_relative 'cafefilter'

module PlaceInfo
  module Place
    # Library for Place API
    class PlaceApi
      def initialize(word_term, token_name)
        # word_term是指地址的keyword(例如新竹)
        @word_term = word_term
        @token_name = token_name # @place_token ＝'Place_api'
      end

      def store(word_term = @word_term, token_name = @token_name)
        Request.new(word_term, token_name).request_main # 傳入token
      end

      # Sends out HTTP requests to Google Place API
      class Request
        def initialize(word_term, token_name)
          @word_term = word_term
          @token_name = token_name # @token_name ＝'Place_api'
        end

        def get_placeapi_token(name_of_key = @token_name)
          config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
          config_yaml['GOOGLE_MAP'][0][name_of_key]
        end

        def call_placeapi_url(input, token)
          http_response =
            HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        def request_main(word_term = @word_term, name_of_key = @token_name)
          cafe_filter_array = PlaceInfo::CafeFilter.new.main(word_term) # mapper???????
          cafe_filter_str = cafe_filter_array[0]
          call_placeapi_url(cafe_filter_str, get_placeapi_token(name_of_key)).parse
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
end
