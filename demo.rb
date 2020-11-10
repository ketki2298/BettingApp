require 'sinatra'
require './bets'
require "bundler/setup"

configure :development, :test do     
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

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

