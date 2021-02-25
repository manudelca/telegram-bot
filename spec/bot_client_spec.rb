require 'spec_helper'
require 'web_mock'
# Uncomment to use VCR
# require 'vcr_helper'
require 'byebug'

require "#{File.dirname(__FILE__)}/../app/bot_client"

def stub_get_updates(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_get_inline_keyboard_updates(token, message_text, inline_selection)
  body = {
    "ok": true, "result": [{
      "update_id": 866_033_907,
      "callback_query": { "id": '608740940475689651', "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                          "message": {
                            "message_id": 626,
                            "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                            "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                            "date": 1_595_282_006,
                            "text": message_text,
                            "reply_markup": {
                              "inline_keyboard": [
                                [{ "text": 'Jon Snow', "callback_data": '1' }],
                                [{ "text": 'Daenerys Targaryen', "callback_data": '2' }],
                                [{ "text": 'Ned Stark', "callback_data": '3' }]
                              ]
                            }
                          },
                          "chat_instance": '2671782303129352872',
                          "data": inline_selection }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_send_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text },
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'Content-Type' => 'application/x-www-form-urlencoded',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 200, body: body.to_json, headers: {})
end

def stub_send_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"}],[{"text":"Daenerys Targaryen","callback_data":"2"}],[{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_register(send_body, return_body)
  stub_request(:post, 'http://fakeurl.com/register')
    .with(
      body: send_body.to_json,
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v0.15.4'
      }
    ).to_return(status: 200, body: return_body.to_json, headers: {})
end

def stub_get_content_with_id_one
  body = { "message": 'El contenido fue encontrado!',
           "content": { "id": 1,
                        "name": 'La pistola Desnuda',
                        "audience": 'ATP',
                        "duration_minutes": 210,
                        "genre": 'comedy',
                        "country": 'USA',
                        "director": 'David Zucker',
                        "first_actor": 'Leslie Nielsen',
                        "second_actor": 'Ricardo Montalban' } }
  stub_request(:get, 'http://fakeurl.com/content/1')
    .with(
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 200, body: body.to_json, headers: {})
end

def stub_get_content_with_id_two
  body = {
    "message": 'El contenido fue encontrado!',
    "content": {
      "id": 2,
      "name": 'The Office',
      "audience": 'No ATP',
      "duration_minutes": 30,
      "genre": 'comedy',
      "country": 'USA',
      "director": 'Ricky Gervais',
      "first_actor": 'Steve Carrell',
      "second_actor": 'Rainn Wilson',
      "seasons": 2,
      "episodes": 9
    }
  }
  stub_request(:get, 'http://fakeurl.com/content/2')
    .with(
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 200, body: body.to_json, headers: {})
end

def stub_get_none_existant_content
  body = {
    "message": 'Error: id no se encuentra en la coleccion'
  }
  stub_request(:get, 'http://fakeurl.com/content/-1')
    .with(
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 404, body: body.to_json, headers: {})
end

def stub_like
  body = {
    "message": 'Calificación registrada'
  }
  stub_request(:post, 'http://fakeurl.com/like')
    .with(
      body: { 'content_id' => '1',
              'telegram_user_id' => 141_733_544 },
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'Content-Type' => 'application/json',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 200, body: body.to_json, headers: {})
end

def stub_seen_this_week
  body = {
    "message": 'Búsqueda de contenido visto esta semana exitosa',
    "content": [
      {
        "id": 2,
        "name": 'The Office',
        "genre": 'comedy',
        "director": 'Ricky Gervais',
        "first_actor": 'Steve Carrell',
        "second_actor": 'Rainn Wilson',
        "season_number": 2
      }
    ]
  }
  stub_request(:post, 'http://fakeurl.com/seen_this_week')
    .with(
      body: { 'telegram_user_id' => 141_733_544 },
      headers: { 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'Content-Type' => 'application/json',
                 'User-Agent' => 'Faraday v0.15.4' }
    ).to_return(status: 200, body: body.to_json, headers: {})
end

describe 'BotClient' do
  let(:token) { 'fake_token' }
  let(:api_communicator) { instance_double('ApiCommunicator') }

  it 'should get a /version message and respond with current version' do
    stub_get_updates(token, '/version')
    stub_send_message(token, Version.current)

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /say_hi message and respond with Hola Emilio' do
    stub_get_updates(token, '/say_hi Emilio')
    stub_send_message(token, 'Hola, Emilio')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    stub_get_updates(token, '/start')
    stub_send_message(token, 'Hola, Emilio')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    stub_get_updates(token, '/stop')
    stub_send_message(token, 'Chau, egutter')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /tv message and respond with an inline keyboard' do
    stub_get_updates(token, '/tv')
    stub_send_keyboard_message(token, 'Quien se queda con el trono?')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a "Quien se queda con el trono?" message and respond with' do
    stub_get_inline_keyboard_updates(token, 'Quien se queda con el trono?', 2)
    stub_send_message(token, 'A mi también me encantan los dragones!')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    stub_get_updates(token, '/unknown')
    stub_send_message(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /register test@test.com message and respond with Bienvenido! :)' do # rubocop:disable RSpec/ExampleLength
    email = 'test@test.com'
    send_body = { 'email': email, 'telegram_user_id': 141_733_544 }
    return_body = { "message": 'Bienvenido! :)' }
    stub_get_updates(token, "/register #{email}")
    stub_register(send_body, return_body)
    stub_send_message(token, 'Bienvenido! :)')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /register message and respond with Error: falta el campo email' do # rubocop:disable RSpec/ExampleLength
    send_body = { 'telegram_user_id': 141_733_544 }
    return_body = { "message": 'Error: falta el campo email' }
    stub_get_updates(token, '/register')
    stub_register(send_body, return_body)
    stub_send_message(token, 'Error: falta el campo email')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /detalles message and respond with Error: comando invalido. Quizas quisiste decir: /detalles {id} ?' do
    stub_get_updates(token, '/detalles')
    stub_send_message(token, 'Error: comando invalido. Quizas quisiste decir: /detalles {id} ?')

    app = BotClient.new(api_communicator, token)

    app.run_once
  end

  it 'should get a /detalles 1 message and respond with the movie details' do
    stub_get_updates(token, '/detalles 1')
    stub_get_content_with_id_one
    stub_send_message(token, 'La pistola Desnuda, ATP, 210 minutes, comedy, USA, David Zucker, Leslie Nielsen, Ricardo Montalban')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /detalles 2 message and respond with the tv_show details' do
    stub_get_updates(token, '/detalles 2')
    stub_get_content_with_id_two
    stub_send_message(token, 'The Office, No ATP, 30 minutes, comedy, USA, Ricky Gervais, Steve Carrell, Rainn Wilson, seasons: 2, episodes: 9')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /detalles -1 message and respond with content not found message' do
    stub_get_updates(token, '/detalles -1')
    stub_get_none_existant_content
    stub_send_message(token, 'Error: id no se encuentra en la coleccion')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /like 1 message and respond with Calificación registrada' do
    stub_get_updates(token, '/like 1')
    stub_like
    stub_send_message(token, 'Calificación registrada')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /register test@test.com message with repeated email and respond with Error: este email ya se encuentra registrado' do # rubocop:disable RSpec/ExampleLength
    email = 'test@test.com'
    send_body = { 'email': email, 'telegram_user_id': 141_733_544 }
    return_body = { "message": 'Error: este email ya se encuentra registrado' }
    stub_get_updates(token, "/register #{email}")
    stub_register(send_body, return_body)
    stub_send_message(token, 'Error: este email ya se encuentra registrado')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /register test@test message and respond with Error: email inválido, ingrese un mail válido. Ej: mail@dominio.com' do # rubocop:disable RSpec/ExampleLength
    email = 'test@test'
    send_body = { 'email': email, 'telegram_user_id': 141_733_544 }
    return_body = { "message": 'Error: email inválido, ingrese un mail válido. Ej: mail@dominio.com' }
    stub_get_updates(token, "/register #{email}")
    stub_register(send_body, return_body)
    stub_send_message(token, 'Error: email inválido, ingrese un mail válido. Ej: mail@dominio.com')
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end

  it 'should get a /seen_this_week message and respond with the contents ditails' do
    stub_get_updates(token, '/seen_this_week')
    stub_seen_this_week
    stub_send_message(token, "id: 2, The Office, comedy, Ricky Gervais, Steve Carrell, Rainn Wilson, temporada: 2\n")
    app = BotClient.new(ApiCommunicator.new('http://fakeurl.com'), token)

    app.run_once
  end
end
