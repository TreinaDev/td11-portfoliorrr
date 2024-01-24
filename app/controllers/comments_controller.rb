class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    post = Post.find(params[:post_id])
    comments_params = params.require(:comment).permit(:message)
    comments_params[:user_id] = current_user.id
    comment = post.comments.build(comments_params)
    if comment.save
      redirect_to post, notice: t('.success')
    else
      redirect_to post, alert: t('.error')
    end
  end
end
