# frozen_string_literal: true

module AritcleInfo
  # Provides access to contributor data
  class Issuer
    def initialize(issuer_data)
      @issuer = issuer_data
    end

    def author
      @issuer['author']
    end

    def source_id
      @issuer['source']['id']
    end

    def source_name
      @issuer['source']['name']
    end
  end
end
