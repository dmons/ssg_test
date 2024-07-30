# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/required_params'
require 'json'
require 'redis'

Dir['lib/*.rb', 'services/*.rb'].each { |file| require_relative file }

set :port, 4000

before do
  content_type :json
  @redis = Redis.new
end

post '/translate' do
  required_params :text, :to
  cache_key = ERB::Util.url_encode "text: #{params['text']} to: #{params['to']}"
  data = fragment_cache cache_key do
    TranslateRequestService.new(params['text'], params['to']).call
  end
  if data.is_a?(Net::HTTPSuccess) && data&.code != 200
    halt data.code, { 'Message' => data.message || 'Something went wrong' }.to_json
  else
    str = data.is_a?(String) ? data : data.body
    result = JSON.parse(str, object_class: OpenStruct)
    JSON.generate(translation: result&.translations&.first&.text)
  end
end
