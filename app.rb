require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'compass'
require 'coffee-script'
require 'open-uri'
require 'meme_captain'

configure do
  Compass.configuration do |config|
    config.sass_dir = 'views'
  end

  set :haml, { format: :html5 }
  set :sass, Compass.sass_engine_options
end

get '/' do
	redirect '/eets'
end

get '/eets' do
  haml :index
end

get '/meme.jpg::copy' do
	content_type 'image/jpg'

	open('http://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Large_pot_hole_on_2nd_Avenue_in_New_York_City.JPG/220px-Large_pot_hole_on_2nd_Avenue_in_New_York_City.JPG', 'rb') do |f|
		i = MemeCaptain.meme_top_bottom(f, params[:copy], nil)
  	i.to_blob
	end
end

get '/app.css' do
  sass :app
end

get '/app.js' do
  coffee :app
end
