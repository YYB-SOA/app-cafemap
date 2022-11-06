# frozen_string_literal: true

module CafeMap
  module Repository
    # Repository for Info
    class Infos
      def self.find_id(id)
        rebuild_entity Database::InfoOrm.first(id:)
      end
      
      def self.find(entity)
        find_name(entity.name)
      end

      def self.find_name(name)
        rebuild_entity Database::InfoOrm.first(name:)
      end

      def self.find_all_name(name)
        rebuild_entity Database::InfoOrm.all(name:)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_info = PersistMember.new(entity).create_info
        rebuild_entity(db_info)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Info.new(
          infoid: db_record.infoid,
          name: db_record.name,
          city: db_record.city,
          wifi: db_record.wifi,
          seat: db_record.seat,
          quiet: db_record.quiet,
          tasty: db_record.tasty,
          cheap: db_record.cheap,
          music: db_record.music,
          url: db_record.url,
          address: db_record.address,
          latitude: db_record.latitude,
          longitude: db_record.longitude,
          limited_time: db_record.limited_time,
          socket: db_record.socket,
          standing_desk: db_record.standing_desk,
          mrt: db_record.mrt,
          open_time: db_record.open_time
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Infos.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::InfoOrm.find_or_create(entity.to_attr_hash)
      end
    end

    class PersistMember
      def initialize(entity)
        @entity = entity
      end

      def create_info
        Database::InfoOrm.create(@entity.to_attr_hash)
      end
    end
  end
end
