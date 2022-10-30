# frozen_string_literal: false

require_relative '../gateways/cafe_api'
require_relative '../entities/info'

module CafeMap
  module CafeNomad
    class InfoMapper
      # tokename will be "Cafe_api"
      def initialize(tokename, gateway_class = CafeNomad::Api)
        @tokename = tokename
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@tokename)
      end

      def load_several
        @gateway.cafe_info.map do |each_store|
          InfoMapper.build_entity(each_store)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end
    end

    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        Entity::Info.new(
          id:,
          name:,
          city:,
          wifi:,
          seat:,
          quiet:,
          tasty:,
          cheap:,
          music:,
          url:,
          address:,
          latitude:,
          longitude:,
          limited_time:,
          socket:,
          standing_desk:,
          mrt:,
          open_time:
        )
      end

      private

      def id
        @data['id']
      end

      def name
        @data['name']
      end

      def city
        @data['city']
      end

      def wifi
        @data['wifi']
      end

      def seat
        @data['seat']
      end

      def quiet
        @data['quiet']
      end

      def tasty
        @data['tasty']
      end

      def cheap
        @data['cheap']
      end

      def music
        @data['music']
      end

      def url
        @data['url']
      end

      def address
        @data['address']
      end

      def latitude
        @data['latitude']
      end

      def longitude
        @data['longitude']
      end

      def limited_time
        @data['limited_time']
      end

      def socket
        @data['socket']
      end

      def standing_desk
        @data['standing_desk']
      end

      def mrt
        @data['mrt']
      end

      def open_time
        @data['open_time']
      end
    end
  end
end
# stores_data = CafeMap::CafeNomad::InfoMapper.new("Cafe_api").load_several
# puts stores_data[4].address