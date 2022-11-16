# frozen_string_literal: true

require 'yaml'
require 'json'
require 'http' # We use HTTP here cuz we solve the environment issue

# Get Cafe data
def read_cafe(path = 'db/sample/cafe_nomad9.json')
  JSON.parse(File.read(path))
end

def location_filter(input, attribute, word_term)
  input['row_data'].select! { |key| key[attribute].include? word_term }
end

def read_cafe_attribute(data_hash, attribute = empty)
  box = []
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

def get_placeapi_token(token_category = 'GOOGLE_MAP', name_of_key = 'Place_api')
  config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
  config_yaml[token_category][0][name_of_key]
end

def call_placeapi_url(input, token_name)
  token = get_placeapi_token(token_name)
  HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")
end

def call_placeapi_storename(clean_name, dist)
  # call google place api
  output = {} # 回傳符合資格資料(可能多筆)

  (0..(clean_name.length - 1)).each do |number|
    key = clean_name[number]
    output[key] = call_placeapi_url(key).parse
    save_to_yaml(output, dist) # 先在fixture下建立yml檔案
  end
end

def save_to_yaml(json_file, dist)
  # Save hash to yaml and keep insert value to
  File.open(dist, 'w') do |file|
    file.puts json_file.to_yaml
  end
end

def main(path, dist)
  # call_place_url
  cafe_raw = read_cafe(path)
  # filter by location
  regional_cafe = location_filter(cafe_raw, 'address', '新竹')
  # select data column for goolge place api
  regional_cafe_name = read_cafe_attribute(regional_cafe, 'name')
  # data_cleaning
  clean_name = data_clean(regional_cafe_name)
  call_placeapi_storename(clean_name, dist)
end

puts main('db/sample/cafe_nomad9.json', 'spec/fixtures/cafe_place_api_results_new.yml')
