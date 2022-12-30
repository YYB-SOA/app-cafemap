# frozen_string_literal: true

require 'dry/transaction'

module CafeMap
  module Service
    # Transaction to store cafe data from CafeNomad API to database
    class GetCluster
      include Dry::Transaction

      step :validate_input
      step :request_cluster
      step :reify_cluster

      private

      def validate_input(input)
        if input.success?
          Success(cluster_name: input[:cluster_city])
        else
          Failure("City #{input.errors.messages.first}")
        end
      end

      def request_cluster(input)
        result = Gateway::Api.new(CafeMap::App.config).get_cluster(input[:cluster_name])
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add cafeinfo right now; please try again later')
      end

      def reify_cluster(cluster_json)
        Representer::ClusterList.new(OpenStruct.new)
          .from_json(cluster_json)
          .then { |cluster| Success(cluster) }
      rescue StandardError => e
        Failure(e)
        # 'Error in the project -- please try again'
      end
    end
  end
end
