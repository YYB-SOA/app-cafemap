# frozen_string_literal: false

require_relative '../../infrastructure/gateways/place_api.rb'
require_relative '../entities/store'


module CafeMap
  # Provides access to contributor data
  module Place
    # Data Mapper: Place store -> store entity
    class StoreMapper
      def initialize(token, store_list, gateway_class = Place::PlaceApi)
        @token = token
        @store_list = store_list
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token, @store_list)
      end

      def bad_request
        @gateway.store_data()[0]['status']
      end

      def load_several
        @gateway.store_data().map do |each_store|
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
          CafeMap::Entity::Store.new(
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
# token, store_list =  "AIzaSyDn1SNO-unHl8mSu2u3ZQ7dzfab4Y5bOZ0", ["ARTROOM14藝室"]
# puts token
# puts store_list
# obj = CafeMap::Place::StoreMapper.new(token, store_list).load_several

# p obj[0].place_id