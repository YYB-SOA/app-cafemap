# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative './lib/News_api'

config = YAML.safe_load(File.read('config/secrets.yml')) #yaml
def news_api_path(path)
   "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{path}"
end
key = config['api'][0]['News']
full_url = news_api_path(key)
 
# # 回傳結果hash
# def call_news_url(url)
#    full = URI(url)
#    res = Net::HTTP.get_response(full)
#    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
# end
 
# news_hash = call_news_url(full_url)
 
 
# api跑完後的結果
CORRECT = YAML.safe_load(File.read('spec/fixtures/github_results.yml')) 
test_keys = CORRECT["articles"][0].keys

#describe "columns numbers" do

#end

describe 'Tests News API library' do
  describe 'News information' do
    it 'HAPPY: should provide correct project attributes' do

      data = call_news_url(news_api_path('news'))  
      project = Aritcle_info::NewsApi.new().????Yuan(data)
      _(project.size).must_equal CORRECT['size']
      _(project.git_url).must_equal CORRECT['git_url']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        CodePraise::NewsApi.new(GITHUB_TOKEN).project('soumyaray', 'foobar')
      end).must_raise CodePraise::NewsApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::NewsApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Errors::Unauthorized
    end
  end

  describe 'Contributor information' do
    before do
      @project = CodePraise::NewsApi.new(GITHUB_TOKEN)
                                      .project(USERNAME, PROJECT_NAME)
    end

    it 'HAPPY: should recognize owner' do
      _(@project.owner).must_be_kind_of CodePraise::Contributor
    end

    it 'HAPPY: should identify owner' do
      _(@project.owner.username).wont_be_nil
      _(@project.owner.username).must_equal CORRECT['owner']['login']
    end

#     it 'HAPPY: should identify contributors' do
#       contributors = @project.contributors
#       _(contributors.count).must_equal CORRECT['contributors'].count

#       usernames = contributors.map(&:username)
#       correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
#       _(usernames).must_equal correct_usernames
#     end
#   end
# end