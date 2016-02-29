class PageContentsController < ApplicationController
  before_action :set_page_content, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:show_index_by_name, :show_by_name]
  # GET /page_contents
  # GET /page_contents.json
  def index
    @page_contents = PageContent.all
    if params[:pages_belong_to_developer]
      @page_contents = PageContent.where(user_id: current_user.id)
    end
  end

  # GET /page_contents/1
  # GET /page_contents/1.json
  def show
  end

  def show_by_name
    developer = Developer.find_by(:name => params[:name])

    if developer 
       page_content = developer.page_contents.find_by(:page_name => params[:page_name])
      if(params[:page_name] == 'client_info')
        if(current_user.id == developer.id)
          render('client_info')
        else
          render :text => "Client record is private.", :layout => true
        end
      elsif page_content
        render :inline => page_content.html_content, :layout => "head_only"
      else
        render :text => "This page not found in this user's pages"
      end
    else
      render :text => "User not found"
    end
    
  end
  
  # def showClient
  #  redirect_to '/client_info.html.erb'
  #  end
  
  def show_index_by_name
    developer = Developer.find_by(:name => params[:name])
    if developer 
      page_content = developer.page_contents.find_by(:page_name => "index")
      if page_content 
        record_client_info developer
        render :text => page_content.html_content, :layout => "head_only"
      else
        render :text => "Index page not found in this user's pages"
      end
    else
      render :text => "User not found"
    end
    
  end


  # POST /page_contents/1/preview

  # def preview_html

  #   developer = PageContent.find(params[:id])
  #   if developer.developer_id == current_user.id

  #     # temp_preview_page = developer.page_contents.find_by(:page_name => 'temp_preview_page')
  #     # if temp_preview_page
  #     #   temp_preview_page.update_attribute(:html_content => )

  #     render :nothing => true
  #     # render :inline => params[:preview_content], :layout => "head_only"
  #   else
  #     redner :text => "not the user"
  #   end
  # end

  # GET /page_contents/new
  def new
    @page_content = PageContent.new
  end

  # GET /page_contents/1/edit
  def edit
  end

  # POST /page_contents
  # POST /page_contents.json
  def create
    user = current_user
    # developer = Developer.find(params[:developer_id])
    # @page_content = PageContent.new(page_content_params.merge(:developer_id => current_user.id))
    # if developer.page_contents.where(page_name: params[:page_name])
    #   render :text => "contains this page_name"
    #   return
    # end
    @page_content = user.page_contents.build(page_content_params)
    # @page_content = PageContent.new(:developer_id => 6)
    respond_to do |format|
      if @page_content.save
        format.html { redirect_to @page_content, notice: 'Page content was successfully created.' }
        format.json { render :show, status: :created, location: @page_content }
      else
        format.html { render :new }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_contents/1
  # PATCH/PUT /page_contents/1.json
  def update
    respond_to do |format|
      if @page_content.update(page_content_params)
        format.html { redirect_to @page_content, notice: 'Page content was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_content }
      else
        format.html { render :edit }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_contents/1
  # DELETE /page_contents/1.json
  def destroy
    @page_content.destroy
    respond_to do |format|
      format.html { redirect_to page_contents_url, notice: 'Page content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_content
      @page_content = PageContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_content_params
      params.require(:page_content).permit(:user_id, :html_content, :page_name)
    end


    def record_client_info developer
      client_page = developer.page_contents.find_by(page_name: "client_info_page")
      client_page = developer.page_contents.build(page_name: "client_info_page") if not client_page 
      client_content = client_page.html_content.to_s + request.remote_ip + " Time: " + Time.now.to_s + "\n"
      client_page.update_attribute(:html_content, client_content)
      # client_info = ClientInfo.create(user_id: developer.id, ip: request.remote_ip, date: DateTime.parse(Time.now.to_s))
      # client_info.save
    end
end
