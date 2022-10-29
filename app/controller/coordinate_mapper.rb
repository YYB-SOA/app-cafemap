# frozen_string_literal: false

require_relative '../models/gateways/cafe_api'
# require_relative 'status_mapper'
require_relative '../models/mappers/info_mapper'

module CafeMap
  # Provides access to contributor data
  module StorenameMapper
    class DataInput # rubocop:disable Style/Documentation
      # Get the store name array inside
      def initialize(wordterm)
        @wordterm = wordterm
      end

      attr_reader :wordterm

      def nomad
        CafeMap::CafeNomad::InfoMapper.new('Cafe_api').load_several
      end
    end

    class DataOutput # rubocop:disable Style/Documentation
      def initialize(wordterm)
        @nomad_obj = CafeMap::StorenameMapper::DataInput.new(wordterm).nomad
        @user_wordterm = CafeMap::StorenameMapper::DataInput.new(wordterm).wordterm
      end

      def filtered_store
        store_array = @nomad_obj.select { |obj| obj.address.include? @user_wordterm }.map(&:name)
        store_array.empty? ? "Warming: It's not ligit word term." : store_array
      end
    end
  end
end
