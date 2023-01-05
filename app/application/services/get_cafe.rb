# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class GetCafe
      include Dry::Transaction

      step :request_cafeinfo
      step :reify_project

      private

      def request_cafeinfo(input)
        result = Gateway::Api.new(CafeMap::App.config).get_cafeinfo(input)
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add cafeinfo right now; please try again later')
      end

      def reify_project(cafeinfo_json)
        Representer::CafeList.new(OpenStruct.new)
          .from_json(cafeinfo_json)
          .then { |cafeinfo| Success(cafeinfo) }
      rescue StandardError => e
        Failure(e)
        # 'Error in the project -- please try again'
      end
    end
  end
end
