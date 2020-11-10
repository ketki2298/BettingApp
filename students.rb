require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :grade, Text
  property :score, Integer
  property :birthday , Date
  
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/students' do
  redirect("/login") unless session[:admin]
  @students = Student.all
  erb :students
end

get '/students/new' do
  redirect("/login") unless session[:admin]
  @students = Student.new
  erb :new_student
end

get '/students/:id' do
  redirect("/login") unless session[:admin]
  @students = Student.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  redirect("/login") unless session[:admin]
  @students = Student.get(params[:id])
  if @students
    puts(@students.name, @students.grade)
  else
    puts("Student not found")
  end
  erb :edit_students
end

post '/students' do  
  redirect("/login") unless session[:admin]
  students = Student.create(params['students'])
  redirect to("/students/#{students.id}")
end

put '/students/:id' do
  redirect("/login") unless session[:admin]
  students = Student.get(params[:id])
  students.update(params['students'])
  redirect to("/students/#{students.id}")
end

delete '/students/:id' do
  redirect("/login") unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
