class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize, except: [:index, :show, :ref_posts]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = original_posts.order('created_at DESC')
  end

  # GET /reference_posts
  def ref_posts
    @posts = reference_posts.order('created_at DESC')
    render :index
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /reference_posts/new
  def new_ref_post
    @post = Post.new
    render :new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    user = current_user

    @post = user.posts.build(post_params)

    add_tags

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    
    add_tags

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def authorize_user
      unless session[:user_id] == @post.user_id
        redirect_to :back, notice: "you don't have authorization"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :body, :ref_link)
    end

    def add_tags
      tags = Array.new
      params[:tags].each do |tag_name|
        tag = Tag.find_by(name: tag_name)
        tag = Tag.new(name: tag_name) unless tag
        tags << tag
      end
      @post.tags.clear
      @post.tags << tags
    end


    def original_posts
      Post.all.where(ref_link: nil)
    end

    def reference_posts
      Post.all.where.not(ref_link: nil)
    end
end
