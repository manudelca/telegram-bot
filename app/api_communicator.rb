class ApiCommunicator
  def initialize(api_url)
    @api_url = api_url
    @header = { 'Content-Type' => 'application/json' }
  end

  def register(email, user_id)
    Faraday.post("#{@api_url}/register", { email: email, telegram_user_id: user_id }.to_json, @header)
  end

  def register_with_no_email(user_id)
    Faraday.post("#{@api_url}/register", { telegram_user_id: user_id }.to_json, @header)
  end

  def get_content_details(content_id)
    Faraday.get("#{@api_url}/content/#{content_id}")
  end

  def like(content_id, user_id)
    Faraday.post("#{@api_url}/like", { content_id: content_id, telegram_user_id: user_id }.to_json, @header)
  end
end
