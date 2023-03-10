# frozen_string_literal: true

# require_relative 'list_request'
require 'http'

module CafeMap
  module Gateway
    # Infrastructure to call CodePraise API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def projects_list(list)
        @request.projects_list(list)
      end

      def add_cafeinfo(city)
        @request.add_cafeinfo(city)
      end

      def get_cafeinfo(city)
        @request.get_cafeinfo(city)
      end


      def get_cluster(city)
        @request.get_cluster(city)
      end

      # Gets appraisal of a project folder rom API
      # - req: ProjectRequestPath
      #        with #owner_name, #project_name, #folder_name, #project_fullname
      def appraise(req)
        @request.get_appraisal(req)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def add_cafeinfo(city)
          # call_api('post', ["cafemap", "random_store"], 'city' => Base64.encode64(city))
          # call_api('post', ["cafemap", "random_store"], 'city' => 'Taipei')
          call_api('post', ["cafemap", "random_store"], 'city' => city)
        end

        def get_cafeinfo(city)
          call_api('get', ['cafemap'], 'city' => city)
        end

        def get_cluster(city)
          call_api('get', ['cafemap', "clusters"], 'city' => city)
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = 200..299

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
