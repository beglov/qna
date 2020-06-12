class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
  end

  private

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params[:id])
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
