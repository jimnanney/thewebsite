require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'compass'
require 'coffee-script'

configure do
  Compass.configuration do |config|
    config.sass_dir = 'views'
  end

  set :haml, { format: :html5 }
  set :sass, Compass.sass_engine_options
end

get '/' do
  haml :index
end

get '/app.css' do
  sass :app
end

get '/app.js' do
  coffee :app
end
