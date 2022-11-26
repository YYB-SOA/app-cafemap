# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Add_Cade Service Integration Test' do
  #   VcrHelper.setup_vcr

  #   before do
  #     VcrHelper.configure_vcr_for_cafe(recording: :none)
  #   end

  #   after do
  #     VcrHelper.eject_vcr
  #   end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote CafeStore to database' do
      cafe_info = CafeMap::CafeNomad::InfoMapper.new(CafeMap::App.config.CAFE_TOKEN).load_several
      city_request = CafeMap::Forms::NewCity.new.call(city_name: CITY_DEFAULT)

      # WHEN: the service is called with the request form object
      store_made = CafeMap::Service::AddCafe.new.call(city_request)

      # THEN: the result should report success..
      _(store_made.success?).must_equal true

      # ..and provide a info entity with the right details
      rebuilt = store_made.value!
      includeChecker(rebuilt, :infoid, cafe_info.map(&:infoid))
      includeChecker(rebuilt, :city, cafe_info.map(&:city))
      includeChecker(rebuilt, :wifi, cafe_info.map(&:wifi))
      includeChecker(rebuilt, :seat, cafe_info.map(&:seat))
      includeChecker(rebuilt, :quiet, cafe_info.map(&:quiet))
      includeChecker(rebuilt, :tasty, cafe_info.map(&:tasty))
      includeChecker(rebuilt, :cheap, cafe_info.map(&:cheap))
      includeChecker(rebuilt, :url, cafe_info.map(&:url))
      includeChecker(rebuilt, :address, cafe_info.map(&:address))
      includeChecker(rebuilt, :latitude, cafe_info.map(&:latitude))
      includeChecker(rebuilt, :longitude, cafe_info.map(&:longitude))
      includeChecker(rebuilt, :limited_time, cafe_info.map(&:limited_time))
      includeChecker(rebuilt, :socket, cafe_info.map(&:socket))
      includeChecker(rebuilt, :standing_desk, cafe_info.map(&:standing_desk))
      includeChecker(rebuilt, :mrt, cafe_info.map(&:mrt))
      includeChecker(rebuilt, :open_time, cafe_info.map(&:open_time))
    end
  end
end
