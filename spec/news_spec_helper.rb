# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/news_api'

# USERNAME = 'soumyaray'
# PROJECT_NAME = 'YPBT-app'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
BOX = [nil]
NEWS_TOKEN = CONFIG['NEWS_API'][0]['News']
CORRECT = YAML.safe_load(File.read('spec/fixtures/news_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'news_api'
