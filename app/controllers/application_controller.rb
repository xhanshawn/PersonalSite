class ApplicationController < ActionController::Base
  before_action :authorize

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  skip_before_action :authorize
  def dummy_index
    render :inline => 'The site is still being developing. Some other functionalities are pending.
<br>
Contact xhanbbuing@gmail.com if you want to give us some advices.', :layout => true
  end

  protected

  	def authorize
  	  unless User.find_by(id: session[:user_id])
  	  	redirect_to login_url, notice: "Please log in"
  	  end
  	end

    def authorize_by_name

      unless User.find_by(id: session[:user_id])
        render :text, notice: "you are "
      end
    end

  protect_from_forgery with: :exception
end
