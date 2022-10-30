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
            filtered_store = stores_data.find { |store| store.address.include?user_wordterm}
            routing.halt 404 unless filtered_store
            routing.redirect "region/#{filtered_store.city}"
            end
          
          end
        
        routing.on String do |city|
          # GET /cafe/region
          routing.get do
            filtered_city = stores_data.find { |store| store.city.include? city}
            routing.halt 404 unless filtered_city
            filtered_stores_data = stores_data.select { |filter| filter.city.include? city }
            view 'region', locals: { info: filtered_stores_data}
          end
        end
      end
    end
  end
end
