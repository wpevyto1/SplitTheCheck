require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "test#{SecureRandom.hex(4)}@example.com", password: "password")
    @restaurant = Restaurant.create!(name: "CommentPlace", location: "123 Comment Ave")
    sign_in @user
  end

  test "should create comment with valid content" do
    assert_difference("Comment.count", 1) do
      post restaurant_comments_path(@restaurant), params: {
        comment: { content: "This place is great!" }
      }
    end

    assert_redirected_to restaurant_path(@restaurant)
    follow_redirect!
    assert_match "Comment Posted.", response.body
  end

  test "should not create comment with empty content" do
    assert_no_difference("Comment.count") do
      post restaurant_comments_path(@restaurant), params: {
        comment: { content: "" }
      }
    end

    assert_redirected_to restaurant_path(@restaurant)
    follow_redirect!
    assert_match "Comment was not posted.", response.body
  end
end
