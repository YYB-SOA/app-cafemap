# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

require_relative 'status'

module CafeMap
  module Entity
    # Domain entity for any coding projects
    class Info < Dry::Struct
      include Dry.Types

      attribute :id,          Strict::String
      attribute :name,        Strict::String
      attribute :city,        Strict::String
      attribute :wifi,        Strict::Integer
      attribute :seat,        Strict::Integer
      attribute :quiet,       Strict::Integer
      attribute :tasty,       Strict::Integer
      attribute :cheap,       Strict::Integer
      attribute :music,       Strict::Integer
      attribute :url,         Strict::String
      attribute :address,     Strict::String
      attribute :latitude,            Integer
      attribute :longitude,           Integer
      attribute :limited_time,        String
      attribute :socket,              String
      attribute :standing_desk,       String
      attribute :mrt,                 String
      attribute :open_time,           String
    end
  end
end
