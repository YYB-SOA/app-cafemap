# frozen_string_literal: true

require 'simplecov'
# SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../app/models/mappers/info_mapper'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))

CAFE_TOKEN = CONFIG['CAFE_NOMAD'][0]['Cafe_api']

CORRECT = YAML.safe_load(File.read('spec/fixtures/cafe_results.yml'))
FAKE_TOKEN = 'Fake_api'

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'cafe_api'

def ans_sheet(target_attr, data_keys)
  # This func is to replace the original duplicate code below:
  # @yaml_keys.map { |item| CORRECT[item]['id'] }

  data_keys.map do |item|
    CORRECT[item][target_attr]
  end
end
