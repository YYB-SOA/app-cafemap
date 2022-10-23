# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../place_api/place_api'
require 'http'
require 'json'

require_relative 'store'
require_relative 'reviews'
require_relative 'cafefilter'


# api跑完後的結果
CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_place_api_results_new.yml'))
token = 'Place_api'

#測試
# place_hash = PlaceInfo::PlaceApi::Request.new("新竹",token).request_main("新竹",token)
# place_hash = PlaceInfo::PlaceApi::Request.new("新竹",token).request_main
# puts place_hash.class

#測試
# place_hash = PlaceInfo::PlaceApi.new("新竹",token).store("新竹",token)
# puts place_hash

# place_hash = PlaceInfo::PlaceApi.new("新竹",token).reviews("新竹",token)
# puts place_hash

#測試
instance = PlaceInfo::PlaceApi.new("新竹",token)
puts "place_id : #{instance.store("新竹",token).place_id}"
puts "business_status : #{instance.store("新竹",token).business_status}"
puts "address : #{instance.store("新竹",token).address}"
puts "location_lat : #{instance.store("新竹",token).location_lat}"
puts "location_lng : #{instance.store("新竹",token).location_lng}"


#place_hash = PlaceInfo::PlaceApi.new(token).store

# place_hash = PlaceInfo::PlaceApi.new("WHO'S喜象CAFE",token)

# place_hash = PlaceInfo::Request.new(token)
#puts place_hash


# call API test

# input = "WHO'S喜象CAFE"
# token = "AIzaSyDn1SNO-unHl8mSu2u3ZQ7dzfab4Y5bOZ0"
# puts HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW").class


