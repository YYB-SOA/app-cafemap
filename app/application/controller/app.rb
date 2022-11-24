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
        session[:city] ||= []

        # Load previously viewed location
        result = Service::ListCities.new.call

        if result.failure?
          flash[:error] = result.failure
        else
          cities = result.value!
          if cities.none?
            flash.now[:notice] = 'Add a city name to get started'
          end
          session[:city] = cities.map(&:city)
        end

        # add our view_objects?

        view 'home'
      end

      routing.on 'region' do
        routing.is do
          # POST /region/
          routing.post do

            city_request = Forms::NewCity.new.call(routing.params)
            info_made = Service::AddCafe.new.call(city_request)
            if info_made.failure?
              flash[:error] = info_made.failure
              routing.redirect '/'
            end
            info = info_made.value!
            session[:city].insert(0, info[1]).uniq!
            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          routing.delete do
            session[:city].delete(city)
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

      routing.on 'map' do
        routing.get do
          result = CafeMap::Service::AppraiseCafe.new.call
          if result.failure?
            flash[:error] = result.failure
          else
            infos_data = result.value!
          end
          # puts infos_data.map(&:wifi)
          ip = CafeMap::UserIp::Api.new.ip
          location = CafeMap::UserIp::Api.new.to_geoloc
          $temp = []
          view 'map', locals: { info: infos_data,
                                ip:,
                                your_lat: location[0],
                                your_long: location[1],
                                uni_temp: $temp }
        end
      end
    end
  end
end
