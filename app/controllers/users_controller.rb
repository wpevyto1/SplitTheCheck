class UsersController < ApplicationController
  before_action :authenticate_user!

  def summary
    @user = current_user
    # @comments = current_user.comments.includes(:restaurant)
    # @votes = current_user.votes.includes(:restaurant)
    # @favorites = current_user.favorite_restaurants
  end
end
