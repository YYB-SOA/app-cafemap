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

    def news_api_path(token_category = 'NEWS_API', name_of_key = @news_token)
      config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
      token = config_yaml[token_category][0][name_of_key]
      news_url_concat(token)
    end

    def news_url_concat(token)
      "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{token}"
    end

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

    def news_hash_generator(token_category = 'NEWS_API', name_of_key = @news_token)
      call_news_url(news_api_path(token_category, name_of_key))
    end
  end
end
