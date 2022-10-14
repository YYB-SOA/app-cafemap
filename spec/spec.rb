# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/News_main'
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
    project = Aritcle_info::NewsApi.new(news_token).news_hash_generator

    it 'HAPPY: should provide correct project attributes' do
      _(project['status']).must_equal CORRECT['status']
    end

    it 'HAPPY: should provide correct project attributes' do
      _(project['articles'].length).must_equal CORRECT['articles'].length
    end
    it 'HAPPY: should provide correct project attributes' do
      benchmark = CORRECT['articles'][0].keys
      box = []
      project['articles'].select { |article| box << article.keys.any? { |item| benchmark.include? item } }
      _(box.include?(false)).must_equal false
    end
    it 'HAPPY: should provide correct project attributes' do
      box = []
      # print project["articles"].reduce{|itema, itemb| itema['title'].nil? * itemb['title'].nil?}
      project['articles'].select { |item| box << item['title'].nil? }
      _(box.include?(false)).must_equal true
    end
  end
end
