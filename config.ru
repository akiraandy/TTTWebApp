require 'json'
require 'i18n'

I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml').to_s]
Dir['./ttt/src/*.rb'].each { |file| require file }
require File.expand_path('app', File.dirname(__FILE__))

run WebApp
