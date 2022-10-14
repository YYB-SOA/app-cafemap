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

# Save Parsed Json dict as JSON file
File.write('lib/sample/cafe_nomad.json', JSON.dump(cafe_json))


csv_string = CSV.generate do |csv|
    JSON.parse(File.open("lib/sample/cafe_nomad.json").read).each do |hash|
        csv << hash.values
    end
end
p csv_string

File.write("lib/sample/cafe_nomad.csv",csv_string)
# require_relative 'csv_buddy'
# require_relative 'json_buddy'

# # Converts tabular data between storage formats
# class FlipFlap
#   # Do NOT create an initialize method
#   include csvBuddy # Get the method in this module # Class 用include 從module繼承method
#   include jsonBuddy # Get the method in this module
#   attr_reader :data

#   def self.input_formats
#     method_names = instance_methods.map(&:to_s) 
#     outputs = method_names.select { |method| method.match(/^take_/) } # 根據block的條件去篩選陣列裡面的元素到一個新的陣列
#     outputs ? outputs.map { |method| method[5..] } : [] # content從第6欄位開始
#   end
# end
