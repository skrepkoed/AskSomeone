class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :broadcast_comment
  def create
    @comment = @commentable.comments.new(params_comment)
    @comment.author = current_user

    @comment.save
    gon.comment_id = @comment.id
  end

  private

  def params_comment
    params.require(:comment).permit(:body)
  end

  def broadcast_comment
    return unless @comment.valid?

    comment_partial = ApplicationController.render(
      partial: 'shared/comment',
      locals: { comments: [@comment] }
    )

    comment = { comment_partial: comment_partial,
                type: @comment.commentable_type,
                commentable_id: @comment.commentable_id }
    QuestionChannel.broadcast_to(@comment.question, comment)
  end
end
