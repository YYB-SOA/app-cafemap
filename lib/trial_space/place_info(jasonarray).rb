# frozen_string_literal: true

require 'yaml'
require 'json'
require 'http'

# copy place_info new
# json array -> json file
# place_info_new
def read_cafe(path = 'lib/sample/cafe_nomad?.json')
  JSON.parse(File.read(path))
end

def read_cafe_attribute(data_hash, attribute = nil)
  box = []
  if attribute.nil?
    box = data_hash
    puts "Condition 1 #{puts data_hash}"
  else
    data_hash.select { |ele| box << ele[attribute] }
  end
  box
end

def get_placeapi_token(token_category = 'GOOGLE_MAP', name_of_key = 'Place_api')
  config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
  config_yaml[token_category][0][name_of_key]
end

def call_placeapi_url(input)
  token = get_placeapi_token
  HTTP.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW")
end

def noise_filter(name_str)
  # Normalization
  name_str.gsub('暫停營業', '').gsub('()', '').gsub(' ', '').gsub("\b", '')
end

def data_clean(box)
  # Input: string array of cafe name
  box.map { |name_str| noise_filter(name_str) }
end

def save_to_yaml(json_file, dist)
  # Save hash to yaml and keep insert value to
  File.open(dist, 'w') do |file|
    file.puts json_file.to_yaml
  end
end

def location_filter(input, attribute, word_term)
  input.select! { |item| item[attribute].include? word_term }
end

def main(path) # rubocop:disable Metrics/MethodLength
  # call_place_url
  cafe_raw = read_cafe(path)
  # puts "cafe_raw 1#{ puts cafe_raw}"
  regional_cafe = location_filter(cafe_raw, 'address', '新竹')
  regional_cafe_name = read_cafe_attribute(regional_cafe, 'name')
  clean_name = data_clean(regional_cafe_name)
  puts "cafe_all 4#{clean_name}"
  output = {}
  dist = 'spec/fixtures/cafe_place_api_results.yml'

  (0..(clean_name.length - 1)).each do |number|
    key = clean_name[number]
    puts "No: #{number} #{key}"
    output[key] = call_placeapi_url(key).parse
    save_to_yaml(output, dist) # 先在fixture下建立yml檔案
  end
end
puts main('lib/sample/cafe_nomad1.json')

# puts main('lib/sample/cafe_nomad.json')
# puts [1,2,3,4,5,6].select(&:even?)
# open(file.path) as f:
