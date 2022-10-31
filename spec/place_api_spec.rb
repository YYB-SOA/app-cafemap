# frozen_string_literal: true

require_relative 'place_api_spec_helper'

describe 'Tests Place API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<Place_TOKEN>') { PLACE_TOKEN }
    c.filter_sensitive_data('<Place_TOKEN_ESC>') { CGI.escape(PLACE_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Store information' do
    before do
      # test_store = ["WHO'S 喜象 CAFE", 'ARTROOM14藝室']
      @store = CafeMap::Place::StoreMapper.new(TOKEN_NAME, TEST_STORE).load_several
      @yaml_keys = CORRECT_STORE[0..].map { |key| CORRECT[key]['results'] }
    end

    it 'HAPPY: should provide correct Store attributes' do
      _(@store.map { |item| item }[0].place_id.must_equal(@yaml_keys.map do |item|
                                                            item.map do |i|
                                                              i['place_id']
                                                            end
                                                          end[0][0]))
    end

    it 'HAPPY: should provide correct Store attributes' do
      _(@store.map { |item| item }[0].rating.must_equal(@yaml_keys.map do |item|
                                                          item.map do |i|
                                                            i['rating']
                                                          end
                                                        end[0][0]))
    end

    it 'BAD: should raise exception on incorrect invalid result' do
      bad = CafeMap::Place::StoreMapper.new(TOKEN_NAME, FAKE_TEST_STORE).bad_request
      _(bad).must_equal INCORRECT['INVALID_REQUEST']['status']
    end
  end
end
