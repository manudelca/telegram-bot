class ApiCommunicator
  def initialize(api_url)
    @api_url = api_url
    @header = { 'Content-Type' => 'application/json' }
  end

  def register(email, username)
    Faraday.post("#{@api_url}/register", { email: email, username: username }.to_json, @header)
  end

  def get_movie_details(content_id)
    Faraday.get("#{@api_url}/content/#{content_id}")
  end
end