# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

# require 'simplecov'
# SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative '../../require_app'
require_relative '../../app/domain/cafenomad/mappers/info_mapper.rb'
require_relative '../../config/environment'
# require_app

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))

CAFE_TOKEN = CafeMap::App.config.CAFE_TOKEN
# puts CAFE_TOKEN

CAFE_CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_results.yml'))
FAKE_TOKEN = 'Fake_api'

# PLACE_API

KEYWORD_FILTER = '新竹'
TOKEN_NAME = 'Place_api'


PLACE_TOKEN = CafeMap::App.config.PLACE_TOKEN
# puts PLACE_TOKEN
TEST_STORE = ["WHO'S 喜象 CAFE", 'ARTROOM14藝室']
FAKE_TEST_STORE = ['']
PLACE_CORRECT = YAML.safe_load(File.read('spec/fixtures/place_results.yml'))
STORE_CORRECT = PLACE_CORRECT.keys[0..]
INCORRECT = YAML.safe_load(File.read('spec/fixtures/place_bad_results.yml'))



def ans_sheet(target_attr, data_keys, correct)
    # This func is to replace the original duplicate code below:
    # @yaml_keys.map { |item| CORRECT[item]['id'] }
  data_keys.map do |item|
    correct[item][target_attr]
  end
end
