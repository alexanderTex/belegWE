# Stand:
# Bearbeitenbutton einstellen edit_db_content und put ....
# Löschenbutton implementieren

require './datamapper'
require 'sinatra/base'

class MyApp < Sinatra::Base
enable :sessions

# /----------------------------------------------------------------------------\
#   filter
# \----------------------------------------------------------------------------/

before do
    session[:counter]||= 0
    session[:counter] += 1
end

# /----------------------------------------------------------------------------\
#    authentication
# \----------------------------------------------------------------------------/

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end
end


# /----------------------------------------------------------------------------\
#    routes
# \----------------------------------------------------------------------------/

get "/" do
  @title = 'Start'
  erb :index
end

get '/index.html' do
  @title = 'Start'
  erb :index
end

get '/contact.html' do
  @title = 'Kontakt'
  erb :contact
end

get '/imprint.html' do
  @title = 'Impressum'
  erb :imprint
end

# Komplettansicht der DB - Inhalte
get '/admin/contact-requests.html' do
  @title = 'Kontaktanfragen'
  @req = ContactRequest.all
  erb :show_db_content
end

post '/admin/contact-requests/:id/edit' do |id|
  @req = ContactRequest.get!(id)
  erb :edit_db_content
end

get '/admin/contact-requests/:id/show' do |id|
  req = ContactRequest.get!(id)
  @name = req.name
  @email = req.email
  @message = req.message
  erb :show_db_request
end

post '/admin/contact-requests/:id/show' do |id|
  req = ContactRequest.get(id)
  req.update(params[:req])
  @name = req.name
  @email = req.email
  @message = req.message
  erb :show_db_request
end

# Delete Area
post '/admin/contact-requests/:id' do |id|
  req = ContactRequest.get!(id)
  req.destroy!
  redirect "/admin/contact-requests.html"
end

# /----------------------------------------------------------------------------\
#   send form
# \----------------------------------------------------------------------------/

post '/contact' do
  req = ContactRequest.new(params[:req])
  @name = req.name
  @email = req.email
  @message = req.message

  if req.save
    erb :fixContact
  else
    redirect '/contact.html'
  end
end

# admin-area
get '/admin.html' do
  protected!
  erb :admin
end

# start the server if ruby file executed directly
run! if app_file == $0
end
