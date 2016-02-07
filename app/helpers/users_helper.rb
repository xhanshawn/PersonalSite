module UsersHelper
  def user_profile_path(user)
  	"/users/#{user.name}/profile"
  end
end
