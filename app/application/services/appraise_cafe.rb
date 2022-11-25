# frozen_string_literal: true

require 'dry/monads'

module CafeMap
  module Service
    # Retrieves array of all listed cafe entities
    class AppraiseCafe
      include Dry::Monads::Result::Mixin
      def call
        infos_data = CafeMap::Database::InfoOrm.all
        Success(infos_data)
      end
    rescue StandardError
      Failure('There is no data in database.')
    end
  end
end
