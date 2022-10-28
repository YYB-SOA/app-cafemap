# frozen_string_literal: false

require_relative '../models//gateways/place_api'
require_relative '../models/entities/store'

module PlaceInfo
  # Provides access to contributor data
  module Place
    # Data Mapper: Place store -> store entity
    class StoreMapper
      def initialize(token_name, gateway_class = Place::PlaceApi)
        @token_name = token_name # @place_token ＝'Place_api'
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token_name)
      end

      def load_several
        @gateway.store(@token_name).map do |each_store|
          data = each_store['results'][0]
          StoreMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        # hash
        def initialize(data)
          @data = data
        end

        def build_entity
          PlaceInfo::Entity::Store.new(
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
          @data['place_id']
        end

        def name
          @data['name']
        end

        def formatted_address
          @data['formatted_address']
        end

        def location_lat
          @data['geometry']['location']['lat']
        end

        def location_lng
          @data['geometry']['location']['lng']
        end

        def rating
          @data['rating']
        end

        def user_ratings_total
          @data['user_ratings_total']
        end
      end
    end
  end
end
