# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CafeMap
  module Entity
    # Domain entity for team members
    class Status < Dry::Struct
      include Dry.Types

      attribute :status, Strict::String
      attribute :amount, Strict::Integer
      attribute :header, Strict::Array
    end
  end
end
