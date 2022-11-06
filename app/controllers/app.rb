# frozen_string_literal: true

require 'roda'
require 'slim'

module CafeMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets', css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :status_handler


    status_handler(404) do
      view('404')
    end

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
      routing.public #?
      
      # GET /
      routing.root do

      # infos = Repository::For.klass(Entity::Info).all
        view 'home' # , locals: { infos: }

        # view 'home' # , locals: { store_name: stores_data }
      end

      routing.on 'region' do
        routing.is do
          # POST /region/
          routing.post do
            @user_wordterm = routing.params['The regional keyword you want to search (hsinchu)']
            infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
            filtered_infos_data = infos_data.select { |filter| filter.address.include? @user_wordterm }.shuffle
            routing.halt 404 unless filtered_infos_data[0]
            
            info = filtered_infos_data[1..2]

            # Get info from CafeNomad API
            # info = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several

            # Add project to database
            info.each{ |obj| Repository::For.entity(obj).create(obj)}

            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          # GET /cafe/region
          routing.get do
            # Get
            store_namearr = Repository::For.klass(Entity::Info).find_all_name
            random_stores_data = Repository::For.klass(Entity::Info).all[1..1]
            puts store_namearr.length
            google_data = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN, store_namearr[1..1]).load_several
            view 'region', locals: { info: random_stores_data, reviews: google_data }
          end
        end
      end
    end
  end
end
