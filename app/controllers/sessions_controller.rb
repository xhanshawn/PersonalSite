class SessionsController < ApplicationController
	skip_before_action :authorize
  def new
  end

  def create
  	user = User.find_by(name: params[:name])
  	if(user and user.authenticate(params[:password]))
  	  session[:user_id] = user.id
      session[:user_name] = user.name

      session[:last_url] = root_url unless session[:last_url]
  	  redirect_to session[:last_url], notice: "Logged in"
  	else
  	  redirect_to login_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to :back, notice: "Logged out"
  end
end
