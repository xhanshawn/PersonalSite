require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    # @author = User.create(users(:test_user).attributes)
    # @author.save

    # @post = @author.posts.create(posts(:plain_post).attributes)

    # @user = User.create(users(:test_user2).attributes)
        
    @post = posts(:plain_post)

    @user = users(:test_user)

    @comment = @post.comments.create(user_id: @user.id, body: "normal comment")

    session[:user_id] = @user.id
    session[:user_name] = @user.name

  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create comment" do

  #   assert_equal @post.id, 1

  #   assert_difference('Comment.count') do
  #     post :create, comment: { body: "create comment test", post_id: @post.id, user_id: @user.id }
  #   end

  #   assert_redirected_to comment_path(assigns(:comment))
  # end

  # test "should show comment" do
  #   get :show, id: @comment
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @comment
  #   assert_response :success
  # end

  # test "should update comment" do
  #   patch :update, id: @comment, comment: { body: @comment.body, post_id: @comment.post_id, user_id: @comment.user_id }
  #   assert_redirected_to comment_path(assigns(:comment))
  # end

  # test "should destroy comment" do
  #   assert_difference('Comment.count', -1) do
  #     delete :destroy, id: @comment
  #   end

  #   assert_redirected_to comments_path
  # end
end
