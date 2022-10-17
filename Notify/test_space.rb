# frozen_string_literal: true

require 'yaml'

def read_secret_token(token_category, name_of_key)
  config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
  config_yaml[token_category][0][name_of_key]
end
leimen_token = read_secret_token('LINEBOT_NOTIFY_API', 'Gift-List(test1)')
p leimen_token
