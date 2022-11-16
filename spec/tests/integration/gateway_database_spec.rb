# frozen_string_literal: false

require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Cafe API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_cafe
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store info' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save Info from CafeNomad to database' do
      info = CafeMap::CafeNomad::InfoMapper
        .new(CAFE_TOKEN)
        .load_several

      rebuilt = CafeMap::Repository::For.entity(info).create(info)

      _(rebuilt.infoid).must_equal(info.infoid)
      _(rebuilt.name).must_equal(info.name)
      _(rebuilt.wifi).must_equal(info.wifi)
      _(rebuilt.seat).must_equal(info.seat)
      _(rebuilt.quiet).must_equal(info.quiet)
      _(rebuilt.tasty).must_equal(info.tasty)
      _(rebuilt.cheap).must_equal(info.cheap)
      _(rebuilt.music).must_equal(info.music)
      _(rebuilt.url).must_equal(info.url)
      _(rebuilt.address).must_equal(info.address)
      _(rebuilt.latitude).must_equal(info.latitude)
      _(rebuilt.longitude).must_equal(info.longitude)
      _(rebuilt.limited_time).must_equal(info.limited_time)
      _(rebuilt.socket).must_equal(info.socket)
      _(rebuilt.standing_desk).must_equal(info.standing_desk)
      _(rebuilt.mrt).must_equal(info.mrt)
      _(rebuilt.open_time).must_equal(info.open_time)
    end
  end
end
