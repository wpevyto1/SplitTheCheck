class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @comment = @restaurant.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @restaurant, notice: "Comment Posted."
    else
      redirect_to @restaurant, alert: "Comment was not posted."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
