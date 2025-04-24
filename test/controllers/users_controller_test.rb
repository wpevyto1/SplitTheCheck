require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "should get summary" do
    user = User.create!(email: "test#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in user

    get users_summary_url
    assert_response :success
  end
end
