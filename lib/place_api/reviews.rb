# frozen_string_literal: true

module PlaceInfo
  # Provides access to Store Review data
  class Review
    def initialize(reviews_data)
      @reviews = reviews_data
    end

    def place_id
      @reviews['results']['place_id']
    end

    def address
      @reviews['results']['formatted_address']
    end

    def rating
      @reviews['results']['rating']
    end

    def user_ratings_total
      @reviews['results']['user_ratings_total']
    end
  end
end
