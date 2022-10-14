# frozen_string_literal: true

module Aritcle_info
  # Provides access to contributor data
  class Publisher
    def initialize(issuer_data)
      @issuer = issuer_data
    end

    def author
      @issuer['author']
    end

    def source_id
      @issuer['source']['id']
    end


    def source_id
      @issuer['source']['name']
    end

  end
end