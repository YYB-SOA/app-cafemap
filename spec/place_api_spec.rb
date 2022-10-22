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
        # 老師範例中有額外傳入data_source，不知道是啥意思
        shop = PlaceInfo::PlaceApi.new(PLACE_TOKEN)
                                     .store(??, filter_)
     # 以下兩行根據shop_info傳入place_results['變數名稱'] (yml檔案)替換size與git_url

      _(shop.headers).must_equal CORRECT['result']['header']
      _(shop.location).must_equal CORRECT['result']['geometry']['location']
    end

    it 'SAD: should raise exception on incorrect store' do
      _(proc do
        PlaceInfo::PlaceApi.new(PLACE_TOKEN).store(STORE_NAME, FILTER_KEYWORD)
      end).must_raise PlaceInfo::GithubApi::Response::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        PlaceInfo::PlaceApi.new('BAD_TOKEN').store(STORE_NAME, FILTER_KEYWORD)
      end).must_raise PlaceInfo::PlaceApi::Response::Unauthorized
    end
  end

  describe 'Reviews information' do
    before do
      @store = PlaceInfo::PlaceApi.new(PLACE_TOKEN).store(STORE_NAME, FILTER_KEYWORD)
    end
    ##   Owner Role we don't have this kind of role
    # it 'HAPPY: should recognize owner' do
    #   _(@store.owner).must_be_kind_of PlaceInfo::Reviews
    # end

    # it 'HAPPY: should identify owner' do
    #   _(@store.owner.storename).wont_be_nil
    #   _(@store.owner.storename).must_equal CORRECT['results']['name']
    # end
#--------------------------review/feedback-----------
    it 'HAPPY: should identify reviews number' do
      reviews = @store.reviews
      _(reviews.count).must_equal CORRECT['reviews'].count

      review = reviews.map(&:review)
      correct_reviews = CORRECT['result']['reviews'].count
      _(review).must_equal correct_reviews
    end
  end
end