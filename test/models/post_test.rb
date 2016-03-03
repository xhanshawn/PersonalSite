require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create post" do
  	test_user = users(:test_user)
  	post = test_user.posts.build
  	assert post.invalid?
  	assert post.errors[:title].any?
  	assert post.errors[:body].any?
  end
end
