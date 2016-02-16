module ApplicationHelper
  def brand_name
  	"Archare"
  end

  def current_user_name
    if session[:user_id]
      current_user = User.find(session[:user_id])
      current_user.name if current_user
    end
  end


  def current_user
  	current_user = User.find(session[:user_id]) if session[:user_id] and session[:user_id] <= User.all.size
  end

end
