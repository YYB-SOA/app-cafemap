# frozen_string_literal: true

require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

require 'yaml'
require_relative 'News_main.rb'

freshman = Aritcle_info::NewsApi.new("news")

freshman.project()