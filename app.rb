require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'compass'
require 'coffee-script'
require 'open-uri'
require 'meme_captain'
require './rest-client'

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

  searcher = ImageSearcher.new()
  searcher.search(params[:copy].split(' '))

  puts searcher.url
  file = nil
  done = false
  while !done
    begin
      file = open(searcher.url, 'rb')
      done = true
    rescue StandardError
    end
  end
  i = MemeCaptain.meme_top_bottom(file, params[:copy], nil)
  i.to_blob
  
  open(searcher.url, 'rb') do |f|
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
