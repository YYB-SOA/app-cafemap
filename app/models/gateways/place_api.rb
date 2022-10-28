# frozen_string_literal: true

require 'yaml'
require 'http'

module PlaceInfo
  module Place
    # Library for Place API
    class PlaceApi
      def initialize(token_name)
        @token_name = token_name # @place_token ＝'Place_api'
      end

      def store(token_name = @token_name)
        Request.new(token_name).request_main # Array
      end

      # Sends out HTTP requests to Google Place API
      class Request
        def initialize(token_name)
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

        def noise_filter(name_str)
          # Normalization
          name_str.gsub('()', '').gsub(' ', '').gsub("\b", '')
        end

        def data_clean(box)
          # Input: string array of cafe name
          box.map { |name_str| noise_filter(name_str) }
        end

        def request_main(name_of_key = @token_name, name_array = ["WHO'S 喜象 CAFE", 'ARTROOM14藝室'])
          # PlaceInfo::CafeFilter.new.main(word_term) # mapper
          cafe_clean_name = data_clean(name_array)
          cafe_clean_name.map do |eachstore|
            call_placeapi_url(eachstore, get_placeapi_token(name_of_key)).parse
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
end
