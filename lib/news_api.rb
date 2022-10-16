# frozen_string_literal: true

require 'http'
require_relative 'content'
require_relative 'issuer'

module AritcleInfo
  # Library for news API
  class NewsApi
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(name_of_key)
      @news_token = name_of_key
    end

    def news_api_path(_name_of_key = @news_token)
      config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
      key = config_yaml['api'][0][@news_token]
      "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{key}"
    end

    # data = call_news_url(news_api_path('news'))

    def call_news_url(url)
      # Url只能吃news_api_path url
      full = URI(url)
      res = Net::HTTP.get_response(full)
      output = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
      successful?(res) ? res : raise(HTTP_ERROR[res.code])
      output
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end

    def news_hash_generator(name_of_key = @news_token)
      call_news_url(news_api_path(name_of_key))
    end
  end
end
