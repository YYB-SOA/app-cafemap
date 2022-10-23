# frozen_string_literal: true

require_relative 'issuer'

module AritcleInfo
  # Provides access to contributor data
  class Contents
    def initialize(content_data)
      @content = content_data
    end

    def status
      @content['status']
    end

    def title
      @content['article'][0]['title']
    end

    def author
      @auther ||= Issuer.new(@content['article'][0]['author'])
    end

    def description
      @content['article'][0]['description']
    end

    def publishedat
      @content['article'][0]['publishedAt']
    end
  end
end
