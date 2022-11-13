require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
@cafe_info = CafeMap::CafeNomad:: InfoMapper.new(CAFE_TOKEN).load_several
@yaml_keys = CAFE_CORRECT.keys[3..]
number = 122
puts (@cafe_info.map(&:infoid)).length



puts (ans_sheet('id', @yaml_keys, CAFE_CORRECT ).map(& :to_s)).length