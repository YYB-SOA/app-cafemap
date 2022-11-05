# frozen_string_literal: false

require_relative '../../infrastructure/gateways/cafe_api'
require_relative '../entities/info'

module CafeMap
  module CafeNomad
    class InfoMapper
      # tokename will be "Cafe_api"
      def initialize(cafe_token, gateway_class = CafeNomad::Api) # cafe_token should be a url from secrets.yml
        @cafe_token = cafe_token
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@cafe_token)
      end

      def load_several
        @gateway.info_data.map do |each_store|
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
          infoid:,
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

      def infoid
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
      
      # def storename
      #   @member_mapper.load_several(@data['contributors_url'])
      # end
    end
  end
end

test = CafeMap::CafeNomad::InfoMapper.new('https://cafenomad.tw/api/v1.2/cafes').load_several