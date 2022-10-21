# frozen_string_literal: true

module CafeShop
  # Provides access to contributor data
  class Comment
    def initialize(issuer_data)
      @issuer = issuer_data
    end

    def author
      @issuer['article']['author']
    end

    def source_id
      @issuer['article'][0]['source']['id']
    end

    def source_name
      @issuer['article'][0]['source']['name']
    end
  end
end
