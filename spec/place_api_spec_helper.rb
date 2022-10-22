# frozen_string_literal: true

# require 'simplecov'
# SimpleCov.start

require 'yaml'

# require 'minitest/autorun'
# require 'minitest/rg'
# require 'vcr'
# require 'webmock'

require_relative '../lib/place_api/place_api'

STORE_NAME = 'ARTROOM14藝室'
FILTER_KEYWORD = ['東區'].freeze
FIRST_KEYWORD = FILTER_KEYWORD[0]

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))

PLACE_TOKEN = CONFIG['GOOGLE_MAP'][0]['Place_api']
CORRECT = YAML.safe_load(File.read('spec/fixtures/place_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'place_api'
