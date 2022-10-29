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

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      stores_data = CafeMap::CafeNomad::InfoMapper

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
           
            region=routing.params['region']
            # city_arr = %w[新竹 台北 宜蘭 臺北 新北 桃園 苗栗 台中]
            # region.halt 400 unless city_arr.any?(region) &&
            #                        (region.split(/ /).count >= 2)
            routing.redirect "yyb/#{region}/"
            end
          end

        routing.is do
          # GET /cafe/storename
          routing.get do
            # cafe_storename = CafeMap::InfoMapper
            #                  .new(CAFE_TOKEN_NAME)
            #                  .load_several
            # view 'project', locals: { project: region }

          end
        end
      end
    end
  end
end
