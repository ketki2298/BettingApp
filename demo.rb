require 'sinatra'
require './bets'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/bet.db')
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

