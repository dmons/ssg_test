# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
