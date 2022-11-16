# frozen_string_literal: true

# Because one of out tammate have some unknown issue in his environment
require 'yaml'
require 'json'
require 'net/http'
require 'uri'

require_relative 'api_info'
require_relative 'api_status'

module CafeNomad
  class CafeApi
    # token 這邊要 call "Cafe_api"，後面透過這個 token 去 secret.yml 抓資料
    def initialize(token_category, token)
      @token = token
      @cafenomaf_api = Request.new(token_category, @token).call_cafe_url
    end

    def api_status
      Apistatus.new(Cafeyaml.new(@cafenomaf_api).json_array_to_yaml)
    end

    def api_info
      @cafenomaf_api.map { |each_store| ApiInfo.new(each_store) }
    end
  end

  # 呼叫 API 並將資料以 JSON Array 格式儲存
  class Request
    def initialize(token_category = 'CAFE_NOMAD', token)
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
    # 這邊丟進來的東西應該要是一個 json array
    def initialize(data)
      @data = data
    end

    def json_array_to_yaml
      store = {}
      store['status'] = 'ok' unless @data.nil?
      store['amount'] = @data.length
      store['header'] = @data[0].keys
      @data.each do |each_store|
        cafe_name = "#{each_store['name']}{#{each_store['id'].split('-')[0]}"
        store[cafe_name] = each_store
      end
      store
    end
  end
end
