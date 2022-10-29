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

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'info' do
        routing.is do
          # POST /info/
          routing.post do
            city_ch = routing.params['address'][0..2]
            city_en = routing.params['city']
            store_names =  routing.params['name']
            routing.halt 400 unless (city_ch.include? "市" ) &&
                                    (city_en.split('').count >= 4) &&
                                    (! store_names.nil?)
          
            routing.redirect "info/#{city_en}/#{store_names}"
          end
        end

        routing.on String, String do |city_en, store_names|
          # GET /city_en/stores
          routing.get do
            self.build_entity
            cafe_status = CafeNomad::StatusMapper.new(NOMAD_TOKEN_NAME).find()

            view 'status', locals: { stores: cafe_status }
          end
        end
      end
    end
  end
end
