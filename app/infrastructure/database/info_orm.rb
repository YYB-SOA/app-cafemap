# frozen_string_literal: true

require 'sequel'

module CafeMap
  module Database
    # Object Relational Mapper for Project Entities
    class InfoOrm < Sequel::Model(:info)
      one_to_one :stroereview,
                  class: :'CafeMap::Database::StoreOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
