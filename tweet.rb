require 'rubygems'
require 'bundler/setup'
require 'pusher'
require 'ostruct'
require './s3'
require './rest-client'
require './string_splitter'
require 'meme_captain'

# Pusher
Pusher.url = ENV['PUSHER_URL']

# Tweet Model
class Tweet < OpenStruct
  # From Twitter
  def self.from_twitter(status)
    new.tap do |tweet|
      tweet.text = status.attrs[:text]

      blob = tweet.getImage

      key = "#{tweet.tweet_id}.jpg"
      S3.upload blob, key, :content_type => 'application/jpg'

      tweet.user_id       = status.user.attrs[:id_str]
      tweet.user_nickname = status.user.attrs[:screen_name]
      tweet.user_name     = status.user.attrs[:name]
      tweet.user_image    = status.user.profile_image_url if status.user.profile_image_url?
      tweet.meme          = key

      tweet.save!
      tweet.push
    end
  end

  # Push Tweet
  def push
    Pusher['twitter'].trigger('tweet', self.to_json)
  end

  def getImage
      text = self.text

      searcher = ImageSearcher.new()
      splitter = StringSplitter.new()

      imageQuery = splitter.image_search_text(text)
      searcher.search(imageQuery.split(' '))

      puts searcher.url
      file = nil
      done = false
      while !done
        begin
          file = open(searcher.url_for_image, 'rb')
          done = true
        rescue StandardError
        end
      end

      memeText = splitter.no_hashes(text)
      i = MemeCaptain.meme_top_bottom(file, splitter.left(memeText), splitter.right(memeText))
      i.to_blob
  end

  def self.test
    tweet = OpenStruct.new
    hash = JSON.parse(IO.read('./tweet.json'))

    hash.keys.each do |k|
      puts k
      hash[k.to_sym] = hash[k]
    end

    tweet.attrs = hash
    Tweet.from_twitter tweet
  end
end

DataMapper.finalize
