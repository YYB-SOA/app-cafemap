# frozen_string_literal: true

require 'sequel'

module CafeMap
  module Database
    # Object-Relational Mapper for Members
    class StoreOrm < Sequel::Model(:store)
      one_to_one :storeinfo,
                  class: :'CafeMap::Database::InfoOrm',
                  key: :name

      plugin :timestamps, update_on_create: true

    end
  end
end