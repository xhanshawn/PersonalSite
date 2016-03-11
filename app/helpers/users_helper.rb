module UsersHelper
  def user_profile_path(user)
  	if(user)
  	  "/users/#{user.name}/profile"
  	end
  end
  def developer_homepage_path(user)
  	if(user)
  	  "/developers/#{user.name}"
  	end
  end

  def developer_client_record_path(user)
  	if(user)
  	  "/developers/#{user.name}/client_info"
  	end
  end

  def user_path(user)
    "/users/#{user.name}" if user
  end
  
end
