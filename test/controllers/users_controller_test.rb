require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user
  end

  test "should get summary" do
    get users_summary_url
    assert_response :success
  end
end