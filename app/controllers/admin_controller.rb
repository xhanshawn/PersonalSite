class AdminController < ApplicationController
	skip_before_action :authorize, only: :index
  def index
  	render 'new_index', :layout => 'head_only'
  end
end
