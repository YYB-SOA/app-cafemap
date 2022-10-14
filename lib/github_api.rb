# frozen_string_literal: true

require 'http'
require_relative 'content'
require_relative 'audience'

module Aritcle_info
  # Library for Github Web API
  class NewsApi
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @gh_token = token
    end

    def project(username, project_name)
      project_req_url = gh_api_path([username, project_name].join('/'))
      full_url = news_api_path(key)
      project_data = call_news_url(project_req_url).parse
      Project.new(project_data, self)
    end

    def contributors(contributors_url)
      contributors_data = call_gh_url(contributors_url).parse
      contributors_data.map { |account_data| Contributor.new(account_data) }
    end


    def news_api_path( name_of_key)
        config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
        key =config_yaml['api'][0]['News']
        "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{key}"
    end


    def call_news_url(url)
        full = URI(url) 
        res = Net::HTTP.get_response(full)
        res.body if res.is_a?(Net::HTTPSuccess)

        successful?(res) ? res : raise(HTTP_ERROR[res.code])
    end


    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end