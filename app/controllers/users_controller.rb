class UsersController < ApplicationController
  before_action :authenticate_user!

  def summary
    @user = current_user
  end
end
