require 'bundler/setup'
require 'json'

Bundler.require

get '/' do
  db = GDBM.new('data.db')
  @recipes = []
  db.each_pair do |post, content|
    @recipes << JSON.parse(content)
  end
  db.close
  erb :index
end

get '/:id' do
  db = GDBM.new('data.db')
  @recipe = JSON.parse(db[params[:id]]) rescue nil
  db.close
  if @recipe
    erb :recipe
  else
    status 404
    'not found'
  end
end

post '/' do
  db = GDBM.new('data.db')
  id = db.size.to_s
  db[id] = {
    id: id,
    title: params[:title],
    body: params[:body],
  }.to_json
  db.close
  redirect '/'
end

## fetch("http://localhost:4567/recipes", {method: "POST", headers: {'Content-Type':'application/json'}, body: JSON.stringify({title: "foo", body: "bar"})}).then(response => response.json()).then(console.log)
#post '/recipes' do
  #data = JSON.parse(request.body.read) rescue nil
  #db = GDBM.new('data.db')
  #id = db.size.to_s
  #db[id] = {
    #id: id,
    #title: data['title'],
    #body: data['body'],
  #}.to_json
  #db.close
  #content_type 'application/json'
  #{ status: 'ok' }.to_json
#end
