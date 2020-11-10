require 'sinatra'
require 'erb'
require 'sass'
require './students'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper.auto_migrate!
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_migrate!
end

#get('/styles.css'){ scss :styles }
get("/_bootswatch.scss") {scss :styles}

get '/' do
  redirect("/login") unless session[:admin]
  erb :home
end

get "/login" do
  erb :login
end

post "/login" do
  if params["login"]["username"] == 'frank' && params['login']['password'] == "sinatra"
    session[:admin] = true
    redirect to ("/")
  else
    erb :login
  end
end

get "/logout" do
  session[:admin] = nil
  redirect to ("/")
end

get '/about' do
  redirect("/login") unless session[:admin]
  @title = "All About This Website"
  erb :about
end

get '/contact' do
  redirect("/login") unless session[:admin]  
  erb :contact
end

not_found do
  erb :not_found
end

