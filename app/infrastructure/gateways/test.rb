# frozen_string_literal: true

require 'net/http'
# require 'yaml'
require 'json'

module CafeMap
  module CafeNomad
    class Api # rubocop:disable Style/Documentation
      def initialize(cafe_token)
        # Take the token to get the api. should  be the "real token of Cafe_api"
        @cafe_token = cafe_token
      end

      def status_data
        jarray_temp = Request.new(@cafe_token).get # get jarray
        Api.jarray_to_yml(jarray_temp)
      end

      def nomad_data
        Request.new(@cafe_token).get
      end

      def self.jarray_to_yml(jarray)
        store = {}
        store['status'] = 'ok' unless jarray.nil?
        store['amount'] = jarray.length
        store['header'] = jarray[0].keys

        jarray.each do |each_store|
          cafe_name = "#{each_store['name']}{#{each_store['id'].split('-')[0]}"
          store[cafe_name] = each_store
        end
        store
      end
    end

    class Request # rubocop:disable Style/Documentation
      def initialize(cafe_token)
        @cafe_token = cafe_token
      end

      def get
        uri = URI.parse(@cafe_token)
        req = Net::HTTP::Get.new(uri.request_uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        res = https.request(req)
        JSON.parse(res.body)
      end
    end

    # class Response < SimpleDelegator
    #   Unauthorized = Class.new(StandardError)
    #   NotFound = Class.new(StandardError)

    #   HTTP_ERROR = {
    #     401 => Unauthorized,
    #     404 => NotFound
    #   }.freeze

    #   def successful?
    #     HTTP_ERROR.keys.none?(code)
    #   end

    #   def error
    #     HTTP_ERROR[code]
    #   end
    # end
  end
end

token = 'https://cafenomad.tw/api/v1.2/cafes'
a = CafeMap::CafeNomad::Api.new(token)
puts a.nomad_data[0]