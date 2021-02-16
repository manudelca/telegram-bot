class Parser
  def parse(message)
    JSON.parse(message)['message']
  end
end
