module UsersHelper
  def user_profile_path(user)
  	if(user)
  	  "/users/#{user.name}/profile"
  	end
  end
end
