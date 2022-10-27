# frozen_string_literal: true

require 'http'
require 'yaml'
require 'json'
require 'net/http'
require 'uri'

# question:
# (3). 需要把它(這個檔案) 取代掉舊的cafe_api，或是用來當cafe info

# 我要 call serect.yml 裡面的 cafe_api 網址
def url_concat(token)
  # "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{token}"
  token
end

# 這步目的是透個 secret.yml 拿出 token(aka cafe api網址) ，最後丟入 url_concat(token)，假裝取得完整網址。
def get_full_url(token_category, name_of_key)
  # Added the folder 'config/secrets.yml' first
  config = YAML.safe_load(File.read('config/secrets.yml'))
  token = config[token_category][0][name_of_key]
  url_concat(token)
end

def call_cafe_url(url)
  uri = URI.parse(url)
  req = Net::HTTP::Get.new(uri.request_uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  res = https.request(req)
  JSON.parse(res.body)
end

def json_array_to_yaml(cafe_json)
  store = {}
  store['status'] = 'ok' unless cafe_json.nil?
  store['amount'] = cafe_json.length
  store['header'] = cafe_json[0].keys
  cafe_json.each do |each_store|
    cafe_name = "#{each_store['name']}{#{each_store['id'].split('-')[0]}"
    store[cafe_name] = each_store
  end
  store
end

# def save_yaml(yaml_hash, path)
#   File.write(path, yaml_hash)
# end

def main(token_category, name_of_key, output_path)
  cafenomad_url = get_full_url(token_category, name_of_key)
  cafe_json = call_cafe_url(cafenomad_url)
  cafe_yaml = json_array_to_yaml(cafe_json)
  # save_yaml(cafe_yaml, output_path)
  File.write(output_path, cafe_yaml.to_yaml)
  cafe_yaml
end

# cafenomad_url = get_full_url("CAFE_NOMAD", "Cafe_api")
# cafe_json = call_cafe_url(cafenomad_url) # return a json array
# puts "API 裡有的資料數：#{cafe_json.length}"

cafe_response = main('CAFE_NOMAD', 'Cafe_api', 'spec/fixtures/cafe_nomad3.yml')

cafe_results = {}

cafe_results['status'] = cafe_response['status']
# should be ok

cafe_results['amount'] = cafe_response['amount']
# should be 3488

cafe_results['header'] = cafe_response['header']
# should be ["id", "name", "city", "wifi", "seat", "quiet", "tasty", "cheap", "music", "url", "address", "latitude", "longitude", "limited_time", "socket", "standing_desk", "mrt", "open_time"]

File.write('db/sample/cafe_nomad1.yml', cafe_results.to_yaml)
