def movie_details_formatted(content)
  "#{content['name']}, #{content['audience']}, #{content['duration_minutes']} minutes, #{content['genre']}, #{content['country']}, #{content['director']}, #{content['first_actor']}, #{content['second_actor']}" # rubocop:disable Metrics/LineLength
end
