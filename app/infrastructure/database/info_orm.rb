# frozen_string_literal: true

require 'sequel'
require './config/environment'


module CafeMap
  module Database
    # Object Relational Mapper for Project Entities
    class InfoOrm < Sequel::Model(:info)
      one_to_many :store,
                  class: :'CafeMap::Database::StoreOrm',
                  key: :info_id
      plugin :timestamps, update_on_create: true

      def self.find_or_create(store_info)
        first(name: store_info[:name]) || create(store_info)
      end
    end
  end
end

# CafeMap::Database::InfoOrm.create(infoid: "111078513", name: "FongCafe", city: "新竹")
# CafeMap::Database::InfoOrm.all
# CafeMap::Database::InfoOrm.first
# CafeMap::Database::StoreOrm.create(info_id:1, name:"FongCafe",formatted_address:"清大裡面")
# CafeMap::Database::StoreOrm.create(info_id:2, name:"KangCafe",formatted_address:"清大裡面")
# CafeMap::Database::StoreOrm.all
# CafeMap::Database::InfoOrm.create(infoid: "111078503", name: "KangCafe", city: "新竹")