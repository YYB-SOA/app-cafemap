# frozen_string_literal: true

require 'http'
require 'yaml'
# frozen_string_literal: true

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
    JSON.parse(File.open("lib/sample/cafe_nomad.json").read).each do |hash|
        csv << hash.values
    end
end
# p csv_string


# Save CSV File
File.write("lib/sample/cafe_nomad.csv",csv_string)

nomad_response = {}
nomad_results = {}

## HAPPY project request
project_url = cafenomad_url
nomad_response[project_url] = call_cafe_url(project_url)


# p nomad_response[0]
p nomad_response
# p project
# project = nomad_response[1][project_url].parse

# gh_results['size'] = project['size']
# # should be 551
