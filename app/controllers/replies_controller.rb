class RepliesController < ApplicationController
  before_action :authenticate_user!
  def create
    comment = Comment.find(params[:comment_id])
    @reply = comment.replies.build(reply_params)

    if @reply.save
      redirect_to post_path(comment.post), notice: t('.success')
    else
      redirect_to post_path(comment.post), alert: t('.error')
    end
  end

  private

  def reply_params
    reply_params = params.require(:reply).permit(:message)
    reply_params[:user_id] = current_user.id
    reply_params
  end
end
