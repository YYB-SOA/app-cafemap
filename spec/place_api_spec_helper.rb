# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

# require_relative '../lib/place_api/place_api'
require_relative '../require_app'
require_app

KEYWORD_FILTER = '新竹'
# FIRST_KEYWORD = FILTER_KEYWORD[0]
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
TOKEN_NAME = 'Place_api'
# CORRECT = YAML.safe_load(File.read('spec/fixtures/place_results.yml'))
PLACE_TOKEN = CONFIG['GOOGLE_MAP'][0][TOKEN_NAME]

CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_place_api_results_new.yml')) 
CORRECT_STORE = CORRECT.keys
# puts CORRECT
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'place_api'
