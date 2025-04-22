require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get summary" do
    get users_summary_url
    assert_response :success
  end
end
