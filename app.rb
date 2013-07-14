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
require './string_splitter'

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
  splitter = StringSplitter.new()

  imageQuery = splitter.image_search_text(params[:copy])
  searcher.search(imageQuery.split(' '))

  file = nil
  done = false
  while !done
    begin
      file = open(searcher.url_for_image, 'rb')
      done = true
    rescue StandardError
    end
  end
  puts searcher.url


  memeText = splitter.no_hashes(params[:copy])
  i = MemeCaptain.meme_top_bottom(file, splitter.left(memeText), splitter.right(memeText))
  i.to_blob
  
end

get '/app.css' do
  scss :app
end

get '/app.js' do
  coffee :app
end
