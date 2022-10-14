# frozen_string_literal: true

require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

config = YAML.safe_load(File.read('config/secrets.yml'))

def news_api_path(path)
  "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{path}"
end
key = config['api'][0]['News']
full_url = news_api_path(key)
# def call_gh_url(config, url)
#   HTTP.headers('Accept' => 'application/vnd.github.v3+json',
#                'Authorization' => "token #{config['GITHUB_TOKEN']}").get(url)

# end

# def call_news_url(url)
#     url_path = news_api_path(url)
#     uri = URI.parse(url_path)
#     req = Net::HTTP::Get.new(uri.request_uri)
#     https = Net::HTTP.new(uri.host, uri.port)
#     https.use_ssl = true
#     res = https.request(req)
#     JSON.parse(res.body)
# end

def call_news_url(url)
  full = URI(url)
  res = Net::HTTP.get_response(full)
  JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
end

news_json = call_news_url(full_url)
puts news_json["articles"][0].keys

# print news_json
# File.write('lib/sample/news.json', JSON.dump(news_json))

# File.open("lib/sample/news.json", "w") do |f|
#     f.write(JSON.pretty_generate(news_json))
#   end
# def hash_to_json(data, dist)
#   # Save it!
#   f_data = File.open(dist, 'w')
#   f_data.write(data)
#   f_data.close
# end

# hash_to_json(news_json, 'lib/sample/news.json')
#

# File.open("spec/fixture/results.yml", 'w') do |file|
#   file.puts news_json.to_yaml
# end
