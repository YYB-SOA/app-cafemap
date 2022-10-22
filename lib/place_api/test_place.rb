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

# place_hash = PlaceInfo::PlaceApi::Request.new("新竹",token).request_main("新竹",'GOOGLE_MAP',token)

# puts place_hash

place_hash = PlaceInfo::PlaceApi.new("新竹",'GOOGLE_MAP',token).store("新竹",'GOOGLE_MAP',token)
#.new("新竹",'GOOGLE_MAP',token)
#.store("新竹",'GOOGLE_MAP',token)
puts place_hash

#token = 'Place_api'

#place_hash = PlaceInfo::PlaceApi.new(token).store

# place_hash = PlaceInfo::PlaceApi.new("WHO'S喜象CAFE",token)

# place_hash = PlaceInfo::Request.new(token)
# .place_hash_generator

#puts place_hash

# input = "WHO'S喜象CAFE"
# token = "AIzaSyDn1SNO-unHl8mSu2u3ZQ7dzfab4Y5bOZ0"


# puts HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW").class


