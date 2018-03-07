require 'rack/test'
require 'rspec'
require 'json'
require 'i18n'

I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../locales', '*.yml').to_s]

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    WebApp
  end
end

RSpec.configure { |c| c.include RSpecMixin }
