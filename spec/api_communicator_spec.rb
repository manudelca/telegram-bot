require 'spec_helper'

require "#{File.dirname(__FILE__)}/../app/api_communicator"

describe 'ApiCommunicator' do
  let(:fake_api_url) { 'https://www.api_url.com' }
  let(:api_communicator) { ApiCommunicator.new(fake_api_url) }

  it 'registration of user test95 with mail test@test.com should communicate the api the mail and user' do
    expected = { email: 'test@test.com', username: 'test95' }.to_json
    expect_any_instance_of(Faraday::Connection).to receive(:post).with(anything, expected, anything)
    email = 'test@test.com'
    username = 'test95'
    api_communicator.register(email, username)
  end
end
