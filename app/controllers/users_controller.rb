class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_developer, only: [:index]
  before_action :authorize_name, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    set_users_by_type
  end

  # GET /users/:name
  # GET /users/1.json
  def show
    unless @user 
      render :text => "user not found", :layout => true
    end
  end


  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if params[:type] == "Developer" and not params[:developer_code] == 'wpiece2guys'
      render :text => "your developer code is incorrect"
      return
    end
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_url(@user), notice: "User #{@user.name} was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(name: params[:name])
    end

    def set_users_by_type
      if params[:type]
        @users = User.where(type: params[:type]).order(:name)
      else
        @users = User.order(:name)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :type, :introduction, :contact_info)
    end
end
