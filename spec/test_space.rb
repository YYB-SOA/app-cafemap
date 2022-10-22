require_relative 'news_spec_helper'

@article_hash = AritcleInfo::NewsApi.new('News').news_hash_generator
p @article_hash['status']


