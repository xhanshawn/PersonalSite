class ApplicationController < ActionController::Base
  before_action :authorize

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protected

  	def authorize
  	  unless User.find_by(id: session[:user_id])
  	  	redirect_to login_url, notice: "Please log in"
  	  end
  	end

    def store_last_url
      session[:last_url] = request.url unless [login_url, root_url].include? request.url or request.format != :html or request.method != 'GET' or !path_exists?(request.url)
      puts session[:last_url]
    end

    def path_exists?(path)
      begin
        Rails.application.routes.recognize_path(path)
      rescue
        return false
      end
      true
    end


    def authorize_developer
      unless User.find_by(id: session[:user_id]).is_developer
        render :text => "you are not a developer", :layout => true
      end
    end

    def current_user
      @user = User.find_by(id: session[:user_id])
    end
end
