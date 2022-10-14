# frozen_string_literal: true
require 'http'
require 'yaml'
# frozen_string_literal: true

require 'httparty'
require 'json'
require 'net/http'
require 'uri'


config = YAML.safe_load(File.read('config/secrets.yml'))


def news_api_path(path)
  "https://newsapi.org/v2/top-headlines?country=tw&apiKey=#{path}"
end
key =config['api'][0]['News']
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
    res.body if res.is_a?(Net::HTTPSuccess)
end

news_json = call_news_url(full_url)

File.write('lib/sample/news.json', JSON.dump(news_json))


gh_response = {}
gh_results = {}

# ## HAPPY project request
# project_url = news_api_path('repos/soumyaray/YPBT-app')
# gh_response[project_url] = call_news_url(full_url_key)
# project = gh_response[project_url].parse

# gh_results['size'] = project['size']
# # should be 551

# gh_results['owner'] = project['owner']
# # should have info about Soumya

# gh_results['git_url'] = project['git_url']
# # should be "git://github.com/soumyaray/YPBT-app.git"

# gh_results['contributors_url'] = project['contributors_url']
# # "should be https://api.github.com/repos/soumyaray/YPBT-app/contributors"

# contributors_url = project['contributors_url']
# gh_response[contributors_url] = call_news_url(key_news, contributors_url)
# contributors = gh_response[contributors_url].parse

# gh_results['contributors'] = contributors
# contributors.count
# # should be 3 contributors array

# contributors.map { |c| c['login'] }
# # should be ["Yuan-Yu", "SOA-KunLin", "luyimin"]

# ## BAD project request
# bad_project_url = gh_api_path('soumyaray/foobar')
# gh_response[bad_project_url] = call_news_url(key_news, bad_project_url)
# gh_response[bad_project_url].parse # makes sure any streaming finishes

# File.write('spec/fixtures/github_results.yml', gh_results.to_yaml)