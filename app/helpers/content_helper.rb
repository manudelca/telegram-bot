def content_details_formatted(content)
  content_details = "#{content['name']}, #{content['audience']}, #{content['duration_minutes']} minutes, #{content['genre']}, #{content['country']}, #{content['director']}, #{content['first_actor']}, #{content['second_actor']}" # rubocop:disable Metrics/LineLength
  return content_details if content['seasons'].nil?

  content_details += ", seasons: #{content['seasons']}, episodes: #{content['episodes']}"
  content_details
end
