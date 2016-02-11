class ApplicationController < ActionController::Base
  before_action :authorize

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  skip_before_action :authorize, only: [:dummy_index]

  def dummy_index
    render :inline => 'The site is still being developing. Some other functionalities are pending.
<br>
Contact xhanbbuing@gmail.com if you want to give us some advices.', :layout => true
  end

  protected

  	def authorize
      puts session[:user_id]
  	  unless User.find_by(id: session[:user_id])
  	  	redirect_to login_url, notice: "Please log in"
  	  end
  	end

    def authorize_name

      unless User.find_by(id: session[:user_id]) == User.find_by(name: params[:name])
        render :text => "user's profile setting page are private", :layout => true
      end
    end


    def authorize_developer

      unless Developer.find_by(id: session[:user_id])
        render :text => "you are not a developer", :layout => true
      end
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

  protect_from_forgery with: :exception
end
