# # frozen_string_literal: false

# require_relative 'info_mapper'
# require_relative '../gateways/cafe_api.rb'
# require_relative '../entities/status.rb'

# module CafeMap
#   module CafeNomad
#     class StatusMapper
#       def initialize(tokename, gateway_class = CafeNomad::Api)
#         @tokename = tokename
#         @gateway_class = gateway_class
#         @gateway = gateway_class.new(@tokename) # will be a json array.
#       end

#       def find
#         data = @gateway.cafe_status
#         StatusMapper.build_entity(data)
#       end

#       def self.build_entity(data)
#         DataMapper.new(data).build_entity
#       end
#     end

#     class DataMapper
#       def initialize(data)
#         @data = data
#       end

#       def build_entity
#         CafeMap::Entity::Status.new(
#           status:,
#           amount:,
#           header:
#         )
#       end

#       def status
#         @data['status']
#       end

#       def amount
#         @data['amount']
#       end

#       def header
#         @data['header']
#       end
#     end
#   end
# end

# stores_data = CafeMap::CafeNomad::StatusMapper.new("Cafe_api").find
# puts stores_data.status