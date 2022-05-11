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
