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
                test = response.split("=")[1].split(";")[0]
                @ip = JSON.parse(test)["cip"]
            end

            def ip
                @ip
            end
            def to_geoloc
                Geocoder.search(@ip).first.coordinates
            end
        end
    end
end


a = CafeMap::UserIp::Api.new.to_geoloc
puts a

b = CafeMap::UserIp::Api.new.ip
puts b

# url = 'http://pv.sohu.com/cityjson?ie=utf-8'
# uri = URI(url)
# response = Net::HTTP.get(uri)
# test = response.split("=")[1].split(";")[0]
# ip = JSON.parse(test)["cip"]
# puts ip

# results = Geocoder.search(ip)
# puts results.first.coordinates
