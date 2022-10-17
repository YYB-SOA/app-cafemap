# frozen_string_literal: true

require 'yaml'
require 'json'
require 'net/http'
require 'uri'

class ChatBotNotifier
  require('logger')
  require('net/http')

  LINE_NOTIFY_URL = 'https://notify-api.line.me/api/notify'

  def line_notify(token, message)
    uri = URI(LINE_NOTIFY_URL)
    http = init_http(uri)
    call_line_api(uri, http, token, message)
  end

  private

  def logger
    @logger ||= Logger.new('message_log/message.log')
  end

  def init_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.open_timeout = 10
    http.continue_timeout = 10
    http
  end

  def call_line_api(uri, http, token, message, error_retry = 0)
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{token}"
    request.set_form_data(message: "\n#{message}")
    response = http.request(request)
    logger.info("#{__FILE__}##{__method__} response: #{response.body}")

  rescue StandardError => e
    if error_retry < 5
      sleep(10)
      error_retry += 1
      retry
    else
      logger.error("#{__FILE__}##{__method__} exception: #{e.inspect}")
    end
  end
end


def read_secret_token(token_category, name_of_key)
  config_yaml = YAML.safe_load(File.read('config/secrets.yml'))
  config_yaml[token_category][0][name_of_key]
end

leimen_token = read_secret_token('LineBot_Notify_api', 'Gift-List(test1)')# 目前token命名是trello:leimen
message = "Hi, Yuan-Jie and Bing-Chen. It's Leo Speaking"
ChatBotNotifier.new.line_notify(leimen_token, message)
