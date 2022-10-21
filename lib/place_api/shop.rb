# frozen_string_literal: true

require_relative 'comment'

{"id":"00014645-38c8-4eb4-ad9b-faa871d7e511","name":"R5小餐館","city":"chiayi",
"wifi":5,"seat":5,"quiet":5,"tasty":5,"cheap":5,"music":5,"url":"https://www.facebook.com/r5.bistro","address":"嘉義市東區忠孝路205號","latitude":"23.48386540","longitude":"120.45358340",
"limited_time":"maybe","socket":"maybe","standing_desk":"no","mrt":"","open_time":"11:30~21:00"}

module CafeShop
  # Provides access to contributor data
  class Shop
    def initialize(shop_yaml)
      # get data from cafenomad api
      @shop_yaml = shop_yaml
    end

    def shop_id
      @shop_yaml[]['id']
    end

    def title
      @shop_yaml['article'][0]['title']
    end

    def author

    end

    def description
      @content['article'][0]['description']
    end

    def publishedat
      @content['article'][0]['publishedAt']
    end
  end
end
