require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pry-byebug'
require 'pg'


# # def sql_string(value)
# #   "'#{value.to_s.gsub("'", "''")}'"

# #   sql = "INSERT INTO movies (
# #     title,
# #     poster, 
# #     plot, 
# #     year) VALUES (
# #     #{sql_string(@search_results['Title'])},
# #     #{sql_string(@search_results['Poster'])},
# #     #{sql_string(@search_results['Plot'])},
# #     #{@search_results['Year'].to_i})"

#   @db.exec(sql)

#   @db.close
# end


get '/' do
  redirect to('/tasks')
end


get '/tasks' do 
  # Get all tasks from DB
  sql = "SELECT * FROM tasks"
  @tasks = run_sql(sql)
  erb :index
end

get '/tasks/new' do
  # Render a form
  erb :new
end

post '/tasks' do
  # Persist new task to DB
  name = params[:name]
  details = params[:details]

  sql = "INSERT INTO tasks (name, details) VALUES ('#{name}', '#{details}')"
  run_sql(sql)

  redirect to('/tasks')
end

get '/tasks/:id' do
  # Grab task from DB where id = :id
  task_id = params[:id]
  sql = "SELECT * FROM tasks WHERE id = #{task_id}"
  @result = run_sql(sql)

  erb :show
end

get '/tasks/:id/edit' do
  # Grab task from DB and render form
   task_id = params[:id]
   sql = "SELECT * FROM tasks WHERE id = #{task_id}"
   @task = run_sql(sql).first
   erb :edit
end

post '/tasks/:id' do
  name = params[:name]
  details = params[:details]

  sql = "UPDATE tasks SET name = '#{name}', details = '#{details}' WHERE id = #{params[:id]}"
# WE USE THE PARAMS[:id] OPTION INSTEAD OF DEFINING THE VARIABLE ABOVE.  BOTH OPTIONS ARE FINE.
  run_sql(sql)

  redirect to("/tasks/#{params[:id]}")
end

post '/tasks/:id/delete' do
  sql = "DELETE FROM tasks WHERE id = #{params[:id]}"
  run_sql(sql)
  redirect to('/tasks')
end


def run_sql(sql)
  conn = PG.connect(dbname: 'todo', host: 'localhost')
  result = conn.exec(sql)
  conn.close
  result
end
