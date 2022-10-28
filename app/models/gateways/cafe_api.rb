# frozen_string_literal: true

require 'net/http'
require "yaml"
require "json"

module CafeMap
  module CafeNomad
    class Api
      # Take the tokem to get the api. should be "Cafe_api" here.
      def initialize(tokename)
        @tokename = tokename
        @cafenomaf_api = Request.new(@tokename).get # return will be jason array.
      end
      def cafe_status
        CafeYaml.new(@cafenomaf_api).jsonarray_to_ymal
      end

      def cafe_info
        @cafenomaf_api
      end
    end

    class Request    
      # should be 'Cafe_api'
      def initialize(tokename)
        @tokename = tokename
        @token_category = 'CAFE_NOMAD'
        @config = YAML.safe_load(File.read('config/secrets.yml'))
        @full_url = @config[@token_category][0][@tokename] # total url
      end

      def get(url = @full_url)
        uri = URI.parse(url)
        req = Net::HTTP::Get.new(uri.request_uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        res = https.request(req)
        @cafe_json = JSON.parse(res.body) # feel like should be parsed to json(or hash) in Mapper?
        @cafe_json
      end
    end

    class CafeYaml
      # 這邊丟進來的東西應該要是一個 json array
      def initialize(data)
        @data = data
      end
      def jsonarray_to_ymal()
        @store = {}
        @store['status'] = 'ok' unless @data.nil?
        @store['amount'] = @data.length
        @store['header'] = @data[0].keys
        @data.each do |each_store|
          cafe_name = "#{each_store['name']}{#{each_store['id'].split('-')[0]}"
          @store[cafe_name] = each_store
        end
        @store
      end
    end
  end
end
