# frozen_string_literal: true

module PlaceInfo
  # Provides access to Store Review data
  class Reviews
    def initialize(reviews_data)
      @reviews = reviews_data
    end

    def place_id
      @reviews['results'].map { |item|  item['place_id'] }
    end

    def address
      @reviews['results'].map { |item|  item['formatted_address'] }
    end

    def rating
      @reviews['results'].map { |item|  item['rating'] }
    end

    def user_ratings_total
      @reviews['results'].map { |item|  item['user_ratings_total'] }
    end
  end
end
