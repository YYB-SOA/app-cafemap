# frozen_string_literal: true

require 'http'
require 'yaml'
# frozen_string_literal: true

require 'httparty'
require 'json'
require 'net/http'
require 'uri'

cafenomad_url = 'https://cafenomad.tw/api/v1.2/cafes'

def api(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.request_uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    res = https.request(req)
    JSON.parse(res.body)
end



cafe_json = api(cafenomad_url)
print cafe_json
# csv_string = CSV.generate do |csv|
#     JSON.parse(File.open("foo.json").read).each do |hash|
#       csv << hash.values
#     end
#   end
  
#   puts csv_string
