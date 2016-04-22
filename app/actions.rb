require 'pry'
# Homepage (Root path)
helpers do

  # Get logged-in user or redirects to login page
  # Uses session[:login_error] to store an error message when needed
  def check_user
    @user = User.find_by(id: session[:user_id])
    if @user
      session.delete(:login_error)
    else
      session[:login_error] = "You must be logged in."
      redirect '/login'
    end
  end

end

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

post '/login'do
  email = params[:email]
  password = params[:password]
  user = User.find_by(email: email, password: password)
  if user 
    session[:user_id] = user[:id]
    redirect '/customer/profile'
  else
    session[:login_error] = "You must be logged in."
    redirect '/'
  end
end

get '/logout'do
  session[:user_id] = nil
  redirect '/' 
end


get '/customer/checkout/:id' do
  #session[:services_id] = params[:id]
  #@services_id = params[:id].to_i
  erb :'customer/checkout'
end

post '/customer/checkout' do
  session[:name] = params[:name]
  session[:email] = params[:email]
  session[:password] = params[:password]
  if params[:password] == params[:password_confirmation] 
    redirect '/customer/checkout2'
  end 
end

get '/customer/checkout2' do
  erb :'customer/checkout2'
end

post '/customer/checkout2' do
  session[:phone] = params[:phone]
  session[:address] = params[:address]
  session[:city] = params[:city]
  session[:postalcode] = params[:postalcode]
    redirect '/customer/checkout3'
  end 

  get '/customer/checkout3' do
    erb :'customer/checkout3'
  end

 post '/customer/checkout3' do
    user = User.create(
      name: session[:name],
      email: session[:email],
      phone: session[:phone],
      password: session[:password],
      address: session[:address],
      city: session[:city],
      postalcode: session[:postalcode],
      # services_id: @services_id
      )
    #user.service= Service.find(session[:services_id])
    user.save
    session[:user_id] = user.id
    redirect '/customer/profile'
  end


get '/customer/profile' do
  check_user
  erb :'customer/profile'
end

post '/customer/profile' do
  check_user
  
end



# get '/customer/comments' do
#   erb :'customer/new'
# end

# post 'customer/comments' do
#   erb :'customer/new'
# end

# get '/newuser' do
#   erb :newuser
# end

