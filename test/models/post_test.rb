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


    post = test_user.posts.create(title:"title", body:"body")

    assert post.valid?
    assert_not post.errors[:title].any?
    assert_not post.errors[:body].any?

    post2 = test_user.posts.create(title:"title", body:"body")

    assert post2.invalid?

    puts post2.errors.messages

    
    assert post2.errors[:title].any?
    assert_not post2.errors[:body].any?
  end

  # include ActionView::Helpers
  
  # test "get intro" do
  #   assert_equal "ab", get_intro(posts(:img_post).body)
  # end
end
