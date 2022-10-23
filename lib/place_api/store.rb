# frozen_string_literal: true

require_relative 'reviews'

module PlaceInfo
  # Provides access to cafe store data from google api
  class Store
    def initialize(store_data,data_source)
      @store_data = store_data
      @data_source = data_source
    end

    def place_id
      # uts @store_data.class
      @store_data['results'].map{ |item|  item['place_id']}
    end

    def business_status
      @store_data['results'].map{ |item|  item['business_status']}
    end

    def address
      @store_data['results'].map{ |item|  item['formatted_address']}
    end

    def location_lat
      @store_data['results'].map{ |item|  item['geometry']['location']['lat']}
    end

    def location_lng
      @store_data['results'].map{ |item|  item['geometry']['location']['lng']}
    end

    # def owner
    #   @owner ||= Contributor.new(@project['owner'])
    # end

    # def contributors
    #   @contributors ||= @data_source.contributors(@project['contributors_url'])
    # end
  end
end
