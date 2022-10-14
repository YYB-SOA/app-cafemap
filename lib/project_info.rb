# frozen_string_literal: true
 
require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'
 
 
def news_api_path(path)
  "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{path}"
end
 
def call_news_url(url)
  full = URI(url)
  res = Net::HTTP.get_response(full)
  JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
end
 
# print news_json
def hash_to_json(hash_data, dist)
  # Save it!
  temp = hash_data.to_json
  # f_data = File.open(dist, 'w')
  # f_data.write(data)
  # f_data.close
 
end
 
 
 
def get_full_url(api_url_name = 'News')
  # Added the folder 'config/secrets.yml' first
  config = YAML.safe_load(File.read('config/secrets.yml'))
  key = config['api'][0][api_url_name]
  news_api_path(key)
end
 
 
def save_to_yaml(json_file, dist)
  File.open(dist, 'w') do |file|
    file.puts json_file.to_yaml
  end
end
 
## 以News API url 為例子
full_url = get_full_url() # 找到含有key的url
news_json = call_news_url(full_url) # Call他拿json轉成hash
 
# puts news_json['status'] == 'ok'
# puts news_json['articles'].length # = 20
 
benchmark = ['source','author','title','description','url','urlToImage','publishedAt','content']
 
# puts news_json['articles'].each_key{ |keys|  keys.any? { |i| benchmark.include? i }  }
check_box = []
news_json['articles'].select{ |article|  check_box<<  article.keys.any? { |i| benchmark.include? i } }
puts check_box.include?(false) == false
 
 
 
 
# hash_to_json(news_json, 'lib/sample/news.json')
 
#````````````````````````
 
## HAPPY project request
api_response = {}
api_result = {}
## 以News API url 為例子
news_url = get_full_url(api_url_name = 'News') # get full News url
hash_content = call_news_url(news_url)
 
api_response[news_url] =  hash_content
 
api_response_content = api_response
 
 
api_result["status"] = api_response_content[news_url]['status']
# Should equal ok
 
api_result["Article_Quantity"] = api_response_content[news_url]['articles'].length
# Should equal 20
 
article_no = 0
api_result["Article_#{article_no}_Column"] = hash_content['articles'][article_no].keys
# Should equal ["source", "author", "title", "description", "url", "urlToImage", "publishedAt", "content"]
 
 
api_result["Article_#{article_no}_Title"] = hash_content['articles'][article_no]['title']
# Article Title should not equal 'nil'
 
 
# news_contents = api_response[news_url]
# #project = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=f3c1acee07784d5394185efbe449bba0"
 
puts api_result
 
 
 
# File.write('spec/fixtures/github_results.yml', api_results.to_yaml)
save_to_yaml(json_file = news_json,dist = "spec/fixture/results.yml" ) # 先save成yaml (不知道為何)
 

