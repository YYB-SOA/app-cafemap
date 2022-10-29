# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CafeMap
  module Entity
    # Domain entity for team members
    class Status < Dry::Struct
      include Dry.Types

      attribute :status, String.optional #Strict::String #String.optional
      attribute :amount, Integer.optional # Strict::Integer #Integer.optional
      attribute :header, Array.optional # Strict::Array # Array.optional
    end
  end
end
