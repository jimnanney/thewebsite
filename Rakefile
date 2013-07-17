require 'rubygems'
require 'bundler/setup'
require './.env'  unless ENV['RACK_ENV'] == 'production'

namespace :jobs do
  desc "Heroku worker"

  task :work do
    exec('ruby ./twitter.rb run')
  end
end
