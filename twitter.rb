require 'rubygems'
require 'bundler/setup'
require 'json'
require 'tweetstream'
require './tweet.rb'

TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.auth_method        = :oauth
end

TweetStream::Client.new.on_reconnect do |timeout, retries|
  puts "timeout: #{ timeout }, retries; #{ retries }"
end.on_error do |message|
  puts "error: #{ message }"
end.on_limit do |skip_count|
  puts "limit: #{ skip_count }"
end.track("#onlyinnola") do |status, client|
  tweet = Tweet.from_twitter(status)
  puts tweet.inspect
end
