# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/news_api'
require 'http'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

# api跑完後的結果
CORRECT = YAML.safe_load(File.read('spec/fixture/results.yml'))
news_token = 'News'

describe 'Tests News API library' do
  describe 'News information' do
    article_hash = AritcleInfo::NewsApi.new(news_token).news_hash_generator

    it 'HAPPY: should provide correct News status' do
      _(article_hash['status']).must_equal CORRECT['status']
    end

    it 'HAPPY: should provide correct News quantity' do
      _(article_hash['articles'].length).must_equal CORRECT['articles'].length
    end
    it 'HAPPY: should provide correct News attributes' do
      benchmark = CORRECT['articles'][0].keys
      box = []
      article_hash['articles'].select { |article| box << article.keys.any? { |item| benchmark.include? item } }
      _(box.include?(false)).must_equal false
    end
    it 'HAPPY: the title of news should not be nil' do
      box = []
      # print project["articles"].reduce{|itema, itemb| itema['title'].nil? * itemb['title'].nil?}
      article_hash['articles'].select { |item| box << item['title'].nil? }
      _(box.include?(false)).must_equal true
    end
  end
end
