# frozen_string_literal: true


# ARTROOM14藝室:
#   html_attributions: []
#   results:
#   - business_status: OPERATIONAL
#     formatted_address: 300台灣新竹市北區勝利路300號
#     geometry:
#       location:
#         lat: 24.8020889
#         lng: 120.9637683
#       viewport:
#         northeast:
#           lat: 24.80342682989272
#           lng: 120.9650957298928
#         southwest:
#           lat: 24.80072717010728
#           lng: 120.9623960701073
#     icon: https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png
#     icon_background_color: "#7B9EB0"
#     icon_mask_base_uri: https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet
#     name: ARTROOM14 藝室
#     photos:
#     - height: 4032
#       html_attributions:
#       - <a href="https://maps.google.com/maps/contrib/110216474943743693780">傅傅玉霏</a>
#       photo_reference: AcYSjRgsbJKXS7nxSW1XGn70jZovvqg921W3meycwqxU6RfxBeoByF1vX4ivQc_tYqZcs5uw7jx4No1OZ7TEdRKglnlLv0RD0KwraAf82rIh7CDEWdPPkzHvnSophR9qSQOnPRW-GcKwwz8QLYq3auUfUINsBLNvrOhgFVFtiv82F0NsOffX
#       width: 3024
#     place_id: ChIJC2c7HFc1aDQRdtptswP3kko
#     plus_code:
#       compound_code: RX27+RG 北區 新竹市
#       global_code: 7QP2RX27+RG
#     rating: 4.7
#     reference: ChIJC2c7HFc1aDQRdtptswP3kko
#     types:
#     - hair_care
#     - point_of_interest
#     - establishment
#     user_ratings_total: 42
#   status: OK

module CafeShop
  # Provides access to place_api data/ 
  # Storage: spec/fixtures/cafe_place_api_results.yml  or spec/fixtures/cafe_place_api_results_hc.yml
  class Shop
    def initialize(shop_yaml)
      @shop_yaml = shop_yaml
    end

    def name
      @shop_yaml['result']['name']
    end

    def formatted_address
      @shop_yaml['result']['formatted_address']
    end

    def location
      @shop_yaml['result']["geometry"]['location']
    end

    def icon
      @shop_yaml['result']["icon"]
    end

  end
end
