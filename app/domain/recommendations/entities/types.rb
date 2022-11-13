# # frozen_string_literal: false

# require 'dry-types'
# require 'dry-struct'

# module CafeMap
#   module Entity
#     # Domain entity for stores
#     class Types < Dry::Struct
#       include Dry.Types

#       attribute :types, Strict::String # Coercible #Strict

#       def to_attr_hash
#         to_hash # except:remove keys from hash
#       end
#     end
#   end
# end
