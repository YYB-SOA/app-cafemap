# frozen_string_literal: true

require_relative 'shop'

module CafeShop
  # Provides access to contributor data
  class Feedback
    # Model for Feedback
    def initialize(feedback_data, cafe_data)
      # data comes from placeap
      @feedback = feedback_data
      @cafe = cafe_data # ?我不知道能不能接另一個api的東西進來，架構上這樣是不是很怪
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

    # Teacher's code Idk????
    # def contributors
    #   @contributors ||= @data_source.contributors(@project['contributors_url'])
    # end
  end
end
