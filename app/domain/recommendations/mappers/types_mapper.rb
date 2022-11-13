# frozen_string_literal: true

module CafeMap
    module Mapper
      # Git contributions parsing and reporting services
      class Recommendations
        def initialize(place_data)
          @place_data = place_data
        end
  
        def get(@place_data)
            @place_data.each do |store|
                store.types
            end
        end
      end
    end
end
