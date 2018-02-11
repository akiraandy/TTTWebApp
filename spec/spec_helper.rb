require_relative '../app'
require 'rack/test'
require 'rspec'
ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() WebApp end
end

RSpec.configure { |c| c.include RSpecMixin }
