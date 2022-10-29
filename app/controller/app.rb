# frozen_string_literal: true

require 'roda'
require 'slim'

module CafeMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :status_handler

    status_handler(404) do
      view('404')
    end
    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      stores_data = CafeMap::CafeNomad::InfoMapper.new(CAFE_TOKEN_NAME).load_several
      
      # GET /
      routing.root do
        view 'home' # , locals: { store_name: stores_data }
      end

      routing.on 'region' do
        routing.is do
          # POST /storelist/

          routing.post do
            user_wordterm = routing.params['欲查詢的地區']
            city = stores_data.find { |store| store.address.include? user_wordterm }
            routing.halt 404 unless city
            routing.redirect "light-of-day/#{city.city}"
            # city_arr = %w[新竹 台北 宜蘭 臺北 新北 桃園 苗栗 台中 嘉義 台南 台東 花蓮 南投]
            # routing.halt 404 unless city_arr.any?(user_wordterm) &&
            #                        (user_wordterm.split(/ /).count >= 2)
                   
            # Filtered
            # region = city_arr.select{ |city| city== user_wordterm}

            # stores_list = stores_data.select { |obj| obj.address.include? user_wordterm }.map(&:name)
            
            # routing.redirect "Cafe-Map/region"
            end
          
          end
        # routing.is do
        #   # GET /cafe/region
        #   routing.get do
        #     cafe_storename = CafeMap::InfoMapper
        #                      .new(CAFE_TOKEN_NAME)
        #                      .load_several
        #     view 'region', locals: { storelist: region }
        #   end
        # end
      end
    end
  end
end
