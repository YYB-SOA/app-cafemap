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

  describe 'Store information' do
    it 'HAPPY: should provide correct api status attributes' do
      # PlaceApi會繼承module Store class 的特定參數，目前store檔案只有傳入store_yaml，可能不適合
      # 老師範例中有額外傳入data_source，不知道是啥意思
      api_status = CafeNomad::CafeApi.new("CAFE_NOMAD", CAFE_TOKEN).api_status
      _(api_status.status).must_equal CORRECT['status']
      _(api_status.amount).must_equal CORRECT['amount']
      _(api_status.header).must_equal CORRECT['header']
    end
    # it 'SAD: should provide correct TOKEN_NAME' do
    #   CafeNomad::CafeApi.new("CAFE_NOMAD", FAFE_TOKEN).api_status.response_nil?.must_equal true
    # end
    # it 'SAD: should raise exception on incorrect project' do
    #   _(proc do
    #     CafeNomad::CafeApi.new("CAFE_NOMAD", FAFE_TOKEN)
    #   end).must_raise CodePraise::GithubApi::Response::NotFound
    # end
  end
  describe 'cafe nomad  information' do
    before do
      @api_info = CafeNomad::CafeApi.new("CAFE_NOMAD", CAFE_TOKEN).api_info
      @cafe_yaml_keys = CORRECT.keys[3..-1] 
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

    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.id}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["id"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.name}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["name"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.city}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["city"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.wifi}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["wifi"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.seat}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["seat"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.quiet}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["quiet"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.tasty}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["tasty"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.cheap}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["cheap"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.music}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["music"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.url}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["url"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.address}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["address"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.latitude}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["latitude"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.longitude}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["longitude"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.limited_time}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["limited_time"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.socket}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["socket"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.standing_desk}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["standing_desk"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.mrt}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["mrt"]} 
    end
    it 'HAPPY: should recognize owner' do
      _(@api_info.map{|item| item.open_time}).must_equal @cafe_yaml_keys.map{|item| CORRECT[item]["open_time"]} 
    end
  end
end