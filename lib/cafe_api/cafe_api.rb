# frozen_string_literal: true

# require 'http' 
# Because one of out tammate have some unknown issue in his environment
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

cafenomad_url = 'https://cafenomad.tw/api/v1.2/cafes'

# {"id":"00014645-38c8-4eb4-ad9b-faa871d7e511","name":"R5小餐館","city":"chiayi",
#"wifi":5,"seat":5,"quiet":5,"tasty":5,"cheap":5,"music":5,
# "url":"https://www.facebook.com/r5.bistro","address":"嘉義市東區忠孝路205號",
# "latitude":"23.48386540","longitude":"120.45358340","limited_time":"maybe",
# "socket":"maybe","standing_desk":"no","mrt":"","open_time":"11:30~21:00"}

def call_cafe_url(url)
  # input url; output JSON Array
  uri = URI.parse(url)
  req = Net::HTTP::Get.new(uri.request_uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  res = https.request(req)
  # return a JSON ARRAY!!
  JSON.parse(res.body)
end

def json_array_to_json(cafe_json)
  headers = cafe_json[0].keys
  puts "headers: #{headers}"

  new_hash = {}
  cafe_json.nil?? new_hash["Status"] = "Fail": new_hash["Status"] = "ok" 
  new_hash['row_data'] = cafe_json
  new_hash
end


def save_json(json_hash, path )
  File.open(path, "w") do |f|
    f.puts(json_hash.to_json)
  end
end


cafe_jarray = call_cafe_url(cafenomad_url)
cafe_json = json_array_to_json(cafe_jarray)
save_json(cafe_json,"db/sample/cafe_nomad1.json" )

# def save_jarr(json_array, output_path)
#   # Save Parsed Json ARRAY Directly
#   # It's not working
#   File.write(output_path, JSON.dump(json_array))
# end 


# def jArraytoCsv(json_array_path, csv_path)
#   csv_string = CSV.generate do |csv|
#     JSON.parse(File.read(json_array_path)).each do |hash|
#       csv << hash.values
#     File.write(csv_path, csv_string)
#     end
#     # No test Demo for this API
#   end
# end

# cafe_json = call_cafe_url(cafenomad_url)
# puts cafe_json[0]
# save_arr(cafe_json, 'lib/sample/cafe_nomad.json' )
# # jArraytoCsv("db/sample/cafe_nomad.json","db/sample/cafe_nomad.csv" )

