# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

require_relative 'status'

module CafeMap
  module Entity
    # Domain entity for any coding projects
    class Info < Dry::Struct
      include Dry.Types

      attribute :id,                  Coercible::String
      attribute :name,                Coercible::String
      attribute :city,                Coercible::String
      attribute :wifi,                Coercible::String
      attribute :seat,                Coercible::String
      attribute :quiet,               Coercible::String
      attribute :tasty,               Coercible::String
      attribute :cheap,               Coercible::String
      attribute :music,               Coercible::String
      attribute :url,                 Coercible::String
      attribute :address,             Coercible::String
      attribute :latitude,            Coercible::String
      attribute :longitude,           Coercible::String
      attribute :limited_time,        Coercible::String
      attribute :socket,              Coercible::String
      attribute :standing_desk,       Coercible::String
      attribute :mrt,                 Coercible::String
      attribute :open_time,           Coercible::String

      def to_attr_hash
        to_hash.except(:id) # except:remove keys from hash
      end
    end
  end
end
