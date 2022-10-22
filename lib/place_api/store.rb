# frozen_string_literal: true

require_relative 'reviews'

module PlaceInfo
  # Provides access to cafe store data from google api
  class Store
    def initialize(store_data)
      @store_data = store_data
    end

    def place_id
      @store_data['results']['place_id']
    end

    def business_status
      @store_data['results']['business_status']
    end

    def address
      @store_data['results']['formatted_address']
    end

    def location_lat
      @store_data['results']['geometry']['location']['lat']
    end

    def location_lng
      @store_data['results']['geometry']['location']['lng']
    end


    # def owner
    #   @owner ||= Contributor.new(@project['owner'])
    # end

    # def contributors
    #   @contributors ||= @data_source.contributors(@project['contributors_url'])
    # end

  end
end
