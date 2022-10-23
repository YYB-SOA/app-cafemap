# frozen_string_literal: true

# require 'http' 
# Because one of out tammate have some unknown issue in his environment
require 'yaml'
# require 'httparty'
require 'json'
require 'net/http'
require 'uri'
require_relative 'api_info'
require_relative 'api_status'

module CafeNomad
  class CafeApi
    def initialize(token_category, token) # token 這邊要 call "Cafe_api"，後面透過這個 token 去 secret.yml 抓資料
        @token = token
        @cafenomaf_api = Request.new(token_category, @token).call_cafe_url
    end
    def api_status()
        Apistatus.new(Cafeyaml.new(@cafenomaf_api).json_array_to_yaml)
    end
    def api_info()
        @cafenomaf_api.map{|each_store| ApiInfo.new(each_store)}
    end
  end
  
  # 呼叫 API 並將資料以 JSON Array 格式儲存
  class Request
    def initialize(token_category = "CAFE_NOMAD", token)
        @token_category = token_category
        @token = token
        config = YAML.safe_load(File.read('config/secrets.yml'))
        @full_url = config[token_category][0][token]
    end
    def call_cafe_url(url = @full_url) 
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri.request_uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      res = https.request(req)
      @cafe_json = JSON.parse(res.body) # Json Array
    end
  end
  # 將讀進來的資料轉成我們要的壓模（or hash）格式（內含 status 等）
  class Cafeyaml
    def initialize(data) # 這邊丟進來的東西應該要是一個 json array
        @data = data
    end
    def json_array_to_yaml
      store = {}
      if @data != nil
          store["status"] = "ok"
      end
      store["amount"] = @data.length
      store["header"] = @data[0].keys
      @data.each do |each_store|
          cafe_name = each_store["name"] + "{" + each_store["id"].split("-")[0]
          store[cafe_name] = each_store
      end
      return store
    end
  end
end



# def call_cafe_url(url) # 抓 cafe api
#   # input url; output JSON Array
#   uri = URI.parse(url)
#   req = Net::HTTP::Get.new(uri.request_uri)
#   https = Net::HTTP.new(uri.host, uri.port)
#   https.use_ssl = true
#   res = https.request(req)
#   # return a JSON ARRAY!!
#   JSON.parse(res.body)
# end

# def json_array_to_json(cafe_json)
#   headers = cafe_json[0].keys #第一個裡面的 keys 就會是全部人的 keys
#   puts "headers: #{headers}"

#   new_hash = {}
#   # 如果叫進來的 cafe_json 沒東西，把 new_hash 的 status 設為 fail；有東西則設為 ok 
#   cafe_json.nil?? new_hash["status"] = "Fail": new_hash["status"] = "ok" 
#   new_hash['row_data'] = cafe_json
#   new_hash
# end


# def save_json(json_hash, path )
#   File.open(path, "w") do |f|
#     f.puts(json_hash.to_json)
# end


# cafenomad_url = 'https://cafenomad.tw/api/v1.2/cafes' # Call secret.yml
# cafe_jarray = call_cafe_url(cafenomad_url)
# cafe_json = json_array_to_json(cafe_jarray)
# puts cafe_json["row_data"].length



# save_json(cafe_json,"db/sample/cafe_nomad1.json" )

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
# jArraytoCsv("db/sample/cafe_nomad.json","db/sample/cafe_nomad.csv" )