# frozen_string_literal: true

require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

cafenomad_url = 'https://cafenomad.tw/api/v1.2/cafes'

def call_cafe_url(url)
  uri = URI.parse(url)
  req = Net::HTTP::Get.new(uri.request_uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  res = https.request(req)
  JSON.parse(res.body)
end

cafe_json = call_cafe_url(cafenomad_url)

# Save Parsed Json dict as JSON file
File.write('lib/sample/cafe_nomad.json', JSON.dump(cafe_json))

csv_string = CSV.generate do |csv|
  JSON.parse(File.read('lib/sample/cafe_nomad.json')).each do |hash|
    csv << hash.values
  end
end
# Save CSV File
File.write('lib/sample/cafe_nomad.csv', csv_string)
# No test Demo for this API
