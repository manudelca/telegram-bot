def content_details_formatted(content)
  content_details = "#{content['name']}, #{content['audience']}, #{content['duration_minutes']} minutes, #{content['genre']}, #{content['country']}, #{content['director']}, #{content['first_actor']}, #{content['second_actor']}" # rubocop:disable Metrics/LineLength
  return content_details if content['seasons'].nil?

  content_details += ", seasons: #{content['seasons']}, episodes: #{content['episodes']}"
  content_details
end

def content_release_formatted(contents)
  contents_formatted = ''
  contents.each do |content|
    contents_formatted += basic_details_formatted(content)
    contents_formatted += ", (FUTURE RELEASE), date: #{content['release_date']}" if Time.now.strftime('%Y/%m/%d') < content['release_date']
    contents_formatted += "\n"
  end
  contents_formatted
end

def content_seen_details_formatted(contents)
  contents_formatted = ''
  contents.each do |content|
    contents_formatted += basic_details_formatted(content)
    contents_formatted += "\n"
  end
  contents_formatted
end

def basic_details_formatted(content)
  contents_formatted = "id: #{content['id']}, #{content['name']}, #{content['genre']}, #{content['director']}, #{content['first_actor']}, #{content['second_actor']}" # rubocop:disable Metrics/LineLength
  contents_formatted += ", temporada: #{content['season_number']}" unless content['season_number'].nil?
  contents_formatted
end
