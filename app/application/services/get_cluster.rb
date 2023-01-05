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
        input[:response] = Gateway::Api.new(CafeMap::App.config).get_cluster(input[:cluster_name])
        # puts "mes:", result.message
        # puts "pay:", result.payload
        # puts "rs:", result.success?
  
        input[:response].success? ? Success(input) : Failure(input[:response].message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add cafeinfo right now; please try again later')
      end

      def reify_cluster(input)
        unless input[:response].processing?
          Representer::ClusterList.new(OpenStruct.new)
            .from_json(input[:response].payload)
            .then {input[:cluster_info] = _1}
        end
        Success(input)
      rescue StandardError => e
        puts e
        Failure(e)
        # 'Error in the project -- please try again'
      end
    end
  end
end
