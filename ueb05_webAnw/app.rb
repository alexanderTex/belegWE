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

["/index.html", "/contact.html", "/imprint.html", "sendto.html", "/"].each do |path|
  get path do
    if request.path_info == "/index.html" or request.path_info =="/"
      @title = 'Start'
      erb :index
    #elsif request.path_info =="/"
    #  @title = 'Start'
    #  erb :index
    elsif request.path_info == "/contact.html"
      @title = 'Kontakt'
      erb :contact
    elsif request.path_info == "/imprint.html"
      @title = 'Impressum'
      erb :imprint
    end
  end
end

# /----------------------------------------------------------------------------\
#   send form
# \----------------------------------------------------------------------------/
# Die Inhalte des Formulars werden in die Variablen @name, @email und @message
# gespeichert, wenn das Formular abgesendet wird.
# contact.erb (Formular) => app.rb
#   name = "name" => @name = params[:name}
#   name = "email"  => @email = params[:email]
#   name = "message" => @message = params[:message]
post '/contact' do
  @name = params[:name]
  @email = params[:email]
  @message = params[:message]
  erb :fixContact
end

# admin-area
get '/admin.html' do
  protected!
  erb :admin
end

# start the server if ruby file executed directly
run! if app_file == $0
end
