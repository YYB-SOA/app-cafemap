# frozen_string_literal: false

require_relative ''

module PlaceInfo
  # Provides access to contributor data
  module Place
    # Data Mapper: Place store -> store entity
    class StoreMapper
      def initialize(word_term, token_name, gateway_class = Place::PlaceApi)
        @word_term = word_term   # word_term是指地址的keyword(例如新竹)
        @token_name = token_name # @place_token ＝'Place_api'
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@word_term, @token_name)
      end

      def load_several(word_term = @word_term, token_name = @token_name)
        @gateway.store(word_term, token_name).map do |data|
          MemberMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Store.new(
            place_id:,
            name:,
            formatted_address:,
            location_lat:,
            location_lng:,
            rating:,
            user_ratings_total:
          )
        end

        private

        def place_id
          @data['results'][0]['place_id']
        end

        def name
          @data['results'][0]['name']
        end

        def formatted_address
          @data['results'][0]['formatted_address']
        end

        def location_lat
          @data['results'][0]['geometry']['location']['lat']
        end

        def location_lng
          @data['results'][0]['geometry']['location']['lng']
        end

        def rating
          @data['results'][0]['rating']
        end

        def user_ratings_total
          @data['results'][0]['user_ratings_total']
        end
      end
    end
  end
end
