# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../place_api/place_api'
require 'http'
require 'json'

require_relative '../place_api/store'
require_relative '../place_api/reviews'
require_relative '../place_api/cafefilter'


# api跑完後的結果
CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_place_api_results_new.yml'))
token_name = 'Place_api'

#測試
# place_hash = PlaceInfo::PlaceApi::Request.new("新竹",token).request_main("新竹",token)
# place_hash = PlaceInfo::PlaceApi::Request.new("新竹",token).request_main
# puts place_hash.class

#測試
# place_hash = PlaceInfo::PlaceApi.new("新竹",token).store("新竹",token)
# puts place_hash

# place_hash = PlaceInfo::PlaceApi.new("新竹",token).reviews("新竹",token)
# puts place_hash

# 測試：store/review放參數 run ok
# instance = PlaceInfo::PlaceApi.new("新竹",token_name)
# puts "place_id : #{instance.store("新竹",token_name).place_id}"
# puts "business_status : #{instance.store("新竹",token_name).business_status}"
# puts "address : #{instance.store("新竹",token_name).address}"
# puts "location_lat : #{instance.store("新竹",token_name).location_lat}"
# puts "location_lng : #{instance.store("新竹",token_name).location_lng}"
# puts "/n"
# puts "place_id : #{instance.reviews("新竹",token_name).place_id}"
# puts "address : #{instance.reviews("新竹",token_name).address}"
# puts "rating : #{instance.reviews("新竹",token_name).rating}"
# puts "user_ratings_total : #{instance.reviews("新竹",token_name).user_ratings_total}"


# 測試：store/review不放參數 run not ok
instance = PlaceInfo::PlaceApi.new("新竹",token_name)
puts "place_id : #{instance.store.place_id}"
puts "business_status : #{instance.store.business_status}"
puts "address : #{instance.store.address}"
puts "location_lat : #{instance.store.location_lat}"
puts "location_lng : #{instance.store.location_lng}"
puts "/n"
puts "place_id : #{instance.reviews.place_id}"
puts "address : #{instance.reviews.address}"
puts "rating : #{instance.reviews.rating}"
puts "user_ratings_total : #{instance.reviews.user_ratings_total}"

# 測試：
# place_hash = PlaceInfo::PlaceApi.new(token).store
# place_hash = PlaceInfo::PlaceApi.new("WHO'S喜象CAFE",token)
# place_hash = PlaceInfo::Request.new(token)
# puts place_hash


# 測試：call API test
# input = "WHO'S喜象CAFE"
# token = "AIzaSyDn1SNO-unHl8mSu2u3ZQ7dzfab4Y5bOZ0"
# puts HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW").class


