# frozen_string_literal: true

require_relative 'info'

module CodePraise
  module Repository
    # Repository for Project Entities
    class Stores
      def self.all
        Database::StoreOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      #   def self.find_full_name(owner_name, project_name)
      # SELECT * FROM `projects` LEFT JOIN `members`
      # ON (`members`.`id` = `projects`.`owner_id`)
      # WHERE ((`username` = 'owner_name') AND (`name` = 'project_name'))
      #     db_project = Database::ProjectOrm
      #       .left_join(:members, id: :owner_id)
      #       .where(username: owner_name, name: project_name)
      #       .first
      #     rebuild_entity(db_project)
      #   end

      #   def self.find(entity)
      #     find_origin_id(entity.origin_id)
      #   end

      def self.find_name(name)
        db_record = Database::ProjectOrm.first(name:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_entity(_db_record)
        return nil unless db_record

        Entity::Store.new(
          place_id: db_record.place_id,
          name: db_record.name,
          formatted_address: db_record.formatted_address,
          location_lat: db_record.location_lat,
          location_lng: db_record.location_lng,
          rating: db_record.rating,
          user_ratings_total: db_record.user_ratings_total
        )
      end
    end
  end
end
