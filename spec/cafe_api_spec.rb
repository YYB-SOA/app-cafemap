# frozen_string_literal: true

require_relative 'cafe_api_spec_helper'

describe 'Tests Cafe Nomad API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.ignore_localhost = true
    c.filter_sensitive_data('<CAFE_TOKEN>') { CAFE_TOKEN }
    c.filter_sensitive_data('<CAFE_TOKEN_ESC>') { CGI.escape(CAFE_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Cafe Nomad Store Content' do
    before do
      @cafe_info = CafeMap::CafeNomad:: InfoMapper.new('Cafe_api').load_several
      @yaml_keys = CORRECT.keys[3..]
    end

    #--------------------------Store Content-----------
    it 'HAPPY: should pass corect id' do
      _(@cafe_info.map(&:id)).must_equal ans_sheet('id', @yaml_keys)
    end

    it 'HAPPY: should pass corect name' do
      _(@cafe_info.map(&:name)).must_equal ans_sheet('name', @yaml_keys)

    end

    it 'HAPPY: should pass corect city' do
      _(@cafe_info.map(&:city)).must_equal ans_sheet('city', @yaml_keys)
    end

    it 'HAPPY: should pass corect url' do
      _(@cafe_info.map(&:url)).must_equal ans_sheet('url', @yaml_keys)
    end

    it 'HAPPY: should pass corect address' do
      _(@cafe_info.map(&:address)).must_equal ans_sheet('address', @yaml_keys)
    end

    it 'HAPPY: should pass corect latitude' do
      _(@cafe_info.map(&:latitude)).must_equal ans_sheet('latitude', @yaml_keys)
    end

    it 'HAPPY: should pass corect longitude' do
      _(@cafe_info.map(&:longitude)).must_equal ans_sheet('longitude', @yaml_keys)
    end

    it 'HAPPY: should pass corect limited_time' do
      _(@cafe_info.map(&:limited_time)).must_equal ans_sheet('limited_time', @yaml_keys)
    end

    it 'HAPPY: should pass corrected  mrt' do
      _(@cafe_info.map(&:mrt)).must_equal ans_sheet('mrt', @yaml_keys)
    end

    it 'HAPPY: should pass corrected  open_time' do
      _(@cafe_info.map(&:open_time)).must_equal ans_sheet('open_time', @yaml_keys)
    end

    it 'HAPPY: should pass identitied standing_desk' do
      _(@cafe_info.map(&:standing_desk)).must_equal ans_sheet('standing_desk', @yaml_keys)
    end

    it 'HAPPY: should pass identitied socket' do
      _(@cafe_info.map(&:socket)).must_equal ans_sheet('socket', @yaml_keys)
    end

    #--------------------------Rating Content---------------------------

    it 'HAPPY: should pass identitied wifi score' do
      _(@cafe_info.map(&:wifi)).must_equal ans_sheet('wifi', @yaml_keys).map(& :to_s)
    end

    it 'HAPPY: should pass identitied seat score' do
      _(@cafe_info.map(&:seat)).must_equal ans_sheet('seat', @yaml_keys).map(& :to_s)
    end

    it 'HAPPY: should pass identitied quiet score' do
      _(@cafe_info.map(&:quiet)).must_equal ans_sheet('quiet', @yaml_keys).map(& :to_s)
    end

    it 'HAPPY: should pass identitied tasty score' do
      _(@cafe_info.map(&:tasty)).must_equal ans_sheet('tasty', @yaml_keys).map(& :to_s)
    end

    it 'HAPPY: should pass identitied cheap score' do
      _(@cafe_info.map(&:cheap)).must_equal ans_sheet('cheap', @yaml_keys).map(& :to_s)
    end

    it 'HAPPY: should pass identitied music score' do
      _(@cafe_info.map(&:music)).must_equal ans_sheet('music', @yaml_keys).map(& :to_s)
    end
  end
end
