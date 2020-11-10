require 'sinatra'
require 'sinatra/reloader'
require './bets'



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

