class DevelopersController < ApplicationController
  skip_before_action :authorize, except: [:index, :edit, :update, :destroy]
  before_action :set_developer, only: [:show, :edit, :update, :destroy]

  # GET /developers
  # GET /developers.json
  def index
    @developers = Developer.all
  end

  # GET /developers/:name
  # GET /developers/:name.json
  def show
    if @developer.homepage_content.to_s != ''
      respond_to do |format|
        require 'erb'
        format.html { render :inline => @developer.homepage_content }
        # format.html { render :text => @developer.homepage_content }
      end
    end
  end

  # GET /developers/:name/education
  # GET /developers/:name/education.json
  def show_edupage
    set_developer
    render :text => @developer.name
  end

  # GET /developers/new
  def new
    @developer = Developer.new
  end

  # GET /developers/1/edit
  def edit
  end

  # POST /developers
  # POST /developers.json
  def create
    @developer = Developer.new(developer_params)

    respond_to do |format|
      if @developer.save
        format.html { redirect_to developer_path(@developer.name), notice: 'Developer was successfully created.' }
        format.json { render :show, status: :created, location: @developer }
      else
        format.html { render :new }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /developers/1
  # PATCH/PUT /developers/1.json
  def update
    # @developer = Developer.find(params[:name])
    respond_to do |format|
      if @developer.update(developer_params)
        format.html { redirect_to developer_path(@developer.name), notice: 'Developer was successfully updated.' }
        format.json { render :show, status: :ok, location: @developer }
      else
        format.html { render :edit }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developers/1
  # DELETE /developers/1.json
  def destroy
    @developer.destroy
    respond_to do |format|
      format.html { redirect_to developers_url, notice: 'Developer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developer
      @developer = Developer.find_by(name: params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def developer_params
      params.require(:developer).permit(:name, :introduction, :education, :homepage_content, :edupage_content)
    end
end
