require 'rubygems'
require 'bundler/setup'
require 'json'
require 'tweetstream'
require 'pusher'

TweetStream.configure do |config|
  config.consumer_key       = "F61EGNAPP8rNVs9bG0H1Q"
  config.consumer_secret    = "NsmCehsSKrFpnliwPNBXAtOv572xoCalbYpgt5zE"
  config.oauth_token        = "12920142-L2HCzlIok7B6SLjl0eD0WC79PCQY0FUYiGhGU0Sff"
  config.oauth_token_secret = "M4kidamsEWqXBXJ9eldHXcwZ0Hk1JVix4ZMxJC5EJ0"
  config.auth_method        = :oauth
end

TweetStream::Client.new.on_reconnect do |timeout, retries|
  puts "timeout: #{ timeout }, retries; #{ retries }"
end.on_error do |message|
  puts "error: #{ message }"
end.on_limit do |skip_count|
  puts "limit: #{ skip_count }"
end.track("#onlyinnola") do |status, client|
  puts status.inspect

  Pusher.url = "http://ae645a2445d2f72cf3d4:8bbbadfd263a77086494@api.pusherapp.com/apps/49431"
	Pusher['twitter'].trigger('tweet', status.attrs.to_json)
end
