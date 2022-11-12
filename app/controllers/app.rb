# frozen_string_literal: true

require 'roda'
require 'slim'

module CafeMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets', css: 'style.css'
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
      routing.public # ?

      # GET /
      routing.root do
        # infos = Repository::For.klass(Entity::Info).all
        view 'home' # , locals: { infos: }
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

            # Add project to database
            info.each { |obj| Repository::For.entity(obj).create(obj) }

            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          # GET /cafe/region
          routing.get do
            # Get
            store_namearr = Repository::For.klass(Entity::Info).all_filtered_name(city) # get filtered name(array)
            filtered_stores = Repository::For.klass(Entity::Info).all_filtered(city) # get all filtered city
            all_storedb_names = Repository::For.klass(Entity::Store).all_name # 抓出所有 store.db 的資料
            lock = 2

            if all_storedb_names.any?
              unrecord_name = all_storedb_names.reject { |store| (store_namearr.include? store) }
              store_namearr = unrecord_name
            end

            google_data = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN, store_namearr.first(lock)).load_several


            google_data.each { |google| Repository::For.entity(google).create(google) }
            puts 'place db set successfully'

            view 'region', locals: { info: filtered_stores, reviews: google_data, place_call_num: lock }
          rescue StandardError => e
            puts e.full_message
          end
        end
      end
    end
  end
end
