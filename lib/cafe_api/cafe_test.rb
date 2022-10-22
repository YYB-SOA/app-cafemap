require 'http'
require 'yaml'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

config = YAML.safe_load(File.read("db/sample/cafe_nomad3.yml"))
puts config