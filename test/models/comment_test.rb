require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create comment" do

  	post = posts(:plain_post)
  	user = users(:test_user)
  	comment = post.comments.create(user_id: user.id, body: "normal comment")



  	assert comment.valid?
  	assert_not comment.errors[:title].any?
  	assert_not comment.errors[:body].any?
  end
end
