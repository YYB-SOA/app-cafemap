# # frozen_string_literal: true

# module CafeMap
#   module Repository
#     # Repository for Info
#     class Info
#       def self.find_id(id)
#         rebuild_entity Database::InfoOrm.first(id:)
#       end

#       def self.find_username(username)
#         rebuild_entity Database::InfoOrm.first(username:)
#       end

#       def self.rebuild_entity(db_record)
#         return nil unless db_record

#         Entity::Info.new(
#           id: db_record.id,
#           name: db_record.name,
#           city: db_record.city,
#           wifi: db_record.wifi,
#           seat: db_record.seat,
#           quiet: db_record.quiet,
#           tasty: db_record.tasty,
#           cheap: db_record.cheap,
#           music: db_record.music,
#           url: db_record.url,
#           address: db_record.address,
#           latitude: db_record.latitude,
#           longitude: db_record.longitude,
#           limited_time: db_record.limited_time,
#           socket: db_record.socket,
#           standing_desk: db_record.standing_desk,
#           mrt: db_record.mrt,
#           open_time: db_record.open_time
#         )
#       end

#       def self.rebuild_many(db_records) # 對應到 infomapper 的 load_several
#         db_records.map do |db_member|
#           Members.rebuild_entity(db_member)
#         end
#       end

#       def self.db_find_or_create(entity)
#         Database::MemberOrm.find_or_create(entity.to_attr_hash)
#       end
#     end
#   end
# end
