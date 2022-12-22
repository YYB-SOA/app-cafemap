# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class AddCafe
      include Dry::Transaction

      step :validate_input
      step :request_cafeinfo
      step :reify_project

      private

      def validate_input(input)
        if input.success?

          Success(city: input[:city_name])
        else
          Failure("City #{input.errors.messages.first}")
        end
      end

      def request_cafeinfo(input)
        puts input[:city]
        result = Gateway::Api.new(CafeMap::App.config).add_cafeinfo(input[:city])
        puts result
        puts result.payload
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add cafeinfo right now; please try again later')
      end

      def reify_project(project_json)
        puts "456"
        puts project_json
        Representer::Project.new(OpenStruct.new)
          .from_json(project_json)
          .then { |project| Success(project) }
      rescue StandardError
        Failure('Error in the project -- please try again')
      end
    end
  end
end
