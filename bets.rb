require 'dm-core'
require 'dm-migrations'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")

class Bets
    include DataMapper::Resource

    property :id, Serial
    property :user, Text
    property :password, Text
    property :win, Integer
    property :loss, Integer
    property :profit, Integer
end

DataMapper.finalize


post '/login' do
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
    sessionScore = {:id => user[:id],:user => session[:user], :password => user[:password], :win => w, :loss => l, :profit => p}
    puts sessionScore
    puts user.update(sessionScore)

    session.clear
    session[:message] = "successufully logged out"
    redirect to("/")
  end