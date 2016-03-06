require 'test_helper'

class YourHelperTest < ActionView::TestCase
  test "get intro" do
    assert_equal "ab", get_intro(posts(:img_post))
  end
end