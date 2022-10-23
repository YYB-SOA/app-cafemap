# frozen_string_literal: true

require 'yaml'
require 'json'
require 'http'

class Placeinfo # rubocop:disable Style/Documentation
  def initialize(token_name, path, dist)
    @token_name = token_name # @token_name ＝'Place_api' #要改 #之後需要從spec_helper直接取token
    @path = path
    @dist = dist
  end

  #  Get Cafe data
  def read_cafe(path)
    JSON.parse(File.read(path))
  end

  def location_filter(input, attribute, word_term)
    input['row_data'].select! { |key| key[attribute].include? word_term }
  end

  def read_cafe_attribute(data_hash, attribute = nil)
    box = []
    # if attribute.nil?
    if attribute.empty?
      box = data_hash
    else
      data_hash.select { |ele| box << ele[attribute] }
    end
    box
  end

  def noise_filter(name_str)
    # Normalization
    name_str.gsub('()', '').gsub(' ', '').gsub("\b", '')
  end

  def data_clean(box)
    # Input: string array of cafe name
    box.map { |name_str| noise_filter(name_str) }
  end

  def get_placeapi_token(token_name)
    config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
    config_yaml['GOOGLE_MAP'][0][token_name]
  end

  def call_placeapi_url(input, token_name)
    token = get_placeapi_token(token_name)
    HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")
  end

  def call_placeapi_storename(token_name, clean_name, dist)
    # call google place api
    output = {} # 回傳符合資格資料(可能多筆)

    (0..(clean_name.length - 1)).each do |number|
      key = clean_name[number]
      output[key] = call_placeapi_url(key, token_name).parse
      save_to_yaml(output, dist) # 先在fixture下建立yml檔案
    end
  end

  def save_to_yaml(json_file, dist)
    # Save hash to yaml and keep insert value to
    File.open(dist, 'w') do |file|
      file.puts json_file.to_yaml
    end
  end

  def main
    # call_place_url
    cafe_raw = read_cafe(@path)
    # filter by location
    regional_cafe = location_filter(cafe_raw, 'address', '新竹')
    # select data column for goolge place api
    regional_cafe_name = read_cafe_attribute(regional_cafe, 'name')
    # data_cleaning
    clean_name = data_clean(regional_cafe_name)
    # call api with name and store as yml
    call_placeapi_storename(@token_name, clean_name, @dist)
  end
end

Placeinfo.new('Place_api', 'db/sample/cafe_nomad9.json', 'spec/fixtures/cafe_place_api_results_new.yml').main

# puts main('Place_api', 'db/sample/cafe_nomad9.json', 'spec/fixtures/cafe_place_api_results_new.yml')
