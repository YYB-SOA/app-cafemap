require_relative "info_mapper.rb"

info = CafeMap::CafeNomad::InfoMapper.new("Cafe_api").load_several
puts info.