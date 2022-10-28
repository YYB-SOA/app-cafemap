# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module PlaceInfo
  module Entity
    # Domain entity for stores
    class Store < Dry::Struct
      include Dry.Types

      attribute :place_id, Strict::String  # Coercible
      attribute :name, Strict::String
      attribute :formatted_address, Strict::String
      attribute :location_lat,  Strict::Float
      attribute :location_lng,  Strict::Float
      attribute :rating, Strict::Float
      attribute :user_ratings_total, Strict::Integer
    end
  end
end
