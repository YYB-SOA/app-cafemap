# frozen_string_literal: true

require 'roda'
require 'slim/include'
require 'descriptive_statistics'

module CafeMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :all_verbs
    plugin :status_handler
    plugin :flash

    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    status_handler(404) do
      view('404')
    end

    route do |routing|
      # routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # routing.public # ?

      # GET /
      routing.root do
        session[:loc] ||= []

        # Load previously viewed projects
        Repository::For.klass(Entity::Info).find_all_city
        view 'home' # , locals: { infos: }
      end

      routing.on 'region' do
        routing.is do
          # POST /region/
          routing.post do
            @user_wordterm = routing.params['The regional keyword you want to search (hsinchu)']
            infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
            filtered_infos_data = infos_data.select { |filter| filter.address.include? @user_wordterm }.shuffle
            routing.halt 404 unless filtered_infos_data[0] # if filtered_infos_data is empty.

            @lock = 1
            info = filtered_infos_data[0..@lock] # Random Entities Array
            session[:loc].insert(0, info[1]).uniq!
            info_allname = Repository::For.klass(Entity::Info).all_name
            info_unrecorded = info.reject { |each_info| info_allname.include? each_info.name } # entities not in db

            # Add project to database
            info_unrecorded.each do |each_unrecorded|
              Repository::For.entity(each_unrecorded).create(each_unrecorded)
              place_entity = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN,
                                                             [each_unrecorded.name]).load_several
              Repository::For.entity(place_entity[0]).create(place_entity[0], each_unrecorded.name)

              last_infoid = Repository::For.klass(Entity::Info).last_id
              last_store = Repository::For.klass(Entity::Store).last

              last_store.update(info_id: last_infoid)
            end
            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          routing.delete do
            session[:loc].delete(city)
          end

          # GET /cafe/region
          routing.get do
            begin
              filtered_info = CafeMap::Database::InfoOrm.where(city:).all
              if filtered_info.nil?
                flash[:error] = 'There is no cafe shop in the region'
                routing.redirect '/'
              end
            rescue StandardError => e
              flash[:error] = "Having trouble accessing database: error type: #{e}"
              routing.redirect '/'
            end

            ip = CafeMap::UserIp::Api.new.ip
            # Get Obj array
            google_data = filtered_info.map(&:store)

            # Get Value object
            infostat = Views::StatInfos.new(filtered_info)
            storestat = Views::StatStores.new(google_data)

            view 'region', locals: { infostat:,
                                     storestat:,
                                     ip: }

          rescue StandardError => e
            puts e.full_message
          end
        end
      end
    end
  end
end
