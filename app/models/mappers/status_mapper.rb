# frozen_string_literal: false

require_relative 'info_mapper'

module CafeMap
  module CafeNomad
    class StatusMapper
      def initialize(token, gateway_class = CafeNomad::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@token) # will be a json array.
      end

      def find
        data = @gateway.cafe_status
        StatusMapper.build_entity(data)
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
        CafeMap::Entity::Status.new(
          status:,
          amount:,
          header:
        )
      end

      def status
        @data['status']
      end

      def amount
        @data['amount']
      end

      def header
        @datap['header']
      end
    end
  end
end

a = CafeMap::CafeNomad::StatusMapper.new()