require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/parser"
require "#{File.dirname(__FILE__)}/helpers/content_helper"

require 'webmock'

class Routes
  include Routing

  on_message_pattern %r{\/registro (?<email>.*)} do |bot, message, api_communicator, args|
    user_id = message.from.id
    response = api_communicator.register(args['email'], user_id)
    reg_message = Parser.new.parse(response.body)['message']
    bot.api.send_message(chat_id: message.chat.id, text: reg_message)
  end

  on_message '/registro' do |bot, message, api_communicator|
    user_id = message.from.id
    response = api_communicator.register_with_no_email(user_id)
    reg_message = Parser.new.parse(response.body)['message']
    bot.api.send_message(chat_id: message.chat.id, text: reg_message)
  end

  on_message_pattern %r{\/detalles (?<content_id>.*)} do |bot, message, api_communicator, args|
    response = api_communicator.get_content_details(args['content_id'])
    response_body = Parser.new.parse(response.body)
    if response.status == 404
      bot.api.send_message(chat_id: message.chat.id, text: response_body['message'])
    else
      bot.api.send_message(chat_id: message.chat.id, text: content_details_formatted(response_body['content']))
    end
  end

  on_message '/detalles' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Error: comando invalido. Quizas quisiste decir: /detalles {id} ?')
  end

  on_message_pattern %r{\/me_gusta (?<content_id>.*)} do |bot, message, api_communicator, args|
    user_id = message.from.id
    response = api_communicator.like(args['content_id'], user_id)
    response_body = Parser.new.parse(response.body)['message']
    bot.api.send_message(chat_id: message.chat.id, text: response_body)
  end

  on_message '/novedades' do |bot, message, api_communicator|
    response = api_communicator.releases
    response_body = Parser.new.parse(response.body)
    if response.status == 404
      bot.api.send_message(chat_id: message.chat.id, text: response_body['message'])
    else
      bot.api.send_message(chat_id: message.chat.id, text: content_release_formatted(response_body['content']))
    end
  end

  on_message '/visto_esta_semana' do |bot, message, api_communicator|
    user_id = message.from.id
    response = api_communicator.get_seen_this_week(user_id)
    response_body = Parser.new.parse(response.body)
    if response.status == 404
      bot.api.send_message(chat_id: message.chat.id, text: response_body['message'])
    else
      bot.api.send_message(chat_id: message.chat.id, text: content_seen_details_formatted(response_body['content']))
    end
  end

  on_message '/sugerencias' do |bot, message, api_communicator|
    response = api_communicator.weather_suggestions
    response_body = Parser.new.parse(response.body)
    if response.status == 404
      bot.api.send_message(chat_id: message.chat.id, text: response_body['message'])
    else
      bot.api.send_message(chat_id: message.chat.id, text: content_release_formatted(response_body['content']))
    end
  end

  on_message_pattern %r{\/agregar_a_lista (?<content_id>.*)} do |bot, message, api_communicator, args|
    user_id = message.from.id
    response = api_communicator.add_to_list(user_id, args['content_id'])
    response_body = Parser.new.parse(response.body)
    bot.api.send_message(chat_id: message.chat.id, text: response_body['message'])
  end

  on_message '/agregar_a_lista' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Error: comando invalido. Quizas quisiste decir: /agregar_lista {id} ?')
  end

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
  end

  on_message_pattern %r{/say_hi (?<name>.*)} do |bot, message, _api_communicator, args|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{args['name']}")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  on_message '/time' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "La hora es, #{Time.now}")
  end

  on_message '/version' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: Version.current)
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
