require 'spec_helper'

require "#{File.dirname(__FILE__)}/../app/api_communicator"

describe 'ApiCommunicator' do
  let(:fake_api_url) { 'https://www.api_url.com' }
  let(:api_communicator) { ApiCommunicator.new(fake_api_url) }

  it 'registration of user with id 1 and mail test@test.com should communicate the api the mail and user' do
    email = 'test@test.com'
    user_id = 1
    expected = { email: email, user_id: user_id }.to_json
    expect_any_instance_of(Faraday::Connection).to receive(:post).with(anything, expected, anything)
    api_communicator.register(email, user_id)
  end

  it 'registration of user with id 198 and mail test*34@mail.com.ar should communicate the api the mail and user' do
    email = 'test*34@mail.com.ar'
    user_id = 198
    expected = { email: email, user_id: user_id }.to_json
    expect_any_instance_of(Faraday::Connection).to receive(:post).with(anything, expected, anything)
    api_communicator.register(email, user_id)
  end
end
