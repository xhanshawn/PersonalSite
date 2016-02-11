module ApplicationHelper
  def brand_name
  	"AlgorithmUniverse"
  end

  def current_user_name
  	current_user = User.find(session[:user_id])
  	current_user.name if current_user
  end
end
