# frozen_string_literal: true

require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

require 'yaml'
require_relative 'News_main.rb'

freshman = Aritcle_info::NewsApi.new("News")

x = freshman.news_hash_generator()
benchmark = ["source", "author", "title", "description", "url", "urlToImage", "publishedAt", "content"]
box = []
x["articles"].select{|item| box << item['title'].nil? }
puts box.include?(false) == true



# box = []
# x["articles"].select{ |article|  box  <<  article.keys.any? { |item| benchmark.include? item } }
# puts box.include?(false) == false



# benchmark = ['source','author','title','description','url','urlToImage','publishedAt','content']
 
# puts news_json['articles'].each_key{ |keys|  keys.any? { |i| benchmark.include? i }  }
# check_box = []
# news_json['articles'].select{ |article|  check_box<<  article.keys.any? { |i| benchmark.include? i } }
# puts check_box.include?(false) == false