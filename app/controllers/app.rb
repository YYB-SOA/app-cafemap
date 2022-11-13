# frozen_string_literal: true
require_relative '../../spec/helpers/spec_helper.rb' #should be removed
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

      # infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
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

            info = filtered_infos_data[1..2] # Random Entities Array
            info_allname = Repository::For.klass(Entity::Info).all_name
            info_unrecorded = info.reject{|each_info| info_allname.include? each_info.name} # entities not in db

            # Add project to database
            info_unrecorded.each do |each_unrecorded|
              Repository::For.entity(each_unrecorded).create(each_unrecorded)
              place_entity = CafeMap::Place::StoreMapper.new(App.config.PLACE_TOKEN, [each_unrecorded.name]).load_several
              Repository::For.entity(place_entity[0]).create(place_entity[0], each_unrecorded.name)
              last_infoid = Repository::For.klass(Entity::Info).last_id
              last_store = Repository::For.klass(Entity::Store).last
              last_store.update(info_id:last_infoid)
            end
            routing.redirect "region/#{info[0].city}"
          end
        end

        routing.on String do |city|
          # GET /cafe/region
          routing.get do
            # Get
            filtered_stores = Repository::For.klass(Entity::Info).all_filtered(city) # get all filtered city
            all_storedb_names = Repository::For.klass(Entity::Store).all_name
            lock = 2
            view 'region', locals: { info: filtered_stores, reviews: google_data, place_call_num: lock }
          rescue StandardError => e
            puts e.full_message
          end
        end
      end
    end
  end
end
