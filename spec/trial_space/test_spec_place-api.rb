# frozen_string_literal: true
require_relative '../../lib/place_api/place_api'
require_relative '../place_api_spec_helper'

require 'yaml'
# require_relative 'place_api_spec_helper'

## READ Answer sheet
# CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_place_api_results_new.yml'))
# CORRECT_STORE = CORRECT.keys

## Fine code: 
# result = []
# array_hash = CORRECT_STORE[0..].map{|key| CORRECT[key]['results']}

## Fine code: 
# array_hash.map{|item|item.select{|i| result<<i['place_id']} }
# puts "KEYWORD_FILTER: #{KEYWORD_FILTER}"
# puts "TOKEN_NAME: #{TOKEN_NAME}"

## test code 
# avc = array_hash.map{|item|item.map{|i| i['place_id']} }[0][0]
# puts avc.class
# array_hash.map{|item|item.map{|i| i['location_lat']} }[0][0]

############ DEMO Code
# store = PlaceInfo::PlaceApi.new(KEYWORD_FILTER, TOKEN_NAME).store(KEYWORD_FILTER,TOKEN_NAME)
# puts store.place_id


##############################

# Test token for place_api
store =  PlaceInfo::PlaceApi.new('新竹', "fafsfagsas").store('新竹',"safaf")
# puts store.place_id.nil?
# puts store.correct_token?

# begin
#   store =  PlaceInfo::PlaceApi.new('新竹', "FAKE_TOKEN").store('新竹',"FAKE_TOKEN")
#   store.correct_token?
#   raise StandardError.new "PlaceInfo::PlaceApi::Response::NotFound"
# end

############# Test reviews
review = PlaceInfo::PlaceApi.new(KEYWORD_FILTER, TOKEN_NAME).reviews(KEYWORD_FILTER,TOKEN_NAME)
puts review.rating[0].class