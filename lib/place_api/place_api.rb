# frozen_string_literal: true

require 'yaml'
# require 'httparty'
require 'json'
require 'net/http'
# require 'uri'
require 'http'

require_relative 'shop'
require_relative 'feedback'

module CafeShop
  # Client Library for Github Web API
  class PlaceApi
    token_category = 'GOOGLE_MAP'
    name_of_key = "Place_api"

    def initialize(place_token, )
      @place_token = token
      
    end

    def feedback(username, project_name)
      # 目標拿到place_api response
      feedback_response = Request.new(REPOS_PATH, @place_token)
                                .repo(username, project_name).parse
      Feedback.new(feedback_response, self)
    end

    def read_cafe(path = 'lib/sample/cafe_nomad*.json')
      data_hash = JSON.parse(File.read(path))
      data_hash
    end
    
    def location_filter(input, attribute, word_term)
      # input.map!{|item|  item * (item[attribute].include? word_term)}
      abc = input.select!{|item|  item[attribute].include? word_term}
      abc
    end
    
    def read_cafe_attribute(data_hash, attribute = nil)
        box = []
        if attribute.nil?
            box = data_hash
            puts "Condition 1 #{puts data_hash}"
        else
            data_hash.select {|ele| box << ele[attribute] }
        end
        return box
    end
    
    def get_placeapi_token(token_category = 'GOOGLE_MAP', name_of_key = "Place_api")
        config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
        config_yaml[token_category][0][name_of_key]
    end
    
    
    def call_placeapi_url(input)
      token = get_placeapi_token()
      HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")
    end
    
    
    def noise_filter(name_str)
        # Normalization
        name_str.gsub('暫停營業', '').gsub('()', '').gsub(' ', '').gsub("\b", "")    
    end
    
    
    def data_clean(box)
        # Input: string array of cafe name
        box.map{ |name_str| noise_filter(name_str)}
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