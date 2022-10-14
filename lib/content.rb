# frozen_string_literal: true

require_relative 'Publisher'

module Aritcle_info
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

    def publishedAt
      @content['publishedAt']
    end
  end
end
