# frozen_string_literal: true

require 'roda'
require 'yaml'

module CafeMap
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    CAFE_TOKEN_NAME = 'Cafe_api'
    PLACE_TOKEN_NAME = 'Place_api'
    CAFE_TOKEN = CONFIG['CAFE_NOMAD'][0]['Cafe_api']
    PLACE_TOKEN = CONFIG['GOOGLE_MAP'][0]['Place_api']
  end
end
