# frozen_string_literal: true

# require_relative 'feedback'

module PlaceInfo
  # Provides access to cafe data
  class Store
    def initialize(store_yaml)
      # get data from cafenomad api
      @store_yaml = store_yaml
    end

    def store_id
      @store_yaml['id']
    end

    def name
      @store_yaml['name']
    end

    def city
      @store_yaml['city']
    end

    def address
      @store_yaml['address']
    end

    def url
      @store_yaml['url']
    end

    def limited_time
      @store_yaml['limited_time']
    end

    def socket
      @store_yaml['socket']
    end

    def standing_desk
      @store_yaml['standing_desk']
    end

    def mrt
      @store_yaml['mrt']
    end

    def open_time
      @store_yaml['open_time']
    end
  end
end
