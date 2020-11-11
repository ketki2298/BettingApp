require 'sinatra'
require 'dm-core'
require 'dm-migrations'

enable 'sessions'
DataMapper.setup(:default,ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/bet.db")


class Bets
  include DataMapper::Resource

  property :id, Serial
  property :user, Text
  property :password, Text
  property :win, Integer
  property :loss, Integer
  property :profit, Integer
end
DataMapper.auto_upgrade!
DataMapper.finalize

configure do
  enable :sessions
end


configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :development, :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/' do
    if session[:login]
        erb :home
      else
        erb :login
      end
end


post '/login' do
    Bets.first_or_create({:user => 'ketki', :password => '12345', :win => 0, :loss =>0, :profit =>0})
    @users = Bets.first(user: params[:username])
    puts @users[:password]
    puts @users[:user]
    if @users[:password] == params[:password]
        session[:login] = true
        session[:win] = 0
        session[:loss] = 0
        session[:user] = params[:username]
        session[:profit] = 0
        erb :home
    else
        session[:login] = false
        session[:message] = "Incorrect Username or Password!"
        redirect('/')
    end
end

get '/home' do
    @users = Bets.first(user: session[:user])
    puts "home"
    puts @users.win
    if session[:login] == true
        erb :home
    else
        session[:message] = "Please login!"
        erb :login
    end
end

post '/placeBet' do
    betAmount = params[:betAmount].to_i
    betOn = params[:betOn].to_i
    dice = rand(1..6)
    puts betAmount
    puts betOn
    if dice == betOn
        puts "you won"
        session[:result] = "You win!"
        session[:win] += betAmount * 2
        session[:profit] += betAmount
    else
        session[:result] = "You lose!"
        session[:loss] += betAmount
        session[:profit] -= betAmount
    end
    redirect('/home')
end

get '/logout' do
    user = Bets.first(user: session[:user])
    puts "password"
    puts session[:user]
    puts user[:password]
    w = session[:win] + user[:win]
    l = session[:loss] + user[:loss]
    p = session[:profit] + user[:profit]
    puts user.update(:win => w,:loss => l, :profit => p)

    session.clear
    session[:message] = "successufully logged out"
    redirect to("/")
  end