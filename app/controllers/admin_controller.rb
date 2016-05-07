class AdminController < ApplicationController
	skip_before_action :authorize, only: :index
  def index
  	render :file => 'public/tags/new_index.html.erb', :layout => 'head_only'
  end
end
