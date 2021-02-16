require 'dotenv/load'
require File.dirname(__FILE__) + '/app/bot_client'

$stdout.sync = true
# api_url = ENV['API_URL'] || 'http://localhost:3000'
# ApiCommunicator.new(api_url)
BotClient.new.start
