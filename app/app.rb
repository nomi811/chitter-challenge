ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require 'sinatra/flash'
require_relative 'datamapper_setup'
require_relative 'models/user'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  register Sinatra::Flash

  get '/' do
    erb :'users/new'
  end

  get '/page' do
    erb :'page/index'
  end

  get '/users/new' do
    @users = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(username: params[:username],
                    name: params[:name],
                    email: params[:email],
                    password: params[:password],
                    confirm_password: params[:confirm_password])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
