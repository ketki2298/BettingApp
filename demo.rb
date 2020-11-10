# require 'sinatra'
# require './bets'
# require "bundler/setup"
# require 'sinatra/reloader' if development?

require 'sinatra'
require './bets'

# configure :development, :test do     
#   DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
# end

# configure :production do
#   DataMapper.setup(:default, ENV['DATABASE_URL'])
# end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/bet.db")
end

Bets.auto_migrate! unless DataMapper.repository(:default).adapter.storage_exists?('bets')


enable :sessions
set :username, "ketki"
set :password, "password"

get '/' do
    if session[:login]
        erb :home
      else
        erb :login
      end
end

