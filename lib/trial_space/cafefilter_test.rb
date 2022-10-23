# frozen_string_literal: true

require_relative '../place_api/cafefilter.rb'

cafe_filter_array = PlaceInfo::CafeFilter.new.main('新竹')[0]
puts cafe_filter_array
