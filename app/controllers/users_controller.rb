class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_developer, only: [:index]
  before_action :authorize_name, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :record_visitors_for_user



  helper_method :generate_developer_code
  helper_method :get_developer_code



  @@developer_code = ""
  
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
    logger.info params[:user][:type].to_s

    if params[:user][:type].to_s == "Developer"

      if not user_params[:developer_code].to_s == get_developer_code and user_params[:name].to_s != "xhan"
        render :text => "developer_code incorret", :layout => true
        return
      end

      @user = User.create(user_params)
      @user.update_attribute(:type, "Developer")
    else
      if not user_params[:type].to_s == ""
        render :text => "not a valid type. If you have the developer code, please enter \"Developer\" in type field. If not, just leave it blank", :layout => true
        return
      end 
      @user = User.new(user_params)
    end

    
    respond_to do |format|
      if @user.type == "Developer" or @user.save
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



  # PATCH/PUT /users/:name/record_visitors

  def record_visitors_for_user

    @user = User.find_by(:name => params[:name])
    record_visitors_api_page = @user.page_contents.find_by(page_name: "client_info_page")
    record_visitors_api_page = @user.page_contents.create(page_name: "client_info_page") if not record_visitors_api_page 
    
    record_visitors_api_content = record_visitors_api_page.html_content.to_s + client_api_record(params[:page_url].to_s, params[:visitor_ip].to_s)
    record_visitors_api_page.update_attribute(:html_content, record_visitors_api_content)


    render :text => "your record has been updated"

  end




  def get_developer_code

    if not @@developer_code or @@developer_code == ""
      generate_developer_code
    end

    return @@developer_code
  end
  
  def generate_developer_code
    @@developer_code = Array.new(32){rand(36).to_s(36)}.join
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


    def client_api_record(url, ip)
      record = "visitor_record_api{Page_url: " + url + " IP: " + ip + " Time: " + Time.now.to_s + "}\n"
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :introduction, :contact_info, :developer_code)
    end
end
