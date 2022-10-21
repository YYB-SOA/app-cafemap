# frozen_string_literal: true

require_relative 'feedback'

module CafeShop
  # Provides access to contributor data
  class Shop
    def initialize(shop_yaml)
      # get data from cafenomad api
      @shop_yaml = shop_yaml
    end

    def shop_id
      @shop_yaml['id']
    end

    def name
      @shop_yaml['name']
    end

    def city
      @shop_yaml['city']
    end

    def url
      @shop_yaml['url']
    end

    def limited_time
      @shop_yaml['limited_time']
    end

    
    def socket
      @shop_yaml['socket']
    end

    def standing_desk
      @shop_yaml['standing_desk']
    end


    def mrt
      @shop_yaml['mrt']
    end

    def open_time
      @shop_yaml['open_time']
    end
  end
end
