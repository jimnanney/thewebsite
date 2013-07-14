require 'rubygems'
require 'bundler/setup'
require 'data_mapper'
require 'pusher'
require 'carrierwave'
require 'carrierwave/datamapper'

# DataMapper
DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{ Dir.pwd }/development.sqlite3"))
DataMapper.auto_upgrade!

# Pusher
Pusher.url = "http://ae645a2445d2f72cf3d4:8bbbadfd263a77086494@api.pusherapp.com/apps/49431"

# CarrierWave
CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   provider: 'AWS',
  #   aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  #   aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
	# 	endpoint: ENV["ASSET_HOST"]
  # }
  
  # config.fog_directory = ENV["S3_BUCKET"]
  # config.storage :fog

  # if settings.environment == :production
  #   config.storage :fog
  # else
  #   config.storage :file
  # end
end

# Meme Uploader
class MemeUploader < CarrierWave::Uploader::Base
  # storage :fog

  # def store_dir
  #   "uploads/memes/#{ model.id }"
  # end
end

# Tweet Model
class Tweet
  include DataMapper::Resource
  
  property :id, Serial
  property :tweet_id, String, length: 255
  property :text, Text
  property :keyword, String, length: 255
  property :url, String, length: 255

  property :user_id, String, length: 255
  property :user_nickname, String, length: 255
  property :user_name, String, length: 255
  property :user_image, String, length: 255

  # mount_uploader :meme, MemeUploader

  # From Twitter
  def self.from_twitter(status)
  	first_or_create({tweet_id: status.attrs[:id_str]}).tap do |tweet|
			tweet.text = status.attrs[:text]

			
      tweet.getImage
      # tweet.meme = "http://i0.kym-cdn.com/photos/images/newsfeed/000/227/262/a%20meme.jpg"
			

			tweet.user_id       = status.user.attrs[:id_str]
			tweet.user_nickname = status.user.attrs[:screen_name]
			tweet.user_name     = status.user.attrs[:name]
			tweet.user_image    = status.user.profile_image_url if status.user.profile_image_url?

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
          file = open(searcher.url, 'rb')
          done = true
        rescue StandardError
        end
      end

      memeText = splitter.no_hashes(text)
      i = MemeCaptain.meme_top_bottom(file, splitter.left(memeText), splitter.right(memeText))
      i.to_blob
  end
end
