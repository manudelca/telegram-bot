class ApiCommunicator
  def initialize(api_url)
    @api_url = api_url
    @header = {
      'Content-Type' => 'application/json',
      'Authorization' => ENV['WEBAPI_API_KEY']
    }
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

  def add_to_list(user_id, content_id)
    Faraday.patch("#{@api_url}/clients/#{user_id}/contents/#{content_id}/list")
  end

  def releases
    Faraday.get("#{@api_url}/releases")
  end

  def like(content_id, user_id)
    Faraday.post("#{@api_url}/like", { content_id: content_id, telegram_user_id: user_id }.to_json, @header)
  end

  def get_seen_this_week(user_id)
    Faraday.post("#{@api_url}/seen_this_week", { telegram_user_id: user_id }.to_json, @header)
  end

  def weather_suggestions
    Faraday.get("#{@api_url}/weather_suggestion")
  end
end
