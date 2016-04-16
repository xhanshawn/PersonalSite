class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :authorize, except: [:index, :show]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  
    respond_to do |format|
      format.html
      # format.html { render :file => 'public/tags/tags.html', :layout => true}
      format.json 
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    
    redirect_to '/tags', notice: "Currently Tags can only be created in the Post edit action"
    return

    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create

    # find the post with the post_id passed
    @post = Post.find(params[:post_id])

    puts params[:tag][:name]

    existing_tag = Tag.find_by(name: params[:tag][:name])

    if(@post) 

      # if found the post crate with association
      
      if(existing_tag)
        @tag = existing_tag

        # add association with post only once
        if(not @tag.posts.exists?(@post)) 
          @post.tags << @tag
        end
      else
        @tag = @post.tags.create(tag_params)
      end

      # @tag.posts << @post
    else

      if(existing_tag)
        @tag = existing_tag
      else
        @tag = Tag.new(tag_params)
      end
    end

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
        format.js {}
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
   
    # not update accociations in the tags controller
    # because delete or add a new tag should be decided by the post content
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:post_id, :name)
    end
end
