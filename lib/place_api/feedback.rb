# frozen_string_literal: true

module CafeShop
  # Provides access to contributor data
  class Feedback
    def initialize(feedback_data)
      @feedback = feedback_data
    end

    def author
      @feedback['article']['author']
    end

    def source_id
      @feedback['article'][0]['source']['id']
    end

    def source_name
      @feedback['article'][0]['source']['name']
    end
  end
end
