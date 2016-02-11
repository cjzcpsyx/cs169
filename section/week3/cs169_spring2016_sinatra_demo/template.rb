=begin 
Created on Feb 2nd, 2016
A toy Sinatra app to demostrate the basic concept of MVC, RESTful Routes and CRUD.
Run ``bundle install`` to make sure you have necessary gems installed.
TO run the script, type ``ruby template.rb`` in command line.
@author: hezheng.yin
=end

# load libraries we need 
require 'sinatra'
require 'active_record'
require 'json'

# tell active_record which database to connect to
db_options = {adapter: 'sqlite3', database: 'todos_db'}
ActiveRecord::Base.establish_connection(db_options)

# write migration class for creating Todo table in database
	### how do we write migration in rails?
class CreateTodos < ActiveRecord::Migration
	def change
		create_table :todos do |t|
			t.string :description
		end
	end
end

# create Todo table by executing the function we just wrote
	### how do apply migration in rails?
	### why do we handle exception here?
begin
	CreateTodos.new.change
rescue ActiveRecord::StatementInvalid
	# it's probably OK
end

# create Todo class by inheriting from ActiveRecord::Base
	### how do we write new class in Rails?
	### why there's no setter and getter method (or attr_accessor)?
class Todo < ActiveRecord::Base
end

# populate the database if it is empty (avoid running this piece of code twice)
	### do you still remember this cleaner and simpler hash syntax?
		# old version: new_hash = {:simon => "Talek", :lorem => "Ipsum"}
if Todo.all.empty?
	Todo.create(description: "prepare for discussion section")
	Todo.create(description: "release cs169 hw3")
end

# display all todos
get '/todos' do 
	content_type :json
	Todo.all.to_json
end

# show a specific todo 
get '/todos/:id' do 
	content_type :json
	todo = Todo.find_by_id(params[:id])
	if todo 
		return {description: todo.description}.to_json
	else
		return {msg: "error: specified todo not found"}.to_json
	end
end

# create a new todo 
# return: if we receive non-empty description, render json with msg set to "create success"
# 			otherwise render json with msg set to "error: description can't be blank" 
# hint: use method Todo's class method create
post '/todos' do
	### YOUR CODE HERE
	content_type :json
	param = params[:description]
	if param.nil? || param.empty?
		return {msg: "error: description can't be blank"}.to_json
	else
		Todo.create(description: param)
		return {msg: "create success"}.to_json
	end
	
end

# update a todo
# return: if todo with specified id exist and description non-empty, render json with msg set to "update success"
# 				otherwise render json with msg set to "upate failure" 
# hint: Todo class has instance method update_attribute
put '/todos/:id' do
	### YOUR CODE HERE ###
	content_type :json
	param = params[:description]
	todo = Todo.find_by_id(params[:id])
	if todo.nil? || param.nil? || param.empty?
		return {msg: "upate failure"}.to_json
	else
		todo.update_attribute(:description, param)
		return {msg: "update success"}.to_json
	end
end

# delete a todo
# return: if todo with specified id exist, render json with msg set to "delete success"
# 				otherwise render json with msg set to "delete failure"
# hint: Todo class has instance method destroy
delete '/todos/:id' do 
	### YOUR CODE HERE ###
	content_type :json
	todo = Todo.find_by_id(params[:id])
	if todo.nil?
		return {msg: "delete failure"}.to_json
	else
		Todo.destroy(params[:id])
		return {msg: "delete success"}.to_json
	end
end