require 'sinatra'
require './bets'
require "bundler/setup"
require 'sinatra/reloader' if development?

configure :development, :test do     
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/bet.db')
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

