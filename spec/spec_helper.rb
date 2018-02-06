require_relative '../app'
require 'capybara/rspec'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'


Capybara.app = Sinatra::Application

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end


RSpec.configure { |c| c.include RSpecMixin }
