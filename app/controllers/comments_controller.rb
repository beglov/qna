class CommentsController < ApplicationController
  before_action :set_commentable
  after_action :publish_comment, only: :create
  authorize_resource

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

  def publish_comment
    return if @commentable.errors.any?

    channel = if @commentable.is_a?(Question)
                "question_#{@commentable.id}_comments"
              else
                "question_#{@commentable.question_id}_answers_comments"
              end

    ActionCable.server.broadcast(
      channel,
      CommentSerializer.new(@comment).to_json
    )
  end
end
