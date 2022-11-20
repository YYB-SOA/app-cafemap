# frozen_string_literal: true

require 'net/http'
require 'json'
require 'geocoder'

module CafeMap
  module UserIp
    class Api
      def initialize
        url = 'http://pv.sohu.com/cityjson?ie=utf-8'
        uri = URI(url)
        response = Net::HTTP.get(uri)
        test = response.split('=')[1].split(';')[0]
        @ip = JSON.parse(test)['cip']
      end

      attr_reader :ip

      def to_geoloc
        Geocoder.search(@ip).first.coordinates
      end
    end
  end
end
