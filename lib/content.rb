# frozen_string_literal: true

require_relative 'issuer'

module AritcleInfo
  # Provides access to contributor data
  class Contents
    def initialize(content_data)
      @content = content_data
    end

    def title
      @content['title']
    end

    def auther
      @content['auther']
    end

    def description
      @content['description']
    end

    def publishedat
      @content['publishedAt']
    end
  end
end
