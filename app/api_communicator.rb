class ApiCommunicator
  def initialize(api_url)
    @api_url = api_url
    @header = { 'Content-Type' => 'application/json' }
  end

  def register(_email, _username)
    Faraday.post("#{@api_url}/register", { email: 'test@test.com', username: 'test95' }.to_json, @header)
  end
end
