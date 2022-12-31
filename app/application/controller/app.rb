# frozen_string_literal: true

require 'roda'
require 'slim/include'
require 'descriptive_statistics'

module CafeMap
  # Web App
  class App < Roda
    # include RouteHelpers
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :all_verbs
    plugin :status_handler
    plugin :flash
    plugin :caching

    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    status_handler(404) do
      view('404')
    end

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      routing.public

      # GET /
      routing.root do
        session[:city] = []
        # session[:city] ||= []
        # Load previously viewed location
        # result = Service::ListCities.new.call
        # if result.failure?
        #   flash[:error] = result.failure
        # else
        #   cities = result.value!
        #   flash.now[:notice] = 'Add a city name to get started' if cities.none?
        #   session[:city] = cities.map(&:city)
        # end

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
            puts info['infos'][0]['city']
            # session[:city].insert(0, info['infos'][0]['city']).uniq!
            routing.redirect "region/#{info['infos'][0]['city']}"
          end
        end

        routing.on String do |city|
          routing.delete do
            session[:city].delete(city)
          end

          # GET /cafe/region
          routing.get do
            info_get = Service::GetCafe.new.call(city)
            if info_get.failure?
              flash[:error] = info_made.failure
              routing.redirect '/'
            end

            info = info_get.value!
            filtered_info = info['infos']
            google_data = info['stores']
            infostat = Views::StatInfos.new(filtered_info)
            storestat = Views::StatStores.new(google_data)
            view 'region', locals: { infostat:,
                                     storestat: }

          rescue StandardError => e
            puts e.full_message
          end
        end
      end
      routing.on "cluster" do
        routing.is do
          routing.get do
            cluster_request = Forms::NewCluster.new.call(routing.params)
            get_cluster= Service::GetCluster.new.call(cluster_request)
            if get_cluster.failure?
              flash[:error] = get_cluster.failure
              routing.redirect '/'
            end
            cluster = get_cluster.value!
            cluster_info = cluster["clusters"]
            cluster_view = Views::ClusterData.new(cluster_info)
            response.expires 60, public: true
            view 'cluster', locals: { cluster_view:}
          end
        end
      end
    end
  end
end
