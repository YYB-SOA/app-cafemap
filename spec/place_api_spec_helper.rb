# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_relative '../app/models/mappers/store_mapper'
require_app

KEYWORD_FILTER = '新竹'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
TOKEN_NAME = 'Place_api'

PLACE_TOKEN = CONFIG['GOOGLE_MAP'][0][TOKEN_NAME]
TEST_STORE = ["WHO'S 喜象 CAFE", 'ARTROOM14藝室']

CORRECT = YAML.safe_load(File.read('spec/fixtures/place_results.yml'))
CORRECT_STORE = CORRECT.keys[0..]

FAKE_TEST_STORE = ['']
INCORRECT = YAML.safe_load(File.read('spec/fixtures/place_bad_results.yml'))


# puts CORRECT
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'place_api'
