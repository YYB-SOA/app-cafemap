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
    it 'HAPPY: should provide correct Store attributes' do
      store = PlaceInfo::PlaceApi.new(KEYWORD_FILTER, TOKEN_NAME).store(KEYWORD_FILTER, TOKEN_NAME)
      array_hash = CORRECT_STORE[0..].map { |key| CORRECT[key]['results'] }

      _(store.place_id.must_equal(array_hash.map { |item| item.map { |i| i['place_id'] } }[0][0]))
      _(store.business_status.must_equal(array_hash.map { |item| item.map { |i| i['business_status'] } }[0][0]))

      _(store.location_lat.must_equal(array_hash.map do |item|
                                        item.map do |i|
                                          i['geometry']['location']['lat']
                                        end
                                      end[0][0]))
      _(store.location_lng.must_equal(array_hash.map do |item|
                                        item.map do |i|
                                          i['geometry']['location']['lng']
                                        end
                                      end[0][0]))
    end
  end
end
