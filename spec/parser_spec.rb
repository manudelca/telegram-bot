require 'spec_helper'

require "#{File.dirname(__FILE__)}/../app/parser"

describe 'Parser' do
  let(:parser) { Parser.new }

  it 'parses registration response' do
    message = 'Success'
    response = { message: message }.to_json
    r = parser.parse(response)
    expect(r).to eq message
  end
end
