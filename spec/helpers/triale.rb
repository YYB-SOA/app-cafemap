require_relative '../../app/domain/cafenomad/mappers/info_mapper.rb'

infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
puts infos_data[0]