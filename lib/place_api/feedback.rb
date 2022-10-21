# frozen_string_literal: true

module CafeShop
  # Provides access to contributor data
  class Feedback
    def initialize(feedback_data)
      # data comes from placeap
      @feedback = feedback_data
    end

    def name
      @feedback['result']['name']
    end

    def rating
      @feedback['result']['rating']
    end

    def user_ratings_total
      @feedback['result']['user_ratings_total']
    end
  end
end
