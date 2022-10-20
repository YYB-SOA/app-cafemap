# frozen_string_literal: true

# 缺人的test

require_relative 'news_spec_helper'

describe 'Tests News API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<NEWS_TOKEN>') { NEWS_TOKEN }
    c.filter_sensitive_data('<NEWS_TOKEN_ESC>') { CGI.escape(NEWS_TOKEN) }
  end
  # What's CGI. escape is for escaping a URL value in the query string
  # https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'News information' do
    before do
      @contents = AritcleInfo::NewsApi.new('News')#.news_hash_generator
      # print "abd: #{@article_hash}"
    end

    it 'HAPPY: should provide correct News attributes' do
      article_hash = @contents.news_hash_generator('NEWS_API')
      print "class123: #{article_hash}"
      _(article_hash['status']).must_equal CORRECT['status']
      _(article_hash['articles'].length).must_equal CORRECT['articles'].length
    end
  end
    # it 'HAPPY: should provide correct article columns' do
    #   benchmark = CORRECT['articles'][0].keys
    #   #puts "benchmark: #{benchmark}"
    #   @article_hash['articles'].select { |article| BOX << article.keys.any? { |item| benchmark.include? item } }
    #   _(BOX.include?(false)).must_equal false
    # end

    # it 'HAPPY: should provide valid article title' do
    #   article_hash['articles'].select { |item| BOX << item['title'].nil? }
    #   _(BOX.include?(false)).must_equal true
    # end

    ## 針對角色來做測試
    # it 'SAD: should raise exception on incorrect project' do
    #   _(proc do
    #     AritcleInfo::NewsApi.new(GITHUB_TOKEN).project('soumyaray', 'foobar')
    #   end).must_raise CodePraise::GithubApi::Response::NotFound
    # end

    # it 'SAD: should raise exception when unauthorized' do
    #   _(proc do
    #     CodePraise::GithubApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
    #   end).must_raise CodePraise::GithubApi::Response::Unauthorized
    # end

  ## 針對角色來做測試
  #   describe 'Contributor information' do
  #     before do
  #       @project = CodePraise::GithubApi.new(GITHUB_TOKEN)
  #                                       .project(USERNAME, PROJECT_NAME)
  #     end
  #     it 'HAPPY: should recognize owner' do
  #       _(@project.owner).must_be_kind_of CodePraise::Contributor
  #     end

  #     it 'HAPPY: should identify owner' do
  #       _(@project.owner.username).wont_be_nil
  #       _(@project.owner.username).must_equal CORRECT['owner']['login']
  #     end

  #     it 'HAPPY: should identify contributors' do
  #       contributors = @project.contributors
  #       _(contributors.count).must_equal CORRECT['contributors'].count

  #       usernames = contributors.map(&:username)
  #       correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
  #       _(usernames).must_equal correct_usernames
  #     end
  #   end
end
