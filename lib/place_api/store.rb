# frozen_string_literal: true

require_relative 'reviews'

module PlaceInfo
  # Provides access to cafe store data from google api
  class Store
    def initialize(store_data, data_source)
      @store_data = store_data
      @data_source = data_source
    end

    def place_id
      # uts @store_data.class
      # return str, ex. place_id : "ChIJnyawAAc2aDQRsweZWTh80d8"
      @store_data['results'].map { |item|  item['place_id'] }[0]
    end

    def business_status
      # return str, ex. business_status : "CLOSED_PERMANENTLY"
      @store_data['results'].map { |item|  item['business_status'] }[0]
    end

    def address
      # return str, ex. address : "300台灣新竹市東區寶山路438號300"
      @store_data['results'].map { |item|  item['formatted_address'] }[0]
    end

    def location_lat
      # return str, ex. location_lat : "24.7847091"
      @store_data['results'].map { |item|  item['geometry']['location']['lat'] }[0]
    end

    def location_lng
      # return str, ex. location_lat : "2120.9901702"
      @store_data['results'].map { |item|  item['geometry']['location']['lng'] }[0]
    end

    def correct_token?
      # 若place_id這個唯一鍵沒有任何值，則代表根本沒有call到東西
      # ? raise "Fail Token" if place_id.nil
      raise StandardError, 'PlaceInfo::PlaceApi::Response::NotFound' if place_id.nil?
    end

    def response_nil?
      # 若place_id這個唯一鍵沒有任何值，則代表根本沒有call到東西
      place_id.nil?
    end

    # def owner
    #   @owner ||= Contributor.new(@project['owner'])
    # end

    # def contributors
    #   @contributors ||= @data_source.contributors(@project['contributors_url'])
    # end
  end
end

begin
end
