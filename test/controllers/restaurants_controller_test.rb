require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @restaurant = restaurants(:one)

    # Use dynamic user to avoid fixture conflict
    @user = User.create!(email: "test#{SecureRandom.hex(4)}@test.com", password: "password")
    sign_in @user
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference("Restaurant.count") do
      post restaurants_url, params: {
        restaurant: {
          location: "Test Location",
          name: "Test Name",
          will_split: 0,
          wont_split: 0
        }
      }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
  end

  test "should get edit" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), params: {
      restaurant: {
        location: "Updated Location",
        name: "Updated Name",
        will_split: 5,
        wont_split: 3
      }
    }

    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should destroy restaurant" do
    restaurant = Restaurant.create!(name: "Delete Me", location: "Nowhere", will_split: 0, wont_split: 0)
   
    assert_difference("Restaurant.count", -1) do
      delete restaurant_url(restaurant)
    end

    assert_redirected_to restaurants_url
  end

  test "user can vote will_split once" do
    restaurant = Restaurant.create!(name: "VotePlace1", location: "123 Main St", will_split: 0, wont_split: 0)

    post vote_restaurant_path(restaurant), params: { vote: "will_split" }

    assert_redirected_to restaurant_path(restaurant)
    follow_redirect!
    assert_match "Your vote has been counted.", response.body

    restaurant.reload
    assert_equal 1, restaurant.will_split
    assert_equal 0, restaurant.wont_split
  end

  test "user cannot vote twice on same restaurant" do
    restaurant = Restaurant.create!(name: "VotePlace2", location: "456 Main St", will_split: 0, wont_split: 0)

    post vote_restaurant_path(restaurant), params: { vote: "wont_split" }
    post vote_restaurant_path(restaurant), params: { vote: "will_split" }

    assert_redirected_to restaurant_path(restaurant)
    follow_redirect!
    assert_select "p.alert", text: "You've already voted on this restaurant."

    restaurant.reload
    assert_equal 0, restaurant.will_split
    assert_equal 1, restaurant.wont_split
  end

  test "user can toggle favorite on and off" do
    assert_not @user.favorite_restaurants.include?(@restaurant)

    post toggle_favorite_restaurant_path(@restaurant)
    assert_redirected_to restaurants_path
    follow_redirect!
    assert_match "Favorite updated.", response.body
    assert @user.favorite_restaurants.include?(@restaurant)

    post toggle_favorite_restaurant_path(@restaurant)
    assert_redirected_to restaurants_path
    follow_redirect!
    assert_match "Favorite updated.", response.body
    assert_not @user.favorite_restaurants.include?(@restaurant)
  end
end