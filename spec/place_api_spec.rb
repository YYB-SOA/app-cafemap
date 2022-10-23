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
    it 'HAPPY: should provide correct Shop attributes' do
      # PlaceApi會繼承module Store class 的特定參數，目前store檔案只有傳入store_yaml，可能不適合
      store = PlaceInfo::PlaceApi.new(KEYWORD_FILTER, TOKEN_NAME).store(KEYWORD_FILTER,TOKEN_NAME)
      array_hash = CORRECT_STORE[0..].map{|key| CORRECT[key]['results']}

      _(store.place_id.must_equal array_hash.map{|item|item.map{|i| i['place_id']} }[0][0])
      _(store.business_status.must_equal array_hash.map{|item|item.map{|i| i['business_status']} }[0][0])
      # Location 在不同層
      _(store.location_lat.must_equal array_hash.map{|item|item.map{|i| i['geometry']['location']['lat']} }[0][0])
      _(store.location_lng.must_equal array_hash.map{|item|item.map{|i| i['geometry']['location']['lng']} }[0][0])

    end
    
    # 1. 要refactor
    # 2. place_api argument @@ & @要重新設計
    # 3. 理想狀態，老師要求的是spec on raise exception，詳見老師repo
    it 'SAD: should provide correct TOKEN_NAME' do
      PlaceInfo::PlaceApi.new('新竹', "FAKE_TOKEN").store('新竹',"FAKE_TOKEN").response_nil?.must_equal true
    end
  end

  describe 'Reviews information' do
    array_hash = CORRECT_STORE[0..].map{|key| CORRECT[key]['results']}
    before do
      @review = PlaceInfo::PlaceApi.new(KEYWORD_FILTER, TOKEN_NAME).reviews(KEYWORD_FILTER,TOKEN_NAME)
    end

    it 'HAPPY: should identify reviews number' do
      reviews = @review.rating[0]
      _(reviews).must_equal array_hash.map{|item|item.map{|i| i['rating']} }[0][0]
    end
  end
end
